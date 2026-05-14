module semafor_directie#(
    parameter DURATA_VERDE = 20
)(
    input clk_i,
    input reset_n_i,
    input service_i,
    input start_i,
    input pietoni_btn_i,

    output reg rosu_auto_o,
    output reg galben_auto_o,
    output reg verde_auto_o,

    output reg rosu_pietoni_o,
    output reg verde_pietoni_o,

    output reg secventa_incheiata_o
);

// stari FSM
parameter IDLE = 3'b000;
parameter VERDE_AUTO = 3'b001;
parameter GALBEN_AUTO = 3'b010;
parameter PIETONI_VERDE = 3'b011;
parameter PIETONI_CLIPIRE = 3'b100;
parameter SERVICE = 3'b101;

// registre stare
reg [2:0] stare_curenta;
reg cerere_pietoni;
reg [7:0] timer;
reg start_anterior;


//memorare buton pietoni
always @(posedge clk_i or negedge reset_n_i)
if(~reset_n_i)             cerere_pietoni <= 0; else
if(pietoni_btn_i)          cerere_pietoni <= 1; else
if(stare_curenta == IDLE)  cerere_pietoni <= 0; else
                           cerere_pietoni <= cerere_pietoni;

always @(posedge clk_i or negedge reset_n_i)
if(~reset_n_i) start_anterior <= 0; else
if(service_i)  start_anterior <= 0; else             
               start_anterior <= start_i;
    
  

//FSM
always @(posedge clk_i or negedge reset_n_i)
if(~reset_n_i)                              stare_curenta <= IDLE; else
if(service_i)                               stare_curenta <= SERVICE; else
if(~start_i && stare_curenta != SERVICE)    stare_curenta <= IDLE; else   
case(stare_curenta)
 IDLE: if(start_i && ~start_anterior)       stare_curenta <= VERDE_AUTO; else
                                            stare_curenta <= IDLE;
 VERDE_AUTO:  if(timer == DURATA_VERDE - 1) stare_curenta <= GALBEN_AUTO; else
                                            stare_curenta <= VERDE_AUTO;
 GALBEN_AUTO: if(timer == 2 - 1)                 
              if(cerere_pietoni)            stare_curenta <= PIETONI_VERDE; else 
                                            stare_curenta <= IDLE; else
                                            stare_curenta <= GALBEN_AUTO;
 PIETONI_VERDE: if(timer == 12 - 1)         stare_curenta <= PIETONI_CLIPIRE; else
                                            stare_curenta <= PIETONI_VERDE;
 PIETONI_CLIPIRE: if(timer == 8 - 1)        stare_curenta <= IDLE; else
                                            stare_curenta <= PIETONI_CLIPIRE; 
 SERVICE: if(~service_i) 
          if(start_i)                       stare_curenta <= VERDE_AUTO; else
                                            stare_curenta <= IDLE; else
                                            stare_curenta <= SERVICE;                                                              
 default:                                   stare_curenta <= IDLE;
endcase

always @(posedge clk_i or negedge reset_n_i)
if(~reset_n_i)                             timer <= 0; else
case(stare_curenta)
 VERDE_AUTO: if(timer == DURATA_VERDE - 1) timer <= 0; else 
                                           timer <= timer + 1;
 GALBEN_AUTO:  if(timer == 2 - 1)          timer <= 0; else
                                           timer <= timer + 1;
 PIETONI_VERDE: if(timer == 12 - 1)        timer <= 0; else
                                           timer <= timer + 1; 
 PIETONI_CLIPIRE: if(timer == 8 - 1)       timer <= 0; else
                                           timer <= timer + 1;
 SERVICE:  if(~service_i)                  timer <= 0; else
                                           timer <= timer + 1;
 default:                                  timer <= 0;                                                                                                                         
endcase
    

always @(*)
case(stare_curenta)
 IDLE:        rosu_auto_o = 1;
 VERDE_AUTO:  rosu_auto_o = 0;
 GALBEN_AUTO: rosu_auto_o = 0;
 SERVICE:     rosu_auto_o = 0;
 default:     rosu_auto_o = 1;
endcase

always @(*) 
case (stare_curenta)
 GALBEN_AUTO: galben_auto_o = 1;
 SERVICE:     galben_auto_o = timer[0];
 default:     galben_auto_o = 0;
endcase 

always @(*)
case (stare_curenta)
 VERDE_AUTO: verde_auto_o = 1;
 default:    verde_auto_o = 0;
endcase


always @(*) begin
                                                    secventa_incheiata_o = 0;
case(stare_curenta)
 GALBEN_AUTO: if(timer == 2 - 1 && !cerere_pietoni) secventa_incheiata_o = 1;
 PIETONI_CLIPIRE: if(timer == 8 - 1)                secventa_incheiata_o = 1;
 default:                                           secventa_incheiata_o = 0;
endcase
end
    
always @(*)
case(stare_curenta)
 PIETONI_VERDE:   rosu_pietoni_o = 0;
 PIETONI_CLIPIRE: rosu_pietoni_o = 0;
 SERVICE:         rosu_pietoni_o = 0;
 default:         rosu_pietoni_o = 1;
endcase

always @(*)
case(stare_curenta)
 PIETONI_VERDE:   verde_pietoni_o = 1;
 PIETONI_CLIPIRE: verde_pietoni_o = timer[0];
 SERVICE:         verde_pietoni_o = timer[0];
 default:         verde_pietoni_o = 0;
endcase

endmodule