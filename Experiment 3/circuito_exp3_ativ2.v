/*
 * ------------------------------------------------------------------
 *  Arquivo   : circuito_exp3_ativ2-PARCIAL.v
 *  Projeto   : Experiencia 3 - Um Fluxo de Dados Simples
 * ------------------------------------------------------------------
 *  Descricao : Circuito PARCIAL do fluxo de dados da Atividade 2
 * 
 *     1) circuito composto dos componentes contador 74163 e comparador 7485. 
 *        As saídas do contador são conectadas às entradas do comparador.
 *        A entrada "Chaves"  é conectada às entradas "A" do comparador e "D" do contador.
 *        O circuito tem como output o valor da contagem do contador e as comparações realizadas pelo comparador.
 *
 * ------------------------------------------------------------------
 *  Revisoes  :
 *      Data        Versao  Autor             Descricao
 *      11/01/2024  1.0     Edson Midorikawa  versao inicial
 * ------------------------------------------------------------------
 */

module circuito_exp3_ativ2 (clock, zera, carrega, conta, chaves, 
                            menor, maior, igual, fim, db_contagem, db_chaves);
    input        clock;
    input        zera;
    input        carrega;
    input        conta;
    input  [3:0] chaves;
    output       menor;
    output       maior;
    output       igual;
    output       fim;
    output [6:0] db_contagem;
    output [6:0] db_chaves;

    wire   [3:0] s_contagem;  // sinal interno para interligacao dos componentes

    // contador_163
    contador_163 contador (
      .clock( clock ),
      .clr  ( ~zera ), 
      .ld   ( ~carrega ),
      .enp  ( 1'b1 ),
      .ent  ( conta ),
      .D    ( chaves ), 
      .Q    ( s_contagem ),
      .rco  ( fim )
    );

    // comparador_85
    comparador_85 comparador (
      .A   ( s_contagem ),
      .B   ( chaves ),
      .ALBi( 1'b0 ), 
      .AGBi( 1'b0 ),
      .AEBi( 1'b1 ),
      .ALBo( menor ), 
      .AGBo( maior ),
      .AEBo( igual )
    );

    hexa7seg HEX0 (
      .hexa(s_contagem),
      .display(db_contagem)
    );

    hexa7seg HEX1 (
      .hexa(chaves),
      .display(db_chaves)
    );

endmodule