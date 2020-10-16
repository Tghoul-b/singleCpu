`include "alu.v"
`include "ctrl_unit.v"
`include "EXT.v"
`include "mux.v"
`include "NPC.v"
`include "PC.v"
`include "RF.v"
`include "ctrl_encode_def.v"

module cpu( input           clk,
            input           rst,
            input   [31:0]  Data_in,
            input   [31:0]  Ins,
            output  mem_w,
            output  [31:0]  Addr_out,
            output  [31:0]  Pc,
            output  [31:0]  Data_out );
    
    
    
    
    wire    [31:0]  pc;
    wire    [31:0]  npc;
    wire    [2:0]   NPCOp;
    wire    [31:0]  Rsdata;
    wire    Zero;
    wire    ALUSrc1;
    wire    ALUSrc2;
    wire    [1:0]   RegDst;
    wire    [1:0]   toReg;
    wire    [1:0]   EXTOp;
    wire    [31:0]  Imm32;
    wire    RFWr;
    wire    [4:0]   A3;   
    wire    [31:0]  Rtdata;
    wire    [31:0]  WD;
    wire    [3:0]   ALUOp;
    wire    [31:0]  A;
    wire    [31:0]  B;
    wire    [31:0]  C;
    wire    [1:0]   DMWr;
    wire    [3:0]   DMRd;
    assign Data_out = Rtdata;
    assign mem_w = DMWr[0];
    assign Addr_out = C;
    assign  Pc = pc;
    PC pC(   .clk(clk),       
             .rst(rst),       
             .npc(npc),   
             .pc(pc) );
    NPC NPC (   .pc(pc),         
                .NPCOp(NPCOp),   
                .IMM(Ins[25:0]), 
                .Rt(Ins[20:16]), 
                .RD1(Rsdata),       
                .Zero(Zero),     
                .npc(npc) );
    EXT EXT ( .Imm16(Ins[15:0]), 
              .EXTOp(EXTOp), 
              .Imm32(Imm32));
    RF  RF (.clk(clk), 
            .rst(rst), 
            .RFWr(RFWr), 
            .A1(Ins[25:21]), 
            .A2(Ins[20:16]), 
            .A3(A3),
            .WD(WD),   
            .RD1(Rsdata), 
            .RD2(Rtdata));
    mux2 ALUmux1in   ( .data0(Rsdata),        
                        .data1({27'b0,Ins[10:6]}),  
                        .s(ALUSrc1), 
                        .y(A) );
    mux2 ALUmux2in    ( .data0(Rtdata),        
                    .data1(Imm32),      
                    .s(ALUSrc2),    
                    .y(B) );
    alu      alu    ( .A(A), 
                        .B(B), 
                        .ALUOp(ALUOp), 
                        .C(C), 
                        .Zero(Zero) );
    
    mux4 RegDstmux  ( .data0(Ins[20:16]), 
                        .data1(Ins[15:11]), 
                        .data2(31),        
                        .data3(0), 
                        .s(RegDst), 
                        .y(A3) );   
    mux4 toRegmux   (.data0(C),          
                    .data1(Data_in),   
                    .data2(pc+4),      
                    .data3(0), 
                    .s(toReg),  
                    .y(WD) );
    ctrl_unit ctrl_unit( .opcode(Ins[31:26]), 
                        .func(Ins[5:0]), 
                        .RegDst(RegDst),     
                        .NPCOp(NPCOp),    
                        .DMRd(DMRd), 
                        .toReg(toReg), 
                        .ALUOp(ALUOp),       
                        .DMWr(DMWr),      
                        .ALUSrc1(ALUSrc1), 
                        .ALUSrc2(ALUSrc2),  
                        .RFWr(RFWr),      
                        .EXTOp(EXTOp) );

endmodule