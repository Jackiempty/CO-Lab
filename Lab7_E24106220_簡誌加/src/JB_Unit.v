module JB_Unit (
    input [31:0] operand1,
    input [31:0] operand2,
    output [31:0] jb_out
);
wire [31:0] op1_op2;

assign op1_op2 = (operand1 + operand2);
assign jb_out = op1_op2 & ~32'd1;

endmodule