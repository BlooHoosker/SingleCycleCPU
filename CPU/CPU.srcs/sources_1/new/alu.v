// ALU
module alu (input [31:0] in0, in1, 
            input [3:0] op, 
            output reg [31:0] out, 
            output reg zero);
    reg of[3:0];
    reg [7:0] seg[3:0], tmp;
    always @ (*) begin
        case(op)
            0: out <= in0 & in1;
            1: out <= in0 | in1;
            2: out <= in0 + in1;
            3: out <= in0 - in1;
            4: out <= ($signed(in0) < $signed(in1)) ? 1 : 0;
            5: out <= {(in0[31:24]+in1[31:24]), (in0[23:16]+in1[23:16]), (in0[15:8]+in1[15:8]), (in0[7:0]+in1[7:0])};
            6: begin
                {of[0],tmp} <= in0[31:24]+in1[31:24];
                {of[1],tmp} <= in0[23:16]+in1[23:16];
                {of[2],tmp} <= in0[15:8]+in1[15:8];
                {of[3],tmp} <= in0[7:0]+in1[7:0];
                // First segment
                if (of[0]) begin
                    seg[0] <= {8{1'b1}};
                end
                else begin
                    seg[0] <= in0[31:24]+in1[31:24];
                end
                // Second segment
                if (of[1]) begin
                    seg[1] <= {8{1'b1}};
                end
                else begin
                    seg[1] <= in0[23:16]+in1[23:16];
                end
                // Third segment
                if (of[2]) begin
                    seg[2] <= {8{1'b1}};
                end
                else begin
                    seg[2] <= in0[15:8]+in1[15:8];
                end
                // Fourth segment
                if (of[3]) begin
                    seg[3] <= {8{1'b1}};
                end
                else begin
                    seg[3] <= in0[7:0]+in1[7:0];
                end
                out <= {seg[0], seg[1], seg[2], seg[3]};
            end
            7: out <= in1 << in0;
            8: out <= in1 >> in0;
            default: out <= $signed(in1) >>> in0;
        endcase
        
        if ((in0 - in1) == 0) 
            zero <= 1;
        else
            zero <= 0;
    end     
endmodule

