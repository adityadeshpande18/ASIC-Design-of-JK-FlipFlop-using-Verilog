UART Receiver (UART_RX)
UART (Universal Asynchronous Receiver Transmitter) is a serial communication protocol widely used for data transmission between digital devices. The UART receiver module is designed to receive serial data transmitted at a specific baud rate and convert it into parallel data format.

1) Design code of UART Receiver

RTL Design Code:
module UART_RX
  #(parameter CLKS_PER_BIT = 217)
  (
   input        clk,
   input        rx,
   output       rx_valid,
   output [7:0] rx_data
   );

  parameter STATE_IDLE     = 3'b000;
  parameter STATE_START    = 3'b001;
  parameter STATE_DATA     = 3'b010;
  parameter STATE_STOP     = 3'b011;
  parameter STATE_CLEANUP  = 3'b100;

  reg [7:0]  baud_cnt     = 0;
  reg [2:0]  bit_cnt      = 0;
  reg [7:0]  rx_shift_reg = 0;
  reg        rx_valid_reg = 0;
  reg [2:0]  state        = 0;


  always @(posedge clk) begin
    case (state)
      STATE_IDLE: begin
        rx_valid_reg <= 1'b0;
        baud_cnt     <= 0;
        bit_cnt      <= 0;
        if (rx == 1'b0)
          state <= STATE_START;
        else
          state <= STATE_IDLE;
      end

      STATE_START: begin
        if (baud_cnt == (CLKS_PER_BIT-1)/2) begin
          if (rx == 1'b0) begin
            baud_cnt <= 0;
            state    <= STATE_DATA;
          end else
            state <= STATE_IDLE;
        end else begin
          baud_cnt <= baud_cnt + 1;
          state    <= STATE_START;
        end
      end

      STATE_DATA: begin
        if (baud_cnt < CLKS_PER_BIT-1) begin
          baud_cnt <= baud_cnt + 1;
          state    <= STATE_DATA;
        end else begin
          baud_cnt             <= 0;
          rx_shift_reg[bit_cnt] <= rx;
          if (bit_cnt < 7) begin
            bit_cnt <= bit_cnt + 1;
            state   <= STATE_DATA;
          end else begin
            bit_cnt <= 0;
            state   <= STATE_STOP;
          end
        end
      end

      STATE_STOP: begin
        if (baud_cnt < CLKS_PER_BIT-1) begin
          baud_cnt <= baud_cnt + 1;
          state    <= STATE_STOP;
        end else begin
          rx_valid_reg <= 1'b1;
          baud_cnt     <= 0;
          state        <= STATE_CLEANUP;
        end
      end

      STATE_CLEANUP: begin
        rx_valid_reg <= 1'b0;
        state        <= STATE_IDLE;
      end

      default: state <= STATE_IDLE;
    endcase
  end
  assign rx_valid = rx_valid_reg;
  assign rx_data  = rx_shift_reg;
endmodule

2.2: Save the file using command: :wq!

Step 3: Create Testbench File

3.1: Open gvim editor for testbench with command: gvim uart_tb.v

Testbench:
`timescale 1ns/10ps
module uart_tb;
  parameter CLOCK_PERIOD_NS = 40;
  parameter CLKS_PER_BIT    = 217;
  parameter BIT_PERIOD      = 8600;

  reg clk = 0;
  reg rx  = 1;
  wire [7:0] rx_data;

  task UART_WRITE_BYTE;
    input [7:0] data_in;
    integer bit_idx;
    begin
      rx <= 1'b0;
      #(BIT_PERIOD);
      #1000;
      for (bit_idx = 0; bit_idx < 8; bit_idx = bit_idx + 1) begin
        rx <= data_in[bit_idx];
        #(BIT_PERIOD);
      end
      rx <= 1'b1;
      #(BIT_PERIOD);
    end
  endtask

  UART_RX #(.CLKS_PER_BIT(CLKS_PER_BIT)) UART_RX_INST (
    .clk(clk),
    .rx(rx),
    .rx_valid(),
    .rx_data(rx_data)
  );

  always #(CLOCK_PERIOD_NS/2) clk <= !clk;

  initial begin
    @(posedge clk);
    UART_WRITE_BYTE(8'hAA);
    @(posedge clk);
    if (rx_data == 8'hAA)
      $display("Test Passed - Correct Byte Received");
    else
      $display("Test Failed - Incorrect Byte Received");
    $finish();
  end

  initial begin
    $dumpfile("dump.vcd");
    $dumpvars();
  end

endmodule

3.2: Save the testbench file using command: :wq!
3.3: Check the saved file in current directory: use command ls

Step 4: Simulate the Design with Verilator
4.1: Use the following command to simulate:
verilator --binary -j 0 -Wall UART_RX.v uart_tb.v --top uart_tb --timing --CFLAGS "-std=c++20" --trace
4.2: If any error is available, resolve it.
4.3: After simulation, a new directory obj_dir will be created. Check with ls.
4.4: Open obj_dir: cd obj_dir
4.5: Use command make -f Vuart_tb.mk Vuart_tb
4.6: A new executable named Vuart_tb will be created
4.7: Use command ./Vuart_tb to run simulation
4.8: Check output in terminal