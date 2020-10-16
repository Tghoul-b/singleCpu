`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:53:19 08/24/2020 
// Design Name: 
// Module Name:    top 
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
module top(
    input clk,
    input u9_RSTN,
    input [15:0]u9_SW,
    input [3:0]BTN_y,
    output  u7_led_clk,
    output  u7_led_sout,
    output  u7_LED_PEN,
    output  u7_led_clrn,
    output u6_seg_clk, //串行移位时钟
    output u6_seg_sout, //七段显示数据(串行输出)
    output u6_SEG_PEN, //七段码显示刷新使能
    output u6_seg_clrn, //七段码显示归零
    output RDY,
    output M4_readn,
    output  u9_CR,
    output [4:0] BTN_x
    );


wire reset;
//***********************************U1****************************//
wire u1_MIO_ready;
wire[31:0] u1_instruction;
wire[31:0] u1_data_in;
wire u1_mem_w_output;
wire[31:0] u1_pc_out;
wire [31:0] u1_addr_out;
wire[31:0] u1_data_out;
wire u1_INT_in;

//*******************************U2****************************//
wire clk_m;

//******************************U3****************************//
wire u3_data_ram_we;
wire [9:0] u3_ram_addr;
wire [31:0] u3_ram_data_in;
wire [31:0] u3_ram_data_out;

//****************************U4*******************************//
wire [3:0] u4_BTN_in;
wire [15:0] u4_SW_in;
wire u4_mem_w_in;
wire [31:0] u4_Cpu_data2bus;
wire [31:0] u4_addrbus_in;
wire [31:0] u4_ram_data_out;
wire [15:0] u4_led_out;
wire [31:0]u4_counter_out;
wire u4_counter0_out;
wire u4_counter1_out;
wire u4_counter2_out;
wire [31:0]u4_Cpu_data4bus;
wire [31:0] u4_ram_data_in;
wire [9:0]u4_ram_addr;
wire u4_data_ram_we;
wire u4_GPIOf0000000_we;
wire u4_GPIOe0000000_we;
wire u4_counter_we;
wire [31:0] u4_Peripheral_in;

//******************************U5********************************
wire [15:0]u5_SW_OK;
wire [31:0] u5_Div;
wire [31:0] u5_data0;
wire [31:0] u5_PC;
wire [31:0] u5_data2;
wire [31:0] u5_data3;
wire [31:0] u5_data4;
wire [31:0] u5_data5;
wire [31:0] u5_data6;
wire [7:0] u5_point_out;
wire [7:0] u5_LE_out;
wire [31:0] u5_Disp_num;

//**********************************U6*****************************
wire u6_Start;
wire u6_SW0;
wire u6_flash;
wire [31:0] u6_Hexs;
wire [7:0] u6_point;
wire [7:0] u6_LES;


//************************U7***************************
wire u7_EN;
wire [31:0] u7_P_Data;
wire u7_Start;
wire [1:0] u7_counter_set;
wire [15:0] u7_led_out;
wire [13:0] u7_GPIOf0;


//************************U8**************************
wire u8_SW2;
wire [31:0] u8_clkdiv;
wire  u8_Clk_CPU;

//*************************U9*************************
wire u9_readn;
wire [3:0] u9_Key_y;
wire [4:0] u9_Key_x;
wire [4:0] u9_Key_out;
wire u9_Keyready;
wire [3:0] u9_BTN_OK;
wire [3:0] u9_pulse;
wire [15:0] u9_SW_OK;

//***********************U10*****************************
wire u10_clk0; //clk_div[7]，来自U8
wire u10_clk1; // clk_div[10]，来自U8
wire u10_clk2; //clk_div[10]，来自U8
wire u10_counter_we; //计数器写控制，来自U4
wire [31:0] u10_counter_val; //计数器输入数据，来自U4
wire [1:0] u10_counter_ch;//计数器通道控制，来自U7
wire u10_counter0_OUT;//输出到U4
wire u10_counter1_OUT; //输出到U4
wire u10_counter2_OUT; //输出到U4
wire [31:0] u10_counter_out; //输出到U4
//**********************m4********************************
wire[2:0] M4_BTN;				//对应SAnti_jitter列按键
wire [4:0] M4_Ctrl;			//{SW[7:5],SW[15],SW[0]}
wire M4_D_ready;				//对应SAnti_jitter扫描码有效
wire [4:0]M4_Din;		//=0读扫描码
wire [31:0]M4_Ai=32'h87654321;	//输出32位数一：Ai
wire [31:0]M4_Bi=32'h12345678;	//输出32位数二：Bi
wire [7:0 ]M4_blink;

//***************************assign process ************************
//***************************u1output*******************************
assign u4_mem_w_in=u1_mem_w_output;
assign u4_addrbus_in=u1_addr_out;
assign u4_Cpu_data2bus=u1_data_out;
assign u5_PC=u1_pc_out;
assign u5_data2=u1_instruction;
assign u5_data4=u1_addr_out;
assign u5_data5=u1_data_out;
assign u5_data6=u1_data_in;
//**************************u2output*******************************
//**************************u3output********************************
assign u4_ram_data_out=u3_ram_data_out;

//**************************u4output********************************
assign u1_data_in=u4_Cpu_data4bus;
assign u3_ram_data_in=u4_ram_data_in;
assign u3_ram_addr=u4_ram_addr;
assign u3_data_ram_we=u4_data_ram_we;
assign u7_EN=u4_GPIOf0000000_we;
assign u10_counter_we=u4_counter_we;
assign u5_data0=u4_Peripheral_in;
assign u7_P_Data=u4_Peripheral_in;
assign u10_counter_val=u4_Peripheral_in;
assign u5_data3=u4_counter_out;
//************************u5output***********************************
assign u6_point=u5_point_out;
assign u6_LES=u5_LE_out;
assign u6_Hexs=u5_Disp_num;

//***********************u6output************************************

//**********************u7output*************************************
assign u10_counter_ch=u7_counter_set;
assign u4_led_out=u7_led_out;


//*********************u8output**************************************
assign u10_clk0=u8_clkdiv[6];
assign u10_clk1=u8_clkdiv[9];
assign u10_clk2=u8_clkdiv[11];
assign u6_Start=u8_clkdiv[20];
assign u6_flash=u8_clkdiv[25];
assign u7_Start=u8_clkdiv[20];
//********************u9output***************************************
//key_x......
assign RDY=u9_Keyready;
assign u4_BTN_in=u9_BTN_OK;
assign M4_BTN=u9_BTN_OK[2:0];
assign M4_Ctrl={u9_SW[7:5],u9_SW[15],u9_SW[0]};
assign M4_D_ready=u9_Keyready;
assign M4_Din=u9_Key_out;

assign u4_SW_in=u9_SW_OK;//u5的test为什么只有三位
assign u6_SW0=u9_SW_OK[0];
assign u8_SW2=u9_SW_OK[2];
//CR
//********************u10output**************************************
assign u1_INT_in=u10_counter0_OUT;
assign u4_counter0_out=u10_counter0_OUT;
assign u4_counter1_out=u10_counter1_OUT;
assign u4_counter2_out=u10_counter2_OUT;
assign u4_counter_out=u10_counter_out;
//********************M4output**************************************
assign u9_readn=M4_readn;

PCPU U1(.clk(u8_Clk_CPU),			
		.rst(reset),
		//.MIO_ready(u1_MIO_ready),
		.Ins(u1_instruction),
		.Data_in(u1_data_in),	
	    .Pc(u1_pc_out),
        .Data_out(u1_data_out), 
		.Addr_out(u1_addr_out),
        .mem_w(u1_mem_w_output)
		//.CPU_MIO()
);

ROM_D U2(.a(u1_pc_out[11:2]),
	     .spo (u1_instruction)); 
RAM_B U3 (.clka(~clk), // 存储器时钟，与CPU反向
          .wea(u3_data_ram_we), // 存储器读写，来自MIO_BUS
          .addra(u3_ram_addr), // 地址线，来自MIO_BUS
          .dina(u3_ram_data_in), // 输入数据线，来自MIO_BUS
          .douta(u3_ram_data_out) // 输出数据线，来自MIO_BUS
);
MIO_BUS U4( .clk(clk),
			.rst(reset),
			.BTN(u4_BTN_in),
			.SW(u4_SW_in),
			.mem_w(u4_mem_w_in),
			.Cpu_data2bus(u4_Cpu_data2bus),				//data from CPU
			.addr_bus(u4_addrbus_in),
			.ram_data_out(u4_ram_data_out),
			.led_out(u4_led_out),
			.counter_out(u4_counter_out),
			.counter0_out(u4_counter0_out),
			.counter1_out(u4_counter1_out),
			.counter2_out(u4_counter2_out),
			.Cpu_data4bus(u4_Cpu_data4bus),			//write to CPU
			.ram_data_in(u4_ram_data_in),				//from CPU write to Memory
			.ram_addr(u4_ram_addr),						//Memory Address signals
			.data_ram_we(u4_data_ram_we),
			.GPIOf0000000_we(u4_GPIOf0000000_we),
			.GPIOe0000000_we(u4_GPIOe0000000_we),
			.counter_we(u4_counter_we),
			.Peripheral_in(u4_Peripheral_in)
			);

Multi_8CH32 U5( .clk(~u8_Clk_CPU), 
                .rst(reset), 
                .EN(u4_GPIOe0000000_we), //来自U4
                .point_in({u8_clkdiv[31:0],u8_clkdiv[31:0]}), //外部输入
                .LES(64'b0), //外部输入
                .Test(u9_SW_OK[7:5]), //来自U9
                .Data0(u5_data0), //来自U4
                .data1({2'b00,u5_PC[31:2]}), //来自U1
                .data2(u5_data2), //来自CPU
                .data3(u5_data3), //来自U10
                .data4(u5_data4), //来自CPU
                .data5(u5_data5), //来自CPU
                .data6(u5_data6), //送CPU，来自U4
                .data7(u5_PC), //来自CPU
                .point_out(u5_point_out), //输出到U6
                .LE_out(u5_LE_out), //输出到U6
                .Disp_num(u5_Disp_num) //输出到U6
);
SSeg7_Dev U6(.clk(clk), //时钟
          .rst(reset), //复位
          .Start(u6_Start), //串行扫描启动
          .SW0(u6_SW0), //文本(16进制)/图型(点阵)切换
          .flash(u6_flash), //七段码闪烁频率
          .Hexs(u6_Hexs), //32位待显示输入数据
          .point(u6_point), //七段码小数点：8个
          .LES(u6_LES), //七段码使能：=1时闪烁
          .seg_clk(u6_seg_clk), //串行移位时钟
          .seg_sout(u6_seg_sout), //七段显示数据(串行输出)
          .SEG_PEN(u6_SEG_PEN), //七段码显示刷新使能
          .seg_clrn(u6_seg_clrn) //七段码显示归零
 );

SPIO U7 (.clk(~u8_Clk_CPU), //io_clk，与CPU反向
         .rst(reset),
         .EN(u7_EN), //来自U4
         .P_Data(u7_P_Data), //来自U4
         .Start(u7_Start), //串行输出启动
         .counter_set(u7_counter_set), //来自U7，后继用
         .LED_out(u7_led_out), //输出到LED,回读到U4
         .GPIOf0(u7_GPIOf0), //备用
         .led_clk(u7_led_clk), //串行时钟
         .led_sout(u7_led_sout), //串行LEDE值
         .LED_PEN(u7_LED_PEN), //LED使能
         .led_clrn(u7_led_clrn) //LED清零
);
clk_div U8(.clk(clk),
           .rst(reset),
           .SW2(u8_SW2),
           .clkdiv(u8_clkdiv),
           .Clk_CPU(u8_Clk_CPU)
);
SAnti_jitter U9(.clk(clk), //主板时钟
                .RSTN(u9_RSTN),
                .readn(u9_readn), //阵列式键盘读
                .Key_y(BTN_y), //阵列式键盘列输入
                .Key_x(BTN_x), //阵列式键盘行输出
                .Key_out(u9_Key_out),//阵列式键盘扫描码
                .Key_ready(u9_Keyready), //阵列式键盘有效
                .SW(u9_SW), //开关输入
                .BTN_OK(u9_BTN_OK),//列按键输出
                .pulse_out(u9_pulse), //列按键脉冲输出
                .SW_OK(u9_SW_OK), //开关输出
                .CR(u9_CR), //RSTN短按输出
                .rst(reset)
);
Counter_x U10(.clk(~u8_Clk_CPU), //io_clk
              .rst(reset),
              .clk0(u10_clk0), //clk_div[7]，来自U8
              .clk1(u10_clk1), // clk_div[10]，来自U8
              .clk2(u10_clk2), //clk_div[10]，来自U8
              .counter_we(u10_counter_we), //计数器写控制，来自U4
              .counter_val(u10_counter_val), //计数器输入数据，来自U4
              .counter_ch(u10_counter_ch), //计数器通道控制，来自U7
              .counter0_OUT(u10_counter0_OUT), //输出到U4
              .counter1_OUT(u10_counter1_OUT), //输出到U4
              .counter2_OUT(u10_counter2_OUT), //输出到U4
              .counter_out(u10_counter_out) //输出到U4
 );


SEnter_2_32 M4( .clk(clk),
                .BTN(M4_BTN),				//对应SAnti_jitter列按键
				.Ctrl(M4_Ctrl),				//{SW[7:5],SW[15],SW[0]}
				.D_ready(M4_D_ready),					//对应SAnti_jitter扫描码有效
				.Din(M4_Din),
				.readn(M4_readn), 			//=0读扫描码
				.Ai(M4_Ai),	//输出32位数一：Ai
				.Bi(M4_Bi),	//输出32位数二：Bi
				.blink(M4_blink)
);
endmodule
