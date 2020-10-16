`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:12:42 06/01/2020 
// Design Name: 
// Module Name:    predict_module 
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
module predict_module(
    input [31:0] pc,
    input predict,
    input isjump,
    input [31:0] npcresult,

    output reg [31:0] pcresult
    );
always@(*)
begin
   //$display("gethere predict is %d",predict);
   if(predict==1)
      pcresult=npcresult;
   else if(isjump)
     pcresult=npcresult;
   else
      pcresult=pc+4;
   
end


endmodule
