module MIPSCPU #(
    parameter DATA_WIDTH = 32,
    parameter RD_DEPTH = 2,
    parameter ADDR_WIDTH = log2(REG_DEPTH),  //address width, for the MIPS the operands are addresses, so operand
    parameter DELAY = 0
    parameter DATA_WIDTH_IN = 16,
    parameter DATA_WIDTH_OUT = 32,
    parameter CTRL_WIDTH = 5,
    parameter STATUS_WIDTH = 4,
    parameter SHAMT_WIDTH = 5
    )(
    input clk,
    input en,
)

wire mux_jump_out;
wire pc_out;

reg en_n;
always @ ( * ) begin
    en_n <= ~en;
end


//Components

//THE PROGRAM COUNTER
counter #(
    .DATA_WIDTH(6),
    .COUNT_START(0),
    .STEP(4)
    )U_PC_COUNTER(
    .clk(clk),
    .rst(rst),
    .en(en),
    .load(1'b1),
    .loadval(mux_jump_out),
    .dataOut(pc_out)
);



mux #(
    .BIT_WIDTH(DATA_WIDTH),
    .DEPTH(DEPTH),

    )U_MUX_BRANCH(
    .dataIn(),
    .select(),
    .muxout()
)

mux #(
    .BIT_WIDTH(DATA_WIDTH),
    .DEPTH(DEPTH),

    )U_MUX_JUMP(
    .dataIn(),
    .select(),
    .muxout()
)

mux #(
    .BIT_WIDTH(DATA_WIDTH),
    .DEPTH(DEPTH),

    )U_MUX_REGFILE(
    .dataIn(),
    .select(),
    .muxout()
)

mux #(
    .BIT_WIDTH(DATA_WIDTH),
    .DEPTH(DEPTH),

    )U_MUX_DATAMEM(
    .dataIn(),
    .select(),
    .muxout()
)

mux #(
    .BIT_WIDTH(DATA_WIDTH),
    .DEPTH(DEPTH),

    )U_MUX_ALU(
    .dataIn(),
    .select(),
    .muxout()
)


ram	Data_Memory (
	.address ( address_sig ),
	.clock ( clock_sig ),
	.data ( data_sig ),
	.wren ( wren_sig ),
	.q ( q_sig )
	);

rom	Instruction_Memory (
	.address ( address_sig ),
	.clock ( clock_sig ),
	.q ( q_sig )
	);

alu_controller U_ALUCTRL(
    .ALUop(),
    .functioncode(),
    .ALU_ctrl()
);

controller U_CTRL(
    .OPCODE(),
    .RegDST(),
    .RegWrite(),
    .ALUSrc(),
    .jump(),
    .MemRead(),
    .MemWrite(),
    .MemtoReg(),
    .branch_ctrl(),
    .ALUop()
);

signextend #(
    .DATA_WIDTH_IN(),
    .DEPTH(),
    .DATA_WIDTH_OUT(),
    .DELAY()
    )U_SIGNEXTEND(
    .clk(),
    .rst(),
    .en_n(),
    .dataIn(),
    .dataOut()
);

alu #(
    .DATA_WIDTH(),
    .CTRL_WIDTH(),
    .STATUS_WIDTH(),
    .SHAMT_WIDTH(),
    .DELAY()
    )U_ALU(
    .clk(),
    .en_n(),
    .rst(),
    .dataIn(),
    .ctrl(),
    .shamt(),
    .dataOut(),
    .status()
);




register_file #(
    .DATA_WIDTH(),
    .RD_DEPTH(),
    .REG_DEPTH(),
    .ADDR_WIDTH(),
    .DELAY()
    )U_REGFILE(
    .clk(),
    .rst(),
    .wr(),
    .en_n(),
    .rr(),
    .d(),
    .q()
);



endmodule
