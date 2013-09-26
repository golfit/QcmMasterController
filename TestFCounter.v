module TestFCounter();
reg clk, sig; //Clock and input RF signal whose frequency we must measure.
wire [13:0] f; //Calculated frequency.

integer fMeas;
integer fAct; //Actual frequency.
integer nSig;
integer testNum;

//Number of positive edges in sig before counter computes f.  Note that in repeat blocks, inversions of sig are carried out so that two repetitions are needed to create one new positive edge.
parameter clk_units=10;
parameter m=8000;
parameter f_clk=40000; //Clock frequency in hundreds of Hz.

//Instantiate counter.
fcounter c(clk, sig, f);

//initial begin
//  $dumpfile ("fcounterTestBench.vcd"); 
//  $dumpvars; 
//end

initial begin
  $display("\t\ttime,\ttest#,\tf_actual [100's Hz],\tf_meas [100's Hz]");
  //$monitor("%d\t%d\t%d\t%d",$time, testNum, fAct,f);
  $monitor("%d\t%d\t%d\t%d",$time, testNum, fAct, f);
end

initial begin
  #0
  clk=1'b0;
  sig=1'b0;
  nSig=0; //Initialize signal edge counter.
  testNum=0;

  //counter listens for 50 positive edges of sig before making a measurement.
  //Test 1: f_sig/f_clk = 1/10 => f_sig=4000 hundred Hz.
  testNum=testNum+1;
  fAct=f_clk/clk_units; //fActual = m_sig_counts / (#clock counts*tau_c) = m * f_clk/n
  repeat (8*m*clk_units) begin
    #100 sig=~sig; //f_sig / f_clk = tau_c/tau_s => tau_s=tau_c * f_clk/f_sig = 10*10=100
    nSig=nSig+1;
    //function int $cast( fMeas, f );
  end
  nSig=0; //Restart nSig counter.

  //Test 2: f_sig/f_clk = 1/100
  testNum=testNum+1;
  fAct=f_clk/100; //fActual = m_sig_counts / (#clock counts*tau_c) = m * f_clk/n
  repeat (4*m*clk_units) begin
    #1000 sig=~sig; //tau_s=tau_c * f_clk/f_sig = 10*100=1000
    nSig=nSig+1;
//    function int $cast( fMeas, f );
  end
  nSig=0; //Restart nSig counter.

  //Test 3: f_sig/f_clk = 1/50
  testNum=testNum+1;
  fAct=f_clk/50; //fActual = m_sig_counts / (#clock counts*tau_c) = m * f_clk/n
  repeat (3*m*clk_units) begin
    #500 sig=~sig; //tau_s=tau_c * f_clk/f_sig = 10*50=500
    nSig=nSig+1;
//    function int $cast( fMeas, f );
  end
  nSig=0; //Restart nSig counter.
  
  //Test 4: f_sig/f_clk=1/23
  testNum=testNum+1;
  fAct=f_clk/23; //fActual = m_sig_counts / (#clock counts*tau_c) = m * f_clk/n
  repeat (3*m*clk_units) begin
    #230 sig=~sig; //tau_s=tau_c * f_clk/f_sig = 10*23=230
    nSig=nSig+1;
//    function int $cast( fMeas, f );
  end
  nSig=0; //Restart nSig counter.

  //Test 5: f_sig faster than f_clk: f_sig/f_clk=5
  testNum=testNum+1;
  fAct=f_clk*5; //fActual = m_sig_counts / (#clock counts*tau_c) = m * f_clk/n
  repeat (8*m*clk_units) begin
    #2 sig=~sig; //tau_s=tau_c * f_clk/f_sig = 10/5=2
    nSig=nSig+1;
//    function int $cast( fMeas, f );
  end

  $display("Now make tests last for non-integer or half-integer numbers of M*sig posedges.");
  //Test 6: f_sig/f_clk = 1/50
  testNum=testNum+1;
  fAct=f_clk/50; //fActual = m_sig_counts / (#clock counts*tau_c) = m * f_clk/n
  repeat (2*m*clk_units+3) begin
    #500 sig=~sig; //tau_s=tau_c * f_clk/f_sig = 10*50=500
    nSig=nSig+1;
//    function int $cast( fMeas, f );
  end
  nSig=0; //Restart nSig counter.
  
  //Test 7: f_sig/f_clk=1/23
  testNum=testNum+1;
  fAct=f_clk/23; //fActual = m_sig_counts / (#clock counts*tau_c) = m * f_clk/n
  repeat (4*m*clk_units+7) begin
    #230 sig=~sig; //tau_s=tau_c * f_clk/f_sig = 10*23=230
    nSig=nSig+1;
//    function int $cast( fMeas, f );
  end
  nSig=0; //Restart nSig counter.
  nSig=0; //Restart nSig counter.  

  //Test 8: f_sig/f_clk=1/100000
//  testNum=testNum+1;
//  fAct=f_clk/1000; //fActual = m_sig_counts / (#clock counts*tau_c) = m * f_clk/n
//  repeat (2*m*clk_units+1) begin
//    #10000 sig=~sig; //tau_s=tau_c * f_clk/f_sig = 10*100000=1000000
//    nSig=nSig+1;
//  end
//  nSig=0; //Restart nSig counter.  

  #5 $finish; //Stop the simulation
end

always begin
  //Choose larger number of cycles between clock edges to allow for
  //different ratios of sig and clock frequencies.
  #clk_units
  clk=~clk; //Invert clock
end

endmodule
