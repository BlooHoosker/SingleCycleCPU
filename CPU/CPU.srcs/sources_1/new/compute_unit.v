module processor( input         clk, reset,
                  output [31:0] PC,
                  input  [31:0] instruction,
                  output        WE,
                  output [31:0] address_to_mem,
                  output [31:0] data_to_mem,
                  input  [31:0] data_from_mem
                );
    wire [31:0] PCnext, PCout, PCjal, PCbranch, PCplus4, RD1out, RD2out, result, WD3In,
                signImm, ALUout, ALUsrcOut, multBy4Out;
                
    wire [7:0] controlSignals;
    
    wire [4:0] Rt, Rd, writeReg, A3In;
    
    wire [2:0] PCsrcSel;
    
    wire [3:0] ALUop;
    
    wire PCsrcJr, PCsrcJal, PCsrcBeq, regWrite, regDst, ALUsrc, memWrite, memToReg, zero;

    // Internal assignments
    assign PCsrcSel = {PCsrcJr, PCsrcJal, PCsrcBeq};
    assign Rt = instruction[20:16];
    assign Rd = instruction[15:11];
    assign PCjal = {PCplus4[31:28], instruction[25:0], 2'b00};
    
    assign regWrite =   controlSignals[7];
    assign regDst =     controlSignals[6];
    assign ALUsrc =     controlSignals[5];
    assign PCsrcBeq =   zero & controlSignals[4];
    assign memWrite =   controlSignals[3];
    assign memToReg =   controlSignals[2];
    assign PCsrcJal =   controlSignals[1];
    assign PCsrcJr =    controlSignals[0];
    
    // Assignments to output of processor
    assign PC = PCout;
    assign address_to_mem = ALUout;
    assign data_to_mem = RD2out;
    assign WE = memWrite;
    
    controller controller_inst  (instruction[31:26] ,instruction[5:0], instruction[10:6],
                                controlSignals, ALUop);
    
    // Unit that contains all registers we will be using
    gprSet gprRegisters (clk, reset, regWrite,
                        instruction[25:21], instruction[20:16], A3In,
                        WD3In,
                        RD1out, RD2out);
                        
    // ALU
    alu ALUmodule   (RD1out, ALUsrcOut,
                    ALUop,
                    ALUout,
                    zero);
          
    // Program counter      
    pc pcReg    (clk, reset, 
                PCnext, 
                PCout);
                
    // Adder for basic program counter
    adder plus4Adder    (PCout, 4, 
                        PCplus4);
    
    // Adder for when we want to jump to a branch               
    adder plus4AdderBranch  (multBy4Out, PCplus4,
                            PCbranch);
     
    // Multiplexors                       
    mux4 #(32) pcSrcToPcMux     (RD1out, PCjal, PCbranch, PCplus4,
                                PCsrcSel,
                                PCnext);
    mux2 #(32) pcSrcJalToWD3Mux (result, PCplus4,
                                PCsrcJal, 
                                WD3In);
    mux2 #(32) aluSrcToAluMux   (RD2out, signImm,
                                ALUsrc,
                                ALUsrcOut);
    mux2 #(32) srcToReg         (ALUout, data_from_mem,
                                memToReg, 
                                result);
    mux2 #(5) pcSrcJalToA3Mux   (writeReg, 31, 
                                PCsrcJal, 
                                A3In);
    mux2 #(5) regDstToWriteRegMux   (Rt, Rd, 
                                    regDst,
                                    writeReg);
                                    
    // Sign extension from 16 -> 32
    signExt signExtImm  (instruction[15:0],
                        signImm);
    
    // Shift left by 2 so it multiplies value by 4
    multiply4 multBy4   (signImm,
                        multBy4Out);
endmodule

// Program counter
module pc(  input clk, reset, 
            input [31:0] in, 
            output reg [31:0] out
        );
        
    always@(posedge clk) begin
        if (reset) begin
            out <= 0;
        end
        else begin
            out <= in;
        end
        //$display ("PC value: %d", out);
    end   
endmodule

// Multiplexor for 2 inputs
module mux2  #(parameter bits = 32)
            (input [bits-1:0] in0, in1,
             input sel,
             output reg [bits-1:0] out);
    always@(*)
        if (sel)
            out <= in1;
        else
            out <= in0;           
endmodule

// Multiplexor for 4 inputs
module mux4  #(parameter bits = 32)
            (input [bits-1:0] in0, in1, in2, in3,
             input [2:0] sel,
             output reg [bits-1:0] out);
            
    always@(*)
        casez (sel)
           3'b100: out <= in0;
           3'b010: out <= in1;
           3'b001: out <= in2;
           default: out <= in3;
        endcase 
endmodule

// Sign extension from 16 -> 32
module signExt ( input [15:0] in, output [31:0] out);
    assign out = {{16{in[15]}}, in};
endmodule

// Multiply by 4
module multiply4(input [31:0] in, output [31:0] out);
    assign out = in << 2;
endmodule

// Adder for two values
module adder #(parameter bits = 32) (input [bits-1:0] in0, in1, output [bits-1:0] out);
    assign out = in0 + in1;
endmodule