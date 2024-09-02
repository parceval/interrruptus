`timescale 1ns/1ns
`include "interruptus.v"
`define IO_ADDR0  16'h0018
`define IO_ADDR1  16'h0019
`define IO_ADDR2  16'h001A
`define IO_ADDR3  16'h001B
`define IO_ADDR_CONTROL  16'h001C

module interruptus_tb;

reg gclk1=1'b0;
reg resetn=1'b0;
reg [19:0] A=16'h0;

wire[7:0] d;
reg[7:0] d_drive;
wire[7:0] d_recv;
assign d = d_drive;
assign d_recv = d;

reg iorqn=1'b0;
reg m1n=1'b0;
reg intan=1'b0;
reg rdn=1'b0;
reg wrn=1'b1;
wire led_r;
wire led_o;
wire led_g;

interruptus uut (gclk1,resetn,A,d,iorqn,m1n,intan,rdn,wrn,led_r,led_o,led_g);


always begin
    gclk1 = ~gclk1;
    #1;
end

initial begin
    $dumpfile("interruptus_tb.vcd");
    $dumpvars(0, interruptus_tb);
    $dumpvars(1, uut);
    // {rst_n,b_m1_n,nmi_n,read_n,write_n,int_ack_n} = 6'b111111;
    // $monitor($time, " b_irq_n input = %0d int_n = %0b, interrupt priority ",b_irq_n,int_n);
    $monitor($time,"\ttimer: %0h\tshadow:%0h \tA:%0h \td:%0h \toe:%h",uut.timer, uut.shadow, A,d,uut.oe);
    uut.timer=32'h112233aa;
    uut.shadow=24'h0;
    d_drive=8'hz;
    
    #10;
    resetn=1'b1;
    #10;

    A=`IO_ADDR0;
    rdn=1'b0;
    m1n=1'b0;
    iorqn=1'b1;
    intan=1'b1;
    #10

    A=`IO_ADDR1;
    rdn=1'b0;
    m1n=1'b0;
    iorqn=1'b1;
    intan=1'b1;
    #10

    A=`IO_ADDR2;
    rdn=1'b0;
    m1n=1'b0;
    iorqn=1'b1;
    intan=1'b1;
    #10

    A=`IO_ADDR3;
    rdn=1'b0;
    m1n=1'b0;
    iorqn=1'b1;
    intan=1'b1;
    #10

    A=`IO_ADDR0;
    rdn=1'b0;
    m1n=1'b0;
    iorqn=1'b1;
    intan=1'b1;
    #40
    A=16'h1000;
    rdn=1'b1;
    #10

    A=`IO_ADDR_CONTROL;
    rdn=1'b1;
    wrn=1'b0;
    m1n=1'b0;
    iorqn=1'b1;
    intan=1'b1;
    d_drive=8'h5f;
    #10

    d_drive=8'hz;
    A=`IO_ADDR0;
    wrn=1'b1;
    rdn=1'b0;
    m1n=1'b0;
    iorqn=1'b1;
    intan=1'b1;
    #10
    A=16'h1000;
    rdn=1'b1;
    #10

    A=`IO_ADDR3;
    rdn=1'b0;
    m1n=1'b0;
    iorqn=1'b1;
    intan=1'b1;
    #10


    $finish;
end
endmodule