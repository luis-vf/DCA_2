module controller(
    //input clk,
    input  [5:0]OPCODE,
    output [1:0]RegDST,
    output RegWrite,
    output ALUSrc,
    output jump,
    output MemRead,
    output MemWrite,
    output [1:0]MemtoReg,
    output branch_ctrl,
    output [2:0]ALUop,
    output IsSigned
);

localparam aluop_rtype = 3'h0;
localparam aluop_add = 3'h1;
localparam aluop_sub = 3'h2;
localparam aluop_and = 3'h3;
localparam aluop_or = 3'h4;
localparam aluop_xor = 3'h5;
localparam aluop_slt = 3'h6;
localparam aluop_sll = 3'h7;


localparam rtype   = 6'b000000;
localparam branch_ri  = 6'b000001;

localparam j    = 6'b000010;
localparam jal  = 6'b000011;
localparam beq  = 6'b000100;
localparam bne  = 6'b000101;
localparam blez = 6'b000110;
localparam bgtz = 6'b000111;

localparam addi = 6'b001000;
localparam andi = 6'b001100;
localparam addiu= 6'b001001;
localparam slti = 6'b001010;
localparam sltiu= 6'b001011;
localparam ori  = 6'b001101;
localparam xori = 6'b001110;

localparam lw   = 6'b100011;
localparam lwl  = 6'b100010;
localparam lwr  = 6'b100110;
localparam lh   = 6'b100001;
localparam lui  = 6'b001111;
localparam lbu  = 6'b100100;
localparam lhu  = 6'b100101;
localparam lb   = 6'b100000;
localparam sb   = 6'b101000;
localparam sh   = 6'b101001;
localparam sw   = 6'b101011;
localparam swr  = 6'b101110;
localparam swl  = 6'b101010;

reg [1:0]RegDST_t;
reg RegWrite_t;
reg jump_t;
reg branch_ctrl_t;
reg ALUSrc_t;
reg MemRead_t;
reg MemWrite_t;
reg [1:0]MemtoReg_t;
reg [2:0]ALUop_t;

