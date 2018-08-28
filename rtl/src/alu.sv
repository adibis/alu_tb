module alu_top (
    input   wire            clk_i,
    input   wire            rst_i,
    input   wire    [31:0]  dataA_i,
    input   wire    [31:0]  dataB_i,
    input   wire    [ 2:0]  ALUCtrl_i,     // Operation code
    output  logic   [31:0]  ALUResult_o,
    output  logic           Zero_o
);

reg [31:0] temp_alu_result;
reg temp_zero;

always @(*) begin
    if (rst_i == 1'b1) begin
        temp_alu_result =  32'b0;
        temp_zero      =   1'b0;
    end else begin
        case (ALUCtrl_i)
            3'b010: // ADD
            begin
                temp_alu_result = dataA_i + dataB_i;
            end

            3'b110: // SUB
            begin
                temp_alu_result = dataA_i - dataB_i;
            end

            3'b000: // AND
            begin
                temp_alu_result = dataA_i & dataB_i;
            end

            3'b001: // OR
            begin
                temp_alu_result = dataA_i | dataB_i;
            end

            3'b011: // XOR
            begin
                temp_alu_result = dataA_i ^ dataB_i;
            end

            3'b100: // NOR
            begin
                temp_alu_result = ~(dataA_i | dataB_i);
            end

            3'b111: // SLT
            begin
                if ((dataA_i - dataB_i) < 0)
                    temp_alu_result = 32'b1;
                else
                    temp_alu_result = 32'b0;
            end

            default:
            begin
                temp_alu_result =  32'b0;
                temp_zero      =   1'b0;
            end
        endcase

        // The zero signal is mainly used by the branch
        if (temp_alu_result == 32'b0) begin
            temp_zero = 1'b1;
        end else begin
            temp_zero = 1'b0;
        end
    end // NOT reset

end // always

always @(posedge clk_i or posedge rst_i) begin
    if (rst_i == 1'b1) begin
        ALUResult_o <= 32'b0;
        Zero_o <= 1'b1;
    end else begin
        ALUResult_o <= temp_alu_result;
        Zero_o <= temp_zero;
    end
end // always

endmodule : alu_top
