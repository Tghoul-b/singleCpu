`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:49:49 05/08/2020 
// Design Name: 
// Module Name:    signed-extended 
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
module signextended(
    input [15:0] immediate,
    input Exten,
    output reg [31:0] result
    );
always@(*)
begin
end
always@(*)
begin
 result[15:0]=immediate;
//$display("signedextended is %d",immediate);
//$display("Exten is %d",Exten);
 result[31:16]=Exten?(immediate[15]?16'hffff:16'h0000):16'h0000;
end
endmodule
