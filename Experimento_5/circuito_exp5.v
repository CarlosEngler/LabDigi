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

module circuito_exp5 (
 input clock,
 input reset,
 input iniciar,
 input [3:0] chaves,
 output acertou,
 output errou,
 output pronto,
 output [3:0] leds,
 output db_igual,
 output [6:0] db_contagem,
 output [6:0] db_memoria,
 output [6:0] db_estado,
 output [6:0] db_jogadafeita,
 output db_clock,
 output db_iniciar,
 output db_tem_jogada
);


wire w_fimC;
wire w_contaC;
wire w_zeraC;
wire w_zeraR;
wire w_registraR;
wire w_jogada_feita;
wire w_igual;
wire [3:0] s_estado;
wire [3:0] s_contagem;
wire [3:0] s_chaves;
wire [3:0] s_memoria;


	exp5_fluxo_dados FD(
    .clock(clock),
    .chaves(chaves),
    .zeraR(w_zeraR),
    .registraR(w_registraR),
    .contaC(w_contaC),
    .zeraC(w_zeraC),
    .igual(w_igual),
    .fimC(w_fimC),
    .db_contagem(s_contagem),
    .db_jogada(s_chaves),
    .db_memoria(s_memoria),
    .jogada_feita(w_jogada_feita),
    .db_tem_jogada(db_tem_jogada)
);

	exp5_unidade_controle UC(
    .clock(clock),
    .reset(reset),
    .iniciar(iniciar),
    .fim(w_fimC),
    .zeraC(w_zeraC),
    .contaC(w_contaC),
    .zeraR(w_zeraR),
    .registraR(w_registraR),
    .pronto(pronto),
    .db_estado(s_estado),
    .jogada(w_jogada_feita),
    .igual(w_igual),
    .acertou(acertou),
    .errou(errou)
);

	hexa7seg HEX0(
    .hexa(s_contagem), .display(db_contagem)
);

	hexa7seg HEX1(
    .hexa(s_memoria), .display(db_memoria)
);

	hexa7seg HEX2(
    .hexa(s_chaves), .display(db_jogadafeita)
);

	hexa7seg HEX5(
    .hexa(s_estado), .display(db_estado)
);

assign db_iniciar = iniciar;
assign db_clock = clock;
assign leds = s_chaves;
assign db_igual = w_igual;

endmodule