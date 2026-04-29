
module semafor_directie(
    input clk_i,
    input reset_n_i,
    input service_i,
    input start_i,
    input pietoni_btn_i,
    input timer_done_i,

    output reg rosu_auto_o,
    output reg galben_auto_o,
    output reg verde_auto_o,

    output reg rosu_pietoni_o,
    output reg verde_pietoni_o,

    output reg secventa_incheiata_o,
    output [2:0] stare_curenta_o
);

// stari FSM
parameter IDLE = 3'b000;
parameter VERDE_AUTO = 3'b001;
parameter GALBEN_AUTO = 3'b010;
parameter PIETONI_VERDE = 3'b011;
parameter PIETONI_CLIPIRE = 3'b100;
parameter FINAL = 3'b101;

// registre stare
reg [2:0] stare_curenta;
reg cerere_pietoni;

always @(posedge clk_i or negedge reset_n_i) begin
if(~reset_n_i)             cerere_pietoni <= 0; else
if(pietoni_btn_i)          cerere_pietoni <= 1; else
if(stare_curenta == FINAL) cerere_pietoni <= 0;
end
    


always @(posedge clk_i or negedge reset_n_i) begin
if(~reset_n_i) stare_curenta <= IDLE; else
if (service_i) stare_curenta <= IDLE; else
    
case(stare_curenta)
    IDLE:        if(start_i)          stare_curenta <= VERDE_AUTO;
    VERDE_AUTO:  if(timer_done_i)     stare_curenta <= GALBEN_AUTO;
    GALBEN_AUTO: if(timer_done_i) 
                 if(cerere_pietoni)   stare_curenta <= PIETONI_VERDE; 
                 else                 stare_curenta <= FINAL;
    PIETONI_VERDE: if(timer_done_i)   stare_curenta <= PIETONI_CLIPIRE;
    PIETONI_CLIPIRE: if(timer_done_i) stare_curenta <= FINAL;
    FINAL:                            stare_curenta <= IDLE;
endcase
end

//Auto(output)
always @(posedge clk_i or negedge reset_n_i) begin
    if(~reset_n_i) rosu_auto_o <= 1  ;
                   galben_auto_o <= 0;
                   verde_auto_o <= 0 ; else
case (stare_curenta)
IDLE, FINAL: 
            rosu_auto_o <= 1  ;
            galben_auto_o <= 0;
            verde_auto_o <= 0 ;
VERDE_AUTO:
            rosu_auto_o <= 0  ;
            galben_auto_o <= 0;
            verde_auto_o <= 1 ;
GALBEN_AUTO:
            rosu_auto_o <= 0  ;
            galben_auto_o <= 1; 
            verde_auto_o <= 0 ;
    default: 
            rosu_auto_o <= 1  ;
            galben_auto_o <= 0;
            verde_auto_o <= 0 ;
endcase
end    

//Pietoni(output)
always @(posedge clk_i or negedge reset_n_i) begin
    if(~reset_n_i) rosu_pietoni_o <= 1  ;
                   verde_pietoni_o <= 0 ; else
case (stare_curenta)
PIETONI_VERDE:
            rosu_pietoni_o <= 0  ;
            verde_pietoni_o <= 1 ;
PIETONI_CLIPIRE:
            rosu_pietoni_o <= 0  ;
            verde_pietoni_o <= ~verde_pietoni_o ;
    default:
            rosu_pietoni_o <= 1  ;
            verde_pietoni_o <= 0 ;
endcase
end

//final flag
always @(posedge clk_i or negedge reset_n_i) begin
if(~reset_n_i)             secventa_incheiata_o <= 0; else
if(stare_curenta == FINAL) secventa_incheiata_o <= 1; else
                           secventa_incheiata_o <= 0;
end

assign stare_curenta_o = stare_curenta;
endmodule