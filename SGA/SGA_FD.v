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
    input         load_size,
    input         render_clr,
    input         render_count,
    input         register_apple,
    input         reset_apple,
    input         count_play_time,
    input         register_head,
    input         reset_head,
    input  [1:0]  direction,
    input         we_ram,
    input         mux_ram,
    input         recharge,
    output        render_finish,
    output [3:0]  db_tamanho,
    output [3:0]  db_macas_comidas,
    output [3:0]  db_memoria,
    output [35:0] db_leds,
    output end_play_time,
    output played
);

	  wire [3:0] s_size;
    wire [3:0] s_render_count;
	  wire [3:0] s_position;
    wire [3:0] s_apple;
    wire [3:0] w_new_apple;
    wire sinal;
    wire [3:0] head;
    wire [3:0] headXsoma;
    wire [3:0] headXsubtrai;
    wire [3:0] headYSoma;
    wire [3:0] headYSubtrai;
    wire [3:0] newHead;
    wire [3:0] dataRAM;


    assign sinal = buttons[0] | buttons [1] | buttons[2] | buttons [3];   

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

    contador_163 render_component (
      .clock( clock ),
      .clr  ( ~render_clr ), 
      .ld   ( 1'b1 ),
      .enp  ( render_count ),
      .ent  ( 1'b1 ),
      .D    ( 4'd0 ), 
      .Q    ( s_render_count ),
      .rco  (  )
    );

    LFSR new_apple(
      .clk(clock),
      .reset(restart),
      .lfsr_output(w_new_apple)
    );

    	 contador_m #( .M(200), .N(10) ) contador_de_jogada (
      .clock  ( clock ),
      .zera_as( restart ),
      .zera_s ( render_count ),
      .conta  ( count_play_time ),
      .Q      (  ),
      .fim    ( end_play_time ),
      .meio   (),
      .quarto ()
    );

    registrador_4 apple_position (
        .clock ( clock ),
        .clear ( reset_apple ),
        .enable ( register_apple ),
        .D ( w_new_apple ),
        .Q ( s_apple )
    );

    registrador_4 head_position (
        .clock ( clock ),
        .clear ( reset_head ),
        .enable ( register_head ),
        .D ( s_position ),
        .Q ( head )
    );

    edge_detector detector (
      .clock(clock),
      .reset(restart),
      .sinal(sinal),
      .pulso(played)
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
        .apple( s_apple ),
        .position ( s_position ),
        .leds( db_leds ),
        .restart( recharge | restart )
    );

    assign  dataRAM = mux_ram ? s_position : newHead;

    	 sync_ram_16x4_file #(
        .BINFILE("ram_init.txt")
    ) RAM
    (
			.clk(clock),
			.we( we_ram ),
			.data( dataRAM ),
			.addr( s_render_count ),
			.q( s_position )
    );

    assign headXsoma = {head[3:2] , head[1:0] + 2'b01} ;
    assign headXsubtrai = {head[3:2], head[1:0] - 2'b01} ;
    assign headYSoma = {head[3:2] + 2'b01 , head[1:0]} ;
    assign headYSubtrai = {head[3:2] - 2'b01 , head[1:0]} ;

    mux4x1_n #( .BITS(4) ) mux_zera (
      .D0(headXsoma),
      .D1(headXsubtrai),
      .D2(headYSoma),
      .D3(headYSubtrai),
      .SEL(direction),
      .OUT(newHead)
    );

  assign db_memoria = s_position;

endmodule