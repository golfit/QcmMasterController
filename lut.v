module lut(clk,f, state);
/* This module contains the framework for an eighty-state look-up table.
It takes a seed value followed by an arbitrary list of 79 corner values in
ascending order and uses if-else conditionals, selecting
if(val<val0), state0, if(val<val1), state1, ..., else state_80.
State changes are made on clock edges.
*/

input clk;
input [13:0] f;
output reg [6:0] state;

//Note that this file should not be included in the project because it is not
//a fully-defined Verilog entity, but a snippet of code.  It should
//remain in the working directory, however.

//Load corner frequencies.
`include "cornerFreq.v" 

always @(posedge clk) begin
	//For now, limit to the 4 states that will be used in the initial 1-board tests.

	if(f<fc[0]) state=7'b1010000; //Lowest frequency - hold state for all frequencies lower.
	else if(f<fc[1]) state=7'b1001111;
	else if(f<fc[2]) state=7'b1001110;
	else if(f<fc[3]) state=7'b1001101;
	else if(f<fc[4]) state=7'b1001100;
	else if(f<fc[5]) state=7'b1001011;
	else if(f<fc[6]) state=7'b1001010;
	else if(f<fc[7]) state=7'b1001001;
	else if(f<fc[8]) state=7'b1001000;
	else if(f<fc[9]) state=7'b1000111;
	else if(f<fc[10]) state=7'b1000110;
	else if(f<fc[11]) state=7'b1000101;
	else if(f<fc[12]) state=7'b1000100;
	else if(f<fc[13]) state=7'b1000011;
	else if(f<fc[14]) state=7'b1000010;
	else if(f<fc[15]) state=7'b1000001;
	else if(f<fc[16]) state=7'b1000000;
	else if(f<fc[17]) state=7'b111111;
	else if(f<fc[18]) state=7'b111110;
	else if(f<fc[19]) state=7'b111101;
	else if(f<fc[20]) state=7'b111100;
	else if(f<fc[21]) state=7'b111011;
	else if(f<fc[22]) state=7'b111010;
	else if(f<fc[23]) state=7'b111001;
	else if(f<fc[24]) state=7'b111000;
	else if(f<fc[25]) state=7'b110111;
	else if(f<fc[26]) state=7'b110110;
	else if(f<fc[27]) state=7'b110101;
	else if(f<fc[28]) state=7'b110100;
	else if(f<fc[29]) state=7'b110011;
	else if(f<fc[30]) state=7'b110010;
	else if(f<fc[31]) state=7'b110001;
	else if(f<fc[32]) state=7'b110000;
	else if(f<fc[33]) state=7'b101111;
	else if(f<fc[34]) state=7'b101110;
	else if(f<fc[35]) state=7'b101101;
	else if(f<fc[36]) state=7'b101100;
	else if(f<fc[37]) state=7'b101011;
	else if(f<fc[38]) state=7'b101010;
	else if(f<fc[39]) state=7'b101001;
	else if(f<fc[40]) state=7'b101000;
	else if(f<fc[41]) state=7'b100111;
	else if(f<fc[42]) state=7'b100110;
	else if(f<fc[43]) state=7'b100101;
	else if(f<fc[44]) state=7'b100100;
	else if(f<fc[45]) state=7'b100011;
	else if(f<fc[46]) state=7'b100010;
	else if(f<fc[47]) state=7'b100001;
	else if(f<fc[48]) state=7'b100000;
	else if(f<fc[49]) state=7'b11111;
	else if(f<fc[50]) state=7'b11110;
	else if(f<fc[51]) state=7'b11101;
	else if(f<fc[52]) state=7'b11100;
	else if(f<fc[53]) state=7'b11011;
	else if(f<fc[54]) state=7'b11010;
	else if(f<fc[55]) state=7'b11001;
	else if(f<fc[56]) state=7'b11000;
	else if(f<fc[57]) state=7'b10111;
	else if(f<fc[58]) state=7'b10110;
	else if(f<fc[59]) state=7'b10101;
	else if(f<fc[60]) state=7'b10100;
	else if(f<fc[61]) state=7'b10011;
	else if(f<fc[62]) state=7'b10010;
	else if(f<fc[63]) state=7'b10001;
	else if(f<fc[64]) state=7'b10000;
	else if(f<fc[65]) state=7'b1111;
	else if(f<fc[66]) state=7'b1110;
	else if(f<fc[67]) state=7'b1101;
	else if(f<fc[68]) state=7'b1100;
	else if(f<fc[69]) state=7'b1011;
	else if(f<fc[70]) state=7'b1010;
	else if(f<fc[71]) state=7'b1001;
	else if(f<fc[72]) state=7'b1000;
	else if(f<fc[73]) state=7'b111;
	else if(f<fc[74]) state=7'b110;
	else if(f<fc[75]) state=7'b101;
	else if(f<fc[76]) state=7'b100;
	else if(f<fc[77]) state=7'b11;
	else if(f<fc[78]) state=7'b10;
	else if(f<fc[79]) state=7'b1;
	else state=7'b0; //Highest frequency - baseload for all frequencies higher.

end

endmodule
