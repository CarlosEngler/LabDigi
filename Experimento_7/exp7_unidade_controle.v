// --------------------------------------------------------------------
// Arquivo   : circuito_exp5_tb-MODELO.vhd
// Projeto   : Experiencia 5 - Desenvolvimento de Projeto de 
//             Circuitos Digitais em FPGA
// --------------------------------------------------------------------
// Descricao : 
//          
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     14/01/2024  1.0     João Bassetti  versao inicial
//------------------------------------------------------------------
//

module exp7_unidade_controle (
 input clock,
 input reset,
 input jogar,
 input fim,
 input jogada,
 input jogada_correta,
 input enderecoIgualRodada,
 input timeout,
 input 2sec_reach,
 input halfsec_reach,
 output reg zeraCR,
 output reg contaCR,
 output reg zeraE,
 output reg contaE,
 output reg limpaRC,
 output reg registraRC,
 output reg zeraLeds,
 output reg registraLeds,
 output reg ganhou,
 output reg perdeu,
 output reg pronto,
 output reg contaT,
 output reg contaL,
 output reg db_timeout,
 output reg [4:0] db_estado,
 output reg ram_enable,
 output reg led_selector,
 output reg led_turn_off
);

    // Define estados
    parameter idle                = 5'b00000;  // 0
    parameter preparacao          = 5'b00001;  // 1
    parameter inicia_rodada       = 5'b00010;  // 2
    parameter espera              = 5'b00011;  // 3
    parameter registra            = 5'b00100;  // 4
    parameter comparacao          = 5'b00101;  // 5
    parameter proxima_jogada      = 5'b00110;  // 6
    parameter ultima_jogada       = 5'b00111;  // 7
    parameter proxima_rodada      = 5'b01000;  // 8
	parameter write_enable        = 5'b01001;  // 9
	parameter fim_A               = 5'b01010;  // A
    parameter atualiza_memoria    = 5'b01011;  // B
    parameter show_first_play       = 5'b01100;  // C
	parameter fim_T               = 5'b01101;  // D
    parameter fim_E               = 5'b01110;  // E
    parameter show_last_play     = 5'b01111;  // F
    parameter show_correct_play     = 5'b10001;  // H
    parameter show_wrong_play     = 5'b10000;  // G

    // Variaveis de estado
    reg [4:0] Eatual, Eprox;

    // Memoria de estado
    always @(posedge clock or posedge reset) begin
        if (reset)
            Eatual <= idle;
        else
            Eatual <= Eprox;
    end

    // Logica de proximo estado
    always @* begin
        case (Eatual)
            idle:               Eprox = jogar ? preparacao : idle;
            preparacao:         Eprox = show_first_play;
			show_first_play:      Eprox = 2sec_reach ? espera : show_first_play;
            inicia_rodada:      Eprox = show_last_play;
            show_last_play:    Eprox = halfsec_reach ? espera : show_last_play;
            espera:             Eprox = timeout ? fim_T : (jogada ? registra : espera);
            registra:           Eprox = atualiza_memoria;
            atualiza_memoria:   Eprox = comparacao;
            comparacao:         Eprox = !jogada_correta ? show_wrong_play : (enderecoIgualRodada ? show_correct_play : proxima_jogada);
            show_correct_play:    Eprox = halfsec_reach ? ultima_jogada : show_correct_play;
            show_wrong_play:    Eprox = halfsec_reach ? fim_E : show_wrong_play;
            proxima_jogada:     Eprox = show_last_play;
            ultima_jogada:      Eprox = fim ? fim_A : (jogada ? proxima_rodada : ultima_jogada);
            proxima_rodada:     Eprox = write_enable;
			write_enable:       Eprox = inicia_rodada;
			fim_T:              Eprox = jogar ? preparacao : fim_T;
            fim_E:              Eprox = jogar ? preparacao : fim_E;
			fim_A:              Eprox = jogar ? preparacao : fim_A;
            default:            Eprox = idle;
        endcase
    end

    // Logica de saida (maquina Moore)
    always @* begin
        zeraCR        = (Eatual == idle || Eatual == preparacao) ? 1'b1 : 1'b0;
        zeraE         = (Eatual == idle || Eatual == preparacao || Eatual == inicia_rodada) ? 1'b1 : 1'b0;
        limpaRC       = (Eatual == idle || Eatual == preparacao) ? 1'b1 : 1'b0;
        registraRC    = (Eatual == registra || Eatual == proxima_rodada) ? 1'b1 : 1'b0;
        zeraLeds      = (Eatual == idle) ? 1'b1 : 1'b0;
        registraLeds  = (Eatual == registra || Eatual == preparacao || Eatual == espera) ? 1'b1 : 1'b0;
        contaCR       = (Eatual == proxima_rodada) ? 1'b1 : 1'b0;
        contaE        = (Eatual == proxima_jogada || Eatual == proxima_rodada) ? 1'b1 : 1'b0;
        pronto        = (Eatual == fim_A || Eatual == fim_E || Eatual == fim_T) ? 1'b1 : 1'b0;
		db_timeout    = (Eatual == fim_T) ? 1'b1 : 1'b0;
        ganhou        = (Eatual == fim_A) ? 1'b1 : 1'b0;
        perdeu        = (Eatual == fim_E || Eatual == fim_T) ? 1'b1 : 1'b0;
		contaT        = (Eatual == espera) ? 1'b1 : 1'b0;
        contaL        = (Eatual == show_correct_play || Eatual == show_last_play || Eatual == show_first_play || Eatual == show_wrong_play) ? 1'b1 : 1'b0;
		ram_enable    = (Eatual == write_enable) ? 1'b1 : 1'b0;
        led_selector  = (Eatual == inicia_rodada || Eatual == proxima_rodada || Eatual == preparacao || Eatual == idle) ? 1'b1 : 1'b0;
        led_turn_off  = (Eatual == espera || Eatual == ultima_jogada || Eatual == fim_A || Eatual == fim_E) ? 1'b1 : 1'b0;

        // Saida de depuracao (estado)
        case (Eatual)
            idle:              db_estado = 5'b00000;  // 0
            preparacao:        db_estado = 5'b00001;  // 1
            inicia_rodada:     db_estado = 5'b00010;  // 2
            espera:            db_estado = 5'b00011;  // 3
            registra:          db_estado = 5'b00100;  // 4
            comparacao:        db_estado = 5'b00101;  // 5
            proxima_jogada:    db_estado = 5'b00110;  // 6
            ultima_jogada:     db_estado = 5'b00111;  // 7
            proxima_rodada:    db_estado = 5'b01000;  // 8
            write_enable:      db_estado = 5'b01001;  // 9
            fim_A:             db_estado = 5'b01010;  // A
            atualiza_memoria:  db_estado = 5'b01011;  // B
            show_first_play:     db_estado = 5'b01100;  // C
            fim_T:             db_estado = 5'b01101;  // D
            fim_E:             db_estado = 5'b01110;  // E
            show_last_play:   db_estado = 5'b01111;  // F
            show_wrong_play:   db_estado = 5'b10000;  // G
            show_correct_play:   db_estado = 5'b10001;  // H
            default:           db_estado = 5'b00000;  // 0
        endcase
    end

endmodule