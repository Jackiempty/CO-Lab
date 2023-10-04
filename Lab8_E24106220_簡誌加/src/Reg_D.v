module Reg_D (
    input clk,
    input rst,
    input [31:0] pc_in,
    input [31:0] inst_in,
    input stall,
    input jb,
    output reg [31:0] pc_out,
    output reg [31:0] inst_out
);

always @(posedge rst)
begin
    pc_out <= 32'd0;
    inst_out <= 32'd0;
end

always @(posedge clk)
begin // if-else would be better
    if (stall) 
    begin
        pc_out <= pc_out;
        inst_out <= inst_out;
    end
    else if (~jb)
    begin
        pc_out <= 32'd0;
        inst_out <= 32'b00000000000000000000000000010011;
    end
    else
    begin
        pc_out <= pc_in;
        inst_out <= inst_in;
    end
end

endmodule