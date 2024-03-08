/* --------------------------------------------------------------------
 * Arquivo   : SGA_FD.v
 * Projeto   : Snake Game Arcade
 * --------------------------------------------------------------------
 * Descricao : Fluxo de Dados
 *
 * --------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor                            Descricao
 *     09/03/2024  1.0     Erick Sousa, João Bassetti       versao inicial
 * --------------------------------------------------------------------
*/

module SGA_FD (
    input         clock,
    input [3:0]   buttons,
    input         restart,
    input         clear_size,
    input         count_size,
    input         render_clr,
    input         render_count,
    input         register_apple,
    input         reset_apple,
    output        render_finish,
    output [3:0]  db_tamanho,
    output [3:0]  db_macas_comidas,
    output [3:0]  db_memoria,
    output [35:0] db_leds
);

	  wire [3:0] s_address;
	  wire [3:0] s_size;
    wire [3:0] s_render_count;
	  wire [3:0] s_position;
    wire [3:0] s_position;
    wire [3:0] s_apple;

    // contador_163
    contador_163 snake_size (
      .clock( clock ),
      .clr  ( ~clear_size ), 
      .ld   ( ~load_size ),
      .enp  ( count_size ),
      .ent  ( 1'b1 ),
      .D    ( 4'b0001 ), 
      .Q    ( s_size ),
      .rco  (  )
    );

    contador_163 render_count_component (
      .clock( clock ),
      .clr  ( ~render_clr ), 
      .ld   ( 1'b1 ),
      .enp  ( render_count ),
      .ent  ( 1'b1 ),
      .D    ( 4'd0 ), 
      .Q    ( s_render_count ),
      .rco  (  )
    );

    registrador_4 apple_position (
        .clock ( clock ),
        .clear ( reset_apple ),
        .enable ( register_apple ),
        .D ( 4'b1101 ),
        .Q ( s_apple )
    );

    sync_rom_16x4 snake_body (
        .clock ( clock ),
        .address ( s_address ),
        .data_out ( s_position )
    );
	 
	 // comparador_85
    comparador_85 render_comparator (
      .A   ( s_size ),
      .B   ( s_render_count ),
      .ALBi( 1'b0 ), 
      .AGBi( 1'b0 ),
      .AEBi( 1'b1 ),
      .ALBo( ), 
      .AGBo( ),
      .AEBo( render_finish )
    );

    matrizleds game_interface (
        .clock( clock ),
        .apple()
        .position ( s_position )
        .leds( db_leds )
    );

  assign db_memoria = s_position;

endmodule