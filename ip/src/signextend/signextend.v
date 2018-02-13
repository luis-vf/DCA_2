module signextend #(
        parameter DATA_WIDTH_IN = 16,
        parameter DEPTH = 2,
        parameter DATA_WIDTH_OUT = 32,
        parameter DELAY = 0
)(
    input clk,
    input rst,
    input en_n,
    input IsSigned,
    input [DATA_WIDTH_IN*DEPTH-1:0]dataIn,
    output  [DATA_WIDTH_OUT*DEPTH-1:0]dataOut
);
/**********
 *  Array Packing Defines
 **********/
//These are preprocessor defines similar to C/C++ preprocessor or VHDL functions
`define PACK_ARRAY(PK_WIDTH,PK_DEPTH,PK_SRC,PK_DEST, BLOCK_ID, GEN_VAR)    genvar GEN_VAR; generate for (GEN_VAR=0; GEN_VAR<(PK_DEPTH); GEN_VAR=GEN_VAR+1) begin: BLOCK_ID assign PK_DEST[((PK_WIDTH)*GEN_VAR+((PK_WIDTH)-1)):((PK_WIDTH)*GEN_VAR)] = PK_SRC[GEN_VAR][((PK_WIDTH)-1):0]; end endgenerate
`define UNPACK_ARRAY(PK_WIDTH,PK_DEPTH,PK_DEST,PK_SRC, BLOCK_ID, GEN_VAR)  genvar GEN_VAR; generate for (GEN_VAR=0; GEN_VAR<(PK_DEPTH); GEN_VAR=GEN_VAR+1) begin: BLOCK_ID assign PK_DEST[GEN_VAR][((PK_WIDTH)-1):0] = PK_SRC[((PK_WIDTH)*GEN_VAR+(PK_WIDTH-1)):((PK_WIDTH)*GEN_VAR)]; end endgenerate

wire [DATA_WIDTH_IN-1:0] tmp [DEPTH-1:0];
reg [DATA_WIDTH_OUT-1:0] extend [DEPTH-1:0];
wire [DATA_WIDTH_OUT*DEPTH-1:0] tmpOut;
wire [DATA_WIDTH_OUT*DEPTH-1:0] trueOut;

`UNPACK_ARRAY(DATA_WIDTH_IN,DEPTH,tmp,dataIn, U_BLK_0, idx_0)

integer i = 0;
always @ (dataIn) begin
    for(i = 0;i < DEPTH;i = i + 1)
    begin
        extend[i][DATA_WIDTH_IN-1:0] <= tmp[i][DATA_WIDTH_IN-1:0];
        if(isSigned == 1'b1) begin
          extend[i][DATA_WIDTH_OUT-1:DATA_WIDTH_IN] <= {(DATA_WIDTH_OUT - DATA_WIDTH_IN){tmp[i][DATA_WIDTH_IN-1]}};
        end
        else begin
          extend[i][DATA_WIDTH_OUT-1:DATA_WIDTH_IN] <= {(DATA_WIDTH_OUT - DATA_WIDTH_IN){1'b0}};
        end
    end

end
`PACK_ARRAY(DATA_WIDTH_OUT,DEPTH,extend,tmpOut, U_BLK_1, idx_1)

delay #(
     .BIT_WIDTH(DATA_WIDTH_OUT*DEPTH),
     .DELAY(DELAY)
 )U_DELAY(
     .clk(clk),
     .rst(rst),
     .en_n(en_n),
     .dataIn(tmpOut),
     .dataOut(trueOut)
 );

assign dataOut = trueOut;

endmodule // signextend
