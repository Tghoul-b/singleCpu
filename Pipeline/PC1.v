module PC( clk, rst,pcwrite, NPC, PC );

  input   clk;
  input   rst;
  input pcwrite;
  input   [31:0] NPC;
  output reg  [31:0] PC;
  always @(posedge clk, posedge rst)
  begin
    if (rst) 
      PC = 32'h0000_0000;
//      PC <= 32'h0000_3000;
    else
    if(pcwrite)
    begin
      PC = NPC;
    end
//$display("PC is %h",PC);
  end
endmodule