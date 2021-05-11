/*
 * ALU w/ 32-bit Accumulator Register
 * Cohort Name: Logical Cohort
 * Cohort Members: Amogh Yatnatti, Vineet Goyal, Sanika Buche, Muhammad Khan, Unnati Patel
 * 
 */

//OpCodes
`define NOOP  '4b0000 //00=system, 00=NOOP
`define RESET '4b0001 //00=system, 01=Reset
`define PRESET '4b0011 //00=system, 11=Preset
`define ADD   '4b0101 //01=Mathematics, 01=ADD
`define SUB   '4b0110 //01=Mathematics, 10=SUB
`define MULT  '4b0100 //01=Mathematics, 00=MULT
`define DIV   '4b0111 //01=Mathematics, 11=DIV
`define OR    '4b1000 //10=Logic, 00=OR
`define AND   '4b1001 //10=Logic, 01=AND
`define NOT   '4b1010 //10=Logic, 10=NOT
`define XOR   '4b1011 //10=Logic, 11=XOR

// 16 bit AND
module and_gate(inputA, inputB, outputC);
    input [15:0] inputA;
    input [15:0] inputB;
	wire [15:0] inputA;
    wire [15:0] inputB;
    output[31:0] outputC;
    assign outputC = inputA & inputB;
endmodule

// 16 bit NOT
module not_gate(inputB, outputC);
    input [15:0] inputB;
	wire [15:0] inputB;
    output [31:0] outputC;
    assign outputC =~ inputB;
endmodule

// 16 bit XOR
module xor_gate(inputA, inputB, outputC);
    input [15:0] inputA;
    input [15:0] inputB;
    wire [15:0] inputA;
    wire [15:0] inputB;
    output [31:0] outputC;
    assign outputC = inputA ^ inputB;
endmodule

// 16 bit OR
module or_gate(inputA, inputB, outputC);
    input [15:0] inputA;
    input [15:0] inputB;
    wire [15:0] inputA;
    wire [15:0] inputB;
    output [31:0] outputC;
    assign outputC = inputA | inputB;
endmodule

// 16 bit ADDITION
module addition(inputA, inputB, outputC);
    input [15:0] inputA;
    input [15:0] inputB;
    wire [15:0] inputA;
    wire [15:0] inputB;
    output [31:0] outputC;
    assign outputC = inputA + inputB;
endmodule

// 16 bit SUBTRACTION
module subtraction(inputA, inputB, outputC);
    input [15:0] inputA;
    input [15:0] inputB;
    wire [15:0] inputA;
    wire [15:0] inputB;
    output [31:0] outputC;
    assign outputC = inputA - inputB;
endmodule

// 16 bit MULTIPLICATION
module multiplication(inputA, inputB, outputC);
    output [31:0] outputC;
	input  [15:0] inputA;
	input  [15:0] inputB;
	assign outputC = inputA * inputB;
endmodule

// 16 bit DIVISION
module division(inputA, inputB, outputC);
    output [31:0] outputC;
	input  [15:0] inputA;
	input  [15:0] inputB;
	assign outputC = inputA / inputB;
endmodule

//MUX Multiplexer 16 by 32
module MUX(channels,select,b);
    input [15:0][31:0]channels;
    input [3:0] select;
    output [31:0] b;
    wire[15:0][31:0] channels;
    reg [31:0] b;
    always @(*)
    begin
        b = channels[select];
    end
endmodule

// D-Flip Flop
module DFF(clk,in,out);
    parameter n=1; // width
    input clk;
    input [n-1:0] in;
    output [n-1:0] out;
    reg [n-1:0] out;
    always @(posedge clk) // positive edge
    out = in;
endmodule

//Breadboard
module breadboard(clk,rst,A,B,C,opcode);
    input clk; 
    input rst;
    input [15:0] A;
    input [15:0] B;
    input [3:0] opcode;
    wire clk;
    wire rst;
    wire [15:0] A;
    wire [15:0] B;
    wire [3:0] opcode;

    output reg [31:0] C;
    wire [15:0][31:0]channels;
    wire [31:0] b;
    
    // Channel outputs
    wire [31:0] outputADD;
    wire [31:0] outputAND;
    wire [31:0] outputXOR;
    wire [31:0] outputOR;
    wire [31:0] outputNOT;
    wire [31:0] outputSUB;
    wire [31:0] outputPRESET;
    wire [31:0] outputMULT;
    wire [31:0] outputDIV;
    assign outputPRESET = {32{1'b1}};
    
    reg [15:0] regA;
    reg [15:0] regB;
    reg  [31:0] next;
    wire [31:0] cur;

    // Multiplexor
    MUX mux1(channels,opcode,b);

    // Logic
    and_gate and1(regA, regB, outputAND);
    xor_gate xor1(regA, regB, outputXOR);
    or_gate or1(regA, regB, outputOR);
    not_gate not1(regB, outputNOT);

    // Mathematics
    addition add1(regA, regB, outputADD);
    subtraction sub1(regB, regA, outputSUB);
    multiplication mult1(regA, regB, outputMULT);
    division div1(regB, regA, outputDIV);

    // DFF for Accumulator
    DFF ACC1 [31:0] (clk,next,cur);

    assign channels[0]=cur;//NO-OP
    assign channels[1]=0;//RESET
    assign channels[2]=0;//GROUND=0
    assign channels[3]=outputPRESET;//PRESET
    assign channels[4]=outputMULT;//MULT
    assign channels[5]=outputADD; //ADD
    assign channels[6]=outputSUB;//SUB
    assign channels[7]=outputDIV;//DIV
    assign channels[8]=outputOR;//OR
    assign channels[9]=outputAND; //AND
    assign channels[10]=outputNOT;//NOT
    assign channels[11]=outputXOR;//XOR
    assign channels[12]=0;//GROUND=0
    assign channels[13]=0;//GROUND=0
    assign channels[14]=0;//GROUND=0
    assign channels[15]=0;//GROUND=0

    always @(*)
    begin
    regA=A;
    regB=cur;

    assign C=b;
    assign next=b;
    end
endmodule

//TEST BENCH
module testbench();

   //Local Variables
   reg clk;
   reg rst;
   reg [15:0] inputA;
   reg [15:0] inputB;
   wire [31:0] outputC;
   reg [3:0] opcode;

    // create breadboard
    breadboard bb8(clk,rst,inputA,inputB,outputC,opcode);

   //CLOCK
   initial begin //Start Clock Thread
     forever //While TRUE
        begin //Do Clock Procedural
          clk=0; //square wave is low
          #5; //half a wave is 5 time units
          clk=1;//square wave is high
          #5; //half a wave is 5 time units
        end
    end

    initial begin //Start Output Thread
	forever
         begin
		 $display("(ACC:%32b)(OPCODE:%4b)(IN:%16b)(OUT:%32b)",bb8.cur,opcode,inputA,bb8.b);
		 #10;
		 end
	end

    //STIMULOUS
	initial begin//Start Stimulous Thread
	#6;
    //---------------------------------
	inputA=16'b0000000000000000;
	opcode=4'b0000;//NO-OP
	#10; 
	//---------------------------------
	inputA=16'b0000000000000000;
	opcode=4'b0001;//RESET
	#10
	//---------------------------------	
	inputA=16'b0000000000000000;
	opcode=4'b1001;//AND
	#10;
	//---------------------------------	
	inputA=16'b0000000011111111;
	opcode=4'b1010;//NOT
	#10;
	//---------------------------------	
	inputA=16'b0000000000001111;
	opcode=4'b0101;//ADD
	#10;
    //---------------------------------	
	inputA=16'b0000000000000000;
	opcode=4'b1011;//XOR
	#10;
    //---------------------------------	
	inputA=16'b0000000000001111;
	opcode=4'b0110;//SUB
	#10;
    //---------------------------------	
    inputA=16'b0000000000000000;
	opcode=4'b0001;//RESET
	#10;
    //---------------------------------	
	inputA=16'b0000000000000000;
	opcode=4'b0011;//PRESET
	#10;
    //---------------------------------	
	inputA=16'b0000000000000000;
	opcode=4'b1000;//OR
	#10;
    //---------------------------------	
	inputA=16'b0000000000000000;
	opcode=4'b0000;//NO OP
	#10;
    //---------------------------------	
	inputA=16'b0000000000001111;
	opcode=4'b0100;//MULT
	#10;
    //---------------------------------	
	inputA=16'b0000000000000010;
	opcode=4'b0111;//DIV
	#10;
    //---------------------------------	
	inputA=16'b0000000000000000;
	opcode=4'b0011;//PRESET
	#10;
    //---------------------------------	
	inputA=16'b0000000000000001;
	opcode=4'b0101;//ADD
	#10;

    #10; 
    #10;
    #10; // CONTINUES ADD OPERATION
    //---------------------------------	
	$finish;
	end
endmodule