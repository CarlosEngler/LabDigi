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
 inout clock,
 input reset,
 input iniciar,
 input [3:0] chaves,
 output pronto,
 output db_igual,
 output db_menor,
 output db_maior,
 output db_iniciar,
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
    .chavesMaiorMemoria(db_maior),
    .chavesIgualMemoria(db_igual),
    .chavesMenorMemoria(db_menor),
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


endmodule