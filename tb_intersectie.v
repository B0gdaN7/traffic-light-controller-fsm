module tb_intersectie;
    reg clk;
    reg reset;

intersectie uut(
    .clk_i(clk),
    .reset_n_i(reset)
);
    
initial clk = 0;
always #5 clk = ~clk;

initial begin
    reset = 0;
    #20;
    reset = 1;
end

initial begin
    #1000;
    $stop;
end
endmodule