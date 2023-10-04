module Controller(
    input [4:0] opcode,
    input [2:0] func3,
    input       func7,
    input       alu_0,
    output reg       next_pc_sel,
    output reg [3:0] im_w_en,
    output reg       wb_en,
    output reg       jb_op1_sel,
    output reg       alu_op1_sel,
    output reg       alu_op2_sel,
    output [4:0] opcode_o,
    output [2:0] func3_o,
    output       func7_o,
    output reg       wb_sel,
    output reg [3:0] dm_w_en
);

assign im_w_en = 4'b0000;
assign opcode_o = opcode;
assign func3_o = func3;
assign func7_o = func7;
always @(*)
begin
    case(opcode)
    5'b01101: // U lui
    begin
        next_pc_sel = 1;
        wb_en = 1;
        alu_op2_sel = 1; // imm
        wb_sel = 0; // ALU
        dm_w_en = 4'b0000;
    end
    5'b00101: // U auipc
    begin
        next_pc_sel = 1;
        wb_en = 1;   
        alu_op1_sel = 1; // pc
        alu_op2_sel = 1; // imm
        wb_sel = 0; // ALU
        dm_w_en = 4'b0000;
    end
    5'b11011: // J jal
    begin
        next_pc_sel = 0;
        wb_en = 1;
        jb_op1_sel = 1; // pc
        alu_op1_sel = 1; // pc
        wb_sel = 0; // ALU
        dm_w_en = 4'b0000;
    end
    5'b11001: // I jalr
    begin
        next_pc_sel = 0;
        wb_en = 1;
        jb_op1_sel = 0; // rs1
        alu_op1_sel = 1; // pc
        wb_sel = 0; // ALU
        dm_w_en = 4'b0000;
    end
    5'b11000: // B
    begin
        next_pc_sel = ~alu_0;
        wb_en = 0;
        jb_op1_sel = 1; // pc
        alu_op1_sel = 0; // rs1
        alu_op2_sel = 0; // rs2
        dm_w_en = 4'b0000;
    end
    5'b00000: // I
    begin
        next_pc_sel = 1;
        wb_en = 1;
        alu_op1_sel = 0; // rs1
        alu_op2_sel = 1; // imm
        wb_sel = 1; // DM
        dm_w_en = 4'b0000;
    end
    5'b01000: // S
    begin
        next_pc_sel = 1;
        wb_en = 0;
        alu_op1_sel = 0; // rs1
        alu_op2_sel = 1; // imm
        case(func3)
        3'b000: // sb
        begin
            dm_w_en = 4'b0001;
        end
        3'b001: // sh
        begin
            dm_w_en = 4'b0011;
        end
        3'b010: // sw
        begin
            dm_w_en = 4'b1111;
        end
        endcase
    end
    5'b00100: // I
    begin
        next_pc_sel = 1;
        wb_en = 1;
        alu_op1_sel = 0; // rs1
        alu_op2_sel = 1; // imm
        wb_sel = 0; // ALU
        dm_w_en = 4'b0000;
    end
    5'b01100: // R
    begin
        next_pc_sel = 1;
        wb_en = 1;
        alu_op1_sel = 0; // rs1
        alu_op2_sel = 0; // rs2
        wb_sel = 0; // ALU
        dm_w_en = 4'b0000;
    end
    endcase
end

endmodule