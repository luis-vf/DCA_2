module alu_controller #(
//PARAMETERS
    parameter CTRL_WIDTH = 4
  )(
    //inputs and outputs
    input [2:0]   ALUop,
    input [5:0]   functioncode,
    output [4:0]  ALU_ctrl
);
  //function codes from the instructions register
  localparam  func_ADD    = 5'b100000;
  localparam  func_ADDU   = 5'b100001;
  localparam  func_SUB    = 5'b100010;
  localparam  func_SUBU   = 5'b100011;
  localparam  func_AND    = 5'b100100;
  localparam  func_OR     = 5'b100101;
  localparam  func_XOR    = 5'b100110;
  localparam  func_NOR    = 5'b100111;
  localparam  func_SLT    = 5'b101010;
  localparam  func_SLTU   = 5'b101011;
  localparam  func_SLL    = 5'b000000;
  localparam  func_SRL    = 5'b000010;
  localparam  func_SRA    = 5'b000011;
  localparam  func_SLLV   = 5'b000100;
  localparam  func_SRLV   = 5'b000110;
  localparam  func_SRAV   = 5'b000111;
  localparam  func_JALR   = 5'b001001;
  localparam  func_MULT   = 5'b011000;
  localparam  func_MULTU  = 5'b011001;
  localparam  func_MFHI   = 5'b010000;
  localparam  func_MFLO   = 5'b010010;
  localparam  func_MTHI   = 5'b010001;
  localparam  func_MTLO   = 5'b010011;
  localparam  func_JR     = 5'b001000;


  //controller codes for the alu
  localparam  alu_AND   = 4'h0;
  localparam  alu_OR    = 4'h1;
  localparam  alu_NOR   = 4'h2;
  localparam  alu_XOR   = 4'h3;
  localparam  alu_ADD   = 4'h4;
  localparam  alu_SUB   = 4'h5;
  localparam  alu_MULT  = 4'h6;
  localparam  alu_SLT   = 4'h7;
  localparam  alu_SRL   = 4'h8;
  localparam  alu_SLL   = 4'h9;
  localparam  alu_SRA   = 4'hA;
  localparam  alu_MFHI  = 4'hB;
  localparam  alu_MFLO  = 4'hC;
  localparam  alu_MTHI  = 4'hD;
  localparam  alu_MTLO  = 4'hE;
  localparam  alu_SLLV  = 4'hF;

  wire funct;

always @ ( * ) begin
  case (functioncode)
    func_ADD: funct <= alu_ADD;
    func_ADDU: funct <= alu_ADD;
    func_SUB: funct <= alu_SUB;
    func_SUBU: funct <= alu_SUB;
    func_AND: funct <= alu_AND;
    func_OR: funct <= alu_OR;
    func_XOR: funct <= alu_XOR;
    func_NOR: funct <= alu_NOR;
    func_SLT: funct <= alu_SLT;
    func_SLTU: funct <= alu_SLTU;
    func_SLL: funct <= alu_SLL;
    func_SRL: funct <= alu_SRL;
    func_SRA: funct <= alu_SRA;
    func_SLLV: funct <= alu_SLLV;
    func_SRLV: funct <= alu_SRLV;
    func_SRAV: funct <= alu_SRAV;
    func_JALR: funct <= alu_ADD;
    func_MULT: funct <= alu_MULT;
    func_MULTU: funct <= alu_MULT;
    func_MFHI: funct <= alu_MFHI;
    func_MFLO: funct <= alu_MFLO;
    func_MTHI: funct <= alu_MTHI;
    func_MTLO: funct <= alu_MTLO;
    func_JR: funct <= alu_ADD;


    default: ;
  endcase
end

always @ ( * ) begin
  case (ALUop)
    value: ;
    default: ;
  endcase
end

endmodule
