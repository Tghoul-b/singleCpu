`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:12:45 05/07/2020 
// Design Name: 
// Module Name:    ALU 
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
module ALU(
    input signed [31:0] r1,
    input signed [31:0] r2,
    input [31:0] immediate,
    input [3:0] ALUop,
    input [4:0]shamt,
    input ALUSrc,
    input sl,
    input v,//可变与不可变移位
    input lui,
    input slez,
    output reg zero,
    output reg less,
    output reg overflow,
    output reg [31:0] result
    );
reg [31:0] add1;
reg [31:0] add2;
reg [32:0] temp;
always @(*)
begin 
add1=r1;
 if(ALUSrc)
   begin
   add2=immediate;
   end
   else
   begin
   add2=r2;
   end
zero=0;
less=0;
 case (ALUop)
     4'b0000:
     begin
     temp = {1'b0, add1} + {1'b0,add2};
     result = $signed(add1) + $signed(add2);
     overflow = temp[32] ^ add1[31] ^ add2[31] ^ result[31];
     end
     4'b0100:
     begin
     result=add1+add2;
     end
     4'b0001:
     begin
     result=(add1)|(add2);
     end
     4'b0010:
     begin
     //$display("gethere add1 is %d,add2 is %d,sl is %d",$signed(add1),$signed(add2),sl);
    if(sl)//sl没有传递过来造成过一次错误
    begin
    result=($signed(add1)<$signed(add2))?1:0;
    end
    else
    begin
    if(slez) 
    begin
    less=($signed(add1)<$signed(0))?1:0;
    zero=(add1==0)?1:0;
    end
    else
     begin
     temp = {1'b0, add1} -{1'b0,add2};
     result = add1 -add2;
     overflow = temp[32] ^ add1[31] ^ add2[31] ^ result[31];
     zero=(result==0)?1:0;
     less=(result<0)?1:0;
     end
    end
     end
     4'b0011:
     begin
     result=add1^add2;
     end
     4'b0100:
     begin
     result=(add1)+(add2);
     end
     4'b0101:
     begin
     result=add1&add2;
     end
     4'b0110:
     begin
     result=~(add1|add2);
     end
     4'b0111:
     begin
     //$display("getherev is %d",v);
     if(lui)
     begin
     result=immediate<<16;
     end
     else
     begin
     if(v)
     begin
     
     result=r2<<r1[4:0];
     end
     else
     begin
     result=r2<<shamt;
     end
     end
     end
     4'b1000:
     begin
     if(sl)
    begin
    result=(add1<add2)?1:0;
    end
    else 
    begin
     result=(add1)-(add2);
     zero=(result==0)?1:0;
     less=(result<0)?1:0;
     end
     end
     4'b1001:
     begin
     if(v)
     begin
     result=$signed(r2)>>>r1[4:0];
     end
     else
     begin
     result=$signed(r2)>>>shamt;
     end
     end
     4'b1010:
     begin
     if(v)
     begin
     result=$unsigned(r2)>>>r1[4:0];
     end
     else
     begin
     result=$unsigned(r2)>>>shamt;
     end
     end
    default:
       result=add1;   
endcase
end

endmodule
