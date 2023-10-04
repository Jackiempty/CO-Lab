module Reg_W (
    input clk,
    input rst,
    input [31:0] alu_out_in,
    input [31:0] ld_data_in,
    output reg [31:0] alu_out_out,
    output reg [31:0] ld_data_out
);

always @(posedge rst)
begin
    alu_out_out <= 32'd0;
    ld_data_out <= 32'd0;
end

always @(posedge clk)
begin
    alu_out_out <= alu_out_in;
    ld_data_out <= ld_data_in;
end

endmodule