/*
*
*testbench for the register file
*Notes:
*To-Do
*/

module register_file_tb();

`define DELAY(TIME_CLK) #(10*TIME_CLK);

/**********
 * Internal Signals
**********/
parameter DATA_WIDTH = 32;  //word length
parameter RD_DEPTH = 2; //number of parallel reads
parameter REG_DEPTH = 32; //depth of the register file
parameter ADDR_WIDTH = 5; //address width, for the MIPS the operands are addresses, so operand
parameter DELAY = 0;


reg clk = 0;
reg rst = 0;
reg wr = 0; //write enable
reg [ADDR_WIDTH*RD_DEPTH-1:0] rr; //reg read address as vectorized array
reg [ADDR_WIDTH-1:0] rw; //reg write address
reg [DATA_WIDTH-1:0] d; //input data to be written to reg
wire [DATA_WIDTH*RD_DEPTH-1:0] q; //output data from reg reads, vectorized array
reg en_n = 0;

reg simState = 0;

/**********
 * Synchronous Logic
 **********/
always begin
	if(simState != 1)begin
		`DELAY(1/2)
		clk = ~clk;
	end
end

initial begin
	simState = 0;
	$display($time, "- Starting Sim");
	$monitor("Changes in output: %h",d);
	clk = 0;
	rst = 1;
	`DELAY(5)
	rst = 0;
	rr = 10'b1101100100;
	d= 32'hdcaf484c;
	`DELAY(5)
	rw = 5'b11011; //this is the address we are writing to in the register file
	`DELAY(5)
	wr = 1; //this starts the process to write the data
	`DELAY(5)
	wr = 0;
	`DELAY(5)
	d = 32'h37373737; //data that we are writing
	`DELAY(5)
	rw = 5'b00100;  //this is the address we are writing to in the register file
	`DELAY(5)
	wr = 1; //this starts the process to write the data
	`DELAY(5)
	wr = 0;
	`DELAY(5)

	$display($time, "- End Simulation");

	simState = 1;
end
/**********
 * Components
 **********/
register_file #(
	.DATA_WIDTH(DATA_WIDTH),
	.RD_DEPTH(RD_DEPTH),
	.REG_DEPTH(REG_DEPTH),
	.ADDR_WIDTH(ADDR_WIDTH),
	.DELAY(DELAY)
)UUT(
	.clk(clk),
	.en_n(en_n),
	.rst(rst),
	.wr(wr),
	.rr(rr),
	.rw(rw),
	.d(d),
	.q(q)
);
endmodule
