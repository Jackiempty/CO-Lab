`include "./src/SRAM.v"
`include "./src/RegFile.v"
`include "./src/Adder.v"
`include "./src/ALU.v"
`include "./src/Controller.v"
`include "./src/Decoder.v"
`include "./src/Imm_Ext.v"
`include "./src/JB_Unit.v"
`include "./src/LD_Filter.v"
`include "./src/Mux.v"
`include "./src/Reg_PC.v"

module Top (
    input clk_m,
    input rst_m
);

// Data Path
wire [31:0] pc_4;
wire [31:0] jb_pc;
wire [31:0] next_pc;
wire [31:0] pc;
wire [31:0] inst;
wire [31:0] sext_imme;
wire [4:0] rs1_index;
wire [4:0] rs2_index;
wire [4:0] rd_index;
wire [8:0] dc_out_inst;
wire [31:0] rs1_data;
wire [31:0] rs2_data;
wire [31:0] mux2_wire;
wire [31:0] mux3_wire;
wire [31:0] mux4_wire;
wire [31:0] alu_out;
wire [31:0] ld_data;
wire [31:0] ld_data_f;
wire [31:0] wb_data;

// Control Path
wire next_pc_sel;
wire [3:0] im_w_en;
wire wb_en;
wire jb_op1_sel;
wire alu_op1_sel;
wire alu_op2_sel;
wire [4:0] opcode;
wire [2:0] func3;
wire func7;
wire wb_sel;
wire [3:0] dm_w_en;

SRAM im (
    .clk(clk_m),
    .w_en(im_w_en),
    .address(pc[15:0]),
    .write_data(32'd0),
    .read_data(inst)
);

SRAM dm (
    .clk(clk_m),
    .w_en(dm_w_en),
    .address(alu_out[15:0]),
    .write_data(rs2_data),
    .read_data(ld_data)
);

RegFile regfile (
    .clk(clk_m),
    .wb_en(wb_en),
    .wb_data(wb_data),
    .rd_index(rd_index),
    .rs1_index(rs1_index),
    .rs2_index(rs2_index),
    .rs1_data_out(rs1_data),
    .rs2_data_out(rs2_data)
);

Adder adder (
    .pc(pc),
    .next_pc(pc_4)
);

ALU alu (
    .opcode(opcode),
    .func3(func3),
    .func7(func7),
    .operand1(mux2_wire),
    .operand2(mux3_wire),
    .alu_out(alu_out)
);

Controller controller (
    .opcode(dc_out_inst[4:0]),
    .func3(dc_out_inst[7:5]),
    .func7(dc_out_inst[8]),
    .alu_0(alu_out[0]),
    .next_pc_sel(next_pc_sel),
    .im_w_en(im_w_en),
    .wb_en(wb_en),
    .jb_op1_sel(jb_op1_sel),
    .alu_op1_sel(alu_op1_sel),
    .alu_op2_sel(alu_op2_sel),
    .opcode_o(opcode),
    .func3_o(func3),
    .func7_o(func7),
    .wb_sel(wb_sel),
    .dm_w_en(dm_w_en)
);

Decoder decoder (
    .inst(inst),
    .dc_out_opcode(dc_out_inst[4:0]),
    .dc_out_func3(dc_out_inst[7:5]),
    .dc_out_func7(dc_out_inst[8]),
    .dc_out_rs1_index(rs1_index),
    .dc_out_rs2_index(rs2_index),
    .dc_out_rd_index(rd_index)
);

Imm_Ext imm_ext (
    .inst(inst),
    .imm_ext_out(sext_imme)
);

JB_Unit jb_unit (
    .operand1(mux4_wire),
    .operand2(sext_imme),
    .jb_out(jb_pc)
);

LD_Filter ld_filter (
    .func3(func3),
    .ld_data(ld_data),
    .ld_data_f(ld_data_f)
);

Mux mux_1 (
    .sel(next_pc_sel),
    .in_1(jb_pc),
    .in_2(pc_4),
    .out(next_pc)
);

Mux mux_2 (
    .sel(alu_op1_sel),
    .in_1(rs1_data),
    .in_2(pc),
    .out(mux2_wire)
);

Mux mux_3 (
    .sel(alu_op2_sel),
    .in_1(rs2_data),
    .in_2(sext_imme),
    .out(mux3_wire)
);

Mux mux_4 (
    .sel(jb_op1_sel),
    .in_1(rs1_data),
    .in_2(pc),
    .out(mux4_wire)
);

Mux mux_5 (
    .sel(wb_sel),
    .in_1(alu_out),
    .in_2(ld_data_f),
    .out(wb_data)
);

Reg_PC reg_pc (
    .clk(clk_m),
    .rst(rst_m),
    .next_pc(next_pc),
    .current_pc(pc)
);


endmodule