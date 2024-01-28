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

module exp4_fluxo_dados (
    input        clock,
    input [3:0]  chaves,
    input        zeraR,
    input        registraR,
    input        contaC,
    input        zeraC,
    output       chavesMaiorMemoria,
    output       chavesIgualMemoria,
    output       chavesMenorMemoria,
    output       fimC,
    output [3:0] db_contagem,
    output [3:0] db_chaves,
    output [3:0] db_memoria
);

	wire [3:0] s_endereco;
	wire [3:0] s_chaves;
	wire [3:0] s_dado;

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

    registrador_4 registrador (
        .clock ( clock ),
        .clear (zeraR),
        .enable (registraR),
        .D (chaves),
        .Q (s_chaves)
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
      .ALBo( chavesMaiorMemoria ), 
      .AGBo( chavesMenorMemoria ),
      .AEBo( chavesIgualMemoria )
    );

	 
assign db_chaves = s_chaves;
assign db_memoria = s_dado;
assign db_contagem = s_endereco;



endmodule
