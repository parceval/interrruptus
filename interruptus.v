`define IO_ADDR0  19'h0018
`define IO_ADDR1  19'h0019
`define IO_ADDR2  19'h001A
`define IO_ADDR3  19'h001B
`define IO_ADDR_CONTROL  19'h001C 

module interruptus (
    input wire gclk1,
    input wire resetn,
    input wire [19:0] A,
    inout wire [7:0] d,
    input wire iorqn,
    input wire m1n,
    input wire intan,
    input wire rdn,
    input wire wrn,
    output wire led_r,
    output wire led_o,
    output wire led_g
    );

    wire io_noint;
    wire oe;

    reg [31:0] timer;
    reg [23:0] shadow;
    reg [7:0] control;

    always @(posedge !wrn)
    begin
      case(A)
      `IO_ADDR_CONTROL:
        control <= d;
    endcase
    end

    always @*
    begin
      case(A)
      `IO_ADDR0:
        shadow <= timer[23:0];
      endcase
    end

    always @(posedge gclk1)
    begin
        timer <= timer + 1;
    end

    assign io_noint = iorqn && intan;
    assign oe = io_noint && !rdn;

    assign d = oe && (A==`IO_ADDR0)? timer[31:24] : 8'hz;
    assign d = oe && (A==`IO_ADDR1)? shadow[23:16] : 8'hz;
    assign d = oe && (A==`IO_ADDR2)? shadow[15:8] : 8'hz;
    assign d = oe && (A==`IO_ADDR3)? shadow[7:0] : 8'hz;
    assign led_g = 1'b1;
    assign led_r = 1'b1;
    assign led_o = 1'b1;


endmodule

// Pin assignment
//PIN: CHIP "interruptus" ASSIGNED TO PLCC84
//PIN: led_r : 45
//PIN: led_o : 12
//PIN: led_g : 81
//PIN: irq0n : 15
//PIN: irq1n : 16
//PIN: irq2n : 17
//PIN: irq3n : 18
//PIN: irq4n : 20
//PIN: irq5n : 21
//PIN: irq6n : 22
//PIN: irq7n : 24
//PIN: m1n : 25
//PIN: wrn : 28
//PIN: rdn : 29
//PIN: intan : 30
//PIN: dreqn : 31
//PIN: iorqn : 34
//PIN: ds0n : 46
//PIN: ds1n : 48
//PIN: sxtakn : 40
//PIN: sxtrqn : 41
//PIN: resoutn : 33
//PIN: resetn : 35
//PIN: gclk1 : 83
//PIN: gclk2 : 2

//PIN: gclrn : 1

//PIN: a_0 : 74
//PIN: a_1 : 73
//PIN: a_2 : 70
//PIN: a_3 : 69
//PIN: a_4 : 68
//PIN: a_5 : 67
//PIN: a_6 : 65
//PIN: a_7 : 64
//PIN: a_8 : 63
//PIN: a_9 : 61
//PIN: a_10 : 60
//PIN: a_11 : 58
//PIN: a_12 : 57
//PIN: a_13 : 56
//PIN: a_14 : 55
//PIN: a_15 : 54
//PIN: a_16 : 52
//PIN: a_17 : 51
//PIN: a_18 : 50
//PIN: a_19 : 49

//PIN: d_0 : 75
//PIN: d_1 : 76
//PIN: d_2 : 77
//PIN: d_3 : 79
//PIN: d_4 : 80
//PIN: d_5 : 4
//PIN: d_6 : 5
//PIN: d_7 : 6
//PIN: d_8 : 8
//PIN: d_9 : 9
//PIN: d_10 : 10
//PIN: d_11 : 11
//PIN: d_12 : 44
//PIN: d_13 : 36
//PIN: d_14 : 37
//PIN: d_15 : 39
