module Reg_PC(
    input clk,
    input rst,
    input [31:0] next_pc,
    output reg [31:0] current_pc
);

always @(posedge clk, rst)
begin
    if (rst)
    current_pc <= 32'd0;
end

always @(posedge clk)
begin
    current_pc <= next_pc;
end

endmodule