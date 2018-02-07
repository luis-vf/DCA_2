module signextend_tb();

parameter DATA_WIDTH_IN = 4;
parameter DEPTH = 2;
parameter DATA_WIDTH_OUT = 8;
parameter DELAY = 1;


`define DELAY(TIME_CLK) #(10*TIME_CLK);

reg clk = 0;
reg rst;
reg en_n;

reg simState = 0;
reg [DATA_WIDTH_IN*DEPTH-1:0]dataIn;
wire [DATA_WIDTH_OUT*DEPTH-1:0]dataOut;

always begin
    if (simState != 1) begin
      `DELAY(1/2)
      clk = ~clk;
    end
end

initial begin
    rst <= 1'b1;
    rst <= 1'b0;
    en_n<= 1'b0;
    $monitor("Data In is: %h    Data Out is: %h ",dataIn,dataOut);
    dataIn <= 8'ha5;
    `DELAY(5)
    simState <= 1'b1;
    $stop;
end

signextend #(
    .DATA_WIDTH_IN(DATA_WIDTH_IN),
    .DEPTH(DEPTH),
    .DATA_WIDTH_OUT(DATA_WIDTH_OUT),
    .DELAY(DELAY)
    )UUT(
    .clk(clk),
    .rst(rst),
    .en_n(en_n),
    .dataIn(dataIn),
    .dataOut(dataOut)
);

endmodule // signextend_tb
