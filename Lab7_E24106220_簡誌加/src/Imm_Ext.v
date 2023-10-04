module Imm_Ext(
    input [31:0] inst,
    output reg [31:0] imm_ext_out
);

always @(*)
begin
    case(inst[6:2])
    5'b01101: // U lui
    begin
        imm_ext_out = {inst[31:12], 12'd0};
    end
    5'b00101: // U aupic
    begin
        imm_ext_out = {inst[31:12], 12'd0};
    end
    5'b11011: // J jal
    begin
        imm_ext_out = {{5'd12{inst[31]}}, inst[19:12], inst[20], inst[30:21], 1'b0};
    end
    5'b11001: // I jalr
    begin
        imm_ext_out = {{5'd20{inst[31]}}, inst[31:20]};
    end
    5'b11000: // B
    begin
        imm_ext_out = {{5'd20{inst[31]}}, inst[7], inst[30:25], inst[11:8], 1'b0};
    end
    5'b00000: // I
    begin
        imm_ext_out = {{5'd20{inst[31]}}, inst[31:20]};
    end
    5'b01000: // S
    begin
        imm_ext_out = {{5'd20{inst[31]}}, inst[31:25], inst[11:7]};
    end
    5'b00100: // I
    begin
        imm_ext_out = {{5'd20{inst[31]}}, inst[31:20]};
    end
    endcase
end
endmodule