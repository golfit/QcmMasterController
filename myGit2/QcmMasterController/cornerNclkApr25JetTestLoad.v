reg [13:0] n_clk_corner[0:79];
//reg [13:0] n_clk_corner[0:3];

//HACK
//Because, as of 2012 spring, Verilog cannot handle passing anything but
//vectors in port lists, and `include statements can't seem to take a variable
//string as a filename argument, and 2D parameter arrays don't seem to be allowed,
//either...
//...in order to allow the look-up table to source multiple tables without changing
//the code, and to specify which look-up table to use from a level up in the hierarchy
//(from the main (top) module)...
//...this data file which contain all look-up tables and will have a switch-style
//if-then list in the initial block, looking at a parameter from the parent which 
//is including this file, and selecting the look-up table appropriately.
initial begin
	//	n_clk_corner[0]=14'b11110111100; //101 kHz
	//	n_clk_corner[1]=14'b11110101000; //102 kHz
	//	n_clk_corner[2]=14'b11110010101; //103 kHz
	//	n_clk_corner[3]=14'b11110000011; //104 kHz

	//These lookup tables are found by looking up corresponding center frequencies
	//of equivalent Cs and Cp from ideal Cs and Cp, and then interpolating in
	//between to find the upper corner frequencies.
	if (LOOKUP_ID==2) begin
		$display("Lookup table #2 used"); //Parallel capacitors

		//UPDATED APRIL 25, 2013 FOR MATCHING TO JET TEST LOAD
		//Parallel Code, T=5.80:1, effective capacitance data from 1120604903
		//This is for use with the combiner/transformer, which has two nominally 4:1 cores and series leakage resistance ~=0.153 ohms.
		//Load: from measurements of JET Test Load on April 24, 2013, using Agilent oscilloscope.
		//Corner frequencies for capacitor lookup table:
		//Corner frequencies between tuning code configurations = N-index and N-index+1
		//where N = total number of configurations (including baseload), and index
		//index is the index of n_clk_corner.
		n_clk_corner[0]=14'b110011001010; //f=61 kHz
		n_clk_corner[1]=14'b110000110001; //f=64 kHz
		n_clk_corner[2]=14'b101110110101; //f=67 kHz
		n_clk_corner[3]=14'b101101001010; //f=69 kHz
		n_clk_corner[4]=14'b101011100010; //f=72 kHz
		n_clk_corner[5]=14'b101001111111; //f=74 kHz
		n_clk_corner[6]=14'b101000100101; //f=77 kHz
		n_clk_corner[7]=14'b100111001110; //f=80 kHz
		n_clk_corner[8]=14'b100101111100; //f=82 kHz
		n_clk_corner[9]=14'b100100101101; //f=85 kHz
		n_clk_corner[10]=14'b100011100000; //f=88 kHz
		n_clk_corner[11]=14'b100010010101; //f=91 kHz
		n_clk_corner[12]=14'b100001001101; //f=94 kHz
		n_clk_corner[13]=14'b100000000111; //f=97 kHz
		n_clk_corner[14]=14'b11111000100; //f=101 kHz
		n_clk_corner[15]=14'b11110000010; //f=104 kHz
		n_clk_corner[16]=14'b11101000011; //f=108 kHz
		n_clk_corner[17]=14'b11100000110; //f=111 kHz
		n_clk_corner[18]=14'b11011001010; //f=115 kHz
		n_clk_corner[19]=14'b11010010010; //f=119 kHz
		n_clk_corner[20]=14'b11001011011; //f=123 kHz
		n_clk_corner[21]=14'b11000100110; //f=127 kHz
		n_clk_corner[22]=14'b10111110010; //f=131 kHz
		n_clk_corner[23]=14'b10111000001; //f=136 kHz
		n_clk_corner[24]=14'b10110010010; //f=140 kHz
		n_clk_corner[25]=14'b10101100100; //f=145 kHz
		n_clk_corner[26]=14'b10100111000; //f=150 kHz
		n_clk_corner[27]=14'b10100001110; //f=154 kHz
		n_clk_corner[28]=14'b10011100101; //f=159 kHz
		n_clk_corner[29]=14'b10010111110; //f=165 kHz
		n_clk_corner[30]=14'b10010011001; //f=170 kHz
		n_clk_corner[31]=14'b10001110110; //f=175 kHz
		n_clk_corner[32]=14'b10001010011; //f=181 kHz
		n_clk_corner[33]=14'b10000110001; //f=186 kHz
		n_clk_corner[34]=14'b10000010001; //f=192 kHz
		n_clk_corner[35]=14'b1111110010; //f=198 kHz
		n_clk_corner[36]=14'b1111010100; //f=204 kHz
		n_clk_corner[37]=14'b1110111000; //f=210 kHz
		n_clk_corner[38]=14'b1110011100; //f=216 kHz
		n_clk_corner[39]=14'b1110000001; //f=223 kHz
		n_clk_corner[40]=14'b1101100111; //f=230 kHz
		n_clk_corner[41]=14'b1101001110; //f=236 kHz
		n_clk_corner[42]=14'b1100110101; //f=243 kHz
		n_clk_corner[43]=14'b1100011110; //f=250 kHz
		n_clk_corner[44]=14'b1100000111; //f=258 kHz
		n_clk_corner[45]=14'b1011110001; //f=266 kHz
		n_clk_corner[46]=14'b1011011011; //f=273 kHz
		n_clk_corner[47]=14'b1011000110; //f=281 kHz
		n_clk_corner[48]=14'b1010110010; //f=290 kHz
		n_clk_corner[49]=14'b1010011111; //f=298 kHz
		n_clk_corner[50]=14'b1010001100; //f=306 kHz
		n_clk_corner[51]=14'b1001111011; //f=315 kHz
		n_clk_corner[52]=14'b1001100111; //f=325 kHz
		n_clk_corner[53]=14'b1001010100; //f=335 kHz
		n_clk_corner[54]=14'b1001000100; //f=344 kHz
		n_clk_corner[55]=14'b1000110110; //f=353 kHz
		n_clk_corner[56]=14'b1000101000; //f=362 kHz
		n_clk_corner[57]=14'b1000011010; //f=371 kHz
		n_clk_corner[58]=14'b1000001101; //f=380 kHz
		n_clk_corner[59]=14'b1000000001; //f=389 kHz
		n_clk_corner[60]=14'b111110110; //f=398 kHz
		n_clk_corner[61]=14'b111101101; //f=405 kHz
		n_clk_corner[62]=14'b111100101; //f=412 kHz
		n_clk_corner[63]=14'b111011011; //f=421 kHz
		n_clk_corner[64]=14'b111010010; //f=429 kHz
		n_clk_corner[65]=14'b111001010; //f=436 kHz
		n_clk_corner[66]=14'b111000100; //f=442 kHz
		n_clk_corner[67]=14'b110111110; //f=448 kHz
		n_clk_corner[68]=14'b110111000; //f=454 kHz
		n_clk_corner[69]=14'b110110011; //f=459 kHz
		n_clk_corner[70]=14'b110101110; //f=465 kHz
		n_clk_corner[71]=14'b110101001; //f=470 kHz
		n_clk_corner[72]=14'b110100110; //f=474 kHz
		n_clk_corner[73]=14'b110100001; //f=479 kHz
		n_clk_corner[74]=14'b110011001; //f=488 kHz
		n_clk_corner[75]=14'b110010001; //f=498 kHz
		n_clk_corner[76]=14'b110001010; //f=507 kHz
		n_clk_corner[77]=14'b110000011; //f=516 kHz
		n_clk_corner[78]=14'b101110101; //f=535 kHz
		n_clk_corner[79]=14'b101101010; //f=551 kHz

	end else begin
		$display("Lookup table #1 used"); //Series capacitors
		//UPDATED APRIL 25, 2013 FOR MATCHING TO JET TEST LOAD
		//Series Code, T=5.80:1, effective capacitance data from 1120604903
		//Load: from measurements of JET Test Load on April 24, 2013, using Agilent oscilloscope.
		//Corner frequencies for capacitor lookup table:
		//Corner frequencies between tuning code configurations = N-index and N-index+1
		//where N = total number of configurations (including baseload), and index
		//index is the index of n_clk_corner.
		n_clk_corner[0]=14'b1000100110100; //f=45 kHz
		n_clk_corner[1]=14'b1000100000100; //f=46 kHz
		n_clk_corner[2]=14'b1000011000111; //f=47 kHz
		n_clk_corner[3]=14'b1000001111100; //f=47 kHz
		n_clk_corner[4]=14'b1000001000011; //f=48 kHz
		n_clk_corner[5]=14'b1000000001100; //f=49 kHz
		n_clk_corner[6]=14'b111111010101; //f=49 kHz
		n_clk_corner[7]=14'b111110011111; //f=50 kHz
		n_clk_corner[8]=14'b111101101001; //f=51 kHz
		n_clk_corner[9]=14'b111100111001; //f=51 kHz
		n_clk_corner[10]=14'b111100001111; //f=52 kHz
		n_clk_corner[11]=14'b111011100101; //f=52 kHz
		n_clk_corner[12]=14'b111010111001; //f=53 kHz
		n_clk_corner[13]=14'b111010001110; //f=54 kHz
		n_clk_corner[14]=14'b111001100100; //f=54 kHz
		n_clk_corner[15]=14'b111000111011; //f=55 kHz
		n_clk_corner[16]=14'b111000010100; //f=55 kHz
		n_clk_corner[17]=14'b110111101110; //f=56 kHz
		n_clk_corner[18]=14'b110111001010; //f=57 kHz
		n_clk_corner[19]=14'b110110100000; //f=57 kHz
		n_clk_corner[20]=14'b110101101101; //f=58 kHz
		n_clk_corner[21]=14'b110100110110; //f=59 kHz
		n_clk_corner[22]=14'b110011111110; //f=60 kHz
		n_clk_corner[23]=14'b110011000011; //f=61 kHz
		n_clk_corner[24]=14'b110010000100; //f=62 kHz
		n_clk_corner[25]=14'b110000111111; //f=64 kHz
		n_clk_corner[26]=14'b101111111001; //f=65 kHz
		n_clk_corner[27]=14'b101110110000; //f=67 kHz
		n_clk_corner[28]=14'b101101101000; //f=68 kHz
		n_clk_corner[29]=14'b101100100110; //f=70 kHz
		n_clk_corner[30]=14'b101011100111; //f=72 kHz
		n_clk_corner[31]=14'b101010100111; //f=73 kHz
		n_clk_corner[32]=14'b101001100101; //f=75 kHz
		n_clk_corner[33]=14'b101000100110; //f=77 kHz
		n_clk_corner[34]=14'b100111101011; //f=79 kHz
		n_clk_corner[35]=14'b100110110000; //f=81 kHz
		n_clk_corner[36]=14'b100101110101; //f=83 kHz
		n_clk_corner[37]=14'b100100111010; //f=85 kHz
		n_clk_corner[38]=14'b100100000000; //f=87 kHz
		n_clk_corner[39]=14'b100011000110; //f=89 kHz
		n_clk_corner[40]=14'b100010001111; //f=91 kHz
		n_clk_corner[41]=14'b100001011001; //f=94 kHz
		n_clk_corner[42]=14'b100000100100; //f=96 kHz
		n_clk_corner[43]=14'b11111101111; //f=98 kHz
		n_clk_corner[44]=14'b11110111100; //f=101 kHz
		n_clk_corner[45]=14'b11110001101; //f=103 kHz
		n_clk_corner[46]=14'b11101100010; //f=106 kHz
		n_clk_corner[47]=14'b11100110111; //f=108 kHz
		n_clk_corner[48]=14'b11100001111; //f=111 kHz
		n_clk_corner[49]=14'b11011101000; //f=113 kHz
		n_clk_corner[50]=14'b11011000000; //f=116 kHz
		n_clk_corner[51]=14'b11010011000; //f=118 kHz
		n_clk_corner[52]=14'b11001110001; //f=121 kHz
		n_clk_corner[53]=14'b11001101001; //f=122 kHz
		n_clk_corner[54]=14'b11001011110; //f=123 kHz
		n_clk_corner[55]=14'b11000110010; //f=126 kHz
		n_clk_corner[56]=14'b11000001100; //f=129 kHz
		n_clk_corner[57]=14'b10111100110; //f=132 kHz
		n_clk_corner[58]=14'b10110111011; //f=136 kHz
		n_clk_corner[59]=14'b10110010100; //f=140 kHz
		n_clk_corner[60]=14'b10101101110; //f=144 kHz
		n_clk_corner[61]=14'b10101001001; //f=148 kHz
		n_clk_corner[62]=14'b10011111010; //f=157 kHz
		n_clk_corner[63]=14'b10010110011; //f=166 kHz
		n_clk_corner[64]=14'b10010010001; //f=171 kHz
		n_clk_corner[65]=14'b10001101101; //f=176 kHz
		n_clk_corner[66]=14'b10001001011; //f=182 kHz
		n_clk_corner[67]=14'b10000101100; //f=187 kHz
		n_clk_corner[68]=14'b10000001110; //f=193 kHz
		n_clk_corner[69]=14'b1111101111; //f=199 kHz
		n_clk_corner[70]=14'b1111001111; //f=205 kHz
		n_clk_corner[71]=14'b1110111100; //f=209 kHz
		n_clk_corner[72]=14'b1110101000; //f=214 kHz
		n_clk_corner[73]=14'b1110000111; //f=221 kHz
		n_clk_corner[74]=14'b1101100110; //f=230 kHz
		n_clk_corner[75]=14'b1101001001; //f=238 kHz
		n_clk_corner[76]=14'b1100101011; //f=246 kHz
		n_clk_corner[77]=14'b1100001101; //f=256 kHz
		n_clk_corner[78]=14'b1011101110; //f=266 kHz
		n_clk_corner[79]=14'b1011011110; //f=272 kHz



	end
end
