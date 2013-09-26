module fcounter(clk, sig, f);
/*
	This module implements a frequency counter.  It has the same module signature as counter.v, which implements a period counter with inversion to give the frequency counter.
	The frequency counter counts edges of the RF signal input in a register, and gates this counting with a fixed time period as measured by counting of clock edges.  The +- count error of this scheme is associated with the RF signal, as opposed to the clock, so when the RF signal is slower than the clock, the period counter will have a smaller error for the same measurement time (i.e. a longer measurement time would be needed with the frequency counter, so that the error is reduced by averaging, in order to achieve the same error from the period counter).

PARAMETER SELECTION:
F_rf = #cnts/time period +-1 / (time period)
 => error= +- 1/time period = 500 Hz = acceptable error
=> time period = 1/500 Hz = 0.002 s

With 4 MHz clock => 2E-3*4E6=8E3 clock posedges count in time period.

Ted Golfinopoulos, 25 Oct 2011
*/

`define CLK_COUNTER_SIZE 14 //Number of bits in clock edge counter.
`define SIG_COUNTER_SIZE 10 //Number of bits in signal edge counter.

input clk, sig;
output reg [13:0] f; //Allows frequency count up to 819.2 kHz.

reg [13:0] n_clk; //Counter for clock positive edges.
reg [9:0] n_sig; //Counter for signal positive edges.
reg reset; //Reset flag set every NUM_CNTS_AVG clock cycles to re-compute frequency and restart counters.

parameter F_CLK=40000; //Clock frequency in HUNDREDS OF Hz.
parameter ERR=5; //Allowable frequency measurement error, HUNDREDS OF Hz.
parameter NUM_CNTS_AVG=F_CLK/ERR; //Number of clock edge counts required such that averaging reduces +-1 count error to acceptable levels.
parameter F_SCALE=ERR; //Scale rf signal counter by this amount to give a frequency measurement in HUNDREDS OF Hz.
parameter N_SIG_MAX=`SIG_COUNTER_SIZE'b1111111111; //Maximum value sig edge counter can reach.

initial begin
	reset=1'b1; //Initialize reset signal counter flag low so that counting only starts when gate is actually opened.
	n_clk=`CLK_COUNTER_SIZE'b0; //Initialize clock counter.
	n_sig=`SIG_COUNTER_SIZE'b0; //Initialize signal counter.
end

always @(posedge clk) begin
	//As for period counter, but swap gate and registered count, n_sig and n_clk, so that now, n_clk is the gate.
	//n_sig is not counted when n_clk is between 0 and 1.
	//The gate is open between n_clk Edges 1 and (NUM_CNTS_AVG+1) (which is also Edge 0), corresponding to
	// NUM_CNTS_AVG clock intervals.
	//Then f=(n_sig+-1)/(tau_clk*NUM_CNTS_AVG) = (n_sig+-1)*f_clk/NUM_CNTS_AVG => error = +-1*f_clk/NUM_CNTS_AVG.

	if(n_clk>=NUM_CNTS_AVG) begin //Close frequency counter gate.  Subtract one from count because actually start counting signal edges at n_clk=1.
		f=F_SCALE*n_sig; //Compute frequency.
		reset = 1'b1; //Set flag to re-compute the frequency and restart the frequency counter.
		n_clk = 1'b0; //Restart clock positive edge counter.
	end else begin
		 //Keep reset flag low (turn off on next clock cycle).
		reset = 1'b0;
		n_clk=n_clk+`CLK_COUNTER_SIZE'b1; //Increment clock cycle counter.
	end
end

always @(posedge sig or posedge reset) begin
	if(reset==1) begin
		n_sig=`SIG_COUNTER_SIZE'b0; //Reset RF signal counter.
	end else if(n_sig<=N_SIG_MAX) begin //Handle overflow gracefully - stop counting when register is saturated.
		n_sig=n_sig+`SIG_COUNTER_SIZE'b1; //Increment frequency counter.
	end
end

endmodule

