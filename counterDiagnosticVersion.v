module counterDiagnosticVersion (clk,sig,f,n_clk_out);
/*This module takes an input signal and implements a period counter,
taking the reciprocal to deliver the frequency in kHz.

USAGE:
counter c(clk,sig,f);

clk and sig are 1-bit inputs representing the clock and RF signal whose frequency
is to be measured.

f is a 4-bit output corresponding to the frequency of sig, IN UNITS OF HUNDREDS
OF Hz.  This is because hundreds of Hz is the highest requeired frequency
resolution, and we want to use integer arithmetic.

Reference: Agilent Technologies.  "Fundamentals of the Electronic Counters".
  Application Note 200, Electronic Counter Series.

Design notes:
  In a period counter, pulses of the clock are counted in a register, with the
totaling (counting) action gated by pulses from the RF input whose frequency
is being measured.  Averaging over multiple RF cycles reduces error.

The total time elapsed between RF edges will be
n_clk*tau_c+err = m/f

=>f= m/(n_clk*tau_c+err)

where tau_c is the clock period, n_clk is the number of clock cycles actually counted 
by the register, err is the error in the time estimate, m is the number of RF
positive edges, and f is the RF frequency.

Contributions to error include the +-1 count error, timebase deviations, etc.
The +-1 count error, or quantization error, arises because time is only measured
in discrete steps, and a measurement of four clock time units may be produced by
RF pulses which are acutally separated by 3+delta or 5-delta clock units.

The nominal frequency estimate

f_nominal=m/(n_clk*tau_c)

converges with the value that would arise from an average after many cycles
if n_clk is very large.

With just the +-1 count error, the spread in maximum and minimum possible
frequency estimates

fmax-fmin=m/tau_c*(1/(n_clk-1)-1/(n_clk+1))=2*m/tau_c * 1/(n_clk^2-1) ~= 2*f_nom^2*tau_c/m
=2*f_nom^2/(f_clk*m)

The error increases with frequency for a fixed number of RF pulses, but decreases
as the clock frequency increases and as the number of RF pulses averaged over
increases.

We require about 3 kHz resolution at the highest frequencies (around 300 kHz)
and about 500 Hz resolution at the lowest frequencies - these values are about
half the frequency interval between adjacent bins in these sub-bands.  With
a clock speed of 4 MHz,

m=2*f_high^2/(f_clk*Delta_f_high)=2*(3E5^2)/(4E6*3E3)=18E10/(12E9)=15

with m=15, at the lower frequencies,

fmax-fmin=2*5E4^2/(4E6*15) = Delta_f_high/36 ~= 83 Hz

while m/5E4=15/5E4=3.0E-4=300 us is the maximum time elapsed per measurement.
At high frequency, Delta_t = m/300E3=50 us.

Since we are willing to accept a reaction time on the order of 1 ms, we can
actually improve accuracy by increasing m such that Delta_t_max = 1 ms = m/5E4
=>m=50.

So choose m=50, which gives fmax-fmin~=900 Hz at f_rf=300 kHz.

f_nom = m*f_clk/n_clk => n_clk = m*f_clk/f_nom,
n_clk_max=50*4E6/5E4=80E2=4000
=>n_clk needs to be at least 12 bits.  Make 13.

//Error (10239): Verilog HDL Always Construct error at counter.v(102): event control cannot test for both positive and negative edges of variable "clk"
*/

//11 Jan 2012: THIS VERSION OUTPUTS THE CLK COUNTER TO SEE WHETHER THE INPUT TO THE DIVISION, IN ADDITION TO THE OUTPUT, IS UNSTABLE. TED GOLFINOPOULOS


input clk,sig;
output reg [13:0] f; //Output frequency in hundreds of Hz.

reg [13:0] n_clk; //Register to hold number of clock counts between RF signal.
reg [13:0] n_clk_last; //Clock sub-counter.  Increment clock in 3's
//reg firstPassComplete; //Flag indicating that a legitimate n_clk_last is available.

output reg [13:0] n_clk_out; //Only update this counter when the frequency is computed.
reg [6:0] n_sig; //Register to count the number of RF cycles.
reg cnt_flg; //Counter flag.
reg hold_n_clk; //Gate for increment action for n_clk - count when 0, don't count when 1.
reg reset; //Internal flag to reset clock counter.

`define CLK_COUNTER_SIZE 14 //Number of bits in clock edge counter.
`define SIG_COUNTER_SIZE 7 //Number of bits in signal edge counter.
//Clock frequency in hundreds of Hz.
//parameter F_CLK=40000;
parameter F_CLK=35795; //This clock was used to test whether incorrect firing of state happens at different frequencies depending on clock frequency and precession of this with sync signal freq.
//Number of cycles of RF signal over which to average period.
parameter M=50; //Double M and increase sample time, and throw away lowest bits (jitter).
//parameter MIN_CHANGE=`CLK_COUNTER_SIZE'b10; //n_clk must change by at least this about (up or down) from last n_clk in order for a change in computed frequency to be allowed.
parameter MIN_CHANGE=`CLK_COUNTER_SIZE'b10;
//parameter ROUND_RANGE=3; //Round in triplets according to floor(n/ROUND_RANGE)*ROUND_RANGE+1.
//Define macros to set counter sizes for convenience (so that don't have to make multiple changes if counter size needs to be adjusted).


initial begin
	#0
	n_clk=`CLK_COUNTER_SIZE'b0; //Initialize clock edge counter.
	n_sig=`SIG_COUNTER_SIZE'b0; //RF Cycle counter.
	n_clk_last=`CLK_COUNTER_SIZE'b0; //Initialize storage for last clock counter value.
	reset=1'b1; //Initialize reset flag to block clock counter until signal counter gate opens.
	hold_n_clk=1'b0; //Initialize hold on increment action for clock counter to OFF.
