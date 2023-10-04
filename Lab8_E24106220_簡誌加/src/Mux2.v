module Mux2 (
    input sel,
    input [31:0] in_1,
    input [31:0] in_2,
    output reg [31:0] out
);

always @(*)
begin
    case(sel)
    1'b0:
    begin
        out = in_1;
    end
    1'b1:
    begin
        out = in_2;
    end
    endcase
end

endmodule