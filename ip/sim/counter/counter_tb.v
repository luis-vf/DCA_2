





module counter_tb();

`define DELAY(TIME_CLK) #(10*TIME_CLK);
parameter DATA_WIDTH = 4;
parameter COUNT_START = 0;
parameter COUNT_END = 2**(DATA_WIDTH-1);
parameter STEP = 1;

reg clk = 0;
reg simState = 0;
reg rst;
reg en;
reg load;
reg [DATA_WIDTH - 1:0] loadval;
wire [DATA_WIDTH - 1:0] dataOut;


always begin
    if (simState != 1) begin
      `DELAY(1/2)
      clk = ~clk;
    end
end

initial begin
    load <= 1'b0;
    rst <= 1'b1;
    rst <= 1'b0;
    en <= 1'b1;
    loadval <= 4'h4;
    `DELAY(20)
    load <= 1'b1;
    `DELAY(5)
    load <= 1'b0;
    `DELAY(20)
    simState <= 1'b1;
    $stop;
end

counter #(
    .DATA_WIDTH(DATA_WIDTH),
    .COUNT_START(COUNT_START),
    .COUNT_END(COUNT_END),
    .STEP(STEP)
    )UUT(
        .clk(clk),
        .rst(rst),
        .en(en),
        .load(load),
        .loadval(loadval),
        .dataOut(dataOut)
);

endmodule
