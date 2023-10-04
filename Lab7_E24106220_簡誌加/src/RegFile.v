module RegFile (
    input clk,
    input wb_en,
    input [31:0] wb_data,
    input [4:0] rd_index,
    input [4:0] rs1_index,
    input [4:0] rs2_index,
    output [31:0] rs1_data_out,
    output [31:0] rs2_data_out
);

reg [31:0] registers [0:31];
reg is_rd_x0;
assign is_rd_not_x0 = (rd_index[4] || rd_index[3] || rd_index[2] || rd_index[1] || rd_index[0]);
assign registers[0] = 32'd0;

assign rs1_data_out = registers[rs1_index];
assign rs2_data_out = registers[rs2_index];


always @(posedge clk)
begin
    if(wb_en && is_rd_not_x0)
        registers[rd_index] <= wb_data;
end



endmodule