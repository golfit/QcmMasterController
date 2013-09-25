module stateEncoder(clk, state, enable, out);
/*
This module reads the state vector.  When it perceives a rising edge in the enable bit,
it is trigerred to encode the state information into a serial output sequence.  This is
done via the following protocol :

(header signal) (space) (first state bit) (space) (second state bit) (space) ... (last state bit) (space) (closer signal)

1. The header signal is a high state in the output for three consecutive clock cycles followed by a low state for one clock cycle
2. The spacer is two clock cycles in the low position.
3. the states are conveyed bit-by-bit in sequence from highest (most-significant) bit to lowest (least-significant) bit.  Three clock cycles are used.  The output is held high or low for one clock cycle according to whether the state bit is high or low.
4. the closer signal puts the output high for two clock cycles, then low.

The whole sequence takes 4 clock cycles for the header, #state bits+(#state bit+1)*2=23 for the state information, and 2 clock cycles for the closer.  In total, 29 clock cycles are used.

While a signal is being output during these 29 cycles, the enable bit is ignored.

Ted Golfinopoulos, 13 Jan 2012
*/

//`define STATE_LENGTH 4'b0111 //=7  -> Define a macro containing the number of bits in the state vector
//`define HEADER_LENGTH 3'b110 //Number of clock cycles in header sequence (6).

parameter STATE_LENGTH=4'b0111; //=7  -> Define a macro containing the number of bits in the state vector
parameter HEADER_LENGTH=3'b110; //Number of clock cycles in header sequence (6).

parameter HEADER_ON_COUNTS=2'b11; //Header should be on for this number of counts.
parameter CLOSER_ON_COUNTS=2'b10; //Closer should be on for this number of counts.

input clk; //Clock signal
//input [`STATE_LENGTH-1:0] state; //State vector to encode on serial output line.
//reg [`STATE_LENGTH-1:0] storedState; //Store state vector on an enable trigger for stability.
input [STATE_LENGTH-1:0] state; //State vector to encode on serial output line.
reg [STATE_LENGTH-1:0] storedState; //Store state vector on an enable trigger for stability.


input enable; //Trigger for encode action.

output out; //Serial output into which state vector is encoded.
reg outReg;

reg [4:0] cntr; //Five-bit counter, reused and reset in each output sequence block.
reg encodingInProgress, playState, playCloser, finished; //Flags determining which state of output sequence we are in.
reg [3:0] stateIndex; //Make one bit larger than needed as of 13 Jan 2012.


initial begin
	outReg=1'b0; //Initialize output storage register.
	//Set sequence flags low - wait for enable edge to output a state sequence.
	encodingInProgress=1'b0;
	playState=1'b0;
	playCloser=1'b0;
	finished=1'b0;
	//stateIndex=`STATE_LENGTH-1'b1;
	stateIndex=STATE_LENGTH-1'b1;
	storedState=1'b0; //Initialize stored state.
end

assign out=outReg; //Tie output to outReg.

//Output state sequence with a header and closer on an enable edge.
always @(posedge enable or posedge finished) begin
	//If another encoding job is not already in progress, initiate a new one.
	//Otherwise, don't change the current output message.
	if(enable) begin
		if( !encodingInProgress && !playState && !playCloser) begin
			storedState=state; //Store current state in a register.
			encodingInProgress=1'b1; //Set encodingInProgress flag high and begin encoding an output message.
		end
	end else if(finished) begin
		encodingInProgress=1'b0; //Set encodingInProgress flag low.
	end

end

//This always block is responsible for outputting the header signal
always @(posedge clk) begin
	if( !encodingInProgress ) begin
		outReg=1'b0; //Make sure output is low if a sequence is not being encoded.
		//Keep playState and playCloser flags off if not encoding.
		playState=1'b0;
		playCloser=1'b0;
		cntr=1'b0; //Keep counter at zero if encoding is not in progress.
		finished = 1'b0; //Turn off finished - it is only the positive edge of this flag that is used.
		//stateIndex=`STATE_LENGTH-1'b1; //Reset state index counter.
		stateIndex=STATE_LENGTH-1'b1; //Reset state index counter.
	end

	//If flag to play header is on, output header sequence until it is complete.
	//Then, free output control and intitiate signal sequence.
	//Note: encodingInProgress is clocked by enable and finished, and so we can't turn it off in this block.
	//Header output is terminated by inititiation of next stage in sequence, playState.
	if(encodingInProgress && !playState && !playCloser) begin
		cntr=cntr+1'b1; //Increment counter.
		if(cntr<=HEADER_ON_COUNTS) begin
			outReg=1'b1; //Assert output for header on period
			$display("HEADER ON");
		end else if(cntr<=HEADER_LENGTH) begin
			outReg=1'b0; //Pull output low during off period of header.
			$display("HEADER OFF");
		end else begin
			playState=1'b1; //Assert playState flag and initiate playState sequence.
			cntr=1'b0; //Reset counter.
			$display("HEADER DONE.");
		end
	end else if(!encodingInProgress) cntr=1'b0; //Continuously reset counter if not being used.

