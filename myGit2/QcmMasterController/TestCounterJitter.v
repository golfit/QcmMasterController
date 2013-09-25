module TestCounter();
/*
This module is used for testing the output of the "counter" module.
Specifically, in implementation on a CPLD, we see a jitter between
adjacent frequencies.  This module is intended to determine whether
that jitter can be reproduced in the Verilog logic, alone.

Ted Golfinopoulos, 11 Jan 2012
*/


reg clk, sig; //Clock and input RF signal whose frequency we must measure.
wire [13:0] f; //Calculated frequency.
wire [13:0] n_clk_out;

integer fMeas;
integer fAct; //Actual frequency.
integer nSig;
integer testNum;
integer fComputeCounter; //This counter increments every time the counter calculates the frequency.

//Number of positive edges in sig before counter computes f.  Note that in repeat blocks, inversions of sig are carried out so that two repetitions are needed to create one new positive edge.
parameter m=50;
//parameter f_clk=40000; //Clock frequency in hundreds of Hz.
parameter f_clk=35795; //Clock frequency in hundreds of Hz.

//Instantiate counter.
//counter c(clk, sig, f);
counterDiagnosticVersion c(clk,sig,f,n_clk_out); //With rounding in triplets.

initial begin
  $dumpfile ("counterTestBench.vcd"); 
  $dumpvars; 
end

initial begin
  $display("\t\ttime,\ttest#,\tFreq Update#,\tf_actual [100's Hz],\tf_meas [100's Hz]");
  //$monitor("%d\t%d\t%d\t%d",$time, testNum, fAct,f);
  $monitor("%d\t%d\t%d\t%d\t%d",$time, testNum, fComputeCounter, fAct, f);
end

initial begin
  #0
  clk=1'b0;
  sig=1'b0;
  nSig=0; //Freq. is computed on (m+1)th edge, (mth) interval; then there is one interval skipped.
  testNum=0;
  fComputeCounter=0;

  //counter listens for 50 positive edges of sig before making a measurement.
  //Let tau_c = number of time units in simulation per clock cycle (=100 - see below).
  //tau_s = period of signal (sync signal in AMHD application)
  //Test 1: f_sig=307.5 kHz = 3075 hundred Hz, f_clk=3.5795 MHz = 35795 hundred Hz
  //Test 1: f_sig/f_clk = 0.0859058528
  //f_clk/f_sig=11.6406504065
  testNum=testNum+1;
  fAct=3075; //fActual = m_sig_counts / (#clock counts*tau_c) = m * f_clk/n
  //The clock 
  repeat (8*(m+1)+m/2) begin //This will cause the counter module instance to compute the frequency 8 times.
    #1164 sig=~sig; //f_sig / f_clk = 2*tau_c/(2*tau_s) => tau_s=tau_c * f_clk/f_sig = 100*11.64=1164
    if( nSig%(2*(m))==0 && nSig>0 ) begin //Every time m sig positive edges go by, one sig cycle is used to calculate frequency.
	fComputeCounter=fComputeCounter+1;
	nSig=0; //Zero out nSigCounter.
    end else begin
        nSig=nSig+1;
    end
  end
  //$display("nSig=%d, t=%d", nSig, $time);

  //Test 2: f_sig=130.0 kHz = 1300 hundred Hz, f_clk=3.5795 MHz = 35795 hundred Hz
  //Test 2: f_sig/f_clk = 0.0363179215
  //f_clk/f_sig=27.5346153846
  testNum=testNum+1;
  fAct=1300; //fActual = m_sig_counts / (#clock counts*tau_c) = m * f_clk/n
  //The clock 
  repeat (200*(m+1)) begin //This will cause the counter module instance to compute the frequency 8 times.
    #2753 sig=~sig; //f_sig / f_clk = 2*tau_c/(2*tau_s) => tau_s=tau_c * f_clk/f_sig = 100*27.53=2753
    if( nSig%(2*(m))==0 && nSig>0 ) begin //Every time m sig counts go by, one sig cycle is used to calculate frequency.
	fComputeCounter=fComputeCounter+1;
//	$display("nSig=%d", nSig);
	nSig=0; //Zero out nSigCounter.
    end else begin
        nSig=nSig+1;
    end
  end

  #5 $finish; //Stop the simulation
end

always begin
  //Choose larger number of cycles between clock edges to allow for
  //different ratios of sig and clock frequencies.
  #100
  clk=~clk; //Invert clock
end

endmodule
