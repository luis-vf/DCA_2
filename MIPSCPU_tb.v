`timescale 1 ps / 1 ps
module MIPSCPU_tb();

`define DELAY(TIME_CLK) #(10*TIME_CLK);


parameter DATA_WIDTH = 32;
parameter RD_DEPTH = 2;
parameter REG_DEPTH = 32;
parameter ADDR_WIDTH = 6;  //address width; for the MIPS the operands are addresses; so operand
parameter DELAY = 0;
parameter DATA_WIDTH_IN = 16;
parameter DATA_WIDTH_OUT = 32;
parameter CTRL_WIDTH = 5;
parameter STATUS_WIDTH = 4;
parameter SHAMT_WIDTH = 5;

reg clk = 0;
reg simState;
reg rst2;
reg en;
reg rst;
reg [DATA_WIDTH-1:0]datamem_out;


always begin
    `DELAY(1/2)
    clk = ~clk;
end

initial begin
    en = 1'b1;
    rst = 1'b1;
    rst2 = 1'b1;
    `DELAY(5)
    rst2 = 1'b0;
    `DELAY(5)
    rst = 1'b0;
    `DELAY(1)
    $monitor("Data out: %h",datamem_out);
    `DELAY(100)
    $stop;
end


MIPSCPU #(
    .DATA_WIDTH(DATA_WIDTH),
    .RD_DEPTH(RD_DEPTH),
    .REG_DEPTH(REG_DEPTH),
    .ADDR_WIDTH(ADDR_WIDTH),
    .DELAY(DELAY),
    .DATA_WIDTH_IN(DATA_WIDTH_IN),
    .DATA_WIDTH_OUT(DATA_WIDTH_OUT),
    .CTRL_WIDTH(CTRL_WIDTH),
    .STATUS_WIDTH(STATUS_WIDTH),
    .SHAMT_WIDTH(SHAMT_WIDTH)
    )UUT(
    .clk(clk),
    .rst(rst),
    .rst2(rst2),
    .en(en)
);

endmodule;
