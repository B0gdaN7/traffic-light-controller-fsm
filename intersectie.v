module intersectie (
    input clk_i,
    input reset_n_i
);
    reg secventa_incheiata;
    reg service;

    wire secventa_N, secventa_S, secventa_E, secventa_V;
    reg pietoni_N, pietoni_S, pietoni_E, pietoni_V;

    wire rosu_auto_N, galben_auto_N, verde_auto_N;
    wire rosu_pietoni_N, verde_pietoni_N;

    wire rosu_auto_S, galben_auto_S, verde_auto_S;
    wire rosu_pietoni_S, verde_pietoni_S;

    wire rosu_auto_E, galben_auto_E, verde_auto_E;
    wire rosu_pietoni_E, verde_pietoni_E;

    wire rosu_auto_V, galben_auto_V, verde_auto_V;
    wire rosu_pietoni_V, verde_pietoni_V;



reg [1:0] directie_curenta;
parameter SUD  = 2'd0;
parameter NORD = 2'd1;
parameter EST  = 2'd2;
parameter VEST = 2'd3;

//schimbare directie
always @(posedge clk_i or negedge reset_n_i)begin
if(~reset_n_i)         directie_curenta <= SUD; else
if(secventa_incheiata) directie_curenta <= directie_curenta + 1; else
                       directie_curenta <= directie_curenta;
end

reg start_N, start_S, start_E, start_V;
//start_N
always @(*)
start_N = (directie_curenta == NORD);

//start_S
always @(*)
start_S = (directie_curenta == SUD);

//start_E
always @(*)
start_E = (directie_curenta == EST);

//start_V
always @(*)
start_V = (directie_curenta == VEST);

    
//secventa_incheiata 
always @(posedge clk_i or negedge reset_n_i)
if(~reset_n_i) secventa_incheiata <= 0; else
case(directie_curenta)
 NORD:   secventa_incheiata <= secventa_N;
 SUD:    secventa_incheiata <= secventa_S;
 EST:    secventa_incheiata <= secventa_E;
 VEST:   secventa_incheiata <= secventa_V;
default: secventa_incheiata <= 0;
endcase   


semafor_directie #(.DURATA_VERDE(17)) semafor_N (
    .clk_i               (clk_i          ),
    .reset_n_i           (reset_n_i      ),
    .service_i           (service        ),
    .start_i             (start_N        ),
    .pietoni_btn_i       (pietoni_N      ),
    .rosu_auto_o         (rosu_auto_N    ),
    .galben_auto_o       (galben_auto_N  ),
    .verde_auto_o        (verde_auto_N   ),
    .rosu_pietoni_o      (rosu_pietoni_N ),
    .verde_pietoni_o     (verde_pietoni_N),
    .secventa_incheiata_o(secventa_N     )
);
semafor_directie #(.DURATA_VERDE(22)) semafor_S (
    .clk_i               (clk_i          ),
    .reset_n_i           (reset_n_i      ),
    .service_i           (service        ),
    .start_i             (start_S        ),
    .pietoni_btn_i       (pietoni_S      ),
    .rosu_auto_o         (rosu_auto_S    ),
    .galben_auto_o       (galben_auto_S  ),
    .verde_auto_o        (verde_auto_S   ),
    .rosu_pietoni_o      (rosu_pietoni_S ),
    .verde_pietoni_o     (verde_pietoni_S),
    .secventa_incheiata_o(secventa_S     )
);
semafor_directie #(.DURATA_VERDE(19)) semafor_E (
    .clk_i               (clk_i          ),
    .reset_n_i           (reset_n_i      ),
    .service_i           (service        ),
    .start_i             (start_E        ),
    .pietoni_btn_i       (pietoni_E      ),
    .rosu_auto_o         (rosu_auto_E    ),
    .galben_auto_o       (galben_auto_E  ),
    .verde_auto_o        (verde_auto_E   ),
    .rosu_pietoni_o      (rosu_pietoni_E ),
    .verde_pietoni_o     (verde_pietoni_E),
    .secventa_incheiata_o(secventa_E     )
);
semafor_directie #(.DURATA_VERDE(20)) semafor_V (
    .clk_i               (clk_i          ),
    .reset_n_i           (reset_n_i      ),
    .service_i           (service        ),
    .start_i             (start_V        ),
    .pietoni_btn_i       (pietoni_V      ),
    .rosu_auto_o         (rosu_auto_V    ),
    .galben_auto_o       (galben_auto_V  ),
    .verde_auto_o        (verde_auto_V   ),
    .rosu_pietoni_o      (rosu_pietoni_V ),
    .verde_pietoni_o     (verde_pietoni_V),
    .secventa_incheiata_o(secventa_V     )
);

wire clk1_hz;

clock_divider#(
    .MAX(5000000 - 1)
)
div_fsm(
    .clk_i(clk_i),
    .reset_n_i(reset_n_i),
    .clk_o(clk1_hz)
);

endmodule