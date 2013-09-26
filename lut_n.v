module lut_n(clk,n_clk, state);
/* This module contains the framework for an eighty-state look-up table.
It takes a seed value followed by an arbitrary list of 79 corner values in
ascending order and uses if-else conditionals, selecting
if(val<val0), state0, if(val<val1), state1, ..., else state_80.
State changes are made on clock edges.
*/

input clk;
input [13:0] n_clk;
output reg [6:0] state;

//To calibrate the matching network, it is useful to use a coarser look-up table
//with switches separated by wider frequency gaps.  This increases the likelihood
//that we will actually see the center-frequency.  To facilitate this, a macro
//is defined that lets us shift the subset of switching states selected from the total
//available set, advancing the coarse-grid by offset number of levels.
parameter OFFSET=4'b0100;

//Note that this file should not be included in the project because it is not
//a fully-defined Verilog entity, but a snippet of code.  It should
//remain in the working directory, however.

//Load corner clock counts.
//parameter cornerNclkFilename="cornerNclk.v"
//Define a default parameter specifying which lookup table to use.  
//This is a hack because 2D arrays cannot be passed in the port list.
parameter LOOKUP_ID=1;
`include "cornerNclk.v" 

always @(posedge clk) begin
//	if(n_clk>n_clk_corner[0]) state=7'b110011; //f>101&f<102
//	else if(n_clk>n_clk_corner[1]) state=7'b110010; //f>102&f<103
//	else if(n_clk>n_clk_corner[2]) state=7'b110001; //f>103&f<104
//	else if(n_clk>n_clk_corner[3]) state=7'b110000; //f>104
//	else state=7'b110000-7'b1; //f>104 Higher frequencies than period from n_clk_corner[3]

//	if(n_clk>n_clk_corner[0]) state=7'b1001111; //Lowest frequency - hold state for all frequencies lower
//	//else if(n_clk>n_clk_corner[1]) state=7'b1001111+OFFSET;
//	else if(n_clk>n_clk_corner[9-OFFSET]) state=7'b1000111+OFFSET;
//	else if(n_clk>n_clk_corner[17-OFFSET]) state=7'b111111+OFFSET;
//	else if(n_clk>n_clk_corner[25-OFFSET]) state=7'b110111+OFFSET;
//	else if(n_clk>n_clk_corner[33-OFFSET]) state=7'b101111+OFFSET;
//	else if(n_clk>n_clk_corner[41-OFFSET]) state=7'b100111+OFFSET;
//	else if(n_clk>n_clk_corner[49-OFFSET]) state=7'b11111+OFFSET;
//	else if(n_clk>n_clk_corner[57-OFFSET]) state=7'b10111+OFFSET;
//	else if(n_clk>n_clk_corner[65-OFFSET]) state=7'b1111+OFFSET;
//	else if(n_clk>n_clk_corner[73-OFFSET]) state=7'b111+OFFSET;
//	else state=7'b0+OFFSET; //Highest frequency = - baseload for all frequencies higher.

	if(n_clk>n_clk_corner[0]) state=7'b1010000; //Lowest frequency - hold state for all frequencies lower
	else if(n_clk>n_clk_corner[1]) state=7'b1001111;
	else if(n_clk>n_clk_corner[2]) state=7'b1001110;
	else if(n_clk>n_clk_corner[3]) state=7'b1001101;
	else if(n_clk>n_clk_corner[4]) state=7'b1001100;
	else if(n_clk>n_clk_corner[5]) state=7'b1001011;
	else if(n_clk>n_clk_corner[6]) state=7'b1001010;
	else if(n_clk>n_clk_corner[7]) state=7'b1001001;
	else if(n_clk>n_clk_corner[8]) state=7'b1001000;
	else if(n_clk>n_clk_corner[9]) state=7'b1000111;
	else if(n_clk>n_clk_corner[10]) state=7'b1000110;
	else if(n_clk>n_clk_corner[11]) state=7'b1000101;
	else if(n_clk>n_clk_corner[12]) state=7'b1000100;
	else if(n_clk>n_clk_corner[13]) state=7'b1000011;
	else if(n_clk>n_clk_corner[14]) state=7'b1000010;
	else if(n_clk>n_clk_corner[15]) state=7'b1000001;
	else if(n_clk>n_clk_corner[16]) state=7'b1000000;
	else if(n_clk>n_clk_corner[17]) state=7'b111111;
	else if(n_clk>n_clk_corner[18]) state=7'b111110;
	else if(n_clk>n_clk_corner[19]) state=7'b111101;
	else if(n_clk>n_clk_corner[20]) state=7'b111100;
	else if(n_clk>n_clk_corner[21]) state=7'b111011;
	else if(n_clk>n_clk_corner[22]) state=7'b111010;
	else if(n_clk>n_clk_corner[23]) state=7'b111001;
	else if(n_clk>n_clk_corner[24]) state=7'b111000;
	else if(n_clk>n_clk_corner[25]) state=7'b110111;
	else if(n_clk>n_clk_corner[26]) state=7'b110110;
	else if(n_clk>n_clk_corner[27]) state=7'b110101;
	else if(n_clk>n_clk_corner[28]) state=7'b110100;
	else if(n_clk>n_clk_corner[29]) state=7'b110011;
	else if(n_clk>n_clk_corner[30]) state=7'b110010;
	else if(n_clk>n_clk_corner[31]) state=7'b110001;
	else if(n_clk>n_clk_corner[32]) state=7'b110000;
	else if(n_clk>n_clk_corner[33]) state=7'b101111;
	else if(n_clk>n_clk_corner[34]) state=7'b101110;
	else if(n_clk>n_clk_corner[35]) state=7'b101101;
	else if(n_clk>n_clk_corner[36]) state=7'b101100;
	else if(n_clk>n_clk_corner[37]) state=7'b101011;
	else if(n_clk>n_clk_corner[38]) state=7'b101010;
	else if(n_clk>n_clk_corner[39]) state=7'b101001;
	else if(n_clk>n_clk_corner[40]) state=7'b101000;
	else if(n_clk>n_clk_corner[41]) state=7'b100111;
	else if(n_clk>n_clk_corner[42]) state=7'b100110;
	else if(n_clk>n_clk_corner[43]) state=7'b100101;
	else if(n_clk>n_clk_corner[44]) state=7'b100100;
	else if(n_clk>n_clk_corner[45]) state=7'b100011;
	else if(n_clk>n_clk_corner[46]) state=7'b100010;
	else if(n_clk>n_clk_corner[47]) state=7'b100001;
	else if(n_clk>n_clk_corner[48]) state=7'b100000;
	else if(n_clk>n_clk_corner[49]) state=7'b11111;
	else if(n_clk>n_clk_corner[50]) state=7'b11110;
	else if(n_clk>n_clk_corner[51]) state=7'b11101;
	else if(n_clk>n_clk_corner[52]) state=7'b11100;
	else if(n_clk>n_clk_corner[53]) state=7'b11011;
	else if(n_clk>n_clk_corner[54]) state=7'b11010;
	else if(n_clk>n_clk_corner[55]) state=7'b11001;
	else if(n_clk>n_clk_corner[56]) state=7'b11000;
	else if(n_clk>n_clk_corner[57]) state=7'b10111;
	else if(n_clk>n_clk_corner[58]) state=7'b10110;
	else if(n_clk>n_clk_corner[59]) state=7'b10101;
	else if(n_clk>n_clk_corner[60]) state=7'b10100;
	else if(n_clk>n_clk_corner[61]) state=7'b10011;
	else if(n_clk>n_clk_corner[62]) state=7'b10010;
	else if(n_clk>n_clk_corner[63]) state=7'b10001;
	else if(n_clk>n_clk_corner[64]) state=7'b10000;
	else if(n_clk>n_clk_corner[65]) state=7'b1111;
	else if(n_clk>n_clk_corner[66]) state=7'b1110;
	else if(n_clk>n_clk_corner[67]) state=7'b1101;
	else if(n_clk>n_clk_corner[68]) state=7'b1100;
	else if(n_clk>n_clk_corner[69]) state=7'b1011;
	else if(n_clk>n_clk_corner[70]) state=7'b1010;
	else if(n_clk>n_clk_corner[71]) state=7'b1001;
	else if(n_clk>n_clk_corner[72]) state=7'b1000;
	else if(n_clk>n_clk_corner[73]) state=7'b111;
	else if(n_clk>n_clk_corner[74]) state=7'b110;
	else if(n_clk>n_clk_corner[75]) state=7'b101;
	else if(n_clk>n_clk_corner[76]) state=7'b100;
	else if(n_clk>n_clk_corner[77]) state=7'b11;
	else if(n_clk>n_clk_corner[78]) state=7'b10;
	else if(n_clk>n_clk_corner[79]) state=7'b1;
	else state=7'b0; //Highest frequency = - baseload for all frequencies higher.

end

endmodule
