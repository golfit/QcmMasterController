module TestDriver();
//This module tests the driver module, which functions by listening for changes in the state, waiting for the state to settle, and then setting HIGH the level of the enable flag.
//
//Things to test are:
// (1) driver responds to changes in state and waits the appropriate number of clock cycles before setting enable
// (2) driver will continue to wait for state to settle as long as state changes before settle time is up.
// (3) enable remains HIGH for sufficient period of time
// (4) enable remains HIGH even if state changes while enable is HIGH.
//
//Ted Golfinopoulos, 20 Oct 2011

reg clk; //Clock
reg [6:0] state; //State input to driver.
wire enable; //Output from driver.

//Instantiate driver.
driver d(clk, state, enable);

initial begin
	$dumpfile("driverTestBench.vcd");
	$dumpvars;
end

initial begin
	$display("\ttime\tstate\tenable");
	$monitor("%d\t%b\t%b", $time, state, enable);
end

initial begin
	#0 clk=1'b0; //Initialize clock.
	state=7'b0; //Initialize state.
	//Enable is not initialized.

	//(1) check that driver responds to changes in state
	//and waits the appropriate number of clock cycles before setting enable.
	// (3) check that enable remains HIGH for sufficient period of time (2^5-1 clock posedges=31=62 time units)
	#10 state=state+7'b1; //Change state.
	#100 state=7'b1000; //Try a different state.
	#100 state=7'b1000000; //Try a different state.

	// (2) check that driver will continue to wait for state to settle
	// as long as state changes before settle wait time (2^3-1=7 clock posedges=14 time units) is up.
	repeat (10) #3 state=state+7'b1; //Keep changing state.
	repeat (10) #13 state=state+7'b1; //Keep changing state.

	// (4) enable remains HIGH even if state changes while enable is HIGH.
	#100 state=state+7'b1;
	repeat (3) #16 state=state+7'b1;

	#100 $finish; //End the simulation.
end

always begin
	#1 clk=~clk; //Invert clock.
end

endmodule

