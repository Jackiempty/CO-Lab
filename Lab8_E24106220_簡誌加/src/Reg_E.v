module Reg_E (
    input clk,
    input rst,
    input [31:0] pc_in,
    input [31:0] rs1_data_in,
    input [31:0] rs2_data_in,
    input [31:0] sext_imm_in,
    input stall,
    input jb,
    output reg [31:0] pc_out,
    output reg [31:0] rs1_data_out,
    output reg [31:0] rs2_data_out,
    output reg [31:0] sext_imm_out
);

always @(posedge rst)
begin
    pc_out <= 32'd0;
    rs1_data_out <= 32'd0;
    rs2_data_out <= 32'd0;
    sext_imm_out <= 32'd0;
end

always @(posedge clk)
begin // if-else would be better
     if (stall | ~jb)
    begin
        pc_out <= 32'd0;
        rs1_data_out <= 32'd0;
        rs2_data_out <= 32'd0;
        sext_imm_out <= 32'd0;
    end
    else
    begin
        pc_out <= pc_in;
        rs1_data_out <= rs1_data_in;
        rs2_data_out <= rs2_data_in;
        sext_imm_out <= sext_imm_in;
    end
end

endmodule