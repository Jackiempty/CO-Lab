module ALU (
    input [4:0] opcode,
    input [2:0] func3,
    input       func7,
    input [31:0] operand1,
    input [31:0] operand2,
    output reg [31:0] alu_out
);

always @(*)
begin
    case(opcode)
    5'b01101: // U lui
    begin
        alu_out = operand2;
    end
    5'b00101: // U auipc
    begin
        alu_out = operand1 + operand2;
    end
    5'b11011: // J jal
    begin
        alu_out = operand1 + 32'd4;
    end
    5'b11001: // I jalr
    begin
        alu_out = operand1 + 32'd4;
    end
    5'b11000: // B
    begin
        case(func3)
        3'b000: // beq
        begin
            alu_out[0] = (operand1 == operand2);
        end
        3'b001: // bne
        begin
            alu_out[0] = (operand1 != operand2);
        end
        3'b100: // blt
        begin
            alu_out[0] = ($signed (operand1) < $signed (operand2));
        end
        3'b101: // bge
        begin
            alu_out[0] = ($signed (operand1) >= $signed (operand2));
        end
        3'b110: // bltu
        begin
            alu_out[0] = (operand1 < operand2);
        end
        3'b111: // bgeu
        begin
            alu_out[0] = (operand1 >= operand2);
        end
        endcase
    end
    5'b00000: // I
    begin
        alu_out = operand1 + operand2;
    end
    5'b01000: // S
    begin
        alu_out = operand1 + operand2;
    end
    5'b00100: // I
    begin
        case(func3)
        3'b000: // addi
        begin
            alu_out = operand1 + operand2;
        end
        3'b010: // slti
        begin
            alu_out = ($signed (operand1) < $signed (operand2));
        end
        3'b011: // sltiu
        begin
            alu_out = (operand1 < operand2);
        end
        3'b100: // xori
        begin
            alu_out = (operand1 ^ operand2);
        end
        3'b110: // ori
        begin
            alu_out = (operand1 | operand2);
        end
        3'b111: // andi
        begin
            alu_out = (operand1 & operand2);
        end
        3'b001: // slli
        begin
            alu_out = (operand1 << operand2[4:0]);
        end
        3'b101:
        begin
            case(func7)
            1'b0: // srli
            begin
                alu_out = (operand1 >> operand2[4:0]);
            end
            1'b1: // srai
            begin
                alu_out = ($signed(operand1) >>> operand2[4:0]);
            end
            endcase
        end
        endcase
    end
    5'b01100: // R
    begin
        case(func3)
        3'b000:
        begin
            case(func7)
            1'b0: // add
            begin
                alu_out = (operand1 + operand2);
            end
            1'b1: // sub
            begin
                alu_out = (operand1 - operand2);
            end
            endcase
        end
        3'b001: // sll
        begin
            alu_out = ($signed(operand1) << $signed(operand2[4:0]));
        end
        3'b010: // slt
        begin
            alu_out = ($signed(operand1) < $signed(operand2));
        end
        3'b011: // sltu
        begin
            alu_out = (operand1 < operand2);
        end
        3'b100: // xor
        begin
            alu_out = (operand1 ^ operand2);
        end
        3'b101:
        begin
            case(func7)
            1'b0: // srl
            begin
                alu_out = ($signed(operand1) >> $signed(operand2[4:0]));
            end
            1'b1: // sra
            begin
                alu_out = ($signed(operand1) >>> $signed(operand2[4:0]));
            end
            endcase
        end
        3'b110: // or
        begin
            alu_out = (operand1 | operand2);
        end
        3'b111: // and
        begin
            alu_out = (operand1 & operand2);
        end
        endcase
    end
    endcase
end

endmodule