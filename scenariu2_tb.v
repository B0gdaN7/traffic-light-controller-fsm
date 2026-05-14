module scenariu2_tb;
reg clk_i;
reg reset_n_i;

intersectie UUT (
    .clk_i(clk_i),
    .reset_n_i(reset_n_i)
);

always #5 clk_i = ~clk_i;

initial begin
 clk_i = 0;
 reset_n_i = 0;

 UUT.pietoni_N = 0;
 UUT.pietoni_S = 0;
 UUT.pietoni_E = 0;
 UUT.pietoni_V = 0;

//reset
repeat(2) @(posedge clk_i);
reset_n_i = 1;

//sud
repeat(20) @(posedge clk_i);
UUT.pietoni_S = 1;

repeat(1) @(posedge clk_i);
UUT.pietoni_S = 0;
//asteptam secventa completa (22 verde +2 galben +12 +8)
repeat(30) @(posedge clk_i);

//nord
repeat(8) @(posedge clk_i);

UUT.pietoni_N = 1;

repeat(1) @(posedge clk_i);

UUT.pietoni_N = 0;
repeat(30) @(posedge clk_i);

//est
repeat(9) @(posedge clk_i);

UUT.pietoni_E = 1;

repeat(1) @(posedge clk_i);

UUT.pietoni_E = 0;

repeat(30) @(posedge clk_i);

//vest
repeat(10) @(posedge clk_i);
UUT.pietoni_V = 1;

repeat(1) @(posedge clk_i);

UUT.pietoni_V = 0;

repeat(40) @(posedge clk_i);

$stop;

end
    

endmodule