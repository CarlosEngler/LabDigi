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

    // contador_163
    contador_163 contador (
      .clock( clock ),
      .clr  ( ~zeraC ), 
      .ld   ( 1'b1 ),
      .enp  ( 1'b1 ),
      .ent  ( 1'b1 ),
      .D    ( 1'b0 ), 
      .Q    ( s_endereco ),
      .rco  ( fimC )
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
        .data_out (db_memoria)
    );

    hexa7seg HEX0 (
      .hexa(s_endereco),
      .display(db_contagem)
    );

    hexa7seg HEX1 (
      .hexa(s_chaves),
      .display(db_chaves)
    );

    hexa7seg HEX2 (
      .hexa(s_dado),
      .display(db_memoria)
    );



endmodule
