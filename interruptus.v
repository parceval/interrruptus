module interruptus (rst_n,clk,data_bus,addr_bus,b_irq_n,b_m1_n,nmi_n,read_n,write_n,int_ack_n,int_n,b_nmi_n);
    `define START_ADDRESS    14'h2000
    `define TIMER_ADDRESS_LO (`START_ADDRESS + 14'd2)
    `define TIMER_ADDRESS_HI (`START_ADDRESS + 14'd4)
    `define TIMER_MAX 32'h100

    // parameter ADDRESS_BIT_WIDTH = 14;
    //! Asynchronous active low reset
    input wire rst_n;
    //! Clock signal
    input wire clk;
    output reg [15:0] data_bus;
    input wire [13:0] addr_bus;
    input wire [7:0] b_irq_n;
    input wire b_m1_n;
    input wire nmi_n;

    input wire read_n;
    input wire write_n;
    input wire int_ack_n;
    output reg int_n;
    output wire b_nmi_n;
    
    reg [3:0] interrupt_priority; // 0 lowest, 7 highest
    reg [31:0] timer;
    reg timer_interrupt_pending;

  integer I;
  

  always @(posedge clk)
    begin
      data_bus <= 16'bz;

      if (~rst_n)
        begin
          timer <= 0;
          timer_interrupt_pending <=0;
        end
      else
        begin
          timer<= timer + 1;
        end

      interrupt_priority=0;
      int_n=1;
      for (I=0; I< 8 ; I=I+1) 
        if (~b_irq_n[I])
          begin
            interrupt_priority=I;
            int_n=0;
          end
          
      if (timer_interrupt_pending & int_n) begin
        int_n <= 0;
        interrupt_priority <= 0;
        timer_interrupt_pending <= 0;
      end 

      if (timer == `TIMER_MAX) begin
        timer <=0;
        timer_interrupt_pending <= 1'b1;
      end

      if (~int_ack_n)
        begin
          data_bus <= interrupt_priority;
          int_n <= 1'b1;
        end

      if (~read_n & (addr_bus[13:0] == `START_ADDRESS))
        begin
          data_bus <= interrupt_priority;
        end
      else if (~read_n & (addr_bus[13:0] == `TIMER_ADDRESS_LO))
        begin
          data_bus <= timer[15:0];
        end
      else if (~read_n & (addr_bus[13:0] == `TIMER_ADDRESS_HI))
        begin
          data_bus <= timer[31:16];
        end

    end

   assign b_nmi_n = 1'b1;
  

endmodule