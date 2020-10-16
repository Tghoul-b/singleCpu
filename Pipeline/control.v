`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:00:12 05/07/2020 
// Design Name: 
// Module Name:    ControlUnit 
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
module ControlUnit(
    input [5:0] op,
    input [5:0] func,
    input [4:0]rt,
    output reg Regdst,
    output reg ALUSrc,
    output reg MemtoReg,
    output reg RegWrite,
    output reg Memread,
    output reg Memwrite,
    output reg lui,
    output reg sl,
    output reg [1:0]muxtoreg,
    output reg [3:0] ALUop,
    output reg [3:0] npcop,
    output reg [1:0] byte,
    output reg exten,
    output reg v,
    output reg lw,
    output reg valueisPc,
    output reg unsi,
    output reg slez
    );
always @(*)
begin
  byte=2'b11;//byte为写入寄存器中的字节数，2'b01代表写入一个字节,2'b10代表写入两个字节，2'b11代表写入四个字节
  npcop=4'b0000;//具体定义见npc单元
  exten=1;//1代表有符号扩展，0代表无符号扩展
  Regdst=0;//
  ALUSrc=0;//ALUSrc为1时第二个ALU操作数为立即数，为0时则为rt
  MemtoReg=2'b00;//2'b00代表写入的寄存器为rt,2'b01代表写入寄存器为31,2'b10代表写入寄存器为rd
  RegWrite=0;//寄存器写信号
  Memread=0;//内存读信号
  Memwrite=0;//内存写信号
  muxtoreg=2'b00;//决定写入的寄存器2'b00代表为rt,2'b01代表为31,2'b10代表为rd
  v=0;//v选择左移右移数，v=1时为rs[4:0],v=0时则为shamt
  sl=0;//sl=1时则是两个数作比较,否则则进行减法
  lw=0;//lw=1时写入register的数据来自内存，否则来自ALU结果
  lui=0;//lui=1时执行lui指令,将立即数加载到高位
  unsi=0;//unsi为1时写入register中的一个字节或两个字节采用无符号扩展,否则为有符号扩展
  valueisPc=0;//valueisPc为1时写入register的数据为PC+4
  slez=0;//slez为1时与0进行比大小
  case(op)
  //R型
    6'b000000:
    begin 
    Regdst=1;
    ALUSrc=0;
    MemtoReg=0;
    RegWrite=1;
    Memread=0;
    Memwrite=0;  
    muxtoreg=2'b10;
    //$display("func is %6b",func);
    case (func)
         6'b100000: //ADD
         begin
          ALUop=4'b0000;
         end
        6'b100010://SUB
        begin
        ALUop=4'b0010;
        end
        6'b100100://AND
        begin
        ALUop=4'b0101;
        end
       6'b100101://or
        begin
        ALUop=4'b0001;
        end
        6'b101010://slt
        begin
        ALUop=4'b0010;
        sl=1;
        end
        6'b101011://sltu
        begin
        ALUop=4'b1000;
        sl=1;
        end
        6'b100001://addu
        begin 
        ALUop=4'b0100;
        muxtoreg=2'b10;
        // $display("gethere addu muxtoreg is %2b",muxtoreg);
        end
        6'b100011://subu
        begin
        ALUop=4'b1000;
        muxtoreg=2'b10;
        end
        6'b100110://xor
        begin
        ALUop=4'b0011;
        end
        6'b100111://nor
        begin
        ALUop=4'b0110;
        muxtoreg=2'b10;
        end
        6'b000000://sll
        begin
        ALUop=4'b0111;
        muxtoreg=2'b00;
        end
        6'b000011://sra
        begin
        ALUop=4'b1001;
        end
        6'b000111://srav
        begin
        ALUop=4'b1001;
        v=1;
        end
       6'b000010://srl
       begin
       ALUop=4'b1010;
       end
       6'b000100://sllv
       begin
       ALUop=4'b0111;
       v=1;
       end
       6'b000110://srlv
       begin
       ALUop=4'b1010;
       v=1;
       end
       6'b001001://jalr
       begin
       npcop=4'b1000;
       RegWrite=1;
       muxtoreg=2'b10;
       valueisPc=1;
       end
       6'b001000://jr
       begin
       npcop=4'b1000;
       RegWrite=0;
       end
       endcase
    end
  //I型 addi
  6'b001000:
    begin
    Regdst=0;
    ALUSrc=1;
    MemtoReg=0;
    RegWrite=1;
    Memread=0;
    Memwrite=0;
    ALUop=4'b0000;//加法
    end
    //I型 ori
   6'b001101:
    begin
    Regdst=0;
    ALUSrc=1;
    MemtoReg=0;
    RegWrite=1;
    Memread=0;
    Memwrite=0;
    ALUop=4'b0001;//或
    end
    //lw
   6'b100011:
   begin
    Regdst=0;
    ALUSrc=1;
    MemtoReg=1;
    RegWrite=1;
    Memread=1;
    Memwrite=0;
    lw=1;
    ALUop=4'b0000;//加法
   end
   //sw
   6'b101011:
   begin
    Regdst=0;
    ALUSrc=1;
    MemtoReg=0;
    RegWrite=0;
    Memread=0;
    Memwrite=1;
    byte=2'b11;
    ALUop=4'b0000;//加法
    end
   //beq
   6'b000100:
   begin
    Regdst=0;
    ALUSrc=0;
    MemtoReg=0;
    RegWrite=0;
    Memread=0;
    Memwrite=0;
    ALUop=4'b0010;//减法
    npcop=4'b0001;
    end
    //J
    6'b000010:
    begin
    Regdst=0;
    ALUSrc=0;
    MemtoReg=0;
    RegWrite=0;
    Memread=0;
    Memwrite=0;
      
    ALUop=4'b0000;//加法
    npcop=4'b0111;
    end
    //JAL
    6'b000011:
    begin
     Regdst=0;
    ALUSrc=0;
    MemtoReg=0;
    RegWrite=1;
    Memread=0;
    Memwrite=0;
    valueisPc=1;
    ALUop=4'b0000;//加法
    npcop=4'b0111;
    muxtoreg=2'b01;
    end
  //xori
  6'b001110:
  begin
    Regdst=0;
    ALUSrc=1;
    MemtoReg=0;
    RegWrite=1;
    Memread=0;
    Memwrite=0;
      
    ALUop=4'b0011;//异或
     
  end
  //addiu
  6'b001001:
  begin
    Regdst=0;
    ALUSrc=1;
    MemtoReg=0;
    RegWrite=1;
    Memread=0;
    Memwrite=0;
      
    ALUop=4'b0100;//无符号加
     
  end
  //andi
  6'b001100:
  begin
    Regdst=0;
    ALUSrc=1;
    MemtoReg=0;
    RegWrite=1;
    Memread=0;
    Memwrite=0;
    ALUop=4'b0101;//与
 end
  //lui
  6'b001111:
  begin
  Regdst=0;
    ALUSrc=1;
    MemtoReg=0;
    RegWrite=1;
    Memread=0;
    Memwrite=0;
    ALUop=4'b0111;
    lui=1;
    //移位
   end
  //slti
  6'b001010:
  begin
    Regdst=0;
    ALUSrc=1;
    MemtoReg=0;
    RegWrite=1;
    Memread=0;
    Memwrite=0;
    ALUop=4'b0010;//减法
    sl=1;
  end
  //sltui
  6'b001011:
   begin
    Regdst=0;
    ALUSrc=1;
    MemtoReg=0;
    RegWrite=1;
    Memread=0;
    Memwrite=0;
      
    ALUop=4'b1000;//无符号减法
     
  end
  //lb
  6'b100000:
  begin
  Regdst=0;
    ALUSrc=1;
    MemtoReg=0;
    RegWrite=1;
    Memread=1;
    Memwrite=0;
  ALUop=4'b0000;//有符号加法
     lw=1;
    byte=2'b01;
  end
  //lh
  6'b100001:
  begin
    Regdst=0;
    ALUSrc=1;
    MemtoReg=0;
    RegWrite=1;
    Memread=1;
    Memwrite=0;
    ALUop=4'b0000;//有符号加法
    byte=2'b10;
    lw=1;
  end
  //lbu
  6'b100100:
  begin
    Regdst=0;
    ALUSrc=1;
    MemtoReg=0;
    RegWrite=1;
    Memread=1;
    Memwrite=0;
    lw=1;
    ALUop=4'b0100;//无符号加法
     unsi=1;
    byte=2'b01;
  end
  //lhu
  6'b100101:
  begin
    Regdst=0;
    ALUSrc=1;
    MemtoReg=0;
    RegWrite=1;
    Memread=1;
    Memwrite=0;
    unsi=1;
    lw=1;
    ALUop=4'b0100;//无符号加法
    byte=2'b10;
  end
  //sb
  6'b101000:
  begin
    Regdst=0;
    ALUSrc=1;
    MemtoReg=0;
    RegWrite=0;
    Memread=0;
    Memwrite=1;
    ALUop=4'b0000;//有符号加法
    byte=2'b01;
  end
  //sh
  6'b101001:
   begin
    Regdst=0;
    ALUSrc=1;
    MemtoReg=0;
    RegWrite=0;
    Memread=0;
    Memwrite=1;
    ALUop=4'b0000;//有符号加法
    byte=2'b10;
  end
  //bne
  6'b000101:
   begin
    Regdst=0;
    ALUSrc=0;
    MemtoReg=0;
    RegWrite=0;
    Memread=0;
    Memwrite=0;
      
    ALUop=4'b0010;//减法
   end
  //blez
  6'b000110:
   begin
    Regdst=0;
    ALUSrc=0;
    MemtoReg=0;
    RegWrite=0;
    Memread=0;
    Memwrite=0;
    slez=1;
    npcop=4'b0100;
    ALUop=4'b0010;//减法
    end
    //bltz and bgez
    6'b000001:
    begin
    //$display("%s","gethere");
    if(rt==6'b000000)
    begin
     Regdst=0;
    ALUSrc=0;
    MemtoReg=0;
    RegWrite=0;
    Memread=0;
    Memwrite=0;
    slez=1;
    npcop=4'b0011;
    ALUop=4'b0010;//减法
    end
    else
    begin
    Regdst=0;
    ALUSrc=0;
    MemtoReg=0;
    RegWrite=0;
    Memread=0;
    Memwrite=0;
    slez=1;
    npcop=4'b0110;
    ALUop=4'b0010;//特殊判断
    end
    end
    //bgtz
    6'b000111:
    begin
    Regdst=0;
    ALUSrc=0;
    MemtoReg=0;
    RegWrite=0;
    Memread=0;
    Memwrite=0;
    slez=1;  
    npcop=4'b0101;
    ALUop=4'b0010;//减法
    end 
    default:
    begin
    end
   endcase
  end
endmodule
