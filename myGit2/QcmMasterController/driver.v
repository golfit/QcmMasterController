module driver (clk, state, enable);
/*
Listen for state changes; on such changes, wait a specified number
of clock cycles, and then trigger enable bit to indicate state change.
Because the CapBoardDecoder works on the enable level rather than the enable
edge, enable should be on for some period of time.  If enable is on
so long as to overlap with the next state change, this should not present a problem;
the CapBoardDecoders will then just make two consecutive changes.
*/

input clk;
input [6:0] state; //7 bit number to go on backplane logic bus
output enable; // gating signal telling listener boards when to update.
reg enableReg; //Signal to modify in procedural blocks corresponding to enable.

//Allow state to settle first for triggering enable.
reg [2:0] settleTimeCntr;
//Leave enable on for 31 clock cycles before resetting - give CapBoardDecoder a chance to make sure enable trigger is genuine.
reg [4:0] enableOnCntr;

reg settleTimeFlag; //Flag indicating whether we are waiting for state to settle.
reg enableOnFlag; //Flag indicating whether we are waiting for enable to finish its ON cycle after a settled state change.

reg [6:0] stateLast; //Store previous state to listen for changes.

//Wait times
parameter SETTLE_TIME=3'b111;
parameter ENABLE_ON_TIME=5'b11111;

initial begin
	stateLast=7'b0; //Initialize stateLast.
	settleTimeCntr=3'b0; //Initialize counter which increments while waiting for state to settle.
	enableOnCntr=5'b0; //Initialize counter which increments while leaving the state-change-enable flag bit on.
	settleTimeFlag=1'b0; //Initialize flag indicating that we are waiting for state to settle.
	enableOnFlag=1'b0; //Initialize flag indicating that we should leave the enable bit ON.
	
	//The compiler once reported that the enable was getting locked at 0;
	//now, it does not report this, and I don't know what changed.
	enableReg=1'b0; //Initialize enable bit to OFF.
	
end

//Listen for changes in state by comparing state between clock pulses.
always @(posedge clk) begin
	//If there is a state change, wait for a period, then trigger enable on
	//for a period, then turn off enable, update the stored state, and
	//continue listening.
	if(|(stateLast - state)) begin //If there is any difference between the the current and last state
		//Reset settle time and enable on counter - this is in case
		//there is another state change while we are waiting for state to settle.
		settleTimeCntr=3'b0;
		
		//Trigger flag for counting settle time
		settleTimeFlag=1'b1;
		
		stateLast=state; //Update state.
	end
	
	//If settleTimeFlag is ON, start incrementing counter
	//which determines the time since the last state change; if it
	//reaches its threshold value of 7, then the state is considered "stable"
	//after its last change, and we can turn on the ENABLE bit.
	if(settleTimeFlag) begin
		if(settleTimeCntr==SETTLE_TIME) begin
			settleTimeFlag=1'b0; //The state is settled - turn settle time wait flag off.
			enableOnFlag=1'b1; //Indicate that the ENABLE on time period should begin.
			settleTimeCntr=3'b0; //Zero counter.
			//Zero enable on counter - this is in case there are overlapping on-times
			//associated with state changes - make sure that the last state change
			//gets the full enable-on period.
			enableOnCntr=5'b0;
		end else settleTimeCntr=settleTimeCntr+3'b1; //Increment.
	end
	
	//If enableOnFlag is ON, start incrementing counter which determines
	//how long the enable bit has bin on.  Once it has been on for its
	//threshold period of time - when the enableOnCntr==31 - turn off
	//enable and its flag.
	if(enableOnFlag) begin
		if(enableOnCntr==ENABLE_ON_TIME) begin
			enableReg=1'b0; //Turn off enable bit.
			enableOnFlag=1'b0; //Enable doesn't need to be on any more.
			enableOnCntr=5'b0; //Zero counter.
		end else begin
			enableReg=1'b1; //Keep enable bit on.
			enableOnCntr=enableOnCntr+5'b1; //Increment.
		end
	end
end

assign enable=enableReg; //Tie actual enable output to the associated register variable.

endmodule
