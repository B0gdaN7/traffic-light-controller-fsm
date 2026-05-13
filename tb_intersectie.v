module tb_intersectie;
    reg clk_i;
    reg reset_n_i;

intersectie uut(
    .clk_i(clk_i),
    .reset_n_i(reset_n_i)
);
    
initial begin
    clk_i = 0;
    forever #5 clk_i = ~clk_i;
end

//test
initial begin
    reset_n_i = 0;
    #20;

    reset_n_i = 1;

    //rulare suficient de lunga
    #3000;

    $stop;
end
endmodule