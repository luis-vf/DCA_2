

module counter #(
	parameter DATA_WIDTH = 4,
    parameter COUNT_START = 0,
    parameter COUNT_END = 2**(DATA_WIDTH-1),
    parameter STEP = 1
)(
	input clk,
	input rst,
	input en,
    input load,
	input [DATA_WIDTH - 1:0] loadval,
	output [DATA_WIDTH - 1:0] dataOut
);
    reg [DATA_WIDTH - 1:0]tmp = 0;

    always @(posedge clk) begin
        if(rst == 1'b1) begin
            tmp <= COUNT_START;
        end
        else begin
            if(load == 1'b1) begin
                tmp <= loadval;
            end
            else if(en == 1'b1) begin
                tmp <= tmp + STEP;
            end
            else begin
                tmp <= tmp;
            end
        end
    end

    assign dataOut = tmp;

endmodule
