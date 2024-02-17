/* --------------------------------------------------------------------
 * Arquivo   : exp4_fluxo_dados.v
 * Projeto   : Experiencia 4 - Projeto de uma Unidade de Controle
 * --------------------------------------------------------------------
 * Descricao : Fluxo de Dados
 *
 * --------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     26/01/2024  1.0     Erick Sousa       versao inicial
 * --------------------------------------------------------------------
*/

module exp6_fluxo_dados (
    input clock,
    input zeraCR,
    input zeraE,
    input contaCR,
    input contaE,
    input limpaRC,
    input registraRC,
    input zeraLeds,
    input registraLeds,
	  input contaT,
    input [3:0] botoes,
    input led_selector,
    output jogada_correta,
    output enderecoIgualRodada,
    output fimC,
    output fimL,
    output jogada_feita,
    output db_tem_jogada,
	  output timeout,
    output [3:0] db_contagem,
    output [3:0] db_memoria,
    output [3:0] db_jogada,
    output [3:0] db_rodada,
    output [3:0] leds
);
    
	wire [3:0] s_endereco;
  wire [3:0] s_memoria;
	wire [3:0] s_jogada;
	wire [3:0] s_dado;
  wire [3:0] s_rodada;
  wire s_led_selector;
  wire sinal;

  assign sinal = botoes[0] | botoes [1] | botoes[2] | botoes [3];

    // contador_163
    contador_163 contador_de_endereco (
      .clock( clock ),
      .clr  ( ~zeraE ), 
      .ld   ( 1'b1 ),
      .enp  ( contaE ),
      .ent  ( 1'b1 ),
      .D    ( 4'd0 ), 
      .Q    ( s_endereco ),
      .rco  ( fimC )
    );

    contador_163 contador_de_rodada (
      .clock( clock ),
      .clr  ( ~zeraCR ), 
      .ld   ( 1'b1 ),
      .enp  ( contaCR ),
      .ent  ( 1'b1 ),
      .D    ( 4'd0 ), 
      .Q    ( s_rodada ),
      .rco  ( fimL )
    );
  
	 contador_m #( .M(5000), .N(13) ) contador_de_timeout (
		.clock  ( clock ),
		.zera_as( zeraCR | limpaRC | zeraE),
		.zera_s ( contaE ),
		.conta  ( contaT ),
		.Q      (  ),
		.fim    ( timeout ),
		.meio   (  )
  );

    registrador_4 registrador (
        .clock ( clock ),
        .clear (limpaRC),
        .enable (registraRC),
        .D (botoes),
        .Q (s_jogada)
    );

    registrador_1 registradorLeds (
        .clock ( clock ),
        .clear (zeraLeds),
        .enable (registraLeds),
        .D (led_selector),
        .Q (s_led_selector)
    );

    edge_detector detector (
      .clock(clock),
      .reset(zeraCR),
      .sinal(sinal),
      .pulso(jogada_feita)
    );

  assign s_memoria = s_led_selector ? s_rodada : s_endereco;

    sync_rom_16x4 memoria (
        .clock ( clock ),
        .address ( s_memoria ),
        .data_out (s_dado)
    );
	 
	 // comparador_85
    comparador_85 comparador_de_jogada (
      .A   ( s_dado ),
      .B   ( s_jogada ),
      .ALBi( 1'b0 ), 
      .AGBi( 1'b0 ),
      .AEBi( 1'b1 ),
      .ALBo( ), 
      .AGBo( ),
      .AEBo( jogada_correta)
    );

    comparador_85 comparador_de_endereco (
      .A   ( s_rodada ),
      .B   ( s_endereco ),
      .ALBi( 1'b0 ), 
      .AGBi( 1'b0 ),
      .AEBi( 1'b1 ),
      .ALBo( ), 
      .AGBo( ),
      .AEBo( enderecoIgualRodada )
    );

assign leds = s_led_selector ? db_memoria : db_jogada;

assign db_jogada = s_jogada;
assign db_memoria = s_dado;
assign db_contagem = s_endereco;
assign db_tem_jogada = sinal;
assign db_rodada = s_rodada;




endmodule
