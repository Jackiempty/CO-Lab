module LD_Filter (
    input [2:0] func3,
    input [31:0] ld_data,
    output reg [31:0] ld_data_f
);

always @(*)
begin
    case(func3)
    3'b000: // I lb
    begin
        ld_data_f = {{5'd24{ld_data[7]}}, ld_data[7:0]};
    end
    3'b001: // I lh
    begin
        ld_data_f = {{5'd16{ld_data[15]}}, ld_data[15:0]};
    end
    3'b010: // I lw
    begin
        ld_data_f = ld_data;
    end
    3'b100: // I lbu
    begin
        ld_data_f = {{5'd24{1'b0}}, ld_data[7:0]};
    end
    3'b101: // I lhu
    begin
        ld_data_f = {{5'd16{1'b0}}, ld_data[15:0]};
    end
    endcase
end

endmodule