`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    08:38:14 05/08/2020 
// Design Name: 
// Module Name:    Registerfile 
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
module Registerfile(
    input clk,
    input reset,
    input [31:0] writedata,
    input [4:0] rs,
    input [4:0] rt,
    input writereg,
    input [4:0] rtd,
    //input [1:0] byte,
    input unsi,
    output  [31:0] rsdata,
    output  [31:0] rtdata
    );
  integer i;
  reg[31:0] regfile[0:31];
//32个32位寄存器组
always @(negedge clk,posedge reset)
begin 
   if (reset)
    for(i=0;i<32;i=i+1)
       regfile[i]=32'd0;
    //$display("gethere writereg and rts  is %d and %d",writereg,rtd);
   else 
   if(writereg)//写入的寄存器号不能为0
       begin
         //$display("rtd is %d",rtd);
      /*case (byte)
      2'b01:
      begin
      if(unsi) regfile[rtd]={24'b0,writedata[7:0]};
      else regfile[rtd]={{24{writedata[7]}},writedata[7:0]};
      end
      2'b10:
      begin
     if(unsi) regfile[rtd]={16'b0,writedata[15:0]};
      else regfile[rtd]={{16{writedata[15]}},writedata[15:0]};
      end
      2'b11:
      begin
      regfile[rtd]=writedata;
      end*/
      regfile[rtd]=writedata;
      //endcase
      $display("r[%2d] = 0x%8X", rtd, regfile[rtd]);
      end
end
assign rsdata=(rs!=0)? regfile[rs]:0;
assign rtdata=(rt!=0)?regfile[rt]:0;
endmodule
