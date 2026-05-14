module timer (
    input clk_i,
    input reset_n_i,
    input [2:0] stare_i,
    input [7:0] durata_verde_i,

    output reg timer_done_o
);
    parameter IDLE = 3'b000;
    parameter VERDE_AUTO = 3'b001;
    parameter GALBEN_AUTO = 3'b010;
    parameter PIETONI_VERDE = 3'b011;
    parameter PIETONI_CLIPIRE = 3'b100;
    parameter FINAL = 3'b101;

    reg [7:0] contor;
    reg [7:0] limita;
    reg [2:0] stare_anterioara;


//limita numarare
always @(posedge clk_i or negedge reset_n_i)
if(~reset_n_i)           limita <= 0; else
case (stare_i)
 VERDE_AUTO:      limita <= durata_verde_i;
 GALBEN_AUTO:     limita <= 2;
 PIETONI_VERDE:   limita <= 12;
 PIETONI_CLIPIRE: limita <= 8;
 default:         limita <= 0;
endcase

 

//stare_anterioara
always @(posedge clk_i or negedge reset_n_i) 
if(~reset_n_i) stare_anterioara <= IDLE; else
               stare_anterioara <= stare_i;


//contor
always @(posedge clk_i or negedge reset_n_i) 
if(~reset_n_i)                  contor <= 0; else
if(stare_i != stare_anterioara) contor <= 0; else
if(contor == limita - 1)        contor <= 0; else
                                contor <= contor + 1;


//timer_done_o
always @(posedge clk_i or negedge reset_n_i) 
if(~reset_n_i)                  timer_done_o <= 0; else
if(stare_i != stare_anterioara) timer_done_o <= 0; else
if(contor == limita - 1)        timer_done_o <= 1; else
                                timer_done_o <= 0;

endmodule