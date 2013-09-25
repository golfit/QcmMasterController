//This file contains the definition of the corner frequencies.
//They are stored as binary numbers representing the corner
//frequencies in hundreds of Hz.
//This file is referenced by the look-up table.
//Ted Golfinopoulos, 18 Oct. 2011

//Lookup table updated to reflect new 81-level capacitor selection.  9 January 2012, Ted Golfinopoulos
//Note: see ~/matlab/work/VerilogLookupTableGen.m

reg [13:0] fc[0:79];

initial begin
	fc[0]=14'b111001000; //f=456 hundred Hz
	fc[1]=14'b111010011; //f=467 hundred Hz
	fc[2]=14'b111011110; //f=478 hundred Hz
	fc[3]=14'b111101001; //f=489 hundred Hz
	fc[4]=14'b111110011; //f=499 hundred Hz
	fc[5]=14'b111111101; //f=509 hundred Hz
	fc[6]=14'b1000001010; //f=522 hundred Hz
	fc[7]=14'b1000010110; //f=534 hundred Hz
	fc[8]=14'b1000100010; //f=546 hundred Hz
	fc[9]=14'b1000101110; //f=558 hundred Hz
	fc[10]=14'b1000111011; //f=571 hundred Hz
	fc[11]=14'b1001000111; //f=583 hundred Hz
	fc[12]=14'b1001010011; //f=595 hundred Hz
	fc[13]=14'b1001100000; //f=608 hundred Hz
	fc[14]=14'b1001101101; //f=621 hundred Hz
	fc[15]=14'b1001111100; //f=636 hundred Hz
	fc[16]=14'b1010001110; //f=654 hundred Hz
	fc[17]=14'b1010100001; //f=673 hundred Hz
	fc[18]=14'b1010110011; //f=691 hundred Hz
	fc[19]=14'b1011000110; //f=710 hundred Hz
	fc[20]=14'b1011011001; //f=729 hundred Hz
	fc[21]=14'b1011101101; //f=749 hundred Hz
	fc[22]=14'b1100000000; //f=768 hundred Hz
	fc[23]=14'b1100010100; //f=788 hundred Hz
	fc[24]=14'b1100101000; //f=808 hundred Hz
	fc[25]=14'b1100111100; //f=828 hundred Hz
	fc[26]=14'b1101010001; //f=849 hundred Hz
	fc[27]=14'b1101100110; //f=870 hundred Hz
	fc[28]=14'b1101111011; //f=891 hundred Hz
	fc[29]=14'b1110010000; //f=912 hundred Hz
	fc[30]=14'b1110100110; //f=934 hundred Hz
	fc[31]=14'b1110111100; //f=956 hundred Hz
	fc[32]=14'b1111010010; //f=978 hundred Hz
	fc[33]=14'b1111101000; //f=1000 hundred Hz
	fc[34]=14'b1111111110; //f=1022 hundred Hz
	fc[35]=14'b10000010101; //f=1045 hundred Hz
	fc[36]=14'b10000101100; //f=1068 hundred Hz
	fc[37]=14'b10001000011; //f=1091 hundred Hz
	fc[38]=14'b10001011011; //f=1115 hundred Hz
	fc[39]=14'b10001110011; //f=1139 hundred Hz
	fc[40]=14'b10010001011; //f=1163 hundred Hz
	fc[41]=14'b10010100100; //f=1188 hundred Hz
	fc[42]=14'b10010111101; //f=1213 hundred Hz
	fc[43]=14'b10011010111; //f=1239 hundred Hz
	fc[44]=14'b10011110100; //f=1268 hundred Hz
	fc[45]=14'b10100010011; //f=1299 hundred Hz
	fc[46]=14'b10100110100; //f=1332 hundred Hz
	fc[47]=14'b10101010110; //f=1366 hundred Hz
	fc[48]=14'b10101111000; //f=1400 hundred Hz
	fc[49]=14'b10110011001; //f=1433 hundred Hz
	fc[50]=14'b10110111011; //f=1467 hundred Hz
	fc[51]=14'b10111011111; //f=1503 hundred Hz
	fc[52]=14'b11000000011; //f=1539 hundred Hz
	fc[53]=14'b11000100110; //f=1574 hundred Hz
	fc[54]=14'b11001001010; //f=1610 hundred Hz
	fc[55]=14'b11001101111; //f=1647 hundred Hz
	fc[56]=14'b11010010100; //f=1684 hundred Hz
	fc[57]=14'b11010111001; //f=1721 hundred Hz
	fc[58]=14'b11011011111; //f=1759 hundred Hz
	fc[59]=14'b11100000101; //f=1797 hundred Hz
	fc[60]=14'b11100101100; //f=1836 hundred Hz
	fc[61]=14'b11101010010; //f=1874 hundred Hz
	fc[62]=14'b11101111010; //f=1914 hundred Hz
	fc[63]=14'b11110100110; //f=1958 hundred Hz
	fc[64]=14'b11111010101; //f=2005 hundred Hz
	fc[65]=14'b100000000100; //f=2052 hundred Hz
	fc[66]=14'b100000110100; //f=2100 hundred Hz
	fc[67]=14'b100001100100; //f=2148 hundred Hz
	fc[68]=14'b100010011000; //f=2200 hundred Hz
	fc[69]=14'b100011001101; //f=2253 hundred Hz
	fc[70]=14'b100100000001; //f=2305 hundred Hz
	fc[71]=14'b100100110101; //f=2357 hundred Hz
	fc[72]=14'b100101101010; //f=2410 hundred Hz
	fc[73]=14'b100110100000; //f=2464 hundred Hz
	fc[74]=14'b100111010100; //f=2516 hundred Hz
	fc[75]=14'b101000001100; //f=2572 hundred Hz
	fc[76]=14'b101001001001; //f=2633 hundred Hz
	fc[77]=14'b101010000111; //f=2695 hundred Hz
	fc[78]=14'b101011000110; //f=2758 hundred Hz
	fc[79]=14'b101100000011; //f=2819 hundred Hz
end
