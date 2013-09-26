// --------------------June 4th table below, swapped out on 25 Sep 2012
reg [13:0] n_clk_corner[0:79];

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
		//Parallel Code, T=5.80:1, effective capacitance data from 1120604903
		//This is for use with the combiner/transformer, which has two nominally 4:1 cores and series leakage resistance ~=0.153 ohms.
		//Load: R: f<150 kHz: data from 1120419902; f>150 kHz, earlier scope measurements.
		//L: take mean value for whole frequency range from 1120419902.
		//Corner frequencies for capacitor lookup table:
		//Corner frequencies between tuning code configurations = N-index and N-index+1
		//where N = total number of configurations (including baseload), and index
		//index is the index of n_clk_corner.
		//UPDATED 4 June 2012
		n_clk_corner[0]=14'b1000010000001; //f=47 kHz
		n_clk_corner[1]=14'b111110001100; //f=50 kHz
		n_clk_corner[2]=14'b111100000000; //f=52 kHz
		n_clk_corner[3]=14'b111001111000; //f=54 kHz
		n_clk_corner[4]=14'b111000000000; //f=56 kHz
		n_clk_corner[5]=14'b110110001100; //f=58 kHz
		n_clk_corner[6]=14'b110100011010; //f=60 kHz
		n_clk_corner[7]=14'b110010101111; //f=62 kHz
		n_clk_corner[8]=14'b110001001001; //f=64 kHz
		n_clk_corner[9]=14'b101111100000; //f=66 kHz
		n_clk_corner[10]=14'b101110000001; //f=68 kHz
		n_clk_corner[11]=14'b101100100000; //f=70 kHz
		n_clk_corner[12]=14'b101011000011; //f=73 kHz
		n_clk_corner[13]=14'b101001110001; //f=75 kHz
		n_clk_corner[14]=14'b101000011100; //f=77 kHz
		n_clk_corner[15]=14'b100111001011; //f=80 kHz
		n_clk_corner[16]=14'b100101111100; //f=82 kHz
		n_clk_corner[17]=14'b100100101101; //f=85 kHz
		n_clk_corner[18]=14'b100011011111; //f=88 kHz
		n_clk_corner[19]=14'b100010011001; //f=91 kHz
		n_clk_corner[20]=14'b100001010100; //f=94 kHz
		n_clk_corner[21]=14'b100000001101; //f=97 kHz
		n_clk_corner[22]=14'b11111001101; //f=100 kHz
		n_clk_corner[23]=14'b11110010100; //f=103 kHz
		n_clk_corner[24]=14'b11101011010; //f=106 kHz
		n_clk_corner[25]=14'b11100011100; //f=110 kHz
		n_clk_corner[26]=14'b11011011111; //f=114 kHz
		n_clk_corner[27]=14'b11010100111; //f=117 kHz
		n_clk_corner[28]=14'b11001110010; //f=121 kHz
		n_clk_corner[29]=14'b11000111011; //f=125 kHz
		n_clk_corner[30]=14'b11000000111; //f=130 kHz
		n_clk_corner[31]=14'b10111011000; //f=134 kHz
		n_clk_corner[32]=14'b10110101011; //f=138 kHz
		n_clk_corner[33]=14'b10110000011; //f=142 kHz
		n_clk_corner[34]=14'b10101011101; //f=146 kHz
		n_clk_corner[35]=14'b10100111001; //f=150 kHz
		n_clk_corner[36]=14'b10100010101; //f=154 kHz
		n_clk_corner[37]=14'b10011110100; //f=158 kHz
		n_clk_corner[38]=14'b10011010100; //f=162 kHz
		n_clk_corner[39]=14'b10010110110; //f=166 kHz
		n_clk_corner[40]=14'b10010011010; //f=170 kHz
		n_clk_corner[41]=14'b10001111100; //f=174 kHz
		n_clk_corner[42]=14'b10001100000; //f=179 kHz
		n_clk_corner[43]=14'b10001000110; //f=183 kHz
		n_clk_corner[44]=14'b10000101011; //f=187 kHz
		n_clk_corner[45]=14'b10000010010; //f=192 kHz
		n_clk_corner[46]=14'b1111111011; //f=196 kHz
		n_clk_corner[47]=14'b1111100100; //f=201 kHz
		n_clk_corner[48]=14'b1111001100; //f=206 kHz
		n_clk_corner[49]=14'b1110110100; //f=211 kHz
		n_clk_corner[50]=14'b1110100000; //f=215 kHz
		n_clk_corner[51]=14'b1110001110; //f=220 kHz
		n_clk_corner[52]=14'b1101111011; //f=224 kHz
		n_clk_corner[53]=14'b1101101010; //f=229 kHz
		n_clk_corner[54]=14'b1101011001; //f=233 kHz
		n_clk_corner[55]=14'b1101001001; //f=238 kHz
		n_clk_corner[56]=14'b1100101100; //f=246 kHz
		n_clk_corner[57]=14'b1100011110; //f=251 kHz
		n_clk_corner[58]=14'b1100100001; //f=250 kHz
		n_clk_corner[59]=14'b1100010111; //f=253 kHz
		n_clk_corner[60]=14'b1100001100; //f=256 kHz
		n_clk_corner[61]=14'b1100000010; //f=260 kHz
		n_clk_corner[62]=14'b1011110111; //f=263 kHz
		n_clk_corner[63]=14'b1011101111; //f=266 kHz
		n_clk_corner[64]=14'b1011100111; //f=269 kHz
		n_clk_corner[65]=14'b1011011110; //f=272 kHz
		n_clk_corner[66]=14'b1011010100; //f=276 kHz
		n_clk_corner[67]=14'b1011001101; //f=279 kHz
		n_clk_corner[68]=14'b1011001000; //f=281 kHz
		n_clk_corner[69]=14'b1011000110; //f=282 kHz
		n_clk_corner[70]=14'b1011000100; //f=282 kHz
		n_clk_corner[71]=14'b1011000000; //f=284 kHz
		n_clk_corner[72]=14'b1010111101; //f=285 kHz
		n_clk_corner[73]=14'b1010111010; //f=286 kHz
		n_clk_corner[74]=14'b1010101001; //f=293 kHz
		n_clk_corner[75]=14'b1010100111; //f=294 kHz
		n_clk_corner[76]=14'b1010110010; //f=289 kHz
		n_clk_corner[77]=14'b1010011100; //f=299 kHz
		n_clk_corner[78]=14'b1010000111; //f=309 kHz
		n_clk_corner[79]=14'b1010000010; //f=311 kHz

	end else begin
		//Series Code, T=5.80:1, effective capacitance data from 1120604903
		//This is for use with the combiner/transformer, which has two nominally 4:1 cores and series leakage resistance ~=0.153 ohms.
		//Load: R: f<150 kHz: data from 1120419902; f>150 kHz, earlier scope measurements.
		//L: take mean value for whole frequency range from 1120419902.
		//Corner frequencies for capacitor lookup table:
		//Corner frequencies between tuning code configurations = N-index and N-index+1
		//where N = total number of configurations (including baseload), and index
		//index is the index of n_clk_corner.
		//UPDATED 4 June 2012

		n_clk_corner[0]=14'b1000110010001; //f=44 kHz
		n_clk_corner[1]=14'b1000101000101; //f=45 kHz
		n_clk_corner[2]=14'b1000011111001; //f=46 kHz
		n_clk_corner[3]=14'b1000010101110; //f=47 kHz
		n_clk_corner[4]=14'b1000001111010; //f=47 kHz
		n_clk_corner[5]=14'b1000001000101; //f=48 kHz
		n_clk_corner[6]=14'b111111111100; //f=49 kHz
		n_clk_corner[7]=14'b111111001011; //f=49 kHz
		n_clk_corner[8]=14'b111110010010; //f=50 kHz
		n_clk_corner[9]=14'b111100110100; //f=51 kHz
		n_clk_corner[10]=14'b111011100101; //f=52 kHz
		n_clk_corner[11]=14'b111010010001; //f=54 kHz
		n_clk_corner[12]=14'b111000101111; //f=55 kHz
		n_clk_corner[13]=14'b110111101000; //f=56 kHz
		n_clk_corner[14]=14'b110110100011; //f=57 kHz
		n_clk_corner[15]=14'b110101100010; //f=58 kHz
		n_clk_corner[16]=14'b110100010111; //f=60 kHz
		n_clk_corner[17]=14'b110011001001; //f=61 kHz
		n_clk_corner[18]=14'b110010000110; //f=62 kHz
		n_clk_corner[19]=14'b110001000011; //f=64 kHz
		n_clk_corner[20]=14'b101111111011; //f=65 kHz
		n_clk_corner[21]=14'b101110110101; //f=67 kHz
		n_clk_corner[22]=14'b101101111010; //f=68 kHz
		n_clk_corner[23]=14'b101100111001; //f=70 kHz
		n_clk_corner[24]=14'b101011110011; //f=71 kHz
		n_clk_corner[25]=14'b101010110001; //f=73 kHz
		n_clk_corner[26]=14'b101001110111; //f=75 kHz
		n_clk_corner[27]=14'b101000111110; //f=76 kHz
		n_clk_corner[28]=14'b101000000101; //f=78 kHz
		n_clk_corner[29]=14'b100111001100; //f=80 kHz
		n_clk_corner[30]=14'b100110010001; //f=82 kHz
		n_clk_corner[31]=14'b100101010111; //f=84 kHz
		n_clk_corner[32]=14'b100100011110; //f=86 kHz
		n_clk_corner[33]=14'b100011100100; //f=88 kHz
		n_clk_corner[34]=14'b100010110001; //f=90 kHz
		n_clk_corner[35]=14'b100010000010; //f=92 kHz
		n_clk_corner[36]=14'b100001001100; //f=94 kHz
		n_clk_corner[37]=14'b100000010101; //f=97 kHz
		n_clk_corner[38]=14'b11111100110; //f=99 kHz
		n_clk_corner[39]=14'b11110110111; //f=101 kHz
		n_clk_corner[40]=14'b11110000101; //f=104 kHz
		n_clk_corner[41]=14'b11101010101; //f=107 kHz
		n_clk_corner[42]=14'b11100100101; //f=109 kHz
		n_clk_corner[43]=14'b11011110101; //f=112 kHz
		n_clk_corner[44]=14'b11011001100; //f=115 kHz
		n_clk_corner[45]=14'b11010100011; //f=118 kHz
		n_clk_corner[46]=14'b11001111010; //f=121 kHz
		n_clk_corner[47]=14'b11001010100; //f=123 kHz
		n_clk_corner[48]=14'b11000101111; //f=126 kHz
		n_clk_corner[49]=14'b11000011010; //f=128 kHz
		n_clk_corner[50]=14'b11000000101; //f=130 kHz
		n_clk_corner[51]=14'b10111100100; //f=133 kHz
		n_clk_corner[52]=14'b10111000000; //f=136 kHz
		n_clk_corner[53]=14'b10110011011; //f=139 kHz
		n_clk_corner[54]=14'b10101110111; //f=143 kHz
		n_clk_corner[55]=14'b10101010011; //f=147 kHz
		n_clk_corner[56]=14'b10100101110; //f=151 kHz
		n_clk_corner[57]=14'b10100001010; //f=155 kHz
		n_clk_corner[58]=14'b10011100111; //f=159 kHz
		n_clk_corner[59]=14'b10011000101; //f=164 kHz
		n_clk_corner[60]=14'b10010100100; //f=168 kHz
		n_clk_corner[61]=14'b10010000000; //f=173 kHz
		n_clk_corner[62]=14'b10001100000; //f=178 kHz
		n_clk_corner[63]=14'b10001000011; //f=183 kHz
		n_clk_corner[64]=14'b10000100010; //f=189 kHz
		n_clk_corner[65]=14'b10000000000; //f=195 kHz
		n_clk_corner[66]=14'b1111100011; //f=201 kHz
		n_clk_corner[67]=14'b1111000101; //f=207 kHz
		n_clk_corner[68]=14'b1110100100; //f=214 kHz
		n_clk_corner[69]=14'b1110000100; //f=222 kHz
		n_clk_corner[70]=14'b1101100111; //f=230 kHz
		n_clk_corner[71]=14'b1101001100; //f=237 kHz
		n_clk_corner[72]=14'b1100101110; //f=246 kHz
		n_clk_corner[73]=14'b1100001101; //f=256 kHz
		n_clk_corner[74]=14'b1011101110; //f=266 kHz
		n_clk_corner[75]=14'b1011001111; //f=278 kHz
		n_clk_corner[76]=14'b1010110001; //f=290 kHz
		n_clk_corner[77]=14'b1010010000; //f=305 kHz
		n_clk_corner[78]=14'b1001110110; //f=317 kHz
		n_clk_corner[79]=14'b1001110111; //f=317 kHz
	end
end
