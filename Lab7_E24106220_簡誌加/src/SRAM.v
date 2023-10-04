module SRAM (
   input clk,
   input [3:0] w_en,
   input [15:0] address,
   input [31:0] write_data,
   output [31:0] read_data
);

reg [7:0] mem [0:65535];

assign read_data = {mem[address + 3], mem[address +2], mem[address + 1], mem[address]};

always @(posedge clk)
begin
    case(w_en)
    4'b0001:
    begin
        {mem[address]} = {write_data[7:0]};
    end
    4'b0011:
    begin
        {mem[address + 1], mem[address]} = {write_data[15:0]};
    end
    4'b1111:
    begin
        {mem[address + 3], mem[address +2], mem[address + 1], mem[address]} = write_data;
    end
    endcase
end
endmodule