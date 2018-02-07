module add #(
    parameter DATA_WIDTH = 32
)(
    input [DATA_WIDTH-1:0] input1,
    input [DATA_WIDTH-1:0] input2,
    output [DATA_WIDTH:0] dataOut
);
        assign dataOut = input1 + input2;

endmodule

//comment
