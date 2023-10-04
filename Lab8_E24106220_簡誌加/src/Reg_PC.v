module Reg_PC(
    input clk,
    input rst,
    input stall,
    input [31:0] next_pc,
    output reg [31:0] current_pc
);

always @(posedge rst)
begin
    current_pc <= 32'd0;
end

always @(posedge clk)
begin
    case(stall)
    1'b0:
    begin
        current_pc <= next_pc;
    end
    1'b1:
    begin
        current_pc <= current_pc;
    end
    endcase
end

endmodule