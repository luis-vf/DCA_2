/*
DESCRIPTION

NOTES

TODO

*/

module mux #(
  parameter BIT_WIDTH = 8, //size of the data that goes into each mux input
  parameter DEPTH = 8,     //number of inputs for the mux
  parameter SEL_WIDTH = log2(DEPTH) //number of select lines, you can use functions in your module declarations
)(
  input [BIT_WIDTH*DEPTH -1 :0] dataIn,
  input [SEL_WIDTH - 1:0] select,
  output [BIT_WIDTH - 1:0] muxout
);
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

//array to put in inputs for the mux
wire [BIT_WIDTH -1:0] tmp [DEPTH-1:0];
//output for the mux
reg [BIT_WIDTH-1:0] tmpOut = 0;

//iterators
integer j,k,l;
/**********
 * Glue Logic
 **********/

 `UNPACK_ARRAY(BIT_WIDTH,DEPTH,tmp,dataIn,U_BLK_0,idx_0)
 always @ (select,dataIn,tmpOut) begin
 //this loop goes iterates through the number of inputs for the mux
   for(j=0;j < DEPTH; j=j+1) begin
		//if the select line corresponds to the value at the iterator, the input at that depth is pass through the output
      if(select[log2(DEPTH)-1:0] == j) begin //compares the select input but only for the max bits for a given depth
        for(k=0; k<BIT_WIDTH; k=k+1) begin //For all depth of input array
          //this selects the column/mux input line specified by the select and puts that in a register
          tmpOut[k] = tmp[j][k];
        end
      end
   end
 end
/**********
 * Synchronous Logic
 **********/
/**********
 * Glue Logic
 **********/
/**********
 * Components
 **********/
/**********
 * Output Combinatorial Logic
 **********/
generate
  assign muxout = tmpOut;
endgenerate
endmodule
