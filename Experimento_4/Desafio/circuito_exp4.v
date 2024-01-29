/* --------------------------------------------------------------------
 * Arquivo   : exp4_fluxo_dados.v
 * Projeto   : Experiencia 4 - Projeto de uma Unidade de Controle
 * --------------------------------------------------------------------
 * Descricao : Fluxo de Dados
 *
 * --------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     27/01/2024  1.0     João Bassetti     versao inicial
 * --------------------------------------------------------------------
*/


module circuito_exp4 (
 input clock,
 input reset,
 input iniciar,
 input [3:0] chaves,
 output pronto,
 output acertou,
 output errou,
 output db_igual,
 output menor,
 output maior,
 output db_iniciar,
 output db_zeraC,
 output db_zeraR,
 output db_registraR,
 output db_contaC,
 output db_fimC,
 output [6:0] db_contagem,
 output [6:0] db_memoria,
 output [6:0] db_chaves,
 output [6:0] db_estado
);

wire w_fimC;
wire w_contaC;
wire w_zeraC;
wire w_zeraR;
wire w_registraR;
wire w_igual;
wire w_menor;
wire w_maior;
wire [3:0] s_estado;
wire [3:0] s_contagem;
wire [3:0] s_chaves;
wire [3:0] s_memoria;


	exp4_fluxo_dados FD(
    .clock(clock),
    .chaves(chaves),
    .zeraR(w_zeraR),
    .registraR(w_registraR),
    .contaC(w_contaC),
    .zeraC(w_zeraC),
    .chavesMaiorMemoria(w_menor),
    .chavesIgualMemoria(w_igual),
    .chavesMenorMemoria(w_maior),
    .fimC(w_fimC),
    .db_contagem(s_contagem),
    .db_chaves(s_chaves),
    .db_memoria(s_memoria)
);

	exp4_unidade_controle UC(
    .clock(clock),
    .reset(reset),
    .iniciar(iniciar),
    .fimC(w_fimC),
    .zeraC(w_zeraC),
    .contaC(w_contaC),
    .zeraR(w_zeraR),
    .registraR(w_registraR),
    .pronto(pronto),
    .igual(w_igual),
    .acertou(acertou),
    .errou(errou),
    .db_estado(s_estado)
);

	hexa7seg HEX0(
    .hexa(s_contagem), .display(db_contagem)
);

	hexa7seg HEX1(
    .hexa(s_memoria), .display(db_memoria)
);

	hexa7seg HEX2(
    .hexa(s_chaves), .display(db_chaves)
);

	hexa7seg HEX5(
    .hexa(s_estado), .display(db_estado)
);

assign db_iniciar = iniciar;
assign db_zeraC = w_zeraC;
assign db_zeraR = w_zeraR;
assign db_registraR = w_registraR;
assign db_contaC = w_contaC;
assign db_igual = w_igual;
assign db_fimC = w_fimC;
assign maior = ~w_maior;
assign menor = ~w_menor;


endmodule