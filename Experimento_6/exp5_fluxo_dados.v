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

module exp5_fluxo_dados (
    input clock,
    input zeraC,
    input contaC,
    input zeraR,
    input registraR,
	 input contaCM,
    input [3:0] chaves,
    output igual,
    output fimC,
    output jogada_feita,
    output db_tem_jogada,
	 output timeout,
    output [3:0] db_contagem,
    output [3:0] db_memoria,
    output [3:0] db_jogada
);
    
	wire [3:0] s_endereco;
	wire [3:0] s_chaves;
	wire [3:0] s_dado;
  wire sinal;

  assign sinal = chaves[0] | chaves [1] | chaves[2] | chaves [3];

    // contador_163
    contador_163 contador (
      .clock( clock ),
      .clr  ( ~zeraC ), 
      .ld   ( 1'b1 ),
      .enp  ( contaC ),
      .ent  ( 1'b1 ),
      .D    ( 4'd0 ), 
      .Q    ( s_endereco ),
      .rco  ( fimC )
    );
	 
	 contador_m #( .M(3000), .N(12) ) contador_de_timeout (
		.clock  ( clock ),
		.zera_as( zeraC | zeraR ),
		.zera_s ( contaC ),
		.conta  ( contaCM ),
		.Q      (  ),
		.fim    ( timeout ),
		.meio   (  )
  );

    registrador_4 registrador (
        .clock ( clock ),
        .clear (zeraR),
        .enable (registraR),
        .D (chaves),
        .Q (s_chaves)
    );

    edge_detector detector (
      .clock(clock),
      .reset(zeraC),
      .sinal(sinal),
      .pulso(jogada_feita)
    );

    sync_rom_16x4 memoria (
        .clock ( clock ),
        .address ( s_endereco ),
        .data_out (s_dado)
    );
	 
	 // comparador_85
    comparador_85 comparador (
      .A   ( s_dado ),
      .B   ( s_chaves ),
      .ALBi( 1'b0 ), 
      .AGBi( 1'b0 ),
      .AEBi( 1'b1 ),
      .ALBo( ), 
      .AGBo( ),
      .AEBo( igual )
    );

	 
assign db_jogada = s_chaves;
assign db_memoria = s_dado;
assign db_contagem = s_endereco;
assign db_tem_jogada = sinal;



endmodule
