/* --------------------------------------------------------------------
 * Arquivo   : SGA.v
 * Projeto   : Snake Game Arcade
 * --------------------------------------------------------------------
 * Descricao : Circuito completo
 *
 * --------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor                          Descricao
 *     08/03/2024  1.0     Erick Sousa, João Bassetti     versao inicial
 * --------------------------------------------------------------------
*/


module SGA (
 input          clock,
 input          [3:0] buttons,
 input          start,
 input          restart,
 input          pause,
 output         [3:0] db_size;
 output         finished,
 output         won,
 output         lost, 
 output         [6:0] db_state
 output         [35:0] db_leds;
);

wire w_clr_size;
wire w_count_size;
wire w_render_clr;
wire w_render_count;
wire w_render_finish;
wire w_register_apple;
wire w_reset_apple;

wire w_fimC;
wire w_contaC;
wire w_zeraC;
wire w_registraR;
wire [3:0] s_estado;
wire [3:0] s_contagem;
wire [3:0] s_chaves;
wire [3:0] s_memoria;

	SGA_FD FD(
        .clock(clock),
        .buttons(buttons),
        .restart(restart),
        .clear_size(w_clr_size),
        .count_size(w_count_size),
        .render_clr(w_render_clr),
        .render_count(w_render_count),
        .render_finish(w_render_finish),
        .register_apple(w_register_apple),
        .reset_apple(w_reset_apple),
        .db_tamanho(db_size),
        .render_finish(render_finish),
        .db_macas_comidas( ),
        .db_leds(db_leds),
        .db_memoria( )
    );

	SGA_UC UC(
        .clock(clock),
        .restart(restart), 
        .start(start),
        .pause(pause),
        .is_at_apple(1'b0),
        .is_at_border(1'b0),
        .is_at_body(1'b0),
        .end_play_time(1'b0),
        .clear_size(w_clr_size),
        .count_size(w_count_size),
        .render_clr(w_render_clr),
        .render_count(w_render_count),
        .render_finish(w_render_finish),
        .register_apple(w_register_apple),
        .reset_apple(w_reset_apple),
        .finished(finished),
        .won(won),
        .lost(lost), 
        .db_state(s_estado)
    );

	hexa7seg HEX5(
    .hexa({1'b0, s_estado}), .display(db_state)
);

endmodule