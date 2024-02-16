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
 input iniciar,
 input fim,
 input jogada,
 input igual,
 input timeout,
 output reg zeraC,
 output reg contaC,
 output reg zeraR,
 output reg registraR,
 output reg ganhou,
 output reg perdeu,
 output reg pronto,
 output reg contaCM,
 output reg db_timeout,
 output reg [3:0] db_estado
);

    // Define estados
    parameter inicial    = 4'b0000;  // 0
    parameter preparacao = 4'b0001;  // 1
    parameter espera     = 4'b0010;  // 2
    parameter registra   = 4'b0100;  // 4
    parameter comparacao = 4'b0101;  // 5
    parameter proximo    = 4'b0110;  // 6
	parameter fim_T      = 4'b1011;  // B
    parameter fim_E      = 4'b1110;  // E
	parameter fim_A      = 4'b1010;  // A

    // Variaveis de estado
    reg [3:0] Eatual, Eprox;

    // Memoria de estado
    always @(posedge clock or posedge reset) begin
        if (reset)
            Eatual <= inicial;
        else
            Eatual <= Eprox;
    end

    // Logica de proximo estado
    always @* begin
        case (Eatual)
            inicial:     Eprox = iniciar ? preparacao : inicial;
            preparacao:  Eprox = espera;
            espera:      Eprox = timeout ? fim_T : (jogada ? registra : espera);
            registra:    Eprox = comparacao;
            comparacao:  Eprox = !igual ? fim_E : (fim ? fim_A : proximo);
            proximo:     Eprox = espera;
			fim_T:       Eprox = iniciar ? preparacao: fim_T;
            fim_E:       Eprox = iniciar ? preparacao: fim_E;
			fim_A:       Eprox = iniciar ? preparacao: fim_A;
            default:     Eprox = inicial;
        endcase
    end

    // Logica de saida (maquina Moore)
    always @* begin
        zeraC      = (Eatual == inicial || Eatual == preparacao) ? 1'b1 : 1'b0;
        zeraR      = (Eatual == inicial || Eatual == preparacao) ? 1'b1 : 1'b0;
        registraR  = (Eatual == registra) ? 1'b1 : 1'b0;
        contaC     = (Eatual == proximo) ? 1'b1 : 1'b0;
        pronto     = (Eatual == fim_A || Eatual == fim_E || Eatual == fim_T) ? 1'b1 : 1'b0;
		db_timeout = (Eatual == fim_T) ? 1'b1 : 1'b0;
        ganhou     = (Eatual == fim_A) ? 1'b1 : 1'b0;
        perdeu     = (Eatual == fim_E || Eatual == fim_T) ? 1'b1 : 1'b0;
		contaCM    = (Eatual == espera) ? 1'b1 : 1'b0;

        // Saida de depuracao (estado)
        case (Eatual)
            inicial:     db_estado = 4'b0000;  // 0
            preparacao:  db_estado = 4'b0001;  // 1
            espera:      db_estado = 4'b0010;  // 2
            registra:    db_estado = 4'b0100;  // 4
            comparacao:  db_estado = 4'b0101;  // 5
            proximo:     db_estado = 4'b0110;  // 6
			fim_T:       db_estado = 4'b1011;  // B
            fim_E:       db_estado = 4'b1110;  // E
			fim_A:       db_estado = 4'b1010;  // A
            default:     db_estado = 4'b1111;  // F
        endcase
    end

endmodule