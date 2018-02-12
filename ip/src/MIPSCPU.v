<<<<<<< HEAD
    module MIPSCPU #(
    parameter DATA_WIDTH = 32,
    parameter RD_DEPTH = 2,
	 parameter REG_DEPTH = 32,
    parameter ADDR_WIDTH = log2(REG_DEPTH),  //address width, for the MIPS the operands are addresses, so operand
    parameter DELAY = 0,
=======
module MIPSCPU #(
    parameter DATA_WIDTH = 32,
    parameter RD_DEPTH = 2,
    parameter ADDR_WIDTH = log2(REG_DEPTH),  //address width, for the MIPS the operands are addresses, so operand
    parameter DELAY = 0
>>>>>>> cccc8139e1c7507e630b35c34be23e44c832124e
    parameter DATA_WIDTH_IN = 16,
    parameter DATA_WIDTH_OUT = 32,
    parameter CTRL_WIDTH = 5,
    parameter STATUS_WIDTH = 4,
    parameter SHAMT_WIDTH = 5
    )(
    input clk,
<<<<<<< HEAD
    input rst2,
    input en,
    input rst
);

function integer log2; //This is a macro function (no hardware created) which finds the log2, returns log2
   input [31:0] val; //input to the function
   integer 	i;
   begin
      log2 = 0;
      for(i = 0; 2**i < val; i = i + 1)
		log2 = i + 1;
   end
endfunction

wire [DATA_WIDTH-1:0]mux_jump_out;
wire [DATA_WIDTH-1:0]pc_out;
wire [DATA_WIDTH-1:0]Instruction;
wire [4:0]write_register;
wire [DATA_WIDTH-1:0]rddata1;
wire [DATA_WIDTH-1:0]rddata2;
wire [DATA_WIDTH-1:0]mux_datamem;
wire [DATA_WIDTH-1:0]datamem;
wire [4:0]alu_ctrl;
wire [DATA_WIDTH-1:0]mux_alu_in1;
wire [DATA_WIDTH-1:0]alu_out;
wire [DATA_WIDTH:0]pc4_out;
wire [3:0] status;
wire [DATA_WIDTH-1:0]mux_branch_in1;
wire branch_sel;
wire [DATA_WIDTH-1:0]mux_branch_out;
wire [DATA_WIDTH-1:0]mux_jump_in1;
wire [DATA_WIDTH-1:0]mux_Jumpreg;
wire [DATA_WIDTH-1:0]signextend_val;
wire [DATA_WIDTH-1:0]pc1;

//controller signals
wire  [5:0]OPCODE;
wire [1:0]RegDST;
wire RegWrite;
wire ALUSrc;
wire jump;
wire MemRead;
wire MemWrite;
wire [1:0]MemtoReg;
wire branch_ctrl;
wire [2:0]ALUop;
wire Jumpreg;
wire clk2;

wire[27:0] IRshift;
=======
    input en,
)

wire mux_jump_out;
wire pc_out;
>>>>>>> cccc8139e1c7507e630b35c34be23e44c832124e

reg en_n;
always @ ( * ) begin
    en_n <= ~en;
end


//Components

<<<<<<< HEAD
//clock Divider
clk_div #(
    .IN_FREQ(50000000),
    .OUT_FREQ(20000000)
    )U_CLKDIV(
    .clk(clk),
    .rst(rst2),
    .new_clk(clk2)
);

