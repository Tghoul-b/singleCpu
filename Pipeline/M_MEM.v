module MEM(
    input [31:0] Addr,
    input [31:0] WD,
    input clk,
    //input MemRead,
    input MemWrite,
    //input [2:0]MemExt,
    //input [1:0]SSize,
    output reg [31:0] MEMOUT
    );

    reg [31:0] Memory [0:1023];

    initial begin
        $readmemb("C://instrtest.txt", Memory);
    end

    always@(posedge clk) begin
        //if (MemRead == 1) begin
            //if(MemExt == 3'b100) begin//lw IF
                MEMOUT <= Memory[Addr>>2];
            //end
            /*else if(MemExt == 3'b011) begin//lb
                MEMOUT[7:0] = Memory[Addr>>2][7:0]; 
                MEMOUT[31:8] = {24{MEMOUT[7]}};//sign extend 24bits
            end
            else if(MemExt == 3'b010) begin//lh
                MEMOUT[15:0] = Memory[Addr>>2][15:0];
                MEMOUT[31:16] = {16{MEMOUT[15]}};//sign extend 16bits
            end
            else if(MemExt == 3'b001) begin//lbu
                MEMOUT[7:0] = Memory[Addr>>2][7:0];
                MEMOUT[31:8] = 24'd0;//zero extend 24bits
            end
            else if(MemExt == 3'b000) begin//lhu
                MEMOUT[15:0] = Memory[Addr>>2][15:0];
                MEMOUT[31:16] = 16'd0;//zero extend 16bits
            end*/
        //end
    end  

    always@(posedge clk) begin
        if (MemWrite == 1) begin
               //$display("get here writedata Addr is 0x%h,Data is %b",Addr>>2,WD);
            //if(SSize == 2'b10) begin//sw
                Memory[Addr>>2] <= WD;
            //end
            //else if(SSize == 2'b00) begin//sb
                //Memory[Addr>>2][7:0] <= WD[7:0];
                //Memory[Addr>>2][31:8] <= {24{WD[7]}};
            //end
            //else if(SSize == 2'b01) begin//sh
                //Memory[Addr>>2][15:0] <= WD[15:0];
                //Memory[Addr>>2][31:16] <= {16{WD[15]}};
            //end
        end
    end

endmodule
