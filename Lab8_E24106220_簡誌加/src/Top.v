`include "./src/SRAM.v"
`include "./src/RegFile.v"
`include "./src/Adder.v"
`include "./src/ALU.v"
`include "./src/Controller.v"
`include "./src/Decoder.v"
`include "./src/Imm_Ext.v"
`include "./src/JB_Unit.v"
`include "./src/LD_Filter.v"
`include "./src/Mux2.v"
`include "./src/Mux3.v"
`include "./src/Reg_PC.v"
`include "./src/Reg_D.v"
`include "./src/Reg_E.v"
`include "./src/Reg_M.v"
`include "./src/Reg_W.v"

module Top (
    input clk_m,
    input rst_m
);

// Data Path
wire [31:0] pc_4;
wire [31:0] jb_pc;
wire [31:0] next_pc;
wire [31:0] pc;
wire [31:0] inst_im_out;
wire [31:0] pc_Dreg_out;
wire [31:0] inst_Dreg_out;
wire [23:0] D_inst;
// wire [4:0] rs1_index;
// wire [4:0] rs2_index;
wire [31:0] sext_imme;
wire [31:0] rs1_data;
wire [31:0] rs2_data;
wire [31:0] mux2_wire;
wire [31:0] mux3_wire;
wire [31:0] pc_Ereg_out;
wire [31:0] rs1_data_Ereg_out;
wire [31:0] rs2_data_Ereg_out;
wire [31:0] sext_imme_Ereg_out;
wire [31:0] mux4_wire;
wire [31:0] mux5_wire;
wire [31:0] mux6_wire;
wire [31:0] mux7_wire;
wire [31:0] mux8_wire;
wire [31:0] alu_out;
wire [31:0] alu_Mreg_out;
wire [31:0] rs2_data_Mreg_out;
wire [31:0] ld_data_dm_out;
wire [31:0] alu_Wreg_out;
wire [31:0] ld_data_Wreg_out;
wire [31:0] ld_data_f;
wire [31:0] wb_data;

// Control Path
wire stall;
wire next_pc_sel;
wire [3:0] F_im_w_en;
wire D_rs1_data_sel;
wire D_rs2_data_sel;
wire [1:0] E_rs1_data_sel;
wire [1:0] E_rs2_data_sel;
wire E_jb_op1_sel;
wire E_alu_op1_sel;
wire E_alu_op2_sel;
wire [4:0] E_op;
wire [2:0] E_f3;
wire E_f7;
wire [3:0] M_dm_w_en;
wire W_wb_en;
wire [4:0] W_rd_index;
wire [2:0] W_f3;
wire W_wb_data_sel;

