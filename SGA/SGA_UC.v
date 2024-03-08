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
    output reg load_size,
    output reg clear_size,
    output reg count_size,
    output reg render_clr,
    output reg render_count,
    output reg register_apple,
    output reg reset_apple,
    output reg finished,
    output reg won,
    output reg lost, 
    output reg [4:0] db_state
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
            RENDERIZA:              Enext = render_finish ? ESPERA : ATUALIZA_MEMORIA;
            ATUALIZA_MEMORIA:       Enext = PROXIMO_RENDER;
            PROXIMO_RENDER:         Enext = RENDERIZA;
            ESPERA:                 Enext = end_play_time ? REGISTRA : ESPERA;
            REGISTRA:               Enext = MOVE;
            MOVE:                   Enext = COMPARA;
            COMPARA:                Enext = is_at_apple ? GANHOU : FEZ_NADA;
            PAUSOU:                 Enext = start ? ESPERA : PAUSOU;
            FEZ_NADA:               Enext = RENDERIZA;
            GANHOU:                 Enext = start ? PREPARA : GANHOU;
            default:                Enext = IDLE;
        endcase
    end

    // Logica de saida (maquina Moore)
    always @* begin
        load_size      = (Ecurrent == IDLE || Ecurrent == PREPARA) ? 1'b1 : 1'b0;
        clear_size     = (Ecurrent == IDLE) ? 1'b1 : 1'b0;
        count_size     = (Ecurrent == CRESCE) ? 1'b1 : 1'b0;
        render_clr     = (Ecurrent == IDLE) ? 1'b1 : 1'b0;
        render_count   = (Ecurrent == PROXIMO_RENDER) ? 1'b1 : 1'b0;
        register_apple = (Ecurrent == GERA_MACA || Ecurrent == GERA_MACA_INICIAL) ? 1'b1 : 1'b0;
        reset_apple    = (Ecurrent == COMEU_MACA);
        finished       = (Ecurrent == GANHOU || Ecurrent == PERDEU) ? 1'b1 : 1'b0;
        won            = (Ecurrent == GANHOU) ? 1'b1 : 1'b0;
        lost           = (Ecurrent == PERDEU) ? 1'b1 : 1'b0;
        
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
            default           : db_state = 5'b00000;  // 0
        endcase
    end

endmodule