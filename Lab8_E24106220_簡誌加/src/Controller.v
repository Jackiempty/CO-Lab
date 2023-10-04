module Controller(
    input       clk,
    input       rst,
    input [4:0] opcode,
    input [2:0] func3,
    input       func7,
    input [4:0] rs1_index,
    input [4:0] rs2_index,
    input [4:0] rd_index,
    input       alu_0,
    output reg       stall,
    output reg       next_pc_sel,
    output reg [3:0] F_im_w_en,
    output reg       D_rs1_data_sel,
    output reg       D_rs2_data_sel,
    output reg [1:0] E_rs1_data_sel,
    output reg [1:0] E_rs2_data_sel,
    output reg       E_jb_op1_sel,
    output reg       E_alu_op1_sel,
    output reg       E_alu_op2_sel,
    output reg [4:0] E_op_o,
    output reg [2:0] E_f3_o,
    output reg       E_f7_o,
    output reg [3:0] M_dm_w_en,
    output reg       W_wb_en,
    output reg [4:0] W_rd_index,
    output reg [2:0] W_f3_o,
    output reg       W_wb_data_sel
);

reg [4:0] E_op;
reg [2:0] E_f3;
reg [4:0] E_rd;
reg [4:0] E_rs1;
reg [4:0] E_rs2;
reg       E_f7;

reg [4:0] M_op;
reg [2:0] M_f3;
reg [4:0] M_rd;

reg [4:0] W_op;
reg [2:0] W_f3;
reg [4:0] W_rd;

always @(*)
begin
    F_im_w_en <= 4'b0000;
    E_op_o <= E_op;
    E_f3_o <= E_f3;
    E_f7_o <= E_f7;
    W_rd_index <= W_rd;
    W_f3_o <= W_f3;
end


reg is_D_use_rs1;
reg is_D_use_rs2;
reg is_E_use_rs1;
reg is_E_use_rs2;
reg is_W_use_rd;
reg is_M_use_rd;

