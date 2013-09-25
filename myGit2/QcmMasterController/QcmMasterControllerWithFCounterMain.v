module QcmMasterControllerWithFCounterMain(clk, sig, codeSer, codePar, enableSer, enablePar, ioPowerEnable, clkEnable);
/*
This is the master controller module which instantiates the sub-modules responsible for master controller operation:
counter=frequency counter (really, a period counter with inversion) for
		determining the RF frequency from the square-wave input on "sig"
lut=look-up-table for mapping from a frequency to a capacitor state.
		Currently, the same state number is assigned to both the series and parallel outputs
driver=responsible for mapping from look-up-table output to encoded
		signal for decoder boards (in present implementation, no adjustment
		needs to be made to lut output), and also determines whether the state
		has settled and the cap boards may act on the change.

PIN ASSIGNMENT FOR EPM2210F256C5N (MANY MACROCELL CPLD)
To arrive at this pin assignment,
(1) consult pin assignment for CapBoardDecoder (for tuning code pins) OR "BurkeCPLDBoardConfigurationTemplate.doc" (for signal input)
(2) map to pins on standard 84-pin CPLD
(3) consult Bill Parkin's 84-256-pin adapter schematic to map to 256-pin pin values.

Ok		clk	Location	PIN_83	Yes	
Ok		sig	Location	PIN_28	Yes	
Ok		enableSer	Location	PIN_52	Yes	AC16
Ok		enablePar	Location	PIN_68	Yes	AC26
Ok		codeSer[0]	Location	PIN_33	Yes	AC4
Ok		codeSer[1]	Location	PIN_34	Yes	AC7
Ok		codeSer[2]	Location	PIN_39	Yes	AC9
Ok		codeSer[3]	Location	PIN_40	Yes	AC11
Ok		codeSer[4]	Location	PIN_48	Yes	AC13
Ok		codeSer[5]	Location	PIN_49	Yes	AC14
Ok		codeSer[6]	Location	PIN_51	Yes	AC15
Ok		codePar[0]	Location	PIN_57	Yes	AC17
Ok		codePar[1]	Location	PIN_58	Yes	AC18
Ok		codePar[2]	Location	PIN_60	Yes	AC19
Ok		codePar[3]	Location	PIN_61	Yes	AC20
Ok		codePar[4]	Location	PIN_64	Yes	AC21
Ok		codePar[5]	Location	PIN_65	Yes	AC23
Ok		codePar[6]	Location	PIN_67	Yes	AC25
Ok		ioPowerEnable	Location	PIN_56	Yes
Ok		clkEnable	Location	PIN_73	Yes

Ted Golfinopoulos, pin assignment made on 25 Oct 2011
*/

input clk, sig; //1 bit inputs corresponding to clk and RF signal.
output wire [6:0] codeSer, codePar; //Capacitor state encoded in a number which is interpreted by CapBoardDecoder to determine which caps to turn on.
output enableSer, enablePar; //"Ready" bits indicating codes are ready for decoding.
output ioPowerEnable; //Bit which receives clock-like signal and allows IO circuitry to receive power on LH timing board.
output clkEnable; //Bit which, when high, enables clock.

wire [13:0] f; //Frequency of sig IN HUNDREDS OF Hz, need 4 significant decimal figures.
wire [6:0] state; //Intermediate variable to hold lut output.

reg [1:0] clkCntr; //Divide clock signal down.

initial begin
	#0
	clkCntr=2'b0; //Initialize clock counter.
end

//Instantiate frequency counter object.
fcounter c(clk, sig, f);

//79 corner frequencies in HUNDREDS OF Hz,
//from about 50 kHz (500 hundred Hz) to 300 kHz (3000 hundred Hz)

//Instantiate look-up table which determines state from frequency.
lutSmall tab(clk,f,state);

//At this point, the look-up table outputs a state in the same format required for the encoded cap states, and
//the cap index for the series board is the same as for the parallel board.
assign codeSer=state;
assign codePar=state;

//Instantiate drivers for serial and parallel states - primarily, this determines when the states are ready for decoding by CapBoardDecoder.
//driver dSer(clk,codeSer, enableSer);
//driver dPar(clk, codePar, enablePar);

assign enablePar=1'b1;
assign enableSer=1'b1;

always @(posedge clk) begin
	clkCntr=clkCntr+2'b1; //Increment clock counter.
end

//Give ioPowerEnable bit a divided version of the clock.  The rationale behind this is
//that (a) the ioPowerEnable bit needs a clock-like signal and (b) you should do an operation
//on the clock to prove that the CPLD is working (otherwise synthesis can just connect a wire,
//and so passing the clock to the ioPowerEnable bit may not demonstrate functionality).  This
//is in accordance with the new version of the LH Timing Board.  Pin 56 on the CPLD must receive
//the ioPowerEnable bit.

assign ioPowerEnable=clkCntr[1];
assign clkEnable=1'b1;

endmodule
