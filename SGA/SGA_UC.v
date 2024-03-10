//------------------------------------------------------------------
// Arquivo   : SGA_UC.v
// Projeto   : Snake Game Arcade
//------------------------------------------------------------------
// Descricao : Unidade de controle            
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor                        Descricao
//     08/03/2024  1.0     Erick Sousa, João Basseti  versao inicial
//------------------------------------------------------------------
//

module SGA_UC (
    input      clock,
    input      restart, 
    input      start,
    input      pause,
    input      is_at_apple,
    input      is_at_border,
    input      is_at_body,
    input      end_play_time,
    input      render_finish,
    input      left,
    input      right,
    input      up,
    input      down,
    input      played,
    output reg load_size,
    output reg clear_size,
    output reg count_size,
    output reg render_clr,
    output reg render_count,
    output reg register_apple,
    output reg reset_apple,
    output reg register_head,
    output reg reset_head,
    output reg finished,
    output reg won,
    output reg lost, 
    output reg count_play_time,
    output reg [4:0] db_state,
    output reg [1:0] direction,
    output reg       we_ram,
    output reg       mux_ram,
    output reg       recharge
);

    // Define estados
    parameter IDLE              = 5'b00000;  // 0
    parameter PREPARA           = 5'b00001;  // 1
    parameter GERA_MACA_INICIAL = 5'b00010;  // 2
    parameter RENDERIZA         = 5'b00011;  // 3
    parameter ESPERA            = 5'b00100;  // 4
    parameter REGISTRA          = 5'b00101;  // 5
    parameter MOVE              = 5'b00110;  // 6
    parameter COMPARA           = 5'b00111;  // 7
    parameter COMEU_MACA        = 5'b01000;  // 8
    parameter CRESCE            = 5'b01001;  // 9
    parameter GERA_MACA         = 5'b01010;  // A
    parameter PAUSOU            = 5'b01011;  // B
    parameter FEZ_NADA          = 5'b01100;  // C
    parameter PERDEU            = 5'b01101;  // D
    parameter GANHOU            = 5'b01110;  // E
    parameter PROXIMO_RENDER    = 5'b01111;  // F
    parameter ATUALIZA_MEMORIA  = 5'b10000;  // G
    parameter ContaRAM          = 5'b10001;  // h
    parameter WriteRAM          = 5'b10010;  // i
    parameter ComparaRAM        = 5'b10011;  // j
    parameter RESETMATRIZ       = 5'b10100;  // j



    // direções
    // parameter          LEFT  = 2'b01,
    // parameter          UP    = 2'b11,
    // parameter          DOWN  = 2'b10,
    // parameter          RIGHT = 2'b00;

    // Variaveis de estado
    reg [4:0] Ecurrent, Enext;

    // Memoria de estado
    always @(posedge clock or posedge restart) begin
        if (restart)
            Ecurrent <= IDLE;
        else if (pause)
            Ecurrent <= PAUSOU;
        else
            Ecurrent <= Enext;
    end

    // Logica de proximo estado
    always @* begin
        case (Ecurrent)
            IDLE:                   Enext = start ? PREPARA : IDLE;
            PREPARA:                Enext = GERA_MACA_INICIAL;
            GERA_MACA_INICIAL:      Enext = RENDERIZA;
            RENDERIZA:              Enext = render_finish ? ESPERA : PROXIMO_RENDER;
            PROXIMO_RENDER:         Enext = ATUALIZA_MEMORIA;
            ATUALIZA_MEMORIA:       Enext = RENDERIZA;
            ESPERA:                 Enext = (end_play_time | played) ? REGISTRA : ESPERA;
            REGISTRA:               Enext = MOVE;
            MOVE:                   Enext = ContaRAM;
            ContaRAM:               Enext = WriteRAM;
            WriteRAM:               Enext = ComparaRAM;
            ComparaRAM:             Enext = render_finish ? COMPARA : MOVE;
            COMPARA:                Enext = FEZ_NADA;
            PAUSOU:                 Enext = start ? ESPERA : PAUSOU;
            FEZ_NADA:               Enext = RESETMATRIZ;
            RESETMATRIZ:            Enext = RENDERIZA;
            GANHOU:                 Enext = start ? PREPARA : GANHOU;
            default:                Enext = IDLE;
        endcase
    end

    // Logica de saida (maquina Moore)
    always @* begin
        load_size           = (Ecurrent == IDLE || Ecurrent == PREPARA) ? 1'b1 : 1'b0;
        clear_size          = (Ecurrent == IDLE) ? 1'b1 : 1'b0;
        count_size          = (Ecurrent == CRESCE) ? 1'b1 : 1'b0;
        recharge            = (Ecurrent == RESETMATRIZ) ? 1'b1 : 1'b0;
        render_clr          = (Ecurrent == IDLE || Ecurrent == ESPERA || Ecurrent == COMPARA) ? 1'b1 : 1'b0;
        render_count        = (Ecurrent == PROXIMO_RENDER || Ecurrent == ContaRAM) ? 1'b1 : 1'b0;
        register_apple      = (Ecurrent == GERA_MACA || Ecurrent == GERA_MACA_INICIAL) ? 1'b1 : 1'b0;
        reset_apple         = (Ecurrent == COMEU_MACA);
        register_head       = (Ecurrent == REGISTRA) ? 1'b1 : 1'b0;
        reset_head          = (Ecurrent == IDLE);
        finished            = (Ecurrent == GANHOU || Ecurrent == PERDEU) ? 1'b1 : 1'b0;
        won                 = (Ecurrent == GANHOU) ? 1'b1 : 1'b0;
        lost                = (Ecurrent == PERDEU) ? 1'b1 : 1'b0;
        count_play_time     = (Ecurrent == ESPERA) ? 1'b1 : 1'b0;
        we_ram              = (Ecurrent == WriteRAM || Ecurrent == ContaRAM || Ecurrent == FEZ_NADA) ? 1'b1 : 1'b0;
        mux_ram             = (Ecurrent == ContaRAM || Ecurrent == MOVE || Ecurrent == WriteRAM || Ecurrent == ComparaRAM) ? 1'b1 : 1'b0;

        if (restart) begin                      
        direction <= 2'b00;                    
        end else begin
        if (left && direction != 2'b00)  
            direction <= 2'b01;                   
        if (up && direction != 2'b10)     
            direction <= 2'b11;                     
        if (down && direction != 2'b11)     
            direction <= 2'b10;                   
        if (right && direction != 2'b01)  
            direction <= 2'b00;                  
        end
        
        // Saida de depuracao (estado)
        case (Ecurrent)
            IDLE              : db_state = 5'b00000;  // 0
            PREPARA           : db_state = 5'b00001;  // 1
            GERA_MACA_INICIAL : db_state = 5'b00010;  // 2
            RENDERIZA         : db_state = 5'b00011;  // 3
            ESPERA            : db_state = 5'b00100;  // 4
            REGISTRA          : db_state = 5'b00101;  // 5
            MOVE              : db_state = 5'b00110;  // 6
            COMPARA           : db_state = 5'b00111;  // 7
            COMEU_MACA        : db_state = 5'b01000;  // 8
            CRESCE            : db_state = 5'b01001;  // 9
            GERA_MACA         : db_state = 5'b01010;  // A
            PAUSOU            : db_state = 5'b01011;  // B
            FEZ_NADA          : db_state = 5'b01100;  // C
            PERDEU            : db_state = 5'b01101;  // D
            GANHOU            : db_state = 5'b01110;  // E
            PROXIMO_RENDER    : db_state = 5'b01111;  // F
            ATUALIZA_MEMORIA  : db_state = 5'b10000;  // G
            ContaRAM          : db_state = 5'b10001;  // G
            WriteRAM          : db_state = 5'b10010;  // h
            ComparaRAM        : db_state = 5'b10011;  // i
            RESETMATRIZ       : db_state = 5'b10100;  // j
            default           : db_state = 5'b00000;  // 0
        endcase
    end

endmodule