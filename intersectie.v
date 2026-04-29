module intersectie (
    input clk_i,
    input reset_n_i
);
    wire clk_1Hz;
    wire timer_done;
    wire secventa_incheiata;
    wire [2:0] stare_curenta;
    wire [2:0] stare_N, stare_S, stare_E, stare_V;
    wire secventa_N, secventa_S, secventa_E, secventa_V;

clock_divider clk_div(
    .clk_i    (clk_i    ),
    .reset_n_i(reset_n_i),
    .clk_o    (clk_1Hz  )
);

reg [1:0] directie_curenta;
parameter NORD = 2'd0;
parameter SUD  = 2'd1;
parameter EST  = 2'd2;
parameter VEST = 2'd3;

//schimbare directie
always @(posedge clk_1Hz or negedge reset_n_i)
if(~reset_n_i)         directie_curenta <= NORD; else
if(secventa_incheiata) directie_curenta <= directie_curenta + 1;


//durata verde
reg [7:0] durata_verde;
always @(posedge clk_1Hz or negedge reset_n_i) begin
    case(directie_curenta)
                        NORD: durata_verde <= 17;
                        SUD:  durata_verde <= 22;
                        EST:  durata_verde <= 19;
                        VEST: durata_verde <= 20;
    endcase
end

timer timer_inst (
    .clk_1Hz_i     (clk_1Hz            ),
    .reset_n_i     (reset_n_i          ),
    .stare_i       (stare_curenta      ),
    .durata_verde_i(durata_verde       ),
    .timer_done_o  (timer_done         )
);

wire start_N, start_S, start_E, start_V;
assign start_N = (directie_curenta == NORD);
assign start_S = (directie_curenta == SUD);
assign start_E = (directie_curenta == EST);
assign start_V = (directie_curenta == VEST);

assign secventa_incheiata = 
    (directie_curenta == NORD) ? secventa_N :
    (directie_curenta == SUD)  ? secventa_S :
    (directie_curenta == EST)  ? secventa_E :
                                 secventa_V ;

assign stare_curenta = 
    (directie_curenta == NORD) ? stare_N :
    (directie_curenta == SUD)  ? stare_S :
    (directie_curenta == EST)  ? stare_E :
                                 stare_V ;

semafor_directie semafor_N (
    .clk_i               (clk_1Hz            ),
    .reset_n_i           (reset_n_i          ),
    .service_i           (0                  ),
    .start_i             (start_N            ),
    .pietoni_btn_i       (0                  ),
    .timer_done_i        (timer_done         ),
    .rosu_auto_o         (                   ),
    .galben_auto_o       (                   ),
    .verde_auto_o        (                   ),
    .rosu_pietoni_o      (                   ),
    .verde_pietoni_o     (                   ),
    .secventa_incheiata_o(secventa_N         ),
    .stare_curenta_o     (stare_N            )
);
semafor_directie semafor_S (
    .clk_i               (clk_1Hz            ),
    .reset_n_i           (reset_n_i          ),
    .service_i           (0                  ),
    .start_i             (start_S            ),
    .pietoni_btn_i       (0                  ),
    .timer_done_i        (timer_done         ),
    .rosu_auto_o         (                   ),
    .galben_auto_o       (                   ),
    .verde_auto_o        (                   ),
    .rosu_pietoni_o      (                   ),
    .verde_pietoni_o     (                   ),
    .secventa_incheiata_o(secventa_S         ),
    .stare_curenta_o     (stare_S            )
);
semafor_directie semafor_E (
    .clk_i               (clk_1Hz            ),
    .reset_n_i           (reset_n_i          ),
    .service_i           (0                  ),
    .start_i             (start_E            ),
    .pietoni_btn_i       (0                  ),
    .timer_done_i        (timer_done         ),
    .rosu_auto_o         (                   ),
    .galben_auto_o       (                   ),
    .verde_auto_o        (                   ),
    .rosu_pietoni_o      (                   ),
    .verde_pietoni_o     (                   ),
    .secventa_incheiata_o(secventa_E         ),
    .stare_curenta_o     (stare_E            )
);
semafor_directie semafor_V (
    .clk_i               (clk_1Hz            ),
    .reset_n_i           (reset_n_i          ),
    .service_i           (0                  ),
    .start_i             (start_V            ),
    .pietoni_btn_i       (0                  ),
    .timer_done_i        (timer_done         ),
    .rosu_auto_o         (                   ),
    .galben_auto_o       (                   ),
    .verde_auto_o        (                   ),
    .rosu_pietoni_o      (                   ),
    .verde_pietoni_o     (                   ),
    .secventa_incheiata_o(secventa_V         ),
    .stare_curenta_o     (stare_V            )
);
endmodule