//end

//This always block is responsible for outputting the encoded state signal
//always @(posedge clk) begin
	//If flag to play state is on, output signal sequence until it is complete.
	//Then, free output control and initiate closer sequence.
	if(playState && !playCloser) begin
		$display("Displaying state bit %d", stateIndex);
		cntr=cntr+1'b1; //Increment counter.
		if(cntr==2'b10) begin
			outReg=storedState[stateIndex]; //Set output to 
		end else begin
			outReg=1'b0; //Pull output low (spacing between on periods during state sequence).
		end

		if(cntr==2'b11) begin
			cntr=1'b0; //Reset triplet counter
			//Decrement state index (note that we output starting
			//with most significant bit and go down to least significant bit).
			if(stateIndex>1'b0) begin
				stateIndex=stateIndex-1'b1;
			end else if(stateIndex==1'b0) begin //If the stateIndex is zero, the state encoding is done.
				playState=1'b0; //Reset signal output flag.
				playCloser=1'b1; //Advance to the playCloser stage of the encoded sequence.
				cntr=1'b0; //Reset triplet counter.
				//stateIndex=`STATE_LENGTH-1'b1; //Reset state index counter.
				stateIndex=STATE_LENGTH-1'b1; //Reset state index counter.
			end
		end
	end
//end

//This always block is responsible for outputting the closer signal.
//always @(posedge clk) begin
	//If the flag for plaging the closer is high, play the closer sequence until complete.
	//There should be to LOW clock cycles between the last state bit and the next potentially
	//high bit according to the documentation.  One low clock cycle is created in the playState
	//sequence.  The other one is created here.
	if(playCloser && !playState) begin
		cntr=cntr+1'b1; //Increment counter.
		if(cntr>2'b10 && cntr<=2'b10+CLOSER_ON_COUNTS) begin //The output is on when this condition is true.
			outReg=1'b1; //Assert output high for two clock cycles per closer protocol.
			$display("CLOSER ON.");
		end else if(cntr>=3'b100) begin
			outReg=1'b0; //Pull output low.  Encoded sequence is done.
			playCloser=1'b0; //Reset playCloser flag.
			finished=1'b1; //Reset finished bit flag, since encoding is done.
			cntr=1'b0; //Reset counter.
			$display("CLOSER OFF");
			$display("FINISHED");
		end else begin //The output is off when this condition is true (i.e. other conditions are false).
			outReg=1'b0;
			$display("CLOSER OFF");
		end
	end
end

endmodule

/*
`define CLOSER 4'b0110
`define SPACER 2'b10

reg [5:0] outputIndex;
*/

/*
		//Create output message.
		outputMessage={`HEADER, state, `CLOSER}; //Encode and cache output message.
*/

/*
outputMessage={`HEADER, `SPACER,
		state[6], `SPACER,
		state[5], `SPACER,
		state[4], `SPACER,
		state[3], `SPACER,
		state[2], `SPACER,
		state[1], `SPACER,
		state[0], `SPACER,
		`CLOSER};
*/

/*
	if(encodingInProgress) begin
		if(headerIndex<HEADER_LENGTH+1'b1) begin
			headerIndex=headerIndex+1'b1; //Increment header index
			assign out=header[headerIndex-1]; //Make a continuous assignment
		end else //Turn control over to signal player
			encodingInProgress=1'b0; //Turn off play header flag.
			playState=1'b1; //Initiate signal segment of message.
			deassign out;
		end
	end else begin
		headerIndex=1'b0; //Reset header index counter.
		encodingInProgress=1'b0; //Reset encodingInProgress flag.
	end
*/

/*
		//Insert first spacer.
		if(!firstSpacerFinished) begin
			if(cntr<`SPACER) begin
				assign out=1'b0;
				cntr=cntr+1'b1; //Increment counter
			end else begin
				cntr=0'b0; //Reset counter
				firstSpacerFinished=1'b1; //Assert that first spacer has been output.
			end
			stateIndex=1'b0; //Reset state index.
		end else begin
			if(stateIndex<`STATE_LENGTH) begin
				if(cntr==1'b0) begin
					assign out=
				else if(cntr <= `SPACER) begin

				end else begin cntr=1'b0; //Reset counter.
			end
		end

		//Play signals followed by spacers
*/
