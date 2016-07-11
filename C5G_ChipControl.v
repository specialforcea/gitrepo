// Copyright (C) 1991-2013 Altera Corporation
// Your use of Altera Corporation's design tools, logic functions 
// and other software and tools, and its AMPP partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Altera Program License 
// Subscription Agreement, Altera MegaCore Function License 
// Agreement, or other applicable license agreement, including, 
// without limitation, that your use is for the sole purpose of 
// programming logic devices manufactured by Altera and sold by 
// Altera or its authorized distributors.  Please refer to the 
// applicable agreement for further details.

module C5G_ChipControl
(
// {ALTERA_ARGS_BEGIN} DO NOT REMOVE THIS LINE!

	CLOCK_50_B5B,
	CLOCK_50_B6A,
	CLOCK_50_B7A,
	CLOCK_50_B8A,
//	CLOCK_125_p,

	SW,

	RF,

	DIO,

	SYNC,
	SCLK,

	S1MOSI,
	S2MOSI,
	S3MOSI,
	S4MOSI,
	S5MOSI,
	S6MOSI,
	S7MOSI,
	S8MOSI,
	S9MOSI,
	S10MOSI,
	S11MOSI,
	S12MOSI,
	
	readfromusb,
   sendtousb,
 
   address,
   WE,
   CE,
   OE,
   LB,
   UB,
   data,
	KEY,
	

// {ALTERA_ARGS_END} DO NOT REMOVE THIS LINE!

);

// {ALTERA_IO_BEGIN} DO NOT REMOVE THIS LINE!
input			CLOCK_50_B5B;
inout			CLOCK_50_B6A;
input			CLOCK_50_B7A;
input			CLOCK_50_B8A;
//input			CLOCK_125_p;

input readfromusb;
output sendtousb;
output [17:0]address;
output WE;
output CE;
output OE;
output LB;
output UB;

input [3:0]KEY;

inout [15:0]data;



inout	[1:12] RF;

inout	[0:9] SW;

inout	[1:4]	DIO;

output			SYNC;
output			SCLK;

output	[1:8]	S1MOSI;
output	[1:8]	S2MOSI;
output	[1:8]	S3MOSI;
output	[1:8]	S4MOSI;
output	[1:8]	S5MOSI;
output	[1:8]	S6MOSI;
output	[1:8]	S7MOSI;
output	[1:8]	S8MOSI;
output	[1:8]	S9MOSI;
output	[1:8]	S10MOSI;
output	[1:8]	S11MOSI;
output	[1:8]	S12MOSI;

wire [0:5]c;
wire [0:63]reconfig_to_pll;
wire [0:63]reconfig_from_pll;
wire [0:31]mgmt_readdata;
wire mgmt_read;
wire mgmt_write;
wire [0:31]mgmt_writedata;
wire [0:767]nmbr;
wire [0:5]mgmt_address;

// {ALTERA_IO_END} DO NOT REMOVE THIS LINE!
// {ALTERA_MODULE_BEGIN} DO NOT REMOVE THIS LINE!
// {ALTERA_MODULE_END} DO NOT REMOVE THIS LINE!


//=======================================================
//  Structural coding
//=======================================================

// Clock Generator
Gen_CLK Gen_CLK_inst(
	.CLOCK_50( CLOCK_50_B5B),
	.RESET_N( SW[1]),
	.REFCLK( DIO[1]),
	.refSCLK( SCLK)
	);


	


triggerupdate triggerupdate_inst(
   .CLOCK_50_B5B(CLOCK_50_B5B),

   .data(data[15:0]),
   .readfromusb(readfromusb),
   .sendtousb(sendtousb),
   .address(address[17:0]),
   .WE(WE),
   .CE(CE),
   .OE(OE),
   .LB(LB),
   .UB(UB),
	
	.KEY(KEY[3:0]),

   .mgmt_readdata(mgmt_readdata[0:31]),
   .mgmt_writedata(mgmt_writedata[0:31]),
   .mgmt_read(mgmt_read),
   .mgmt_write(mgmt_write),
   .mgmt_address(mgmt_address[0:5]),
   .nmbr(nmbr[0:767]),
);

	// RF Sig Generator
pll	b2v_inst(
	.refclk( CLOCK_50_B5B),
	.outclk_0(c[0]),
	.outclk_1(c[1]),
	.outclk_2(c[2]),
	.outclk_3(c[3]),
	.outclk_4(c[4]),
	.outclk_5(c[5]),
	.reconfig_to_pll(reconfig_to_pll[0:63]),
	.reconfig_from_pll(reconfig_from_pll[0:63])
	);	

	
	
pll_reconfig pll_reconfig_inst(
      .mgmt_clk(CLOCK_50_B5B),          
		.mgmt_readdata(mgmt_readdata[0:31]),      
		.mgmt_read(mgmt_read),        
		.mgmt_write(mgmt_write),        
		.mgmt_address(mgmt_address[0:5]),      
		.mgmt_writedata(mgmt_writedata[0:31]),   
		.reconfig_to_pll(reconfig_to_pll[0:63]),   
		.reconfig_from_pll(reconfig_from_pll[0:63])  
	);
	//Mode Selector
ModeSelect ModeSelect_inst(
	.refclk( CLOCK_50_B5B),
	.RESET_N( SW[1]),
	.MODE( SW[2]),
	.C0( c),
	.RFout( RF[1:12]),
);	
	
// DAC control Slot1
CTRL_DAC CTRL_DAC_inst(
	.SCLK( SCLK),
	.RESET_N (SW[1] ),
	.SYNC( SYNC),
	.ACTIVE_N( SW[2]),
	.SDIN1 ( S1MOSI[1:8]),
	.SDIN2 ( S2MOSI[1:8]),	
	.SDIN3 ( S3MOSI[1:8]),
	.SDIN4 ( S4MOSI[1:8]),	
	.SDIN5 ( S5MOSI[1:8]),
	.SDIN6 ( S6MOSI[1:8]),
	.SDIN7 ( S7MOSI[1:8]),
	.SDIN8 ( S8MOSI[1:8]),
	.SDIN9 ( S9MOSI[1:8]),	
	.SDIN10 ( S10MOSI[1:8]),	
	.SDIN11 ( S11MOSI[1:8]),	
	.SDIN12 ( S12MOSI[1:8]),
   .nmbr(nmbr[0:767])	
	);

endmodule