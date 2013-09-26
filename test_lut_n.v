module test_lut_n();
//This is a test-bench for the look-up table.  The point is to make sure that different instances of lut_n can
//reference different lookup tables stored in the (`include-d) file, cornerNclk.v.
//
//Ted Golfinopoulos, 13 Mar 2012

reg clk;
reg [13:0] n_clk_cnts; //Holds (imagined) clock counter - number of clock periods.

wire [6:0] stateSer, statePar; //Register variables for outputs from lut_n.

//Instantiate a series and parallel lut_n
lut_n serLut(clk, n_clk_cnts, stateSer);
lut_n parLut(clk, n_clk_cnts, statePar);

//Tell each lut_n module instance to look at different look-up table.
defparam serLut.LOOKUP_ID=1;
defparam parLut.LOOKUP_ID=2;

//Don't dump variables.
//initial begin
//	$dumpfile ("test_lut_n_output.vcd");
//	$dumpvars;
//end

initial begin
	$display("\tTime\tState Ser\tState Par");
	$monitor("\t%d\t%b\t%b",$time, stateSer, statePar);
end

initial begin
	#0 clk=0; //Initialize clock.
	n_clk_cnts=1'b0; //Initialize period counter
end

//Main simulation block
initial begin
	#10 //Wait five clock cycles (10 inversions of clock state).
	
	//Sweep up in frequency => down in n_clk_cnts
	//From 40 kHz to 300 kHz => (#sync counts)/(input freq) * clk_freq = 50/40E3*4E6 = 1001110001000; 50/300E3*4E6=1010011010
	for (n_clk_cnts=14'b1001110001000; n_clk_cnts>=14'b1010011010; n_clk_cnts=n_clk_cnts-1'b1) begin
		#2; //Delay one full clock cycle		
		//if(n_clk_cnts % 10000==0) $display(n_clk_cnts);
	end

	//Sweep down in frequency => up in n_clk_cnts
	for (n_clk_cnts=14'b1010011010; n_clk_cnts<=14'b1001110001000; n_clk_cnts=n_clk_cnts+1'b1) begin
		#2; //Delay one full clock cycle
	//	if(n_clk_cnts % 10000==0) $display(n_clk_cnts);
	end

	#5 $finish; //Stop simulation.
end

always begin
	#1
	clk=~clk;
end

endmodule 

