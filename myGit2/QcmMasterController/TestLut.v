//`timescale=125ns/1ns

module TestLut ();

reg clk;
reg [13:0] f;
wire [6:0] state;

lut tab(clk,f,state);

initial  begin
  $dumpfile ("lutTestBench.vcd"); 
  $dumpvars; 
end 

initial  begin
  $display("\t\ttime,\tf,\tstate"); 
  $monitor("%d,\t%b,\t%b",$time, f,state); 
end 

initial
  #150 $finish; //Stop execution after 150 timesteps.

initial begin
  #0
  clk=1'b0; //Initialize clk.
  f=14'b0;

  //Loop through a number of frequencies and look at output of state.
  #5
  //for (f=4'd950; f<4'd1050; #5 f=f+4'd5) //5 time unit delay.
  for ( f=14'b1110110110; f<14'b10000011010; f=f+14'b101 ) begin
    #5 ;
  end
  //Try funky frequencies.
  //#5 f=14'b0;
  #5 f=14'b11111111111111;
end

always begin
  #1 clk=!clk; //Invert clock
end

endmodule
