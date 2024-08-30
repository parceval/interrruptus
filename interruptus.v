module interruptus (
    input gclk1,
    input resetn,
    input [15:0] A,
    input [7:0] d,
    input iorqn,
    input m1n,
    input intan,
    input rdn,
    output reg led_r,
    output reg led_o,
    output reg led_g
    );

    parameter IO_ADDR = 16'h0018;

    wire io18 = A[4];
    wire io_noint = !iorqn && intan;
    wire oe = io18 && io_noint && !rdn;

    reg [31:0] timer;

    always @(negedge rdn, negedge resetn) begin
      if (!resetn) begin
         led <= 1'b0;
      end else begin
        if (io18)
        begin
            led <= 1'b1;
        end
      end
    end

    always @(posedge gclk1)
    begin
        timer <= timer + 1;
    end

    assign led_r = A[4];
    assign led_o = led_r && io_noint;
    assign led_g = led_o && !rdn && io18;
endmodule

// Pin assignment
//PIN: CHIP "interruptus" ASSIGNED TO AN PLCC84
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
