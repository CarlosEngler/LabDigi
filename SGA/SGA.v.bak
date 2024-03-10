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
 output         [3:0] db_size,
 output         finished,
 output         won,
 output         lost, 
 output         [4:0] db_state,
 output         [35:0] db_leds
 );

wire w_clr_size;
wire w_count_size;
wire w_render_clr;
wire w_render_count;
wire w_render_finish;
wire w_register_apple;
wire w_reset_apple;
wire w_register_head;
wire w_reset_head;
wire w_load_size;
wire w_count_play_time;
wire w_end_play_time;
wire w_played;
wire [1:0] w_direction;
wire w_we_ram;
wire w_mux_ram;
wire w_recharge;

wire [3:0] s_contagem;
wire [3:0] s_chaves;
wire [3:0] s_memoria;

wire w_load_ram;
wire w_counter_ram;
wire w_mux_ram_addres;
wire w_mux_ram_render;
wire w_end_move;

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
        .register_head(w_register_head),
        .reset_head(w_reset_head),
        .db_tamanho(db_size),
        .db_macas_comidas( ),
        .db_leds(db_leds),
        .load_size(w_load_size),
        .db_memoria( ),
        .count_play_time(w_count_play_time),
        .played(w_played),
        .we_ram(w_we_ram),
        .mux_ram(w_mux_ram),
        .end_play_time(w_end_play_time),
        .direction(w_direction),
        .load_ram(w_load_ram),
        .counter_ram(w_counter_ram),
        .mux_ram_addres(w_mux_ram_addres),
        .mux_ram_render(w_mux_ram_render),
        .end_move(w_end_move),
        .recharge(w_recharge)
    );

	SGA_UC UC(
        .clock(clock),
        .restart(restart), 
        .start(start),
        .pause(pause),
        .is_at_apple(1'b0),
        .is_at_border(1'b0),
        .is_at_body(1'b0),
        .end_play_time(w_end_play_time),
        .clear_size(w_clr_size),
        .count_size(w_count_size),
        .render_clr(w_render_clr),
        .render_count(w_render_count),
        .render_finish(w_render_finish),
        .register_apple(w_register_apple),
        .reset_apple(w_reset_apple),
        .register_head(w_register_head),
        .reset_head(w_reset_head),
        .finished(finished),
        .won(won),
        .we_ram(w_we_ram),
        .mux_ram(w_mux_ram),
        .lost(lost), 
        .load_size(w_load_size),
        .count_play_time(w_count_play_time),
        .db_state(db_state),
        .left(buttons[3]),
        .right(buttons[2]),
        .up(buttons[1]),
        .down(buttons[0]),
        .played(w_played),
        .direction(w_direction),
        .load_ram(w_load_ram),
        .counter_ram(w_counter_ram),
        .mux_ram_addres(w_mux_ram_addres),
        .mux_ram_render(w_mux_ram_render),
        .end_move(w_end_move),
        .recharge(w_recharge)
    );

endmodule