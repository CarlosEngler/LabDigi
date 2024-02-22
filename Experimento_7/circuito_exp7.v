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

module circuito_exp7 (
 input clock,
 input reset,
 input jogar,
 input [3:0] botoes,
 output [3:0] leds,
 output ganhou,
 output perdeu,
 output pronto,
 output [6:0] db_contagem,
 output [6:0] db_memoria,
 output [6:0] db_estado,
 output [6:0] db_jogadafeita,
 output [6:0] db_rodada,
 output db_clock,
 output db_jogada_correta,
 output db_tem_jogada,
 output db_enderecoIgualRodada,
 output db_timeout
);

wire w_fimL;
wire w_contaE;
wire w_zeraE;
wire w_contaCR;
wire w_zeraCR;
wire w_limparRC;
wire w_registraRC;
wire w_zeraLeds;
wire w_registraLeds;
wire w_jogada_feita;
wire w_enderecoIgualRodada;
wire w_jogada_correta;
wire s_timeout;
wire w_contaT;
wire w_meio;
wire w_enable_ram;
wire w_led_selector;
wire [3:0] s_estado;
wire [3:0] s_contagem;
wire [3:0] s_botoes;
wire [3:0] s_memoria;
wire [3:0] s_rodada;


	exp6_fluxo_dados FD(
    .clock(clock),
    .botoes(botoes),
    .limpaRC(w_limparRC),
    .registraRC(w_registraRC),
    .zeraLeds(w_zeraLeds),
    .registraLeds(w_registraLeds),
    .contaCR(w_contaCR),
    .zeraCR(w_zeraCR),
    .contaE(w_contaE),
    .zeraE(w_zeraE),
    .enderecoIgualRodada(w_enderecoIgualRodada),
    .jogada_correta(w_jogada_correta),
    .fimC( ),
    .fimL(w_fimL),
	.contaT(w_contaT),
	.timeout(s_timeout),
    .db_contagem(s_contagem),
    .db_jogada(s_botoes),
    .db_memoria(s_memoria),
    .db_rodada(s_rodada),
    .jogada_feita(w_jogada_feita),
    .db_tem_jogada(db_tem_jogada),
    .leds(leds),
    .led_selector(w_led_selector),
	.ram_enable(w_enable_ram),
	.meio(w_meio)
);

	exp6_unidade_controle UC(
    .clock(clock),
    .reset(reset),
    .jogar(jogar),
    .fim(w_fimL),
    .zeraCR(w_zeraCR),
    .contaCR(w_contaCR),
    .zeraE(w_zeraE),
    .contaE(w_contaE),
    .zeraLeds(w_zeraLeds),
    .registraLeds(w_registraLeds),
    .limpaRC(w_limparRC),
    .registraRC(w_registraRC),
    .pronto(pronto),
	.timeout(s_timeout),
	.db_timeout(db_timeout),
    .db_estado(s_estado),
    .jogada(w_jogada_feita),
    .jogada_correta(w_jogada_correta),
    .enderecoIgualRodada(w_enderecoIgualRodada),
    .ganhou(ganhou),
    .perdeu(perdeu),
	.contaT(w_contaT),
    .led_selector(w_led_selector),
	.ram_enable(w_enable_ram),
	.meio(w_meio),
);

	hexa7seg HEX0(
    .hexa(s_contagem), .display(db_contagem)
);

	hexa7seg HEX1(
    .hexa(s_memoria), .display(db_memoria)
);

	hexa7seg HEX2(
    .hexa(s_botoes), .display(db_jogadafeita)
);

	hexa7seg HEX5(
    .hexa(s_estado), .display(db_estado)
);

hexa7seg HEX3(
    .hexa(s_rodada), .display(db_rodada)
);

assign db_jogada_correta = w_jogada_correta;
assign db_clock = clock;
assign db_enderecoIgualRodada = w_enderecoIgualRodada;

endmodule