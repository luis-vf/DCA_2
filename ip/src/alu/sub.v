module sub #(
    parameter DATA_WIDTH = 32
)(
    input [DATA_WIDTH-1:0] input1,
    input [DATA_WIDTH-1:0] input2,
    output [DATA_WIDTH:0] dataOut
);
wire signed [DATA_WIDTH:0]input1s;
wire signed [DATA_WIDTH:0]input2s;
        assign input1s = input1;
        assign input2s = input2;
        assign  dataOut = input1s - input2s;

endmodule
