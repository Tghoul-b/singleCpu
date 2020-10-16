`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    16:56:59 05/29/2020 
// Design Name: 
// Module Name:    forward 
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
module IDforward(
  input [31:0]aluresultin,
  input [31:0] rsdata,
  input [31:0] rtdata,
  input [2:0]forwardAin,
  input [2:0]forwardBin,

  output reg [31:0] A,
  output reg [31:0] B
);
always @(*)
begin
  case (forwardAin)
  3'b001:
  begin
    A=aluresultin;
  end
  default:
  A=rsdata;
endcase
 case(forwardBin)
  3'b001:
  begin
    B=aluresultin;
  end
  default:
    B=rtdata;
endcase
end
endmodule
module EXforward(
    input [2:0] forwardA,
    input [2:0] forwardB,
    input [2:0] MEMforwardA,
    input [2:0] MEMforwardB,
    input [31:0] rsdatain,
    input [31:0] rtdatain,
    input [31:0] aluresult,
    input [31:0] MEMWBregwritedata,
    output reg [31:0] rsdata,
    output reg [31:0] rtdata
    );
always@(*)
begin
  //$display("forwardA,forwardB,MEMforwardA,MEMforwardB is %2b,%3b,%3b,%3b",forwardA,forwardB,MEMforwardA,MEMforwardB);
  case (forwardA)
  3'b010:
  begin
  rsdata=aluresult;
  end
  default:rsdata=rsdatain;
 endcase
  case (forwardB)
  3'b010:
  begin
  rtdata=aluresult;
  //$display("gethere rtdata is %d",rtdata);
  end
  default:rtdata=rtdatain;
  endcase
  case (MEMforwardA)
  3'b001: 
  begin
  rsdata=MEMWBregwritedata;
  end
  endcase
  case(MEMforwardB)
  3'b001:
   rtdata=MEMWBregwritedata;
  endcase
  //$display("Add2 is %h",rtdata);
end

endmodule
/*module MEMforward (
    input [2:0]forwardA,
    input [31:0] datain1,
    input [31:0] datain2,
    output reg [31:0] dataout
);
always@(*)
begin
case (forwardA)
3'b111:
  dataout=datain2;
default:
 dataout=datain1;
endcase
end
endmodule*/