/module ic_4bit(
  input  logic clk, rst,
  input  logic [3:0] A,       // Operand A     
  input  logic [3:0] B,       // Operand B     
  input  logic [2:0] OP,      // Operation select     
  output logic [7:0] Y        // Result  
);      
  
  always @(posedge clk or negedge rst) begin 
    if (rst) begin
       case (OP)             
         3'b000: Y = A + B;       // ADD                         
         3'b001: Y = A - B;       // SUB (A - B)             
         3'b010: Y = A & B;       // AND              
         3'b011: Y = A | B;       // OR              
         3'b100: Y = A ^ B;       // XOR             
         3'b101: Y = ~A;          // NOT              
         3'b110: Y = A << 1;      // Logical shift left             
         3'b111: Y = A >> 1;      // Logical shift right              
         default: Y = 8'h00;        
       endcase
    end else begin Y = 8'h00; end
  end  
endmodule

