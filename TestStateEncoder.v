module TestStateEncoder();


//Inputs to encoder
reg clk, enable;
//reg [6:0] state;
reg [13:0] state;
//Encoder output.
wire out;

defparam e.STATE_LENGTH=4'b1110;

stateEncoder e(clk, state, enable, out);

initial begin
	$dumpfile ("TestStateEncoderTestbench.vcd");
	$dumpvars;
end

initial begin
	$display("\tTime\tState\tEnable\tOutput");
	$monitor("\t%d\t%b\t%b\t%b",$time, state,enable,out);
end

//Simulation block
initial begin
	#0
	//state=7'b1100110; //State
	state=14'b11001100000; //State
	clk=1'b1; //Start clock high so first inversion is a falling edge.

	#10 //Wait 5 clock positive edges.
	enable = 1'b1; //Trigger enable.
	$display("Enable triggered.");

	#6 enable = 1'b0;

	#6 enable = 1'b1; //Output will not be done - check to make sure that this enable state going high does not change output.
	$display("Enable triggered.");

	#6 enable = 1'b0; //Reset enable.

	#50 //Wait, change state, and then trigger enable.
	//state=7'b0011001;
	state=14'b00110010000;

	#10
	enable = 1'b1;
	$display("Enable triggered.");
	#10 enable=1'b0;

	#50 $finish; //End simulation
end

//Make clock
always begin
	#1
	clk=~clk; //Invert clock
end

endmodule

