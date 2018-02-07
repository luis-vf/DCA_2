/*
DESCRIPTION
Testbench for Generic multiplexer

NOTES

TODO
*/

module alu_tb ();

`define DELAY(TIME_CLK) #(10*TIME_CLK);


/**********
 * Internal Signals
**********/
parameter DATA_WIDTH = 4;
parameter CTRL_WIDTH = 5;
parameter STATUS_WIDTH = 4;
parameter SHAMT_WIDTH = 5;
parameter DELAY = 1;

reg simState = 0;
reg clk = 0;

reg en_n;
reg rst;
reg [DATA_WIDTH*2-1:0] dataIn;
reg [CTRL_WIDTH-1:0] ctrl;
reg [SHAMT_WIDTH-1:0] shamt;
wire [DATA_WIDTH-1:0] dataOut;
wire [STATUS_WIDTH-1:0] status;


always begin
  if (simState != 1) begin
    `DELAY(1/2)
    clk = ~clk;
  end
end

initial begin
    rst <= 1'b1;
    rst <= 1'b0;
    en_n <= 1'b0;

    //7+3
    dataIn <= 8'h73;
    ctrl <= 4'h4;
    `DELAY(2)

    //7+3
    dataIn <= 8'hAA;
    ctrl <= 4'h6;
    `DELAY(2)

    //nor 5 3
    dataIn <= 8'h53;
    ctrl <= 4'h2;
    `DELAY(2)

    //mfhi
    ctrl <= 4'hb;
    `DELAY(2)

    //mflo
    ctrl <= 4'hc;
    `DELAY(2)

    //mthi
    dataIn <= 8'hAA;
    ctrl <= 4'hd;
    `DELAY(2)

    //sll 5,1
    shamt <= 1;
    dataIn <= 8'h55;
    ctrl <= 4'h9;
    `DELAY(2)

    //srl a,1
    shamt <= 1;
    dataIn <= 8'haa;
    ctrl <= 4'h8;
    `DELAY(2)

    //sra a,1
    shamt <= 1;
    dataIn <= 8'haa;
    ctrl <= 4'ha;
    `DELAY(2)



    //srlv a,2
    shamt <= 1;
    dataIn <= 8'ha2;
    ctrl <= 4'hf;
    `DELAY(2)

    //xor ff
    dataIn <= 8'hff;
    ctrl <= 4'h3;
    `DELAY(2)

    //mfhi
    dataIn <= 8'hAA;
    ctrl <= 4'hb;
    `DELAY(2)

    $stop;
    simState <= 1'b1;
    //datain [a b]
  /*  dataIn <= 64'h0FFFFFFF000FFFFF;
    `DELAY(6)
    $display("Alu opcode:%d     Input:%h    Shift:%d ",ctrl, dataIn,shamt);
    $monitor("Status bits: %h    dataOut:%h  hi:%h   lo:%h",status,dataOut,hi,lo);

    //or
    ctrl <= 4'h1;
    dataIn <= 64'h0FFFFFFF000FFFFF;
    $display("Alu opcode:%d     Input:%h    Shift:%d ",ctrl, dataIn,shamt);
    `DELAY(6)

    //nor
    ctrl <= 4'h2;
    dataIn <= 64'h0FFFFFFF000FFFFF;
    $display("Alu opcode:%d     Input:%h    Shift:%d ",ctrl, dataIn,shamt);
    `DELAY(6)

    //xor
    ctrl <= 4'h3;
    dataIn <= 64'h1000000100000001;
    $display("Alu opcode:%d     Input:%h    Shift:%d ",ctrl, dataIn,shamt);
    `DELAY(6)

    //add
    ctrl <= 4'h4;
    dataIn <= 64'hF0000001F0000001;
    $display("Alu opcode:%d     Input:%h    Shift:%d ",ctrl, dataIn,shamt);
    `DELAY(6)

    //sub
    ctrl <= 4'h5;
    dataIn <= 64'h000000090000000f;
    $display("Alu opcode:%d     Input:%h    Shift:%d ",ctrl, dataIn,shamt);
    `DELAY(6)

    //mult
    ctrl <= 4'h6;
    dataIn <= 64'h0000000600000002;
    $display("Alu opcode:%d     Input:%h    Shift:%d ",ctrl, dataIn,shamt);
    `DELAY(6)

    //set on less than
    ctrl <= 4'h7;
    dataIn <= 64'h0000000600000002;
    $display("Alu opcode:%d     Input:%h    Shift:%d ",ctrl, dataIn,shamt);
    `DELAY(6)

    //shift right logical
    shamt <= 5'h1;
    ctrl <= 4'h8;
    dataIn <= 64'h0000000CC0000001;
    $display("Alu opcode:%d     Input:%h    Shift:%d ",ctrl, dataIn,shamt);
    `DELAY(6)
    //shift left logical
    dataIn <= 64'h0000000CC0000001;
    ctrl <= 4'h9;

    $display("Alu opcode:%d     Input:%h    Shift:%d ",ctrl, dataIn,shamt);
    `DELAY(6)
    //shift right arithmetic
    dataIn <= 64'h0000000CC0000001;
    ctrl <= 4'ha;
    $display("Alu opcode:%d     Input:%h    Shift:%d ",ctrl, dataIn,shamt);
    `DELAY(6)

    //check if less than zero
    dataIn <= 64'h0000000000000000;
    ctrl <= 4'hb;
    $display("Alu opcode:%d     Input:%h    Shift:%d ",ctrl, dataIn,shamt);
    `DELAY(6)


    //check if less than or equal zero
    dataIn <= 64'h0000000000000000;
    ctrl <= 4'hc;
    $display("Alu opcode:%d     Input:%h    Shift:%d ",ctrl, dataIn,shamt);
    `DELAY(6)


    //check if greater than or equal zero
    dataIn <= 64'h0000000000000000;
    ctrl <= 4'hd;
    $display("Alu opcode:%d     Input:%h    Shift:%d ",ctrl, dataIn,shamt);
    `DELAY(6)

    //check if greater than zero
    dataIn <= 64'h0000000000000001;
    ctrl <= 4'he;
    $display("Alu opcode:%d     Input:%h    Shift:%d ",ctrl, dataIn,shamt);
    `DELAY(6)
    simState <= 1'b1;
    $stop;*/

end


/**********
 * Components
 **********/


 alu #(
       .DATA_WIDTH(DATA_WIDTH),
       .CTRL_WIDTH(CTRL_WIDTH),
       .STATUS_WIDTH(STATUS_WIDTH),
       .SHAMT_WIDTH(SHAMT_WIDTH),
       .DELAY(DELAY)
   )UUT(
       .clk(clk),
       .en_n (en_n),
       .rst(rst),
       .dataIn(dataIn),
       .ctrl(ctrl),
       .shamt(shamt),
       .dataOut(dataOut),
       .status(status)
 );
endmodule // alu_tb
