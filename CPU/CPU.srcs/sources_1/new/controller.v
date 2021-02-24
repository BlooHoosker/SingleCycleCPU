// Controller for processor that generates control signals
module controller   (input [5:0] opcode, funct,
                    input [4:0] shamt,
                    output [7:0] controlSignals,
                    output [3:0] ALUcontrol);
                    
    wire [1:0] ALUop;
    
    aluDecoder aluDecode(shamt, funct, ALUop, ALUcontrol);
    opcodeDecoder opDecode(opcode, controlSignals, ALUop);
        
endmodule

// Decoder of ALUop, funct and shamt to generate signals for ALU 
module aluDecoder   (input [4:0] shamt,
                    input [5:0] funct,
                    input [1:0] ALUop,
                    output reg [3:0] ALUcontrol);
    
    // Generates control signals for ALU, based on table from lecture                
    always @ (*) begin
        case(ALUop)
            0: ALUcontrol <= 2;
            1: ALUcontrol <= 3;
            2: begin
                case(funct)
                    6'b100000: ALUcontrol <= 2;
                    6'b100010: ALUcontrol <= 3;
                    6'b100100: ALUcontrol <= 0;
                    6'b100101: ALUcontrol <= 1;
                    6'b101010: ALUcontrol <= 4;
                    6'b000100: ALUcontrol <= 7;
                    6'b000110: ALUcontrol <= 8;
                    default: ALUcontrol <= 9; //6'b000111
                endcase
            end
            3: begin
                case (shamt)
                    0: ALUcontrol <= 5;
                    default: ALUcontrol <= 6;
                endcase
            end
        endcase
    end

endmodule

// Decoder of opecode part from instruction
module opcodeDecoder( input [5:0] opcode,
                    output reg [7:0] signals,
                    output reg [1:0] ALUop);
    
    // Generates signals for cpu and for ALUdecoder, based on table from lecture
    always@(*) begin
        case(opcode)
            6'b100011: begin
                signals <= 8'b10100100;
                ALUop <= 2'b00;
            end
            6'b101011: begin
                signals <= 8'b00101000; 
                ALUop <= 2'b00;
            end
            6'b000100: begin
                signals <= 8'b00010000;
                ALUop <= 2'b01;
            end
            6'b001000: begin
                signals <= 8'b10100000; 
                ALUop <= 2'b00;
            end
            6'b000011: begin
                signals <= 8'b10000010; 
                ALUop <= 2'b00;
            end
            6'b000111: begin
                signals <= 8'b00000001; 
                ALUop <= 2'b00;
            end
            6'b011111: begin
                signals <= 8'b11000000; 
                ALUop <= 2'b11;
            end
            6'b000010: begin
                signals <= 8'b00000010; 
                ALUop <= 2'b00;
            end
            default: begin
                signals <= 8'b11000000;
                ALUop <= 2'b10;
            end
        endcase
    end

endmodule