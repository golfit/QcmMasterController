// --------------------25 Sep 2012 table below, used to adjust for broken antenna.
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

		//UPDATED SEPTEMBER 25, 2012
		//Parallel Code, T=5.80:1, effective capacitance data from 1120604903
		//This is for use with the combiner/transformer, which has two nominally 4:1 cores and series leakage resistance ~=0.153 ohms.
		//Load: from measurements on September 25, 2012, using oscilloscope.  Both R and L are from these measurements.
		//Corner frequencies for capacitor lookup table:
		//Corner frequencies between tuning code configurations = N-index and N-index+1
		//where N = total number of configurations (including baseload), and index
		//index is the index of n_clk_corner.
		n_clk_corner[0]=14'b110100010010; //f=60 kHz
		n_clk_corner[1]=14'b110000100110; //f=64 kHz
		n_clk_corner[2]=14'b101111011000; //f=66 kHz
		n_clk_corner[3]=14'b101110010000; //f=68 kHz
		n_clk_corner[4]=14'b101101010110; //f=69 kHz
		n_clk_corner[5]=14'b101100100010; //f=70 kHz
		n_clk_corner[6]=14'b101011110101; //f=71 kHz
		n_clk_corner[7]=14'b101011001001; //f=72 kHz
		n_clk_corner[8]=14'b101010100001; //f=73 kHz
		n_clk_corner[9]=14'b101001110111; //f=75 kHz
		n_clk_corner[10]=14'b101001001101; //f=76 kHz
		n_clk_corner[11]=14'b101000011011; //f=77 kHz
		n_clk_corner[12]=14'b100111000101; //f=80 kHz
		n_clk_corner[13]=14'b100101010001; //f=84 kHz
		n_clk_corner[14]=14'b100011100100; //f=88 kHz
		n_clk_corner[15]=14'b100010000100; //f=92 kHz
		n_clk_corner[16]=14'b100000101010; //f=96 kHz
		n_clk_corner[17]=14'b11111010000; //f=100 kHz
		n_clk_corner[18]=14'b11101110110; //f=105 kHz
		n_clk_corner[19]=14'b11100101010; //f=109 kHz
		n_clk_corner[20]=14'b11011100000; //f=114 kHz
		n_clk_corner[21]=14'b11010011000; //f=118 kHz
		n_clk_corner[22]=14'b11001010001; //f=124 kHz
		n_clk_corner[23]=14'b11000100001; //f=127 kHz
		n_clk_corner[24]=14'b11000001100; //f=129 kHz
		n_clk_corner[25]=14'b10111111000; //f=131 kHz
		n_clk_corner[26]=14'b10111100111; //f=132 kHz
		n_clk_corner[27]=14'b10111010111; //f=134 kHz
		n_clk_corner[28]=14'b10111001001; //f=135 kHz
		n_clk_corner[29]=14'b10110110111; //f=137 kHz
		n_clk_corner[30]=14'b10110100010; //f=139 kHz
		n_clk_corner[31]=14'b10110001000; //f=141 kHz
		n_clk_corner[32]=14'b10101100011; //f=145 kHz
		n_clk_corner[33]=14'b10100111101; //f=149 kHz
		n_clk_corner[34]=14'b10100011001; //f=153 kHz
		n_clk_corner[35]=14'b10011110110; //f=157 kHz
		n_clk_corner[36]=14'b10011010000; //f=162 kHz
		n_clk_corner[37]=14'b10010101001; //f=168 kHz
		n_clk_corner[38]=14'b10010000101; //f=173 kHz
		n_clk_corner[39]=14'b10001100011; //f=178 kHz
		n_clk_corner[40]=14'b10001000011; //f=183 kHz
		n_clk_corner[41]=14'b10000100010; //f=189 kHz
		n_clk_corner[42]=14'b10000000100; //f=194 kHz
		n_clk_corner[43]=14'b1111101001; //f=200 kHz
		n_clk_corner[44]=14'b1111001011; //f=206 kHz
		n_clk_corner[45]=14'b1110101110; //f=212 kHz
		n_clk_corner[46]=14'b1110010100; //f=218 kHz
		n_clk_corner[47]=14'b1101111010; //f=225 kHz
		n_clk_corner[48]=14'b1101011111; //f=231 kHz
		n_clk_corner[49]=14'b1101001000; //f=238 kHz
		n_clk_corner[50]=14'b1100111001; //f=242 kHz
		n_clk_corner[51]=14'b1100101011; //f=247 kHz
		n_clk_corner[52]=14'b1100011100; //f=251 kHz
		n_clk_corner[53]=14'b1100010000; //f=255 kHz
		n_clk_corner[54]=14'b1100000011; //f=259 kHz
		n_clk_corner[55]=14'b1011110101; //f=264 kHz
		n_clk_corner[56]=14'b1011011000; //f=274 kHz
		n_clk_corner[57]=14'b1011001010; //f=280 kHz
		n_clk_corner[58]=14'b1011001101; //f=279 kHz
		n_clk_corner[59]=14'b1011000100; //f=282 kHz
		n_clk_corner[60]=14'b1010111010; //f=286 kHz
		n_clk_corner[61]=14'b1010110010; //f=290 kHz
		n_clk_corner[62]=14'b1010101010; //f=293 kHz
		n_clk_corner[63]=14'b1010100100; //f=296 kHz
		n_clk_corner[64]=14'b1010011111; //f=298 kHz
		n_clk_corner[65]=14'b1010011000; //f=301 kHz
		n_clk_corner[66]=14'b1010001110; //f=305 kHz
		n_clk_corner[67]=14'b1010001000; //f=308 kHz
		n_clk_corner[68]=14'b1010000101; //f=310 kHz
		n_clk_corner[69]=14'b1010000011; //f=311 kHz
		n_clk_corner[70]=14'b1010000010; //f=311 kHz
		n_clk_corner[71]=14'b1001111111; //f=313 kHz
		n_clk_corner[72]=14'b1001111101; //f=314 kHz
		n_clk_corner[73]=14'b1001111011; //f=315 kHz
		n_clk_corner[74]=14'b1001100110; //f=326 kHz
		n_clk_corner[75]=14'b1001100100; //f=326 kHz
		n_clk_corner[76]=14'b1001110101; //f=318 kHz
		n_clk_corner[77]=14'b1001011001; //f=333 kHz
		n_clk_corner[78]=14'b1000111110; //f=348 kHz
		n_clk_corner[79]=14'b1000111000; //f=352 kHz


	end else begin
		$display("Lookup table #1 used"); //Series capacitors
		//UPDATED SEPTEMBER 25, 2012
		//Series Code, T=5.80:1, effective capacitance data from 1120604903
		//Load: from measurements on September 25, 2012, using oscilloscope.  Both R and L are from these measurements.
		//Corner frequencies for capacitor lookup table:
		//Corner frequencies between tuning code configurations = N-index and N-index+1
		//where N = total number of configurations (including baseload), and index
		//index is the index of n_clk_corner.
		n_clk_corner[0]=14'b1000011100001; //f=46 kHz
		n_clk_corner[1]=14'b1000001101101; //f=48 kHz
		n_clk_corner[2]=14'b111111111100; //f=49 kHz
		n_clk_corner[3]=14'b111110001111; //f=50 kHz
		n_clk_corner[4]=14'b111010011110; //f=53 kHz
		n_clk_corner[5]=14'b110111011111; //f=56 kHz
		n_clk_corner[6]=14'b110110111001; //f=57 kHz
		n_clk_corner[7]=14'b110110011100; //f=57 kHz
		n_clk_corner[8]=14'b110101011110; //f=58 kHz
		n_clk_corner[9]=14'b110011110010; //f=60 kHz
		n_clk_corner[10]=14'b110010100111; //f=62 kHz
		n_clk_corner[11]=14'b110001101100; //f=63 kHz
		n_clk_corner[12]=14'b110000101001; //f=64 kHz
		n_clk_corner[13]=14'b101111110010; //f=65 kHz
		n_clk_corner[14]=14'b101110110010; //f=67 kHz
		n_clk_corner[15]=14'b101101111011; //f=68 kHz
		n_clk_corner[16]=14'b101100110110; //f=70 kHz
		n_clk_corner[17]=14'b101011110111; //f=71 kHz
		n_clk_corner[18]=14'b101011001010; //f=72 kHz
		n_clk_corner[19]=14'b101010011100; //f=74 kHz
		n_clk_corner[20]=14'b101001101010; //f=75 kHz
		n_clk_corner[21]=14'b101000110101; //f=77 kHz
		n_clk_corner[22]=14'b101000000010; //f=78 kHz
		n_clk_corner[23]=14'b100110101010; //f=81 kHz
		n_clk_corner[24]=14'b100100111111; //f=84 kHz
		n_clk_corner[25]=14'b100011100000; //f=88 kHz
		n_clk_corner[26]=14'b100010010011; //f=91 kHz
		n_clk_corner[27]=14'b100001001001; //f=94 kHz
		n_clk_corner[28]=14'b100000000010; //f=98 kHz
		n_clk_corner[29]=14'b11110111110; //f=101 kHz
		n_clk_corner[30]=14'b11101110011; //f=105 kHz
		n_clk_corner[31]=14'b11100101100; //f=109 kHz
		n_clk_corner[32]=14'b11011100100; //f=113 kHz
		n_clk_corner[33]=14'b11010100010; //f=118 kHz
		n_clk_corner[34]=14'b11001101000; //f=122 kHz
		n_clk_corner[35]=14'b11000110000; //f=126 kHz
		n_clk_corner[36]=14'b11000001000; //f=129 kHz
		n_clk_corner[37]=14'b10111101100; //f=132 kHz
		n_clk_corner[38]=14'b10111010110; //f=134 kHz
		n_clk_corner[39]=14'b10110111011; //f=136 kHz
		n_clk_corner[40]=14'b10110011011; //f=139 kHz
		n_clk_corner[41]=14'b10101111100; //f=142 kHz
		n_clk_corner[42]=14'b10101011011; //f=146 kHz
		n_clk_corner[43]=14'b10100111010; //f=149 kHz
		n_clk_corner[44]=14'b10100011010; //f=153 kHz
		n_clk_corner[45]=14'b10011110111; //f=157 kHz
		n_clk_corner[46]=14'b10011010111; //f=161 kHz
		n_clk_corner[47]=14'b10010110110; //f=166 kHz
		n_clk_corner[48]=14'b10010010010; //f=171 kHz
		n_clk_corner[49]=14'b10001111111; //f=174 kHz
		n_clk_corner[50]=14'b10001110001; //f=176 kHz
		n_clk_corner[51]=14'b10001010110; //f=180 kHz
		n_clk_corner[52]=14'b10000111001; //f=185 kHz
		n_clk_corner[53]=14'b10000011101; //f=190 kHz
		n_clk_corner[54]=14'b10000000000; //f=195 kHz
		n_clk_corner[55]=14'b1111100011; //f=201 kHz
		n_clk_corner[56]=14'b1111001001; //f=206 kHz
		n_clk_corner[57]=14'b1110110000; //f=212 kHz
		n_clk_corner[58]=14'b1110011000; //f=217 kHz
		n_clk_corner[59]=14'b1101111111; //f=223 kHz
		n_clk_corner[60]=14'b1101101001; //f=229 kHz
		n_clk_corner[61]=14'b1101010000; //f=236 kHz
		n_clk_corner[62]=14'b1100111001; //f=242 kHz
		n_clk_corner[63]=14'b1100100011; //f=249 kHz
		n_clk_corner[64]=14'b1100001011; //f=257 kHz
		n_clk_corner[65]=14'b1011110110; //f=264 kHz
		n_clk_corner[66]=14'b1011100110; //f=269 kHz
		n_clk_corner[67]=14'b1011001101; //f=279 kHz
		n_clk_corner[68]=14'b1010110000; //f=291 kHz
		n_clk_corner[69]=14'b1010011000; //f=301 kHz
		n_clk_corner[70]=14'b1010000010; //f=311 kHz
		n_clk_corner[71]=14'b1001110000; //f=320 kHz
		n_clk_corner[72]=14'b1001100010; //f=327 kHz
		n_clk_corner[73]=14'b1001010101; //f=335 kHz
		n_clk_corner[74]=14'b1001001000; //f=342 kHz
		n_clk_corner[75]=14'b1000111110; //f=348 kHz
		n_clk_corner[76]=14'b1000110111; //f=353 kHz
		n_clk_corner[77]=14'b1000110010; //f=355 kHz
		n_clk_corner[78]=14'b1000110001; //f=356 kHz
		n_clk_corner[79]=14'b1000011001; //f=372 kHz

	end
end