assign is_D_use_rs1 = ((opcode == 5'b01100) || 
    (opcode == 5'b00000) || 
    (opcode == 5'b11001) || 
    (opcode == 5'b00100) ||
    (opcode == 5'b01000) ||
    (opcode == 5'b11000));

assign is_D_use_rs2 = ((opcode == 5'b01100) || 
    (opcode == 5'b01000) ||
    (opcode == 5'b11000));

assign is_E_use_rs1 = ((E_op == 5'b01100) || 
    (E_op == 5'b00000) || 
    (E_op == 5'b11001) || 
    (E_op == 5'b00100) ||
    (E_op == 5'b01000) ||
    (E_op == 5'b11000));

assign is_E_use_rs2 = ((E_op == 5'b01100) || 
    (E_op == 5'b01000) ||
    (E_op == 5'b11000));

assign is_W_use_rd = ((W_op == 5'b01100) || 
    (W_op == 5'b00000) || 
    (W_op == 5'b11001) || 
    (W_op == 5'b00100) ||
    (W_op == 5'b01101) ||
    (W_op == 5'b00101) || 
    (W_op == 5'b11011)); 

assign is_M_use_rd = ((M_op == 5'b01100) || 
    (M_op == 5'b00000) || 
    (M_op == 5'b11001) || 
    (M_op == 5'b00100) ||
    (M_op == 5'b01101) ||
    (M_op == 5'b00101) || 
    (M_op == 5'b11011));   


always @(*) // D_rs1_data_sel
begin
    if (is_D_use_rs1 && 
    is_W_use_rd && 
    (rs1_index == W_rd) && 
    (W_rd != 5'b00000))
    begin
        D_rs1_data_sel = 1'b1;
    end
    else 
    begin
        D_rs1_data_sel = 1'b0;
    end
end

always @(*) // D_rs2_data_sel
begin
    if (is_D_use_rs2 && 
    is_W_use_rd && 
    (rs2_index == W_rd) && 
    (W_rd != 5'b00000))
    begin
        D_rs2_data_sel = 1'b1;
    end
    else
    begin
        D_rs2_data_sel = 1'b0;
    end
end

reg is_E_rs1_W_rd_overlap;
reg is_E_rs1_M_rd_overlap;
reg is_E_rs2_W_rd_overlap;
reg is_E_rs2_M_rd_overlap;

always @(*) // is_E_rs1_W_rd_overlap
begin
    if (is_E_use_rs1 && 
    is_W_use_rd && 
    (E_rs1 == W_rd) && 
    (W_rd != 5'b00000))
    begin
        is_E_rs1_W_rd_overlap <= 1'b1;
    end
    else 
    begin
        is_E_rs1_W_rd_overlap <= 1'b0;
    end
end

always @(*) // is_E_rs1_M_rd_overlap
begin
    if (is_E_use_rs1 && 
    is_M_use_rd && 
    (E_rs1 == M_rd) && 
    (M_rd != 5'b00000))
    begin
        is_E_rs1_M_rd_overlap <= 1'b1;
    end
    else 
    begin
        is_E_rs1_M_rd_overlap <= 1'b0;
    end
end

always @(*) // is_E_rs2_W_rd_overlap
begin
    if (is_E_use_rs2 && 
    is_W_use_rd && 
    (E_rs2 == W_rd) && 
    (W_rd != 5'b00000))
    begin
        is_E_rs2_W_rd_overlap = 1'b1;
    end
    else
    begin
        is_E_rs2_W_rd_overlap = 1'b0;
    end
end

always @(*) //is_E_rs2_M_rd_overlap
begin
    if (is_E_use_rs2 && 
    is_M_use_rd && 
    (E_rs2 == M_rd) && 
    (M_rd != 5'b00000))
    begin
        is_E_rs2_M_rd_overlap = 1'b1;
    end
    else
    begin
        is_E_rs2_M_rd_overlap = 1'b0;
    end
end

always @(*) // E_rs1_data_sel
begin
    if (is_E_rs1_M_rd_overlap)
    begin
        E_rs1_data_sel <= 2'b01;
    end
    else 
    begin
        if (is_E_rs1_W_rd_overlap)
        begin
            E_rs1_data_sel <= 2'b00;
        end
        else
        begin
            E_rs1_data_sel <= 2'b10;
        end
    end
end

always @(*) // E_rs2_data_sel
begin
    if (is_E_rs2_M_rd_overlap)
    begin
        E_rs2_data_sel <= 2'b01;
    end
    else 
    begin
        if (is_E_rs2_W_rd_overlap)
        begin
            E_rs2_data_sel <= 2'b00;
        end
        else
        begin
            E_rs2_data_sel <= 2'b10;
        end
    end
end
/*
reg is_DE_overlap;
reg is_D_rs1_E_rd_overlap;
reg is_D_rs2_E_rd_overlap;
always @(*)
begin
    stall <= ((E_op == 5'b00000) && (is_DE_overlap));
end
assign is_DE_overlap = (is_D_rs1_E_rd_overlap || is_D_rs2_E_rd_overlap);

always @(*) 
begin
    is_D_rs1_E_rd_overlap <= (is_D_use_rs1 && (rs1_index == E_rd) && (E_rd != 5'd0));
    is_D_rs2_E_rd_overlap <= (is_D_use_rs2 && (rs2_index == E_rd) && (E_rd != 5'd0));
end
*/

always @(*)
begin
    if(E_op_o == 5'b00000)begin
        if(((opcode != 5'b01101 && opcode != 5'b00101 && opcode != 5'b11011) && (rs1_index == E_rd) && E_rd !=0) || 
        ((opcode == 5'b11000 || opcode == 5'b01000 || opcode == 5'b01100) && (rs2_index == E_rd) && (E_rd !=0)))
        begin
            stall = 1;
        end
        else begin
            stall = 0;
        end
    end
    else begin
        stall = 0;
    end
end


always @(rst)
begin
    stall <= 1'b0;
    next_pc_sel <= 1'b1; 
    F_im_w_en <= 4'b0000;
    D_rs1_data_sel <= 1'b0;
    D_rs2_data_sel <= 1'b0;
    E_rs1_data_sel <= 2'b00;
    E_rs2_data_sel <= 2'b00;
    E_jb_op1_sel <= 1'b0;
    E_alu_op1_sel <= 1'b0;
    E_alu_op2_sel <= 1'b0;
    E_op_o <= 5'b00000;
    E_f3_o <= 3'b000;
    E_f7_o <= 1'b0;
    M_dm_w_en <= 4'b0000;
    W_wb_en <= 1'b0;
    W_rd_index <= 5'b00000;
    W_f3_o <= 3'b000;
    W_wb_data_sel <= 1'b0;
end

always @(posedge clk)
begin
    if(stall == 1 || next_pc_sel == 0)begin
        E_op <= 0;
        E_f3  <= 0;
        E_rd     <= 0;
        E_rs1    <= 0;
        E_rs2    <= 0;
        E_f7  <= 0;
    end
    else begin
        E_op <= opcode;
        E_f3  <= func3;
        E_rd     <= rd_index;
        E_rs1    <= rs1_index;
        E_rs2    <= rs2_index;
        E_f7  <= func7;
    end
    M_op <= E_op;
    M_f3 <= E_f3;
    M_rd <= E_rd;
    W_op <= M_op;
    W_f3 <= M_f3;
    W_rd <= M_rd;
end

always @(*) // E control
begin
    case(E_op)
    5'b01101: // U lui
    begin
        next_pc_sel <= 1;
        E_alu_op2_sel <= 1;
    end
    5'b00101: // U auipc
    begin
        next_pc_sel <= 1;
        E_alu_op1_sel <= 1;
        E_alu_op2_sel <= 1;
    end
    5'b11011: // J jal
    begin
        next_pc_sel <= 0;
        E_jb_op1_sel <= 1;
        E_alu_op1_sel <= 1;
    end
    5'b11001: // I jalr
    begin
        next_pc_sel <= 0;
        E_jb_op1_sel <= 0;
        E_alu_op1_sel <= 1;
    end
    5'b11000: // B
    begin
        next_pc_sel <= ~alu_0;
        E_jb_op1_sel <= 1;
        E_alu_op1_sel <= 0;
        E_alu_op2_sel <= 0;
    end
    5'b00000: // I
    begin
        next_pc_sel <= 1;
        E_alu_op1_sel <= 0;
        E_alu_op2_sel <= 1;
    end
    5'b01000: // S
    begin
        next_pc_sel <= 1;
        E_alu_op1_sel <= 0;
        E_alu_op2_sel <= 1;
        case(E_f3)
        3'b000: // sb
        begin
            
        end
        3'b001: // sh
        begin
            
        end
        3'b010: // sw
        begin
            
        end
        endcase
    end
    5'b00100: // I
    begin
        next_pc_sel<= 1;
        E_alu_op1_sel <= 0;
        E_alu_op2_sel <= 1;
    end
    5'b01100: // R
    begin
        next_pc_sel<= 1;
        E_alu_op1_sel <= 0;
        E_alu_op2_sel <= 0;
    end
    endcase
end

always @(*) // M control
begin
    case(M_op)
    5'b01101: // U lui
    begin
        M_dm_w_en <= 4'b0000;
    end
    5'b00101: // U auipc
    begin
        M_dm_w_en <= 4'b0000;
    end
    5'b11011: // J jal
    begin
        M_dm_w_en <= 4'b0000;
    end
    5'b11001: // I jalr
    begin
       M_dm_w_en <= 4'b0000;
    end
    5'b11000: // B
    begin
        M_dm_w_en <= 4'b0000;
    end
    5'b00000: // I
    begin
        M_dm_w_en <= 4'b0000;
    end
    5'b01000: // S
    begin
        
        case(M_f3)
        3'b000: // sb
        begin
            M_dm_w_en <= 4'b0001;
        end
        3'b001: // sh
        begin
            M_dm_w_en <= 4'b0011;
        end
        3'b010: // sw
        begin
            M_dm_w_en <= 4'b1111;
        end
        endcase
    end
    5'b00100: // I
    begin
        M_dm_w_en <= 4'b0000;
    end
    5'b01100: // R
    begin
        M_dm_w_en <= 4'b0000;
    end
    endcase
end

always @(*) // W control
begin
    case(W_op)
    5'b01101: // U lui
    begin
        W_wb_en <= 1;
        W_wb_data_sel <= 0;
    end
    5'b00101: // U auipc
    begin
        W_wb_en <= 1;
        W_wb_data_sel <= 0;
    end
    5'b11011: // J jal
    begin
        W_wb_en <= 1;
        W_wb_data_sel <= 0;
    end
    5'b11001: // I jalr
    begin
       W_wb_en <= 1;
       W_wb_data_sel <= 0;
    end
    5'b11000: // B
    begin
        W_wb_en <= 0;
    end
    5'b00000: // I
    begin
        W_wb_en <= 1;
        W_wb_data_sel <= 1;
    end
    5'b01000: // S
    begin
        W_wb_en <= 0;
    end
    5'b00100: // I
    begin
        W_wb_en <= 1;
        W_wb_data_sel <= 0;
    end
    5'b01100: // R
    begin
        W_wb_en <= 1;
        W_wb_data_sel <= 0;
    end
    endcase
end

endmodule