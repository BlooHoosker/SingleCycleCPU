// Set of 32 registers
module gprSet(  input clk, reset, we3, 
                input [4:0] a1, a2, a3, 
                input [31:0] wd3,
                output reg [31:0] rd1, rd2);
                
    reg [31:0] registers [31:0];
    
    integer i;

	always@(*)begin
		rd1 <= registers[a1];
		rd2 <= registers[a2];
	end   

    always@(posedge clk) begin
        
        if (reset) begin
            for (i = 0; i < 32; i = i + 1) begin
                registers[i] <= 0;
            end 
        end
	    else begin     
        	// if write-enable set write value to register
        	if (we3) begin
                if (a3 > 0) begin
                    registers[a3] <= wd3;
                end 
       		end
	    end	          
    end  
endmodule