always @ ( * ) begin
    RegDST_t        <= 2'h0;
    RegWrite_t      <= 1'b0;
    ALUSrc_t        <= 1'b0;
    branch_ctrl_t   <= 1'b0;
    jump_t          <= 1'b0;
    MemRead_t       <= 1'b0;
    MemWrite_t      <= 1'b0;
    MemtoReg_t      <= 2'h0;
    ALUop_t         <= 3'h0;
    IsSigned        <= 1'b0;

    case (OPCODE)
        rtype:  begin
					      RegDST_t <= 2'b1;
                RegWrite_t <= 1'b1;
                ALUop_t <= aluop_rtype; end

        branch_ri:begin
						     branch_ctrl_t <= 1'b1;
						     ALUop_t <= aluop_sub; end

        j:      jump_t <= 1'b1;

        jal:    begin
					      jump_t <= 1'b1;
                RegWrite_t <= 1'b1;
					      RegDST_t <= 2'h2;
                MemtoReg_t <= 2'h2; end

        blez:   begin
					      branch_ctrl_t <= 1'b1;
                ALUop_t <= aluop_sub; end

        bgtz:   begin
					      branch_ctrl_t <= 1'b1;
                ALUop_t <= aluop_sub; end

        beq:   begin
					      branch_ctrl_t <= 1'b1;
                ALUop_t <= aluop_sub; end

        bne:   begin
					      branch_ctrl_t <= 1'b1;
                ALUop_t <= aluop_sub; end

        addi:   begin
                IsSigned <= 1'b1;
				        ALUSrc_t <= 1'b1;
                RegWrite_t <= 1'b1;
                ALUop_t <= aluop_add; end

        addiu:  begin
					      ALUSrc_t <= 1'b1;
                RegWrite_t <= 1'b1;
                ALUop_t <= aluop_add; end

        slti:   begin
                IsSigned <= 1'b1;
					      ALUSrc_t <= 1'b1;
                RegWrite_t <= 1'b1;
                ALUop_t <= aluop_slt; end

        sltiu:  begin
					      ALUSrc_t <= 1'b1;
                RegWrite_t <= 1'b1;
                ALUop_t <= aluop_slt; end

        andi:   begin
					      ALUSrc_t <= 1'b1;
                RegWrite_t <= 1'b1;
                ALUop_t <= aluop_and; end

        ori:   begin
					      ALUSrc_t <= 1'b1;
                RegWrite_t <= 1'b1;
                ALUop_t <= aluop_or; end

        xori:   begin
					      ALUSrc_t <= 1'b1;
                RegWrite_t <= 1'b1;
                ALUop_t <= aluop_xor; end

        lw:     begin
					      ALUSrc_t <= 1'b1;
                MemtoReg_t <= 2'h1;
                RegWrite_t <= 1'b1;
                MemRead_t <= 1'b1;
                ALUop_t <= aluop_add; end

        lwl:    begin
					      ALUSrc_t <= 1'b1;
                MemtoReg_t <= 2'h1;
                RegWrite_t <= 1'b1;
                MemRead_t <= 1'b1;
                ALUop_t <= aluop_add; end

        lwr:    begin
					      ALUSrc_t <= 1'b1;
                MemtoReg_t <= 2'h1;
                RegWrite_t <= 1'b1;
                MemRead_t <= 1'b1;
                ALUop_t <= aluop_add; end

        lh:     begin
					      ALUSrc_t <= 1'b1;
                MemtoReg_t <= 2'h1;
                RegWrite_t <= 1'b1;
                MemRead_t <= 1'b1;
                ALUop_t <= aluop_add; end

        lbu:    begin
					      ALUSrc_t <= 1'b1;
                MemtoReg_t <= 2'h1;
                RegWrite_t <= 1'b1;
                MemRead_t <= 1'b1;
                ALUop_t <= aluop_add; end

        lhu:    begin
					      ALUSrc_t <= 1'b1;
                MemtoReg_t <= 2'h1;
                RegWrite_t <= 1'b1;
                MemRead_t <= 1'b1;
                ALUop_t <= aluop_add; end

        lb:     begin
					      ALUSrc_t <= 1'b1;
                MemtoReg_t <= 2'h1;
                RegWrite_t <= 1'b1;
                MemRead_t <= 1'b1;
                ALUop_t <= aluop_add; end

        lui:    begin
					      ALUSrc_t <= 1'b1;
                RegWrite_t <= 1'b1;
                ALUop_t <= aluop_sll; end

        sb:     begin
					 	    ALUSrc_t <= 1'b1;
                MemWrite_t <= 1'b1;
                ALUop_t <= aluop_add; end

        sh:     begin
					      ALUSrc_t <= 1'b1;
                MemWrite_t <= 1'b1;
                ALUop_t <= aluop_add; end

        sw:     begin
					      ALUSrc_t <= 1'b1;
                MemWrite_t <= 1'b1;
                ALUop_t <= aluop_add; end

        swr:    begin
					      ALUSrc_t <= 1'b1;
                MemWrite_t <= 1'b1;
                ALUop_t <= aluop_add; end


        swl:    begin
					      ALUSrc_t <= 1'b1;
                MemWrite_t <= 1'b1;
                ALUop_t <= aluop_add; end

        default:ALUop_t <= aluop_add;
    endcase
end

assign RegDST = RegDST_t;
assign RegWrite = RegWrite_t;
assign ALUSrc = ALUSrc_t;
assign MemRead = MemRead_t;
assign MemWrite = MemWrite_t;
assign MemtoReg = MemtoReg_t;
assign ALUop = ALUop_t;
assign branch_ctrl = branch_ctrl_t;
assign jump = jump_t;

endmodule // controller
