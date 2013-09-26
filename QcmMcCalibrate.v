module QcmMasterControllerMain(clk, sig, codeSer, codePar, enableSer, enablePar, ioPowerEnable, clkEnable, serCodeOutput, parCodeOutput, nclkOutput);
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

In one calibration mode, the 

PIN ASSIGNMENT FOR EPM2210F256C5N (MANY MACROCELL CPLD)
To arrive at this pin assignment,
(1) consult pin assignment for CapBoardDecoder (for tuning code pins) OR "BurkeCPLDBoardConfigurationTemplate.doc" (for signal input)
(2) map to pins on standard 84-pin CPLD
(3) consult Bill Parkin's 84-256-pin adapter schematic to map to 256-pin pin values.

Ok		clk	Location	PIN_H5	Yes		
Ok		sig	Location	PIN_K1	Yes		(PIN_04 on socket - see Willy Burke's doc and note we are using Slot 1 for sync input on board front panel)
Ok		enableSer	Location	PIN_F1	Yes		AC24 on backplane
Ok		enablePar	Location	PIN_G1	Yes		AC25
Ok		codeSer[0]	Location	PIN_R16	Yes		AC3
Ok		codeSer[1]	Location	PIN_L16	Yes		AC6
Ok		codeSer[2]	Location	PIN_E16	Yes		AC9
Ok		codeSer[3]	Location	PIN_A13	Yes		AC12
Ok		codeSer[4]	Location	PIN_A8	Yes		AC15
Ok		codeSer[5]	Location	PIN_A5	Yes		AC18
Ok		codeSer[6]	Location	PIN_B1	Yes		AC21
Ok		codePar[0]	Location	PIN_N16	Yes		AC4
Ok		codePar[1]	Location	PIN_G16	Yes		AC7
Ok		codePar[2]	Location	PIN_D16	Yes		AC10
Ok		codePar[3]	Location	PIN_A12	Yes		AC13
Ok		codePar[4]	Location	PIN_A7	Yes		AC16
Ok		codePar[5]	Location	PIN_A4	Yes		AC19
Ok		codePar[6]	Location	PIN_D1	Yes		AC22

Ok		ioPowerEnable	Location	PIN_T12	Yes		Connects to I/O 27.  This needs a signal - e.g. clock divided down - to demonstrate CPLD is working.  But really should go to Pin56 out of CPLD - this is not connected to 256-pin CPLD, so need to make a jumper wire on board.	
Ok		clkEnable	Location	PIN_T15	Yes		Connects to I/O 28.  The clock needs Pin73 out of CPLD to be high to work, but Pin73 is not connected to 256-pin CPLD, so need to make a hardware jumper on the board.	

Ok		serCodeOutput	Location	PIN_N1	Yes		Encodes the logic state for the series capacitors into a time series going out on LEMO I/O 4
Ok		parCodeOutput	Location	PIN_T2	Yes		Encodes the logic state for the series capacitors into a time series going out on LEMO I/O 4
Ok		nclkOutput	Location	PIN_T4	Yes		Encodes n_clk - the number of clock counts in a signal count period.  Goes out on I/O #6 - J16 on 84-pin footprint, and connected to PIN_T4 on 256 pin adapter.


Ted Golfinopoulos, pin assignment made on 24 Oct 2011
Revised 9 January 2012
*/

input clk, sig; //1 bit inputs corresponding to clk and RF signal.
output wire [6:0] codeSer, codePar; //Capacitor state encoded in a number which is interpreted by CapBoardDecoder to determine which caps to turn on.
output enableSer, enablePar; //"Ready" bits indicating codes are ready for decoding.
output ioPowerEnable; //Bit which receives clock-like signal and allows IO circuitry to receive power on LH timing board.
output clkEnable; //Bit which, when high, enables clock.
output serCodeOutput; //Bit containing encoded version of serial cap code.
output parCodeOutput; //Bit containing encoded version of parallel cap code.
output nclkOutput; //Bit containing (time)-encoded version of clock counts per M signal count period.

//wire [13:0] f; //Frequency of sig IN HUNDREDS OF Hz, need 4 significant decimal figures.
wire [13:0] n_clk; //Frequency of sig IN HUNDREDS OF Hz, need 4 significant decimal figures.
wire [6:0] state; //Intermediate variable to hold lut output.

reg [3:0] clkCntr; //Divide clock signal down.

initial begin
	#0
	clkCntr=4'b0; //Initialize clock counter.
end

//Instantiate frequency counter object.
//counter c(clk, sig, f); //Use period counter instead of frequency counter.
//fcounter c(clk, sig, f); //Use frequency counter instead of period counter.
counter_n c(clk, sig, n_clk); //Use period counter, but don't use division step.  Instead, pass number of clock counts.

//79 corner frequencies in HUNDREDS OF Hz,
//from about 50 kHz (500 hundred Hz) to 300 kHz (3000 hundred Hz)

//Instantiate look-up table which determines state from frequency.
//lut tab(clk,f,state);
lut_n tab(clk,n_clk,state);

//At this point, the look-up table outputs a state in the same format required for the encoded cap states, and
//the cap index for the series board is the same as for the parallel board.
assign codeSer=state;
assign codePar=state;

//Instantiate drivers for serial and parallel states - primarily, this determines when the states are ready for decoding by CapBoardDecoder.
driver dSer(clk, codeSer, enableSer);
driver dPar(clk, codePar, enablePar);

//Instantiate encoders to put out the series and parallel codes in a pulse sequence on the LEMO outputs.
//Give a slower version of clock so that the digitizer, with 2.5 MHz sample rate, can resolve the pulses.
stateEncoder seriesStateEncoder(clkCntr[3], codeSer, enableSer, serCodeOutput);
stateEncoder parallelStateEncoder(clkCntr[3], codePar, enablePar, parCodeOutput);

defparam nclkEncoder.STATE_LENGTH=4'b1110; //Need to redefine the parameter dictating the size of the bit pattern to encode.
stateEncoder nclkEncoder(clkCntr[3], n_clk, enableSer, nclkOutput); //Instantiate encoder for n_clk

always @(posedge clk) begin
	clkCntr=clkCntr+4'b1; //Increment clock counter.
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
