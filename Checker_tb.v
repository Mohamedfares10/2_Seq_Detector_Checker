module tb ();
reg clk_tb = 0; 
reg rst_n_tb ;
reg  [31:0] seq_1_tb = 32'b 1000_1011_1111_1000_1011_1101_1011_0001 ;
reg  [31:0] seq_2_tb = 32'b 1011_1011_1111_1000_1010_1110_1011_0001 ;
wire [1:0] mode_tb;
wire [3:0] result_tb;

topmodule dut (.clk(clk_tb),.rst_n(rst_n_tb),.seq1(seq_1_tb[31]),.seq2(seq_2_tb[31]),.mode(mode_tb),.result(result_tb));

always #10 clk_tb = !clk_tb;

initial begin
  rst_n_tb =0;
  #5
	rst_n_tb=1;
  #660
  $stop;
end
always @ (posedge clk_tb) begin
if (rst_n_tb) begin
seq_1_tb <= seq_1_tb << 1;
seq_2_tb <= seq_2_tb << 1;
end
end
initial begin
	$monitor ("time = %0t mode_tb = %d  result_tb= %d",$time,mode_tb,result_tb);
end
endmodule