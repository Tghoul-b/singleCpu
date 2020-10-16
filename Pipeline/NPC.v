`timescale 1ns / 1ps
module NPC(PC, NPCOp,jreg, IMM, rsdata,rtdata,NPC,branch_occur,isjump);  // next pc module
   input  [31:0] PC;        
   input  [3:0]  NPCOp;    
   input  [31:0] IMM;  
   input [31:0]jreg;//used for jalr
   input [31:0]rsdata;
   input [31:0] rtdata;
   output reg [31:0] NPC;   
   output reg branch_occur;
   output reg isjump;
   wire [31:0] temp;
   wire zero;
   wire less;
   assign zero=(rsdata==rtdata);
   assign less=($signed(rsdata)<0);
   assign temp = PC + 4; // pc + 4
   initial begin
   branch_occur=1'b1;
   end
   always @(*) 
   begin
      isjump=1'b0;
      case (NPCOp)
          4'b0001: 
          begin
            NPC =(zero)? temp+ {{14{IMM[15]}}, IMM[15:0], 2'b00}:temp;//beq
            branch_occur=(NPC==(temp+ {{14{IMM[15]}}, IMM[15:0], 2'b00}));
            //$display("NPC is %h",NPC);
          end
          4'b0010: 
          begin
             NPC = (zero)? temp:temp + {{14{IMM[15]}}, IMM[15:0], 2'b00};//bne
             branch_occur=(NPC==(temp + {{14{IMM[15]}}, IMM[15:0], 2'b00}));
          end
          4'b0011: 
          begin
          NPC=(less)? temp + {{14{IMM[15]}}, IMM[15:0], 2'b00}:temp;//bltz
          branch_occur=(NPC==(temp +{{14{IMM[15]}}, IMM[15:0], 2'b00}));
          end
          4'b0100: 
          begin
             //$display("IMM is %h",IMM);
          NPC=(less| zero)? temp + {{14{IMM[15]}}, IMM[15:0], 2'b00}:temp;//blez
          branch_occur=(NPC==(temp + {{14{IMM[15]}}, IMM[15:0], 2'b00}));
          //$display("gethereblez NPC is %h",NPC);
          end
          4'b0101: 
          begin
             NPC=(~less)&&(~zero)?temp + {{14{IMM[15]}}, IMM[15:0], 2'b00}:temp;//bgtz
             branch_occur=(NPC==(temp +{{14{IMM[15]}}, IMM[15:0], 2'b00}));
          end
          4'b0110: 
          begin
          NPC=(~less)? temp + {{14{IMM[15]}}, IMM[15:0], 2'b00}:temp;//bgez
          branch_occur=(NPC==(temp +  {{14{IMM[15]}}, IMM[15:0], 2'b00}));
          end
          4'b0111: 
          begin
             NPC={temp[31:28],IMM[25:0],2'b00};//jump,jal
             isjump=1;
          end
          4'b1000: 
          begin
            NPC=jreg;//jalr
            isjump=1;
          end
          default: NPC = temp;
      endcase
   end
endmodule
