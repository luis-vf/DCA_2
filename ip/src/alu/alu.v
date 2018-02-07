
module alu #(
    parameter DATA_WIDTH = 32,
    parameter CTRL_WIDTH = 4,
    parameter STATUS_WIDTH = 4,
    parameter SHAMT_WIDTH = 5,
    parameter DELAY = 0
)(
    input clk,
    input en_n,
    input rst,
    input [DATA_WIDTH*2-1:0] dataIn,
    input [CTRL_WIDTH-1:0] ctrl,
    input [SHAMT_WIDTH-1:0] shamt,
    output [DATA_WIDTH-1:0] dataOut,
    output [STATUS_WIDTH-1:0] status
);
//status[0] = zero
//status[1] = signed
//status[2] = carry
//status[3] = overflow
/**********
 *  Array Packing Defines
 **********/
//These are preprocessor defines similar to C/C++ preprocessor or VHDL functions
`define PACK_ARRAY(PK_WIDTH,PK_DEPTH,PK_SRC,PK_DEST, BLOCK_ID, GEN_VAR)    genvar GEN_VAR; generate for (GEN_VAR=0; GEN_VAR<(PK_DEPTH); GEN_VAR=GEN_VAR+1) begin: BLOCK_ID assign PK_DEST[((PK_WIDTH)*GEN_VAR+((PK_WIDTH)-1)):((PK_WIDTH)*GEN_VAR)] = PK_SRC[GEN_VAR][((PK_WIDTH)-1):0]; end endgenerate
`define UNPACK_ARRAY(PK_WIDTH,PK_DEPTH,PK_DEST,PK_SRC, BLOCK_ID, GEN_VAR)  genvar GEN_VAR; generate for (GEN_VAR=0; GEN_VAR<(PK_DEPTH); GEN_VAR=GEN_VAR+1) begin: BLOCK_ID assign PK_DEST[GEN_VAR][((PK_WIDTH)-1):0] = PK_SRC[((PK_WIDTH)*GEN_VAR+(PK_WIDTH-1)):((PK_WIDTH)*GEN_VAR)]; end endgenerate


/**********
 * Internal Signals
**********/
    wire [DATA_WIDTH -1:0]data[1:0];

    wire [DATA_WIDTH -1:0]delay_dataOut;
    wire [DATA_WIDTH -1:0]delay_hi;
    wire [DATA_WIDTH -1:0]delay_lo;
    wire [STATUS_WIDTH -1:0]delay_status;


    wire [DATA_WIDTH:0] sub;
    wire [DATA_WIDTH:0] add;
    wire [2*DATA_WIDTH-1:0] mult;

    reg [DATA_WIDTH-1:0] hi_tmp;
    reg [DATA_WIDTH-1:0] lo_tmp;
    reg [STATUS_WIDTH -1:0]status_tmp;
    reg [DATA_WIDTH-1:0] dataOutput_tmp;
    reg carrybit;
    reg overflow;
    reg en_n_tmp;

