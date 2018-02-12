module alu_controller(
    //inputs and outputs
    input[3:0]  ALUop,
    input[5:0]  functioncode,
    output[4:0] ALU_ctrl,
    output Jumpreg
);
  //function codes from the instructions register
  localparam  func_ADD    = 6'b100000;
  localparam  func_ADDU   = 6'b100001;
  localparam  func_SUB    = 6'b100010;
  localparam  func_SUBU   = 6'b100011;
  localparam  func_AND    = 6'b100100;
  localparam  func_OR     = 6'b100101;
  localparam  func_XOR    = 6'b100110;
  localparam  func_NOR    = 6'b100111;
  localparam  func_SLT    = 6'b101010;
  localparam  func_SLTU   = 6'b101011;
  localparam  func_SLL    = 6'b000000;
  localparam  func_SRL    = 6'b000010;
  localparam  func_SRA    = 6'b000011;
  localparam  func_SLLV   = 6'b000100;
  localparam  func_SRLV   = 6'b000110;
  localparam  func_SRAV   = 6'b000111;
  localparam  func_MULT   = 6'b011000;
  localparam  func_MULTU  = 6'b011001;
  localparam  func_MFHI   = 6'b010000;
  localparam  func_MFLO   = 6'b010010;
  localparam  func_MTHI   = 6'b010001;
  localparam  func_MTLO   = 6'b010011;
  localparam  func_JR     = 6'b001000;
  localparam  func_JALR   = 6'b001001;


  //controller codes for the alu
  localparam  alu_AND   = 5'h0;
  localparam  alu_OR    = 5'h1;
  localparam  alu_NOR   = 5'h2;
  localparam  alu_XOR   = 5'h3;
  localparam  alu_ADD   = 5'h4;
  localparam  alu_SUB   = 5'h5;
  localparam  alu_MULT  = 5'h6;
  localparam  alu_SLT   = 5'h7;
  localparam  alu_SRL   = 5'h8;
  localparam  alu_SLL   = 5'h9;
  localparam  alu_SRA   = 5'hA;
  localparam  alu_MFHI  = 5'hB;
  localparam  alu_MFLO  = 5'hC;
  localparam  alu_MTHI  = 5'hD;
  localparam  alu_MTLO  = 5'hE;
  localparam  alu_SRLV  = 5'hF;
  localparam  alu_SLLV  = 5'h10;
  localparam  alu_SRAV  = 5'h11;

  reg [4:0]funct;
  reg [4:0]ctrlout = 5'h0;
  reg JR = 1'b0;


    always @ (*) begin
      case (functioncode)
        func_ADD:   funct    <= alu_ADD;
        func_ADDU:  funct    <= alu_ADD;
        func_SUB:   funct    <= alu_SUB;
        func_SUBU:  funct    <= alu_SUB;
        func_AND:   funct    <= alu_AND;
        func_OR:    funct    <= alu_OR;
        func_XOR:   funct    <= alu_XOR;
        func_NOR:   funct    <= alu_NOR;
        func_SLT:   funct    <= alu_SLT;
        func_SLTU:  funct    <= alu_SLT;
        func_SLL:   funct    <= alu_SLL;
        func_SRL:   funct    <= alu_SRL;
        func_SRA:   funct    <= alu_SRA;
        func_SLLV:  funct    <= alu_SLLV;
        func_SRLV:  funct    <= alu_SRLV;
        func_SRAV:  funct    <= alu_SRAV;
        func_JALR:  funct    <= alu_ADD;
        func_MULT:  funct    <= alu_MULT;
        func_MULTU: funct    <= alu_MULT;
        func_MFHI:  funct    <= alu_MFHI;
        func_MFLO:  funct    <= alu_MFLO;
        func_MTHI:  funct    <= alu_MTHI;
        func_MTLO:  funct    <= alu_MTLO;
        func_JR:    funct    <= alu_ADD;
        default:    funct    <= 5'h0;
      endcase

      if((functioncode == func_JR) || (functioncode == func_JALR)) begin
          JR = 1'b1;
      end
      else begin
          JR = 1'b0;
      end

    end

    always @ (*) begin
      case (ALUop)
        4'h0: ctrlout <= funct;
        4'h1: ctrlout <= alu_ADD;
        4'h2: ctrlout <= alu_SUB;
        4'h3: ctrlout <= alu_AND;
        4'h4: ctrlout <= alu_OR;
        4'h5: ctrlout <= alu_XOR;
        4'h6: ctrlout <= alu_NOR;
        4'h7: ctrlout <= alu_SLT;
        4'h8: ctrlout <= alu_SLL;
        default: ctrlout <= 5'h0;
      endcase
    end

    assign ALU_ctrl = ctrlout;

endmodule
