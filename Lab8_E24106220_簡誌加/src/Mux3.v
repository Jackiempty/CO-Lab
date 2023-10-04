module Mux3 (
    input [1:0] sel,
    input [31:0] in_1,
    input [31:0] in_2,
    input [31:0] in_3,
    output reg [31:0] out
);

always @(*)
begin
    case(sel)
    2'b00:
    begin
        out = in_1;
    end
    2'b01:
    begin
        out = in_2;
    end
    2'b10:
    begin
        out = in_3;
    end
    endcase
end

endmodule