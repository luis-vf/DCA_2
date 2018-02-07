/*
DESCRIPTION

NOTES

TODO

*/

module register_file #(
  parameter DATA_WIDTH = 32, //word length
  parameter RD_DEPTH = 2, //number of parallel reads
  parameter REG_DEPTH = 32, //depth of the register file
  parameter ADDR_WIDTH = log2(REG_DEPTH),  //address width, for the MIPS the operands are addresses, so operand
  parameter DELAY = 0
)(
  input clk,
  input rst, //synchronous reset
  input wr,  //write enable
  input en_n,
  input [ADDR_WIDTH*RD_DEPTH-1:0] rr,  //reg read address as vectorized array
  input [ADDR_WIDTH-1:0] rw, //reg write address
  input [DATA_WIDTH-1:0] d, //input data to be written to reg
  output [DATA_WIDTH*RD_DEPTH-1:0] q  //output data from reg reads, vectorized array
);
//reads are always enable

/**********
 *  Array Packing Defines
 **********/
//These are preprocessor defines similar to C/C++ preprocessor or VHDL functions
`define PACK_ARRAY(PK_WIDTH,PK_DEPTH,PK_SRC,PK_DEST, BLOCK_ID, GEN_VAR)    genvar GEN_VAR; generate for (GEN_VAR=0; GEN_VAR<(PK_DEPTH); GEN_VAR=GEN_VAR+1) begin: BLOCK_ID assign PK_DEST[((PK_WIDTH)*GEN_VAR+((PK_WIDTH)-1)):((PK_WIDTH)*GEN_VAR)] = PK_SRC[GEN_VAR][((PK_WIDTH)-1):0]; end endgenerate
`define UNPACK_ARRAY(PK_WIDTH,PK_DEPTH,PK_DEST,PK_SRC, BLOCK_ID, GEN_VAR)  genvar GEN_VAR; generate for (GEN_VAR=0; GEN_VAR<(PK_DEPTH); GEN_VAR=GEN_VAR+1) begin: BLOCK_ID assign PK_DEST[GEN_VAR][((PK_WIDTH)-1):0] = PK_SRC[((PK_WIDTH)*GEN_VAR+(PK_WIDTH-1)):((PK_WIDTH)*GEN_VAR)]; end endgenerate

/**********
 * Internal Signals
**********/
function integer log2; //This is a macro function (no hardware created) which finds the log2, returns log2
   input [31:0] val; //input to the function
   integer 	i;
   begin
      log2 = 0;
      for(i = 0; 2**i < val; i = i + 1)
		log2 = i + 1;
   end
endfunction

wire [DATA_WIDTH-1:0] out [RD_DEPTH-1:0];
reg [DATA_WIDTH-1:0] register [REG_DEPTH-1:0]; //array for register file

 integer j; //iterator

wire [ADDR_WIDTH-1:0] readreg_num [RD_DEPTH-1:0]; //these are used for the select lines of the mux and input to the 'decoder'
wire [DATA_WIDTH*REG_DEPTH-1:0] register_vect; //vector that holds all the values of the registers to be fed in the 2 muxes
wire [DATA_WIDTH*RD_DEPTH-1:0] outw;
wire [DATA_WIDTH*RD_DEPTH-1:0] delay_out;

`UNPACK_ARRAY(ADDR_WIDTH,RD_DEPTH,readreg_num,rr,U_BLK_0,idx_0)
`PACK_ARRAY(DATA_WIDTH,REG_DEPTH,register,register_vect,U_BLK_1,idx_1)
/**********
 * Glue Logic
 **********/

genvar i;
generate
    for (i = 0;i < RD_DEPTH; i = i+1)
    begin :multiplexer
    mux #(
      .BIT_WIDTH(DATA_WIDTH),
      .DEPTH(REG_DEPTH),
      .SEL_WIDTH(ADDR_WIDTH)
      )u(
        .dataIn(register_vect),
        .select(readreg_num[i][ADDR_WIDTH-1:0]),
        .muxout(out[i][DATA_WIDTH-1:0])
    );

    end
endgenerate
/**********
 * Synchronous Logic
 **********/

 initial begin
   register[0][DATA_WIDTH-1:0] = 0;
 end

 always @(posedge clk) begin
  if(rst) begin
      for(j=0;j<REG_DEPTH;j=j+1) begin
        register[j][DATA_WIDTH-1:0] = 0;
      end
  end
  else begin
    if(wr) begin
      for(j=0;j<REG_DEPTH;j=j+1) begin //loops through the different registers
        if(rw == j) begin //if the select input corresponds to the iterator, write to that register
          if(j != 0) begin //this makes sure you cannot write to the 0 register
          register[j][DATA_WIDTH-1:0] <= d;
          end
        end
      end
    end
  end
 end
/**********
 * Glue Logic
 **********/
 `PACK_ARRAY(DATA_WIDTH,RD_DEPTH,out,outw,U_BLK_2,idx_2)
/**********
 * Components
 **********/
 delay #(
     .BIT_WIDTH(DATA_WIDTH),
     .DELAY(DELAY)
 )U_REG(
     .clk(clk),
     .rst(rst),
     .en_n(en_n),
     .dataIn(outw),
     .dataOut(delay_out)
 );
/**********
 * Output Combinatorial Logic
 **********/
 assign q = delay_out;

endmodule
