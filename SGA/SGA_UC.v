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
    output reg clear_size,
    output reg count_size,
    output reg render_clr,
    output reg register_apple,
    output reg reset_apple,
    output reg finished,
    output reg won,
    output reg lost, 
    output reg [3:0] db_state
);

    // Define estados
    parameter IDLE              = 4'b0000;  // 0
    parameter PREPARA           = 4'b0001;  // 1
    parameter GERA_MACA_INICIAL = 4'b0010;  // 2
    parameter RENDERIZA         = 4'b0011;  // 3
    parameter ESPERA            = 4'b0100;  // 4
    parameter REGISTRA          = 4'b0101;  // 5
    parameter MOVE              = 4'b0110;  // 6
    parameter COMPARA           = 4'b0111;  // 7
    parameter COMEU_MACA        = 4'b1000;  // 8
    parameter CRESCE            = 4'b1001;  // 9
    parameter GERA_MACA         = 4'b1010;  // A
    parameter FEZ_NADA          = 4'b1100;  // C
    parameter PERDEU            = 4'b1101;  // D
    parameter GANHOU            = 4'b1110;  // E
    parameter PROXIMO_RENDER    = 4'b1111;  // F

    // Variaveis de estado
    reg [3:0] Ecurrent, Enext;

    // Memoria de estado
    always @(posedge clock or posedge restart) begin
        if (restart)
            Ecurrent <= IDLE;
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
            PROXIMO_RENDER:         Enext = RENDERIZA;
            ESPERA:                 Enext = end_play_time ? REGISTRA : ESPERA;
            REGISTRA:               Enext = MOVE;
            MOVE:                   Enext = COMPARA;
            COMPARA:                Enext = is_at_apple ? GANHOU : FEZ_NADA;
            FEZ_NADA:               Enext = RENDERIZA;
            GANHOU:                 Enext = start ? PREPARA : GANHOU;
            default:                Enext = IDLE;
        endcase
    end

    // Logica de saida (maquina Moore)
    always @* begin
        clear_size     = (Ecurrent == IDLE || Ecurrent == PREPARA) ? 1'b1 : 1'b0;
        count_size     = (Ecurrent == RENDERIZA) ? 1'b1 : 1'b0;
        render_clr     = (Ecurrent == IDLE) ? 1'b1 : 1'b0;
        register_apple = (Ecurrent == GERA_MACA || Ecurrent == GERA_MACA_INICIAL) ? 1'b1 : 1'b0;
        reset_apple    = (Ecurrent == COMEU_MACA);
        finished       = (Ecurrent == GANHOU || Ecurrent == PERDEU) ? 1'b1 : 1'b0;
        won            = (Ecurrent == GANHOU) ? 1'b1 : 1'b0;
        lost           = (Ecurrent == PERDEU) ? 1'b1 : 1'b0;
        
        // Saida de depuracao (estado)
        case (Ecurrent)
            IDLE              : db_state = 4'b0000;  // 0
            PREPARA           : db_state = 4'b0001;  // 1
            GERA_MACA_INICIAL : db_state = 4'b0010;  // 2
            RENDERIZA         : db_state = 4'b0011;  // 3
            ESPERA            : db_state = 4'b0100;  // 4
            REGISTRA          : db_state = 4'b0101;  // 5
            MOVE              : db_state = 4'b0110;  // 6
            COMPARA           : db_state = 4'b0111;  // 7
            COMEU_MACA        : db_state = 4'b1000;  // 8
            CRESCE            : db_state = 4'b1001;  // 9
            GERA_MACA         : db_state = 4'b1010;  // A
            FEZ_NADA          : db_state = 4'b1100;  // C
            PERDEU            : db_state = 4'b1101;  // D
            GANHOU            : db_state = 4'b1110;  // E
            PROXIMO_RENDER    : db_state = 4'b1111;  // F
            default           : db_state = 4'b0000;  // 0
        endcase
    end

endmodule