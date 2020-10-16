`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:49:58 05/28/2020 
// Design Name: 
// Module Name:    pipeLinereg 
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
module IFIDreg(
    input clk,//时钟信号
    input IFIDflush,//IFID清空信号
    input [31:0]instruction,//指令
    input [31:0]pc,//pc值
    input IFIDwrite,//写信号
    output reg [31:0]outpc,//pc输出值
    output reg [31:0] instructionout
);
always @(posedge clk)
begin
   if(IFIDflush)
   begin
   outpc=32'hfedcba98;
   instructionout=32'hfedcba98;
   end
   else 
   if(IFIDwrite)
     begin
     outpc=pc;
     instructionout=instruction;
     end
end
endmodule


module IDEXreg(
  input clk,
  input IDEXflush,
  input [31:0]registerdata1,
  input [31:0]registerdata2,
  input [4:0] rs,
  input [4:0] rt,
  input [4:0] rd,
  input Regdst,
  input ALUSrc,
  input MemtoReg,
  input RegWrite,
  input Memread,
  input Memwrite,
  input lui,
  input sl,
  input [1:0]muxtoreg,
  input [3:0] ALUop,
  input [3:0] npcop,
  //input [1:0] byte,
  input exten,
  input v,
  input lw,
  input valueisPc,
  input unsi,
  input slez,
  input [31:0]extendedresult,
  input [4:0] shamt,
  input [31:0] instructionin,
  input [31:0] pcin,
  input [2:0] MEMforwardin,

  output reg [4:0] shamtout,
  output reg [31:0] extendedresultout,
  output reg [31:0]registerdataout1,
  output reg [31:0]registerdataout2,
  output reg [4:0] rsout,
  output reg [4:0] rtout,
  output reg [4:0] rdout,
  output reg Regdstout,
  output reg ALUSrcout,
  output reg MemtoRegout,
  output reg RegWriteout,
  output reg Memreadout,
  output reg Memwriteout,
  output reg luiout,
  output reg slout,
  output reg [1:0]muxtoregout,
  output reg [3:0] ALUopout,
  output reg [3:0] npcopout,
  //output reg [1:0] byteout,
  output reg extenout,
  output reg vout,
  output reg lwout,
  output reg valueisPcout,
  output reg unsiout,
  output reg slezout,
  output reg[31:0] instructionout,
  output reg[31:0] pcout,
  output reg [4:0] IDEXrtrd,
  output reg [2:0] MEMforwardAout
);
always @(posedge clk)
begin 
  if(IDEXflush)
  begin
  registerdataout1=32'd0;
  registerdataout2=32'd0;
  rsout=5'd0;
  rtout=5'd0;
  rdout=5'd0;
  Regdstout=1'b0;
  ALUSrcout=1'd0;
  extendedresultout=32'd0;
  MemtoRegout=1'd0;
  shamtout=5'd0;
  RegWriteout=1'd0;
  Memreadout=1'd0;
  Memwriteout=1'd0;
  luiout=1'd0;
  ALUopout=4'b1111;//空操作
  npcopout=4'b1111;//空操作
  //out=2'd0;
  extenout=1'd0;
  lwout=1'd0;
  valueisPcout=1'd0;
  unsiout=1'd0;
  slezout=1'd0;
  instructionout=32'd0;
  pcout=32'd0;
  MEMforwardAout=3'b000;
  end
 else
 begin 
  extendedresultout=extendedresult;
  registerdataout1=registerdata1;
  registerdataout2=registerdata2;
  //$display("registerdataout2 is %h",registerdataout2);
  rsout=rs;
  rtout=rt;
  rdout=rd;
  Regdstout=Regdst;
  ALUSrcout=ALUSrc;
  MemtoRegout=MemtoReg;
  RegWriteout=RegWrite;
  Memreadout=Memread;
  Memwriteout=Memwrite;
  luiout=lui;
  slout=sl;
  ALUopout=ALUop;//空操作
  npcopout=npcop;//空操作
 // byteout=byte;
  extenout=exten;
  lwout=lw;
  valueisPcout=valueisPc;
  unsiout=unsi;
  slezout=slez;
  shamtout=shamt;
  instructionout=instructionin;
  muxtoregout=muxtoreg;
  //$display("muxtoreg is %2b",muxtoreg);
  pcout=pcin;
  vout=v;
  //$display("IDMEMforwardA is %3b",MEMforwardin);
  MEMforwardAout=MEMforwardin;
  case (instructionin[31:26])
  6'b000000:
   IDEXrtrd=instructionin[15:11];
  default:
    IDEXrtrd=instructionin[20:16];
  endcase 
 end
end
endmodule


module EXMEMreg(
    input clk,
    input exmemflush,
    input [31:0]Aluresult,
    input zeroin,
    input lessin,
    input Memreadin,
    input Memwritein,
  //  input [1:0] bytein,
    input [31:0] instructionin,
    input Regwritein,
    input [31:0] rtdatain,
    input [1:0]muxtoregin,
    input lwin,
    input [4:0] rdin,
    input [4:0] rtin,
    input valueisPCin,
    input [31:0] pcin,
    input [4:0] rtrdin,
    input [2:0] MEMforwardA,
    input unsiin,

    output reg[31:0] Aluresultout,
    output reg zeroout,
    output reg lessout,
    output reg Memreadout,
    output reg Memwriteout,
   // output reg [1:0] byteout,
    output reg [31:0] rtdataout,
    output reg RegWriteout,
    output reg [1:0]muxtoregout,
    output reg [31:0] instructionout,
    output reg lwout,
    output reg valueisPcout,
    output reg [4:0] rdout,
    output reg [4:0] rtout,
    output reg [31:0] pcout,
    output reg[4:0] rtrdout,
    output reg [2:0] MEMforwardAout,
    output reg unsiout
);
always @(posedge clk)
  begin
    Aluresultout=Aluresult;
    zeroout=zeroin;
    lessout=lessin;
    Memreadout=Memreadin;
    Memwriteout=Memwritein;
  //  byteout=bytein;
    rtdataout=rtdatain;
    RegWriteout=Regwritein;
    muxtoregout=muxtoregin;
    instructionout=instructionin;
    lwout=lwin;
    valueisPcout=valueisPCin;
    rdout=rdin;
    rtout=rtin;
    pcout=pcin;
    rtrdout=rtrdin;
    MEMforwardAout=MEMforwardA;
    unsiout=unsiin;
  end
endmodule

module MEMWBreg(
  input clk,
  input Regwritein,
  input [31:0] instructionin,
  input [31:0] aluresultin,
  input [31:0] readdatain,
  input lwin,
  input valueisPCin,
  input [1:0]muxtoregin,
  input [31:0] pcin,
 // input [1:0] bytein,
  input unsiin,

  output reg Regwriteout,
  output reg [4:0] MEMWBRdRt,
  output reg [31:0] MEMWBregwritedata,
//  output reg [1:0] byteout,
  output reg unsiout
);
always @(posedge clk)
  begin
    Regwriteout=Regwritein;
 //   byteout=bytein;
    //$display("gethere muxtoregin is %2b",muxtoregin);
    case(muxtoregin)
    2'b00:
       MEMWBRdRt=instructionin[20:16];
    2'b01:
      MEMWBRdRt=5'd31;
    2'b10:
      MEMWBRdRt=instructionin[15:11];
    endcase
    MEMWBregwritedata=aluresultin;
    if(valueisPCin)
      MEMWBregwritedata=pcin+4;
    if(lwin)
     begin
     MEMWBregwritedata=readdatain;
     unsiout=unsiin;
     end
    //$display("MEMWBregwritedata is %h",MEMWBregwritedata);
  end
  
endmodule