//THE PROGRAM COUNTER
counter #(
    .DATA_WIDTH(32),
    .COUNT_START(0),
    .COUNT_END(64),
    .STEP(4)
    )U_PC_COUNTER(
    .clk(clk2),
    .rst(rst),
    .en(en),
    .load(1'b1),
    .loadval(mux_Jumpreg),
    .dataOut(pc_out)
);

rom	Instruction_Memory (
	.address (pc_out[5:0]),
	.clock (clk),
	.q (Instruction)
	);

mux #(
    .BIT_WIDTH(5),
    .DEPTH(3)
    )U_MUX_REGFILE(
    .dataIn({5'h1f,Instruction[15:11],Instruction[20:16]}),
    .select(RegDST), //this is register 31 used for jump and link
    .muxout(write_register)
);

register_file #(
    .DATA_WIDTH(DATA_WIDTH),
    .RD_DEPTH(2),
    .REG_DEPTH(32),
    .DELAY(0)
    )U_REGFILE(
    .clk(clk2),
    .rst(rst),
    .wr(RegWrite),
    .en_n(en_n),
    .rw(write_register),
    .rr({Instruction[20:16],Instruction[25:21]}),
    .d(mux_datamem),
    .q({rddata2,rddata1})
);

signextend #(
    .DATA_WIDTH_IN(16),
    .DEPTH(1),
    .DATA_WIDTH_OUT(DATA_WIDTH),
    .DELAY(0)
    )U_SIGNEXTEND(
    .clk(clk2),
    .rst(rst),
    .en_n(en_n),
    .dataIn(Instruction[15:0]),
    .dataOut(signextend_val)
);

mux #(
    .BIT_WIDTH(DATA_WIDTH),
    .DEPTH(2)
    )U_MUX_ALU(
    .dataIn({signextend_val,rddata2}),
    .select(ALUSrc),
    .muxout(mux_alu_in1)
);

alu #(
    .DATA_WIDTH(DATA_WIDTH),
    .CTRL_WIDTH(5),
    .STATUS_WIDTH(4),
    .SHAMT_WIDTH(5),
    .DELAY(0)
    )U_ALU(
    .clk(clk2),
    .en_n(en_n),
    .rst(rst),
    .dataIn({mux_alu_in1,rddata1}),
    .ctrl(alu_ctrl),
    .shamt(Instruction[10:6]),
    .dataOut(alu_out),
    .status(status)
);

alu_controller U_ALUCTRL(
    .ALUop(ALUop),
    .functioncode(Instruction[5:0]),
    .ALU_ctrl(alu_ctrl),
    .Jumpreg(Jumpreg)
);

add #(
    .DATA_WIDTH(DATA_WIDTH)
    )U_PC4(
    .input1(pc_out),
    .input2(32'h4),
    .dataOut(pc4_out)
);


assign mux_branch_in1 = pc4_out[31:0] + (signextend_val<<2);
assign branch_sel = branch_ctrl | status[0];
mux #(
    .BIT_WIDTH(DATA_WIDTH),
    .DEPTH(2)
    )U_MUX_BRANCH(
    .dataIn({mux_branch_in1,pc4_out[31:0]}),
    .select(branch_sel),
    .muxout(mux_branch_out)
);

assign IRshift = Instruction[25:0]<<2;
assign mux_jump_in1 = {pc4_out[31:28],IRshift};

mux #(
    .BIT_WIDTH(DATA_WIDTH),
    .DEPTH(2)
    )U_MUX_JUMP(
    .dataIn({mux_jump_in1,mux_branch_out}),
    .select(jump),
    .muxout(mux_jump_out)
);

mux #(
    .BIT_WIDTH(DATA_WIDTH),
    .DEPTH(2)
    )U_MUX_Jumpreg(
    .dataIn({rddata1,mux_jump_out}),
    .select(Jumpreg),
    .muxout(mux_Jumpreg)
);


assign pc1 = pc_out + 1;
mux #(
    .BIT_WIDTH(DATA_WIDTH),
    .DEPTH(3)
    )U_MUX_DATAMEM(
    .dataIn({pc1,datamem,alu_out}),
    .select(MemtoReg),
    .muxout(mux_datamem)
);




ram	Data_Memory (
	.address (alu_out[5:0]),
	.clock (clk),
	.data (rddata2),
	.wren (MemWrite),
	.q (datamem)
	);

controller U_CTRL(
    .OPCODE(Instruction[31:26]),
    .RegDST(RegDST),
    .RegWrite(RegWrite),
    .ALUSrc(ALUSrc),
    .jump(jump),
    .MemRead(MemRead),
    .MemWrite(MemWrite),
    .MemtoReg(MemtoReg),
    .branch_ctrl(branch_ctrl),
    .ALUop(ALUop)
);


=======
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



>>>>>>> cccc8139e1c7507e630b35c34be23e44c832124e
endmodule