end

//Clock loop
//always @(posedge clk) begin //Triggering on reset was there in case there were two sig edges before the next clk edge, in which case the reset call would get skipped.  But maybe false triggers are causing clock count to drift or flicker.  Remove this edge detector and see what happens.  Result  - no, that didn't fix the problem.
always @(posedge clk or posedge reset) begin
	if (reset) begin
		n_clk=`CLK_COUNTER_SIZE'b0; //Reset clk counter.
//	end else if(!hold_n_clk) begin
	end else begin
		n_clk=n_clk+`CLK_COUNTER_SIZE'b1; //Increment clk counter.
	end
end

//Gate on positive edges of signal
always @(posedge sig) begin
	//Initially, the gate is closed and n_sig=0.
	//When the gate is opened, n_sig is incremented, so n_sig=1.
	//The gate is closed again at the (M+1)th positive edge on n_sig, but before n_sig is incremented,
	//so n_sig=M still.
	//As such, the gate is open between the 1st and (M+1)th positive edges of n_sig, corresponding to M sig intervals.
	//The gate is closed between the (M+1)th=0th and 1st signal edges.
	//THEN dt = (M)*tau_sig = (M)/f_sig = (n_clk-1+[-0+2])/f_clk
	//It is n_clk-1 because this is the number of clock time intervals in n_clk positive edges.
	// [-0+2]=error on time measurement - time is at least (n_clk-1)*tau_c, but could be as much as
	// (n_clk-1+2-delta)*tau_c, so on average, elapsed time is actually (n_clk-1 - (average error = (0+2)/2=1))*tau_c
	// => f_sig = f_clk * (M)/(n_clk-1-(0+2)/2) = f_clk * (M)/n_clk

	if (n_sig==M) begin //This is actually the M+1th edge, and the Mth interval
//		hold_n_clk=1'b1; //Turn on flag to arrest incrementing of n_clk, but do not reset yet.  Compute on next sig edge.
//		n_sig=n_sig+`SIG_COUNTER_SIZE'b1;
//	end else if(n_sig==(M+1)) begin //Now, compute with the (hopefully-settled) counters.
		//First, round n_clk to triplets, as described below.
		//n_clk = (n_clk/ROUND_RANGE)*ROUND_RANGE+`CLK_COUNTER_SIZE'b1;
		//f=((M*F_CLK)/(ROUND_RANGE*n_clk))*ROUND_RANGE+`CLK_COUNTER_SIZE'b1; //Compute RF frequency.

		//After M sig edges and n_clk clock edges,
		//Handle case where n_clk=0 by saturating frequency at f=M*F_CLK.
		if(n_clk==`CLK_COUNTER_SIZE'b0) f=(M)*F_CLK; //Case where no counts on clock are registered.
		//Round triplets to center values, so count 1, 4, 7, ...  This is to avoid noise from +[0,1] count error,
		//i.e. in general, when M*tau_sig != n*tau_c, M and n integers,
		//the phase between the sig and clock signals will not be constant,
		//but one will precess about the other.  As such, n_clk will register
		//floor(M*tau_s/tau_c) some of the time, and floor(M*tau_s/tau_c)+1
		//some of the time.  To avoid this, count by threes and round to the
		//middle of the triplets, so that the natural oscillation will be ignored.
		
		//Disallow jitter from changes in n_clk by +-2; only update frequency when clock counter is different by a number other than +-1.
		//Also, add in another do-nothing sig cycle during which time the clk counter is gated off
		//to make sure clk counter is settled.

//		else if (n_clk!=n_clk_last && ((n_clk>n_clk_last && n_clk-n_clk_last>`CLK_COUNTER_SIZE'b10) || ( n_clk_last>n_clk && n_clk_last-n_clk>`CLK_COUNTER_SIZE'b10) )) begin
		else if ((n_clk>n_clk_last && n_clk-n_clk_last>MIN_CHANGE) || ( n_clk_last>n_clk && n_clk_last-n_clk>MIN_CHANGE) ) begin
			n_clk_last=n_clk; //Store clock counter at last frequency change.
			f=(M*F_CLK)/n_clk_last; //Re-compute RF frequency.
		end
		n_sig=`SIG_COUNTER_SIZE'b0; //Zero out rf cycle counter.
		reset=1'b1; //Set reset flag high to restart clock counter.
		n_clk_out=n_clk_last;
	end else begin //Start incrementing signal positive edge counter.
		hold_n_clk = 1'b0; //Set hold for clock-counter to zero and start counting clock cycles again.
		reset=1'b0; //Set reset low and start counting clock cycles again.
		n_sig=n_sig+`SIG_COUNTER_SIZE'b1; //Increment RF cycle counter.
	end
end

endmodule
