`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:30:15 05/09/2020 
// Design Name: 
// Module Name:    Regmux 
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
module Regmux(
    input [1:0] muxtoReg,
    input [4:0] rt,
    input [4:0] rd,
    output reg [4:0] A
    );
always @(*)
begin
  case (muxtoReg)
  2'b00:
  begin
   A<=rt;
 end
  2'b01:
  begin 
  A<=5'b11111;
  end
  2'b10: 
  begin
  A<=rd;
  end
  default:
  begin
   A<=rt; 
   end
  endcase
end

endmodule

