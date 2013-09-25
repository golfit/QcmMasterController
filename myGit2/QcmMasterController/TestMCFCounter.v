module TestMCFCounter();
/*This module tests the main master controller module.  It gives the same tests
 seen to the counter, but now sniffs the output on the two encoded capacitor
 states and the enable bit.
 Ted Golfinopoulos, 24 Oct 2011
*/

reg clk, sig; //Clock and input RF signal whose frequency we must measure.
wire [6:0] codeSer, codePar; //These are outputs.
wire enableSer, enablePar; //These are outputs

integer testNum;
integer fAct;

parameter f_clk=40000; //Clock's frequency in hundreds of Hz.
parameter m=8000; //Number of posedges on clock to wait for output change.
parameter clk_units=10;

//Instantiate main module.
QcmMasterControllerMain myMain(clk, sig, codeSer, codePar, enableSer, enablePar);

//initial begin
//  $dumpfile ("MainTestBench.vcd"); 
//  $dumpvars; 
//end

initial begin
  $display("time, testNum, codeSer, codePar, enableSer, enablePar");
  $monitor("%d\t%d\t%d\t%d\t%b\t%b",$time, testNum, codeSer, codePar, enableSer, enablePar);
end

initial begin
  #0
  clk=1'b0;
  sig=1'b0;
  testNum=0;

  //counter listens for 50 positive edges of sig before making a measurement.
  //Test 1: f_sig/f_clk = 1/10 => f_sig=4000 hundred Hz.
  testNum=testNum+1;
  fAct=f_clk/10; //fActual = m_sig_counts / (#clock counts*tau_c) = m * f_clk/n
  repeat (8*m*clk_units) begin
    #100 sig=~sig; //f_sig / f_clk = tau_c/tau_s => tau_s=tau_c * f_clk/f_sig = 10*10=100
  end

  //Test 2: f_sig/f_clk = 1/100
  testNum=testNum+1;
  fAct=f_clk/100; //fActual = m_sig_counts / (#clock counts*tau_c) = m * f_clk/n
  repeat (4*m*clk_units) begin
    #1000 sig=~sig; //tau_s=tau_c * f_clk/f_sig = 10*100=1000
  end

  //Test 3: f_sig/f_clk = 1/50
  testNum=testNum+1;
  fAct=f_clk/50; //fActual = m_sig_counts / (#clock counts*tau_c) = m * f_clk/n
  repeat (3*m*clk_units) begin
    #500 sig=~sig; //tau_s=tau_c * f_clk/f_sig = 10*50=500
  end
  
  //Test 4: f_sig/f_clk=1/23
  testNum=testNum+1;
  fAct=f_clk/23; //fActual = m_sig_counts / (#clock counts*tau_c) = m * f_clk/n
  repeat (3*m*clk_units) begin
    #230 sig=~sig; //tau_s=tau_c * f_clk/f_sig = 10*23=230
  end

  //Test 5: f_sig faster than f_clk: f_sig/f_clk=5
  testNum=testNum+1;
  fAct=f_clk*5; //fActual = m_sig_counts / (#clock counts*tau_c) = m * f_clk/n
  repeat (8*m*clk_units) begin
    #2 sig=~sig; //tau_s=tau_c * f_clk/f_sig = 10/5=2
  end

  $display("Now make tests last for non-integer or half-integer numbers of M*sig posedges.");
  //Test 6: f_sig/f_clk = 1/50
  testNum=testNum+1;
  fAct=f_clk/50; //fActual = m_sig_counts / (#clock counts*tau_c) = m * f_clk/n
  repeat (2*m*clk_units+3) begin
    #500 sig=~sig; //tau_s=tau_c * f_clk/f_sig = 10*50=500
  end
  
  //Test 7: f_sig/f_clk=1/23
  testNum=testNum+1;
  fAct=f_clk/23; //fActual = m_sig_counts / (#clock counts*tau_c) = m * f_clk/n
  repeat (4*m*clk_units+7) begin
    #230 sig=~sig; //tau_s=tau_c * f_clk/f_sig = 10*23=230
  end

  //Test 8: f_sig/f_clk=1/100000
  testNum=testNum+1;
  fAct=f_clk/1000; //fActual = m_sig_counts / (#clock counts*tau_c) = m * f_clk/n
  repeat (4*m*clk_units+1) begin
    #10000 sig=~sig; //tau_s=tau_c * f_clk/f_sig = 10*100000=1000000
  end

//  $display("Now simulate noise by setting a bit on codeSer");
 // assign #10 codeSer<={codeSer[6:3],1,codeSer[1:0]};

  //Test 9: f_sig/f_clk=1/23
//  testNum=testNum+1;
//  fAct=f_clk/10; //fActual = m_sig_counts / (#clock counts*tau_c) = m * f_clk/n
//  repeat (4*m+7) begin
//    #100 sig=~sig; //tau_s=tau_c * f_clk/f_sig = 10*10=100
//  end

  #5 $finish; //Stop the simulation
end

always begin
  //Choose larger number of cycles between clock edges to allow for
  //different ratios of sig and clock frequencies.
  #10
  clk=~clk; //Invert clock
end
endmodule

