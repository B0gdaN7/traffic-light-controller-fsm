module reset_tb;

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

repeat(2) @(posedge clk_i);
reset_n_i = 1;

repeat(15) @(posedge clk_i);
reset_n_i = 0;

repeat(2) @(posedge clk_i);
reset_n_i = 1;

repeat(200) @(posedge clk_i);

$stop;
end

endmodule