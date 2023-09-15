module shift_reg (
input  clk, rst_n, SI,
output reg [3:0] out_shift
	);
always @(posedge clk , negedge rst_n) begin
	if (!rst_n) begin
		out_shift <= 0;
		
	end
	else begin
		out_shift <= {out_shift[2:0],SI} ;
	end
end

endmodule


module seq_det (
input  clk, rst_n, newBit,
output reg  ok,
output wire [3:0] out_seq
	);
reg [2:0] current_state, next_state;
parameter A = 0;
parameter B = 1;
parameter C = 2;
parameter D = 3;
parameter E = 4;

shift_reg S_R (.clk(clk),.rst_n(rst_n),.SI(newBit),.out_shift(out_seq));

always @(posedge clk , negedge rst_n) begin
	if (!rst_n) begin
		current_state <= A;
		
	end
	else begin
		current_state <= next_state ;
	end
end

always @(*) begin
case (current_state) 
A: begin
   if (newBit) begin 
    next_state = B;
   end
   else  begin 
    next_state = A;
   end
   end

B: begin
   if (newBit) begin 
    next_state = B;
   end
   else begin 
    next_state = C;
   end
   end

C: begin
   if (newBit) begin 
    next_state = D;
   end
   else begin 
    next_state = A;
   end
   end

D: begin
   if (newBit) begin 
    next_state = E;
   end
   else begin 
    next_state = C;
   end
   end      
E: begin
   if (newBit) begin 
    next_state = B;
   end
   else begin 
    next_state = C;
   end
   end     
endcase
end

always @(*) begin
case (current_state) 
A: ok = 0;
B: ok = 0;
C: ok = 0;
D: ok = 0;
E: ok = 1;
endcase
end
endmodule


module cheker( 
input [3:0] n1, n2,
input ok1, ok2,
output [1:0] mode,
output [3:0] result
	);
assign mode   = (ok1 && ok2)? 2:(ok1 || ok2)? 1:0 ;
assign result = n1 ^ n2;

endmodule	

module topmodule(
input clk, rst_n,
input seq1, seq2,
output [1:0] mode,
output [3:0] result
	);
wire  ok1, ok2;
wire [3:0] n1, n2;

seq_det seq_1 (.clk(clk),.rst_n(rst_n),.newBit(seq1),.ok(ok1),.out_seq(n1));
seq_det seq_2 (.clk(clk),.rst_n(rst_n),.newBit(seq2),.ok(ok2),.out_seq(n2));
cheker  chek  (.n1(n1),.n2(n2),.ok1(ok1),.ok2(ok2),.mode(mode),.result(result));

endmodule