`UNPACK_ARRAY(DATA_WIDTH,2,data,dataIn,U_BLK_0,idx_0)
/**********
 * Glue Logic
 **********/
 always@(ctrl,shamt,dataIn,add,sub,mult) begin

    status_tmp <= 4'b0;
    carrybit <= 1'b0;
    lo_tmp <= lo_tmp;
    hi_tmp <= hi_tmp;
    dataOutput_tmp <= 32'b0;

    case (ctrl)
        4'h0: dataOutput_tmp <= data[1] & data[0]; //and
        4'h1: dataOutput_tmp <= data[1] | data[0]; //or
        4'h2: dataOutput_tmp <= ~(data[1] | data[0]); //nor
        4'h3: dataOutput_tmp <= data[1] ^ data[0]; //xor
        4'h4: begin //add
              dataOutput_tmp <= add[DATA_WIDTH-1:0];
              carrybit <= add[DATA_WIDTH];
              end
        4'h5: begin//sub
              dataOutput_tmp <= sub[DATA_WIDTH-1:0];
              carrybit <= sub[DATA_WIDTH];
              end
        4'h6: begin
              dataOutput_tmp <= mult[DATA_WIDTH-1:0];
              lo_tmp <= mult[DATA_WIDTH-1:0];
              hi_tmp <= mult[2*DATA_WIDTH-1:DATA_WIDTH];
              end //mult
        4'h7: dataOutput_tmp <= ((data[1] < data[0])? 32'b1 : 32'b0); //set on less than
        4'h8: dataOutput_tmp <= data[0] >> shamt ; //shift right logical
        4'h9: dataOutput_tmp <= data[0] << shamt; //shift left logical
        4'ha: dataOutput_tmp <= $signed($signed(data[0]) >>> shamt); //shift right arithmetic
        4'hb: dataOutput_tmp <= hi_tmp; //mfhi
        4'hc: dataOutput_tmp <= lo_tmp; //mflo
        4'hd: hi_tmp <= data[0]; //mthi A
        4'he: lo_tmp <= data[0];
        4'hf: dataOutput_tmp <= data[1] >> data[0];
        /*
        4'hb: dataOutput_tmp <= ((data[0] < 0)? 32'b1 : 32'b0); //check if less than zero
        4'hc: dataOutput_tmp <= ((data[0] <= 0)? 32'b1 : 32'b0); //check if less than or equal zero
        4'hd: dataOutput_tmp <= ((data[0] >= 0)? 32'b1 : 32'b0); //check if greater than or equal zero
        4'he: dataOutput_tmp <= ((data[0] > 0)? 32'b1 : 32'b0); //check if greater than zero*/
        default: dataOutput_tmp <= 32'b0;
    endcase



 end

 always @ (dataOutput_tmp,carrybit,overflow) begin
 //sets zero flag
     if (dataOutput_tmp == 32'b0) begin
         status_tmp[0] <= 1'b1;
     end
     else begin
         status_tmp[0] <= 1'b0;
     end
     //sets signed flag
     status_tmp[1] <= dataOutput_tmp[DATA_WIDTH-1];
     //sets carry flag
     status_tmp[2] <= carrybit;

     //sets overflow flag
     overflow <= carrybit ^ dataOutput_tmp[DATA_WIDTH-1];

     if (overflow == 32'b1) begin
         status_tmp[3] <= 1;
     end
     else begin
         status_tmp[3] <= 0;
     end
 end
/**********
 * Synchronous Logic
 **********/
 always @ (posedge clk) begin
    if(rst == 1'b1)
        en_n_tmp <= 1'b1;
    else
        en_n_tmp <= en_n;
 end
/**********
 * Glue Logic
 **********/
/**********
 * Components
 **********/
 sub #(
     .DATA_WIDTH(DATA_WIDTH)
     )U_SUB(
     .input1(data[1]),
     .input2(data[0]),
     .dataOut(sub)
 );

 add #(
     .DATA_WIDTH(DATA_WIDTH)
     )U_ADD(
     .input1(data[1]),
     .input2(data[0]),
     .dataOut(add)
 );

 mult #(
     .DATA_WIDTH(DATA_WIDTH)
     )U_MULT(
     .input1(data[1]),
     .input2(data[0]),
     .dataOut(mult)
 );


 delay #(
     .BIT_WIDTH(DATA_WIDTH),
     .DELAY(DELAY)
 )U_DELAYOUT(
     .clk(clk),
     .rst(rst),
     .en_n(en_n_tmp),
     .dataIn(dataOutput_tmp),
     .dataOut(delay_dataOut)
 );

 delay #(
     .BIT_WIDTH(STATUS_WIDTH),
     .DELAY(DELAY)
 )U_DELAYSTATUS(
     .clk(clk),
     .rst(rst),
     .en_n(en_n_tmp),
     .dataIn(status_tmp),
     .dataOut(delay_status)
 );

/**********
 * Output Combinatorial Logic
 **********/

 assign dataOut = delay_dataOut;
 assign status = delay_status;

endmodule