SRAM im (
    .clk(clk_m),
    .w_en(F_im_w_en),
    .address(pc[15:0]),
    .write_data(32'd0),
    .read_data(inst_im_out)
);

SRAM dm (
    .clk(clk_m),
    .w_en(M_dm_w_en),
    .address(alu_Mreg_out[15:0]),
    .write_data(rs2_data_Mreg_out),
    .read_data(ld_data_dm_out)
);

RegFile regfile (
    .clk(clk_m),
    .wb_en(W_wb_en),
    .wb_data(wb_data),
    .rd_index(W_rd_index),
    .rs1_index(D_inst[14:10]),
    .rs2_index(D_inst[9:5]),
    .rs1_data_out(rs1_data),
    .rs2_data_out(rs2_data)
);

Adder adder (
    .pc(pc),
    .next_pc(pc_4)
);

ALU alu (
    .opcode(E_op),
    .func3(E_f3),
    .func7(E_f7),
    .operand1(mux6_wire),
    .operand2(mux7_wire),
    .alu_out(alu_out)
);

Controller controller (
    .clk(clk_m),
    .rst(rst_m),
    .opcode(D_inst[23:19]),
    .func3(D_inst[18:16]),
    .func7(D_inst[15]),
    .rs1_index(D_inst[14:10]),
    .rs2_index(D_inst[9:5]),
    .rd_index(D_inst[4:0]),
    .alu_0(alu_out[0]),
    .stall(stall),
    .next_pc_sel(next_pc_sel),
    .F_im_w_en(F_im_w_en),
    .D_rs1_data_sel(D_rs1_data_sel),
    .D_rs2_data_sel(D_rs2_data_sel),
    .E_rs1_data_sel(E_rs1_data_sel),
    .E_rs2_data_sel(E_rs2_data_sel),
    .E_jb_op1_sel(E_jb_op1_sel),
    .E_alu_op1_sel(E_alu_op1_sel),
    .E_alu_op2_sel(E_alu_op2_sel),
    .E_op_o(E_op),
    .E_f3_o(E_f3),
    .E_f7_o(E_f7),
    .M_dm_w_en(M_dm_w_en),
    .W_wb_en(W_wb_en),
    .W_rd_index(W_rd_index),
    .W_f3_o(W_f3),
    .W_wb_data_sel(W_wb_data_sel)
);

Decoder decoder (
    .inst(inst_Dreg_out),
    .dc_out_opcode(D_inst[23:19]),
    .dc_out_func3(D_inst[18:16]),
    .dc_out_func7(D_inst[15]),
    .dc_out_rs1_index(D_inst[14:10]),
    .dc_out_rs2_index(D_inst[9:5]),
    .dc_out_rd_index(D_inst[4:0])
);

Imm_Ext imm_ext (
    .inst(inst_Dreg_out),
    .imm_ext_out(sext_imme)
);

JB_Unit jb_unit (
    .operand1(mux8_wire),
    .operand2(sext_imme_Ereg_out),
    .jb_out(jb_pc)
);

LD_Filter ld_filter (
    .func3(W_f3),
    .ld_data(ld_data_Wreg_out),
    .ld_data_f(ld_data_f)
);

Mux2 mux_1 ( // Mux2
    .sel(next_pc_sel),
    .in_1(jb_pc),
    .in_2(pc_4),
    .out(next_pc)
);

Mux2 mux_2 ( // Mux2
    .sel(D_rs1_data_sel),
    .in_1(rs1_data),
    .in_2(wb_data),
    .out(mux2_wire)
);

Mux2 mux_3 ( // Mux2
    .sel(D_rs2_data_sel),
    .in_1(rs2_data),
    .in_2(wb_data),
    .out(mux3_wire)
);

Mux3 mux_4 ( // Mux3
    .sel(E_rs1_data_sel),
    .in_1(wb_data),
    .in_2(alu_Mreg_out),
    .in_3(rs1_data_Ereg_out),
    .out(mux4_wire)
);

Mux3 mux_5 ( // Mux3
    .sel(E_rs2_data_sel),
    .in_1(wb_data),
    .in_2(alu_Mreg_out),
    .in_3(rs2_data_Ereg_out),
    .out(mux5_wire)
);

Mux2 mux_6 ( // Mux2
    .sel(E_alu_op1_sel),
    .in_1(mux4_wire),
    .in_2(pc_Ereg_out),
    .out(mux6_wire)
);

Mux2 mux_7 ( // Mux2
    .sel(E_alu_op2_sel),
    .in_1(mux5_wire),
    .in_2(sext_imme_Ereg_out),
    .out(mux7_wire)
);

Mux2 mux_8 ( // Mux2
    .sel(E_jb_op1_sel),
    .in_1(mux4_wire),
    .in_2(pc_Ereg_out),
    .out(mux8_wire)
);

Mux2 mux_9 ( // Mux2
    .sel(W_wb_data_sel),
    .in_1(alu_Wreg_out),
    .in_2(ld_data_f),
    .out(wb_data)
);

Reg_PC reg_pc (
    .clk(clk_m),
    .rst(rst_m),
    .stall(stall),
    .next_pc(next_pc),
    .current_pc(pc)
);

Reg_D reg_d (
    .clk(clk_m),
    .rst(rst_m),
    .pc_in(pc),
    .inst_in(inst_im_out),
    .stall(stall),
    .jb(next_pc_sel),
    .pc_out(pc_Dreg_out),
    .inst_out(inst_Dreg_out)
);

Reg_E reg_e (
    .clk(clk_m),
    .rst(rst_m),
    .pc_in(pc_Dreg_out),
    .rs1_data_in(mux2_wire),
    .rs2_data_in(mux3_wire),
    .sext_imm_in(sext_imme),
    .stall(stall),
    .jb(next_pc_sel),
    .pc_out(pc_Ereg_out),
    .rs1_data_out(rs1_data_Ereg_out),
    .rs2_data_out(rs2_data_Ereg_out),
    .sext_imm_out(sext_imme_Ereg_out)
);

Reg_M reg_m (
    .clk(clk_m),
    .rst(rst_m),
    .alu_out_in(alu_out),
    .rs2_data_in(mux5_wire),
    .alu_out_out(alu_Mreg_out),
    .rs2_data_out(rs2_data_Mreg_out)
);

Reg_W reg_w (
    .clk(clk_m),
    .rst(rst_m),
    .alu_out_in(alu_Mreg_out),
    .ld_data_in(ld_data_dm_out),
    .alu_out_out(alu_Wreg_out),
    .ld_data_out(ld_data_Wreg_out)
);


endmodule