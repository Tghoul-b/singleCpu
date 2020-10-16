`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:21:04 05/29/2020 
// Design Name: 
// Module Name:    PCPU 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module PCPU(
    input clk,			
	input rst,
	input [31:0]Ins,
	input [31:0]Data_in,	
	output [31:0]Pc,
    output [31:0]Data_out, 
	output [31:0]Addr_out,
    output mem_w
    );
//***********************************IF***********************************
//PC
wire isjump;
wire [31:0] npc;
wire [31:0] pc;
//IM
wire [31:0] instruction;
//IFIDreg
wire [31:0]IFIDoutpc;
wire [31:0] IFIDinstructionout;
//***********************************ID************************************
//control
wire regdst;
wire alusrc;
wire memtoreg;
wire regwrite;
wire memread;
wire memwrite;
wire lui;
wire sl;
wire [1:0] MuxtoReg;
wire [3:0] aluop;
wire [3:0] Npcop;
wire [1:0] Byte;
wire Exten;
wire V;
wire LW;
wire valueisPC;
wire Unsi;
wire Slez;
wire [4:0] A;
//detect
wire [4:0] idexregisterrs;
wire [4:0] idexregisterrt;
wire [4:0] exmemregisterrd;
wire idexmemeread;
wire [4:0] ifidregisterrs;
wire [4:0] ifidregisterrt;
wire exmemregwrite;
wire memwbregwrite;
wire [4:0] IDEXrtrd;
wire [4:0] MEMWBrtrd;
wire [4:0] memwbregisterrd;
wire [2:0] IDforwardA;
wire [2:0] IDForwardB;
wire [2:0] EXforwardA;
wire [2:0] EXforwardB;
wire [2:0] MEMforwardA;
wire [2:0] MEMforwardB;
wire ifidwrite;
wire pcwrite;
wire IFIDflush;
wire IDEXflush;
wire branch_occur;
wire predict_occur;
//RF
wire RFwritereg;
wire [4:0] RFRtdreg;
wire [31:0] RFrsdata;
wire [31:0] RFrtdata;
//IDforward
wire [31:0]outA;
wire [31:0] outB;
//npc
wire [31:0] npcresult;
//signedextended
wire [31:0] extendedResult;
//IDEXreg
wire [4:0] IDEXshamt;
wire [31:0] IDEXextendedResult;
wire [31:0]IDEXregisterdata1;
wire [31:0]IDEXregisterdata2;
wire [4:0] IDEXrs;
wire [4:0] IDEXrt;
wire [4:0] IDEXrd;
wire IDEXregdst;
wire IDEXalusrc;
wire IDEXmemtoreg;
wire IDEXregwrite;
wire IDEXmemread;
wire IDEXmemwrite;
wire IDEXlui;
wire IDEXsl;
wire [1:0] IDEXMuxtoReg;
wire [3:0] IDEXaluop;
wire [3:0] IDEXNpcop;
wire [1:0] IDEXByte;
wire IDEXExten;
wire IDEXV;
wire IDEXLW;
wire IDEXvalueisPC;
wire IDEXUnsi;
wire IDEXSlez;
wire [31:0] IDEXinstructionout;
wire [2:0] IDEXforwardA;
wire [2:0] IDEXforwardB;
wire [31:0] IDEXpcout;
wire [2:0] IDMEMforwardA;
//****************************************EX******************************************
wire [31:0] Add1;
wire [31:0] Add2;
//ALU
wire zero;
wire less;
wire overflow;
wire [31:0]ALUresult;

//EXMEMreg
wire [31:0]EXMEMaluout;
wire EXMEMzero;
wire EXMEMless;
wire EXMEMmemread;
wire EXMEMmemwrite;
wire [1:0] EXMEMByte;
wire [31:0] EXMEMrtdata;
wire [1:0]EXMEMMuxtoReg;
wire [31:0] EXMEMinstructionout;
wire EXMEMLW;
wire EXMEMvalueisPC;
wire [4:0]EXMEMrd;
wire [4:0] EXMEMrt;
wire [31:0] EXMEMpcout;
wire [4:0]  EXMEMrtrd;
wire [2:0] EXMEMforwardA;
wire EXMEMunsi;
//*****************************************MEM****************************************
//DM
wire [31:0] MEMreaddata;

//MEMWBreg
wire [31:0] forwardwritedata;
wire [4:0] MEMWBRdRt;
wire [31:0] MEMWBregwritedata;
wire [1:0] MEMWBByte;
wire MEMWBunsi;
//****************************************IF******************************************
//根据老师上课所讲这个预测结构应该放在PC单元
predict_module pre(
    .pc(pc),
    .predict(predict_occur),
    .isjump(isjump),
    .npcresult(npcresult),
    .pcresult(npc)
);

PC  Pcin(
    .clk(clk),
    .rst(reset),
    .pcwrite(pcwrite),
    .NPC(npc),
    .PC(pc)
);
/*InstructionMEM Im(
    .IAddr(pc),
    .instruction(instruction)
);*/
assign Pc=pc;
assign instruction=Ins;
IFIDreg ifidreg(
    .clk(clk),
    .IFIDflush(IFIDflush),
    .instruction(instruction),
    .pc(pc),
    .IFIDwrite(ifidwrite),
    .outpc(IFIDoutpc),
    .instructionout(IFIDinstructionout)
);

//****************************************ID******************************************
ControlUnit ctrl(
    .op(IFIDinstructionout[31:26]),
    .func(IFIDinstructionout[5:0]),
    .rt(IFIDinstructionout[20:16]),
    
    .Regdst(regdst),
    .ALUSrc(alusrc),
    .MemtoReg(memtoreg),
    .RegWrite(regwrite),
    .Memread(memread),
    .Memwrite(memwrite),
    .lui(lui),
    .sl(sl),
    .muxtoreg(MuxtoReg),
    .ALUop(aluop),
    .npcop(Npcop),
    //.byte(Byte),
    .exten(Exten),
    .v(V),
    .lw(LW),
    .valueisPc(valueisPC),
    .unsi(Unsi),
    .slez(Slez)
);
detect dec(
    .clk(clk),
    .EXMEMregwrite(exmemregwrite),
    .MEMWBregwrite(memwbregwrite),
    .IDEXregwrite(IDEXregwrite),
    .IDEXrtrd(IDEXrtrd),
    .EXMEMrtrd(EXMEMrtrd),
    .IDEXrs(IDEXrs),
    .IDEXrt(IDEXrt),
    .MEMWBrtrd(MEMWBRdRt),
    .IFIDNPCOp(Npcop),
    .IFIDRs(IFIDinstructionout[25:21]),
    .IFIDRt(IFIDinstructionout[20:16]),
    .IFIDop(IDEXinstructionout[31:26]),
    .branch_occur(branch_occur),
    .IDEXMemread(IDEXmemread),
      
    .IDforwardA(IDforwardA),
    .IDforwardB(IDForwardB),
    .EXforwardA(EXforwardA),
    .EXforwardB(EXforwardB),
    .MEMforwardA(MEMforwardA),
    .MEMforwardB(MEMforwardB),
    .IFIDwrite(ifidwrite),
    .PCwrite(pcwrite),
    .IFIDflush(IFIDflush),
    .IDEXflush(IDEXflush),
    .predict_occur(predict_occur)
);
Registerfile rf(
    .clk(clk),
    .reset(reset),
    .writedata(MEMWBregwritedata),
    .rs(IFIDinstructionout[25:21]),
    .rt(IFIDinstructionout[20:16]),
    .writereg(memwbregwrite),
    .rtd(MEMWBRdRt),
    //.byte(MEMWBByte),
    .unsi(MEMWBunsi),
    .rsdata(RFrsdata),
    .rtdata(RFrtdata)
);
IDforward IDForward(
    .aluresultin(EXMEMaluout),
    .rsdata(RFrsdata),
    .rtdata(RFrtdata),
    .forwardAin(IDforwardA),
    .forwardBin(IDForwardB),
    .A(outA),
    .B(outB)
);
NPC Npc(
    .PC(IFIDoutpc),
    .NPCOp(Npcop),
    .jreg(outA),
    .IMM(IFIDinstructionout),
    .rsdata(outA),
    .rtdata(outB),
    .NPC(npcresult),
    .branch_occur(branch_occur),
    .isjump(isjump)
);
signextended ext(
    .immediate(IFIDinstructionout[15:0]),
    .Exten(Exten),
    .result(extendedResult)
);
IDEXreg idexreg(
    .clk(clk),
    .IDEXflush(IDEXflush),
    .registerdata1(RFrsdata),
    .registerdata2(RFrtdata),
    .rs(IFIDinstructionout[25:21]),
    .rt(IFIDinstructionout[20:16]),
    .rd(IFIDinstructionout[15:11]),
    .Regdst(regdst),
    .ALUSrc(alusrc),
    .MemtoReg(memtoreg),
    .RegWrite(regwrite),
    .Memread(memread),
    .Memwrite(memwrite),
    .lui(lui),
    .sl(sl),
    .muxtoreg(MuxtoReg),
    .ALUop(aluop),
    .npcop(Npcop),
    //.byte(Byte),
    .exten(Exten),
    .v(V),
    .lw(LW),
    .valueisPc(valueisPC),
    .unsi(Unsi),
    .slez(Slez),
    .extendedresult(extendedResult),
    .shamt(IFIDinstructionout[10:6]),
    .instructionin(IFIDinstructionout),
    .pcin(IFIDoutpc),
    .MEMforwardin(MEMforwardA),

    .shamtout(IDEXshamt),
    .extendedresultout(IDEXextendedResult),
    .registerdataout1(IDEXregisterdata1),
    .registerdataout2(IDEXregisterdata2),
    .rsout(IDEXrs),
    .rtout(IDEXrt),
    .rdout(IDEXrd),
    .Regdstout(IDEXregdst),
    .ALUSrcout(IDEXalusrc),
    .MemtoRegout(IDEXmemtoreg),
    .RegWriteout(IDEXregwrite),
    .Memreadout(IDEXmemread),
    .Memwriteout(IDEXmemwrite),
    .luiout(IDEXlui),
    .slout(IDEXsl),
    .muxtoregout(IDEXMuxtoReg),
    .ALUopout(IDEXaluop),
    .npcopout(IDEXNpcop),
    //.byteout(IDEXByte),
    .extenout(IDEXExten),
    .vout(IDEXV),
    .lwout(IDEXLW),
    .valueisPcout(IDEXvalueisPC),
    .unsiout(IDEXUnsi),
    .slezout(IDEXSlez),
    .instructionout(IDEXinstructionout),
    .pcout(IDEXpcout),
    .IDEXrtrd(IDEXrtrd),
    .MEMforwardAout(IDMEMforwardA)
);

//*************************************************EXE**************************************

EXforward forwarding(
    .forwardA(EXforwardA),
    .forwardB(EXforwardB),
    .MEMforwardA(MEMforwardA),
    .MEMforwardB(MEMforwardB),
    .rsdatain(IDEXregisterdata1),
    .rtdatain(IDEXregisterdata2),
    .aluresult(EXMEMaluout),
    .MEMWBregwritedata(MEMWBregwritedata),
    .rsdata(Add1),
    .rtdata(Add2)
);
ALU alu(
    .r1(Add1),
    .r2(Add2),
    .immediate(IDEXextendedResult),
    .ALUop(IDEXaluop),
    .shamt(IDEXshamt),
    .ALUSrc(IDEXalusrc),
    .sl(IDEXsl),
    .v(IDEXV),
    .lui(IDEXlui),
    .slez(IDEXSlez),

    .zero(zero),
    .less(less),
    .overflow(overflow),
    .result(ALUresult)
);

EXMEMreg exmemreg(
    .clk(clk),
    .Aluresult(ALUresult),
    .zeroin(zero),
    .lessin(less),
    .Memreadin(IDEXmemread),
    .Memwritein(IDEXmemwrite),
    //.bytein(IDEXByte),
    .lwin(IDEXLW),
    .rdin(IDEXrd),
    .rtin(IDEXrt),
    .valueisPCin(IDEXvalueisPC),
    .instructionin(IDEXinstructionout),
    .Regwritein(IDEXregwrite),
    .rtdatain(Add2),
    .muxtoregin(IDEXMuxtoReg),
    .pcin(IDEXpcout),
    .rtrdin(IDEXrtrd),
    .MEMforwardA(MEMforwardA),
    .unsiin(IDEXUnsi),

    .Aluresultout(EXMEMaluout),
    .zeroout(EXMEMzero),
    .lessout(EXMEMless),
    .Memreadout(EXMEMmemread),
    .Memwriteout(EXMEMmemwrite),
   // .byteout(EXMEMByte),
    .rtdataout(EXMEMrtdata),
    .RegWriteout(exmemregwrite),
    .muxtoregout(EXMEMMuxtoReg),
    .instructionout(EXMEMinstructionout),
    .lwout(EXMEMLW),
    .valueisPcout(EXMEMvalueisPC),
    .rdout(EXMEMrd),
    .rtout(EXMEMrt),
    .pcout(EXMEMpcout),
    .rtrdout(EXMEMrtrd),
    .MEMforwardAout(EXMEMforwardA),
    .unsiout(EXMEMunsi)
);
assign Addr_out=EXMEMaluout;
assign Mem_w=EXMEMmemwrite;
//**********************************MEM*********************************
/*MEMforward memforward(
    .forwardA(EXMEMforwardA),
    .datain1(EXMEMrtdata),
    .datain2(MEMWBregwritedata),
    .dataout(forwardwritedata)
);*/
/*dataMEM DM(
    .clk(clk),
    .read(EXMEMmemread),
    .write(EXMEMmemwrite),
    .byte(EXMEMByte),
    .Addr(EXMEMaluout),
    .writedata(EXMEMrtdata),
    .readdata(MEMreaddata)
);*/
assign Data_out=EXMEMrtdata;
assign MEMreaddata=Data_in;
MEMWBreg memwbreg(
  .clk(clk),
  .Regwritein(exmemregwrite),
  .instructionin(EXMEMinstructionout),
  .aluresultin(EXMEMaluout),
  .readdatain(MEMreaddata),
  .lwin(EXMEMLW),
  .valueisPCin(EXMEMvalueisPC),
  .muxtoregin(EXMEMMuxtoReg),
  .pcin(EXMEMpcout),
  //.bytein(EXMEMByte),
  .unsiin(EXMEMunsi),

  .Regwriteout(memwbregwrite),
  .MEMWBRdRt(MEMWBRdRt),
  .MEMWBregwritedata(MEMWBregwritedata),
  //.byteout(MEMWBByte),
  .unsiout(MEMWBunsi)
);
endmodule
