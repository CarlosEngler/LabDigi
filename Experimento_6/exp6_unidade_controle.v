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

module exp6_unidade_controle (
 input clock,
 input reset,
 input jogar,
 input fim,
 input jogada,
 input jogada_correta,
 input enderecoIgualRodada,
 input timeout,
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
 output reg db_timeout,
 output reg [3:0] db_estado,
 output reg led_selector
);

    // Define estados
    parameter idle              = 4'b0000;  // 0
    parameter preparacao        = 4'b0001;  // 1
    parameter inicio            = 4'b0010;  // 2
    parameter espera            = 4'b0011;  // 3
    parameter registra          = 4'b0100;  // 4
    parameter comparacao        = 4'b0101;  // 5
    parameter proxima_jogada    = 4'b0110;  // 6
    parameter ultima_jogada     = 4'b0111;  // 7
    parameter proxima_rodada    = 4'b1000;  // 8
	parameter fim_A             = 4'b1010;  // A
    parameter atualiza_memoria  = 4'b1011;  // B
	parameter fim_T             = 4'b1101;  // D
    parameter fim_E             = 4'b1110;  // E

    // Variaveis de estado
    reg [3:0] Eatual, Eprox;

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
            preparacao:         Eprox = inicio;
            inicio:             Eprox = espera;
            espera:             Eprox = timeout ? fim_T : (jogada ? registra : espera);
            registra:           Eprox = atualiza_memoria;
            atualiza_memoria:   Eprox = comparacao;
            comparacao:         Eprox = !jogada_correta ? fim_E : (enderecoIgualRodada ? ultima_jogada : proxima_jogada);
            proxima_jogada:     Eprox = espera;
            ultima_jogada:      Eprox = fim ? fim_A : proxima_rodada;
            proxima_rodada:     Eprox = inicio;
			fim_T:              Eprox = jogar ? preparacao : fim_T;
            fim_E:              Eprox = jogar ? preparacao : fim_E;
			fim_A:              Eprox = jogar ? preparacao : fim_A;
            default:            Eprox = idle;
        endcase
    end

    // Logica de saida (maquina Moore)
    always @* begin
        zeraCR        = (Eatual == idle || Eatual == preparacao) ? 1'b1 : 1'b0;
        zeraE         = (Eatual == idle || Eatual == preparacao || Eatual == inicio) ? 1'b1 : 1'b0;
        limpaRC       = (Eatual == idle || Eatual == preparacao) ? 1'b1 : 1'b0;
        registraRC    = (Eatual == registra) ? 1'b1 : 1'b0;
        zeraLeds      = (Eatual == idle || Eatual == preparacao) ? 1'b1 : 1'b0;
        registraLeds  = (Eatual == registra || Eatual == inicio) ? 1'b1 : 1'b0;
        contaCR       = (Eatual == proxima_rodada) ? 1'b1 : 1'b0;
        contaE        = (Eatual == proxima_jogada) ? 1'b1 : 1'b0;
        pronto        = (Eatual == fim_A || Eatual == fim_E || Eatual == fim_T) ? 1'b1 : 1'b0;
		db_timeout    = (Eatual == fim_T) ? 1'b1 : 1'b0;
        ganhou        = (Eatual == fim_A) ? 1'b1 : 1'b0;
        perdeu        = (Eatual == fim_E || Eatual == fim_T) ? 1'b1 : 1'b0;
		contaT        = (Eatual == espera) ? 1'b1 : 1'b0;
        led_selector  = (Eatual == inicio || Eatual == preparacao || Eatual == proxima_rodada) ? 1'b1 : 1'b0;

        // Saida de depuracao (estado)
        case (Eatual)
            idle:              db_estado = 4'b0000;  // 0
            preparacao:        db_estado = 4'b0001;  // 1
            inicio:            db_estado = 4'b0010;  // 2
            espera:            db_estado = 4'b0011;  // 3
            registra:          db_estado = 4'b0100;  // 4
            comparacao:        db_estado = 4'b0101;  // 5
            proxima_jogada:    db_estado = 4'b0110;  // 6
            ultima_jogada:     db_estado = 4'b0111;  // 7
            proxima_rodada:    db_estado = 4'b1000;  // 8
	        fim_A:             db_estado = 4'b1010;  // A
            atualiza_memoria:  db_estado = 4'b1011;  // B
	        fim_T:             db_estado = 4'b1101;  // D
            fim_E:             db_estado = 4'b1110;  // E
            default:           db_estado = 4'b1111;  // F
        endcase
    end

endmodule