module intersectie (
    input clk_i,
    input reset_n_i
);
    wire timer_done;
    reg secventa_incheiata;
    reg [2:0] stare_curenta;
    wire [2:0] stare_N, stare_S, stare_E, stare_V;
    wire secventa_N, secventa_S, secventa_E, secventa_V;

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

//durata verde
reg [7:0] durata_verde;
always @(posedge clk_i or negedge reset_n_i)
if(~reset_n_i) durata_verde <= 22; else
case(directie_curenta)
 NORD:    durata_verde <= 17;
 SUD:     durata_verde <= 22;
 EST:     durata_verde <= 19;
 VEST:    durata_verde <= 20;
 default: durata_verde <= 22;
endcase

timer timer_inst (
    .clk_i_i       (clk_i        ),
    .reset_n_i     (reset_n_i    ),
    .stare_i       (stare_curenta),
    .durata_verde_i(durata_verde ),
    .timer_done_o  (timer_done   )
);

reg start_N, start_S, start_E, start_V;
//start_N
always @(posedge clk_i or negedge reset_n_i)
if(~reset_n_i) start_N <= 0; else
start_N <= (directie_curenta == NORD);

//start_S
always @(posedge clk_i or negedge reset_n_i)
if(~reset_n_i) start_S <= 0; else
start_S <= (directie_curenta == SUD);

//start_E
always @(posedge clk_i or negedge reset_n_i)
if(~reset_n_i) start_E <= 0; else
start_E <= (directie_curenta == EST);

//start_V
always @(posedge clk_i or negedge reset_n_i)
if(~reset_n_i) start_V <= 0; else
start_V <= (directie_curenta == VEST);

    
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

//stare_curenta
always @(posedge clk_i or negedge reset_n_i)
if(~reset_n_i) stare_curenta <= 3'b000; else
case(directie_curenta)
 NORD:    stare_curenta <= stare_N;
 SUD:     stare_curenta <= stare_S;
 EST:     stare_curenta <= stare_E;
 VEST:    stare_curenta <= stare_V;
 default: stare_curenta <= 3'b000;
endcase


semafor_directie semafor_N (
    .clk_i               (clk_i          ),
    .reset_n_i           (reset_n_i      ),
    .service_i           (0              ),
    .start_i             (start_N        ),
    .pietoni_btn_i       (0              ),
    .timer_done_i        (timer_done     ),
    .rosu_auto_o         (rosu_auto_N    ),
    .galben_auto_o       (galben_auto_N  ),
    .verde_auto_o        (verde_auto_N   ),
    .rosu_pietoni_o      (rosu_pietoni_N ),
    .verde_pietoni_o     (verde_pietoni_N),
    .secventa_incheiata_o(secventa_N     ),
    .stare_curenta_o     (stare_N        )
);
semafor_directie semafor_S (
    .clk_i               (clk_i          ),
    .reset_n_i           (reset_n_i      ),
    .service_i           (0              ),
    .start_i             (start_S        ),
    .pietoni_btn_i       (0              ),
    .timer_done_i        (timer_done     ),
    .rosu_auto_o         (rosu_auto_S    ),
    .galben_auto_o       (galben_auto_S  ),
    .verde_auto_o        (verde_auto_S   ),
    .rosu_pietoni_o      (rosu_pietoni_S ),
    .verde_pietoni_o     (verde_pietoni_S),
    .secventa_incheiata_o(secventa_S     ),
    .stare_curenta_o     (stare_S        )
);
semafor_directie semafor_E (
    .clk_i               (clk_i          ),
    .reset_n_i           (reset_n_i      ),
    .service_i           (0              ),
    .start_i             (start_E        ),
    .pietoni_btn_i       (0              ),
    .timer_done_i        (timer_done     ),
    .rosu_auto_o         (rosu_auto_E    ),
    .galben_auto_o       (galben_auto_E  ),
    .verde_auto_o        (verde_auto_E   ),
    .rosu_pietoni_o      (rosu_pietoni_E ),
    .verde_pietoni_o     (verde_pietoni_E),
    .secventa_incheiata_o(secventa_E     ),
    .stare_curenta_o     (stare_E        )
);
semafor_directie semafor_V (
    .clk_i               (clk_i          ),
    .reset_n_i           (reset_n_i      ),
    .service_i           (0              ),
    .start_i             (start_V        ),
    .pietoni_btn_i       (0              ),
    .timer_done_i        (timer_done     ),
    .rosu_auto_o         (rosu_auto_V    ),
    .galben_auto_o       (galben_auto_V  ),
    .verde_auto_o        (verde_auto_V   ),
    .rosu_pietoni_o      (rosu_pietoni_V ),
    .verde_pietoni_o     (verde_pietoni_V),
    .secventa_incheiata_o(secventa_V     ),
    .stare_curenta_o     (stare_V        )
);
endmodule