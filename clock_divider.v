module clock_divider (
    input clk_i    ,
    input reset_n_i,
    output reg clk_o
);

reg [31:0] counter;

parameter MAX = 5000000 - 1;

always @(posedge clk_i or negedge reset_n_i) 
if(~reset_n_i)     clk_o <=   1'b0; else
if(counter == MAX) clk_o <= ~clk_o; else
                   clk_o <= clk_o;


always @(posedge clk_i or negedge reset_n_i)
if(~reset_n_i)     counter <= 1'b0; else
if(counter == MAX) counter <= 1'b0; else
                   counter <= counter + 1;
        
    
endmodule