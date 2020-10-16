`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:07:42 05/28/2020 
// Design Name: 
// Module Name:    detect 
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
module detect( 
    input clk,
    input EXMEMregwrite,
    input MEMWBregwrite,
    input IDEXregwrite,
    input [4:0] IDEXrtrd,
    input [4:0] EXMEMrtrd,
    input [4:0] IDEXrs,
    input [4:0] IDEXrt,
    input [4:0] MEMWBrtrd,
    input [3:0] IFIDNPCOp,
    input [4:0] IFIDRs,
    input [4:0] IFIDRt,
    input [5:0] IFIDop,//专门判断是否为I型指令,因为I型指令的数据冒险不涉及rt寄存器所以在下面要特殊判断
    input branch_occur,//判断分支是否发生了
    input IDEXMemread,
    input IDEXMemwrite,

    output reg[2:0] IDforwardA,
    output reg [2:0] IDforwardB,
    output reg[2:0] EXforwardA,
    output reg [2:0] EXforwardB,
    output reg [2:0] MEMforwardA,
    output reg [2:0] MEMforwardB,
    output reg IFIDwrite,
    output reg PCwrite,
    output reg IFIDflush,
    output reg IDEXflush,
    output reg Npcsrc,
    output reg predict_occur
    );
    reg isbranch;
    reg [1:0] state_predict;
     localparam SCS_STRONGLY_TAKEN = 2'b11;
     localparam SCS_WEAKLY_TAKEN = 2'b10;
     localparam SCS_WEAKLY_NOT_TAKEN = 2'b01;
     localparam SCS_STRONGLY_NOT_TAKEN = 2'b00;
    initial begin
    EXforwardA<=3'b000;
    EXforwardB<=3'b000;//EX阶段的旁路
    IFIDwrite<=1;
    PCwrite<=1;
    MEMforwardA<=3'b000;//MEM阶段的旁路
    MEMforwardB<=3'b000;
    IDforwardA<=3'b000;//ID阶段的旁路
    IDforwardB<=3'b000;
    IFIDflush<=1'b0;
    IDEXflush<=1'b0;
    state_predict<=SCS_STRONGLY_NOT_TAKEN;
    end
    
    //'tips:我将NPC单元提前到ID阶段,这样的话如果上面一条指令与这条跳转指令有数据相关的话需要阻塞一个周期因为NPC在ID阶段,其实我想过将NPC单元放在EX阶段但是发现那样的话
    //跳转指令的下一条指令就需要延迟一个周期取指,因为下一条指令取指是在PC确定之后完成的。时钟周期是相同的。
    always @(*)
   begin

    EXforwardA=3'b000;
    EXforwardB=3'b000;//EX阶段的旁路
    MEMforwardA=3'b000;//MEM阶段的旁路
    MEMforwardB=3'b000;
    IDforwardA=3'b000;//ID阶段的旁路
    IDforwardB=3'b000;
    //EX阶段
    //$display("gethere EXMEMregwrite,EXMEMrtd,IDEXrs is %d %d %d ",EXMEMregwrite,EXMEMrtrd,IDEXrs);
    if((EXMEMregwrite)&&(EXMEMrtrd)&&(EXMEMrtrd==IDEXrs))
    begin
      EXforwardA=3'b010;//add add
      //$display("%s","gethere shujumaoxian");
    end
    if((EXMEMregwrite)&&(EXMEMrtrd)&&(EXMEMrtrd==IDEXrt))//I型特殊判断
    begin
    EXforwardB=3'b010;
    //$display("gethere EXforwardB is %3b",EXforwardB);
    end
    //ID阶段
    if(((IFIDNPCOp==4'b1000)||(IFIDNPCOp==4'b0111)||(isbranch))&&(EXMEMregwrite)&&(EXMEMrtrd)&&(EXMEMrtrd==IFIDRs))//jalr,jr指令
    begin
       IDforwardA=3'b001;
    end
    if(((IFIDNPCOp==4'b1000)||(IFIDNPCOp==4'b0111)||(isbranch))&&(EXMEMregwrite)&&(EXMEMrtrd)&&(EXMEMrtrd==IFIDRt))//jalr,jr指令
    begin
       IDforwardB=3'b001;
    end
    //MEM阶段
    if((MEMWBregwrite)&&(MEMWBrtrd)&&!((EXMEMregwrite)&&(EXMEMrtrd)&&(EXMEMrtrd==IDEXrs))&&(MEMWBrtrd==IDEXrs))//双数据冒险
    begin
     MEMforwardA=3'b001;
    end
    if((MEMWBregwrite)&&(MEMWBrtrd)&&!((EXMEMregwrite)&&(EXMEMrtrd)&&(EXMEMrtrd==IDEXrt))&&(MEMWBrtrd==IDEXrt))
    begin
      MEMforwardB=3'b001;
    end
    end
    always@(negedge clk)
    begin
    IFIDwrite=1;
    PCwrite=1;
    IFIDflush=1'b0;
    IDEXflush=1'b0;
    predict_occur=1'b0;
    isbranch=((IFIDNPCOp==4'b0001)||(IFIDNPCOp==4'b0010)||(IFIDNPCOp==4'b0011)||(IFIDNPCOp==4'b0100)||(IFIDNPCOp==4'b0101)||(IFIDNPCOp==4'b0110));
      //lw,sw
      //$display("IDEXMemread is %d",IDEXMemread);
      if((IDEXMemread)&&((IDEXrtrd==IFIDRs)||(IDEXrtrd==IFIDRt)))
      begin
          //$display("%s","gethere");
          PCwrite=1'b0;
          IFIDwrite=0;
          IFIDflush=1'b0;
          IDEXflush=1'b1;
      end
      if(((IFIDNPCOp==4'b1000)||(IFIDNPCOp==4'b0111))&&(IDEXregwrite)&&(IDEXrtrd)&&((IDEXrtrd==IFIDRs)||(IDEXrtrd==IFIDRt)))//jalr指令与上一条指令发生了数据冒险
      begin                                                                                         //这里是将下面一条指令重新取一下,导致之间会阻塞一个周期。
          PCwrite=1'b0;
          IFIDwrite=0;
          IFIDflush=1'b0;
          IDEXflush=1'b1;
          //$display("%s","nop");
      end
      else 
      if((IFIDNPCOp==4'b1000)||(IFIDNPCOp==4'b0111))//这里是将下一条指令直接清除，利用了时间延迟槽的思路,取了一条废指令,导致需要再花一个周期去取指令所以也会阻塞一个周期
      begin
          PCwrite=1'b1;
          IFIDwrite=1'b0;
          IFIDflush=1'b1;
          IDEXflush=1'b0;
          //$display("%s","nop");
      end
      if(isbranch)//branch指令
      begin
        if((IDEXregwrite)&&(IDEXrtrd)&&((IDEXrtrd==IFIDRs)||(IDEXrtrd==IFIDRt)))//上一条指令与这条跳转指令发生数据冒险
        begin//
          PCwrite=1'b0;
          IFIDwrite=0;
          IFIDflush=1'b0;
          IDEXflush=1'b1;
          //$display("%s","nop");
        end
        else 
        if(((MEMWBregwrite)&&(MEMWBrtrd)&&!((EXMEMregwrite)&&(EXMEMrtrd)&&(EXMEMrtrd==IDEXrs))&&(MEMWBrtrd==IDEXrs))
        ||((MEMWBregwrite)&&(MEMWBrtrd)&&!((EXMEMregwrite)&&(EXMEMrtrd)&&(EXMEMrtrd==IDEXrt))&&(MEMWBrtrd==IDEXrt)))
        begin//上上一条指令是lw指令且与这条指令有指令冲突(需要阻塞一个周期)
          PCwrite=1'b0;
          IFIDwrite=0;
          IFIDflush=1'b0;
          IDEXflush=1'b1;
          //$display("%s","nop");
        end
        else
        begin 
        if(((state_predict==SCS_STRONGLY_NOT_TAKEN)||(state_predict==SCS_WEAKLY_NOT_TAKEN))&&(branch_occur)
         ||((state_predict==SCS_STRONGLY_TAKEN)||(state_predict==SCS_WEAKLY_TAKEN)&&(!branch_occur)))//预测错误
         begin
           //$display("%s","predict_failure");
          //$display("%s","getherepredictwrong");
          PCwrite=1'b1;
          IFIDwrite=0;
          IFIDflush=1'b1;
          IDEXflush=1'b1;
          //$display("%s","gethere");
         end
         else if(((state_predict==SCS_STRONGLY_NOT_TAKEN)||(state_predict==SCS_WEAKLY_NOT_TAKEN))&&(!branch_occur)
         ||((state_predict==SCS_STRONGLY_TAKEN)||(state_predict==SCS_WEAKLY_TAKEN)&&(branch_occur)))//预测正确
         begin
           
          // $display("getherepredictright state_predict is %2b,brach_occur is %2b",state_predict,branch_occur);
            PCwrite=1'b1;
            IFIDwrite=1'b1;
            IFIDflush=1'b0;
            IDEXflush=1'b0;
         end
        end
        case(state_predict)
         SCS_STRONGLY_NOT_TAKEN:
            begin
              
              if(branch_occur)
              state_predict=SCS_WEAKLY_NOT_TAKEN;
              else
                state_predict=SCS_STRONGLY_NOT_TAKEN;
              //$display("gethere state_predict is %2b",state_predict);
            end
         SCS_WEAKLY_NOT_TAKEN:
             begin
               if(branch_occur)
                 state_predict=SCS_WEAKLY_TAKEN;
               else
                  state_predict=SCS_STRONGLY_NOT_TAKEN;
              end
          SCS_WEAKLY_TAKEN:
          begin
             if(branch_occur)
               state_predict=SCS_STRONGLY_TAKEN;
             else
                state_predict=SCS_WEAKLY_NOT_TAKEN;
          end
          SCS_STRONGLY_TAKEN:
          begin
            if(branch_occur)
              state_predict=SCS_STRONGLY_TAKEN;
            else
              state_predict=SCS_WEAKLY_TAKEN;
          end
          endcase 
          case (state_predict)
           SCS_STRONGLY_NOT_TAKEN,SCS_WEAKLY_NOT_TAKEN:
             predict_occur=1'b0;
           SCS_WEAKLY_TAKEN,SCS_STRONGLY_TAKEN:
            predict_occur=1'b1;
          endcase       
        end
    end
endmodule
