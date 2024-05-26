`timescale 1ns/1ns
`include "interruptus.v"
`define START_ADDRESS    14'h2000
`define TIMER_ADDRESS_LO 14'h2002
`define TIMER_ADDRESS_HI 14'h2004

module interruptus_tb;

reg rst_n=1'b1;
reg clk=1'b0;
wire [15:0] data_bus;
reg [15:0] data_bus_write;
reg [13:0] addr_bus=14'd0;
reg [7:0] b_irq_n=8'hff;
wire b_m1_n=1'b1;
wire nmi_n=1'b1;
reg read_n=1'b1;
reg write_n=1'b1;
reg int_ack_n=1'b1;
wire int_n;
wire b_nmi_n;
interruptus uut (rst_n,clk,data_bus,addr_bus,b_irq_n,b_m1_n,nmi_n,read_n,write_n,
int_ack_n,int_n,b_nmi_n);


always begin
    clk = ~clk;
    #10;
end

initial begin
    $dumpfile("interruptus_tb.vcd");
    $dumpvars(0, interruptus_tb);
    $dumpvars(1, uut);
    // {rst_n,b_m1_n,nmi_n,read_n,write_n,int_ack_n} = 6'b111111;
    $monitor($time, " b_irq_n input = %0d int_n = %0b, interrupt priority ",b_irq_n,int_n);

    rst_n=1'b0;
    #20;
    rst_n=1'b1;
    #20;
    b_irq_n[0]=1'b0;
    #20;

    // give int ack
    int_ack_n=1'b0;
    #20
    b_irq_n[0]=1'b1;
    // expect int num on data bus
    #20
    int_ack_n=1'b1;
    #40

    addr_bus=`START_ADDRESS;
    read_n=1'b0;
    #20
    read_n=1'b1;
    #20
    b_irq_n[1]=1'b0;
    #20;
    b_irq_n[2]=1'b0;
    #20;
    b_irq_n[3]=1'b0;
    #20;
    addr_bus=`START_ADDRESS;
    read_n=1'b0;
    #20;
    read_n=1'b1;
    #20
    b_irq_n[4]=1'b0;
    #20;
    b_irq_n[5]=1'b0;
    #20;
    b_irq_n[6]=1'b0;
    #20;
    b_irq_n[7]=1'b0;
    #20;
    addr_bus=`START_ADDRESS;
    read_n=1'b0;
    #20
    read_n=1'b1;

    #20;
    addr_bus=`TIMER_ADDRESS_HI;
    read_n=1'b0;
    #20
    read_n=1'b1;

    #20;
    addr_bus=`TIMER_ADDRESS_LO;
    read_n=1'b0;
    #20
    read_n=1'b1;


    $finish;
end
endmodule