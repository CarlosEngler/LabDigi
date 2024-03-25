/* --------------------------------------------------------------------
 * Arquivo   : SGA.v
 * Projeto   : Snake Game Arcade
 * --------------------------------------------------------------------
 * Descricao : Circuito completo
 *
 * --------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor                                          Descricao
 *     08/03/2024  1.0     Erick Sousa, João Bassetti                   versao inicial
 *     13/03/2024  1.0     Erick Sousa, João Bassetti, Carlos Engler       Semana 2
 * --------------------------------------------------------------------
*/


module SGA (
 input          clock,
 input          [3:0] buttons,
 input          start,
 input          restart,
 input          pause,
 input          difficulty,
 input          mode,
 input          velocity,
 output         [3:0] db_size, 
 output         [6:0] db_state,
 output         [6:0] db_state2,
 output         [6:0] db_headX,
 output         [6:0] db_headY,
 output         [6:0] db_appleX,
 output         [6:0] db_appleY,
 output         [1:0] direction,
 output         won,
 output         lost,
 output         [3:0] leds,
 output			 comeu_maca,
 output         led_comeu_maca
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
wire w_chosen_play_time;
wire w_played;
wire [1:0] w_direction;
wire w_we_ram;
wire w_mux_ram;
wire w_recharge;
wire w_wall_collision;
wire w_win_game;
wire w_maca_na_cobra;

wire [3:0] s_contagem;
wire [3:0] s_chaves;
wire [3:0] s_memoria;
wire [4:0] s_estado;
wire [3:0] s_apple;
wire [3:0] s_head;

wire w_load_ram;
wire w_counter_ram;
wire w_mux_ram_addres;
wire w_mux_ram_render;
wire w_end_move;
wire w_comeu_maca;
wire w_self_collision_on;
wire w_self_collision;
wire w_zera_counter_play_time;
wire w_register_game_parameters;
wire w_reset_game_parameters;

	SGA_FD FD(
        .clock(clock),
        .buttons(buttons),
        .restart(restart),
        .mode(mode),
        .difficulty(difficulty),
        .velocity(velocity),
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
        .db_leds( ),
        .load_size(w_load_size),
        .db_memoria( ),
        .db_apple(s_apple),
        .db_head(s_head),
        .count_play_time(w_count_play_time),
        .played(w_played),
        .we_ram(w_we_ram),
        .mux_ram(w_mux_ram),
        .chosen_play_time(w_chosen_play_time),
        .direction(w_direction),
        .load_ram(w_load_ram),
        .counter_ram(w_counter_ram),
        .mux_ram_addres(w_mux_ram_addres),
        .mux_ram_render(w_mux_ram_render),
        .end_move(w_end_move),
		.comeu_maca(w_comeu_maca),
        .wall_collision(w_wall_collision),
        .self_collision(w_self_collision),
        .self_collision_on(w_self_collision_on),
        .chosen_difficulty(w_win_game),
        .zera_counter_play_time(w_zera_counter_play_time),
        .register_game_parameters(w_register_game_parameters),
        .reset_game_parameters(w_reset_game_parameters),
        .maca_na_cobra(w_maca_na_cobra),
        .recharge(w_recharge)
    );

	SGA_UC UC(
        .clock(clock),
        .restart(restart), 
        .start(start),
        .chosen_play_time(w_chosen_play_time),
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
        .db_state(s_estado),
        .left(buttons[3]),
        .right(buttons[0]),
        .up(buttons[2]),
        .down(buttons[1]),
        .played(w_played),
        .direction(w_direction),
        .load_ram(w_load_ram),
        .counter_ram(w_counter_ram),
        .mux_ram_addres(w_mux_ram_addres),
        .mux_ram_render(w_mux_ram_render),
        .end_move(w_end_move),
        .wall_collision(w_wall_collision),
		.comeu_maca(w_comeu_maca),
        .self_collision(w_self_collision),
        .self_collision_on(w_self_collision_on),
        .win_game(w_win_game),
        .pause(pause),
        .zera_counter_play_time(w_zera_counter_play_time),
        .register_game_parameters(w_register_game_parameters),
        .reset_game_parameters(w_reset_game_parameters),
        .maca_na_cobra(w_maca_na_cobra),
        .recharge(w_recharge)
    );
	 
  hexa7seg HEX5(
    .hexa({3'b000, s_estado[4]}), .display(db_state2)
);

	hexa7seg HEX4(
    .hexa(s_estado[3:0]), .display(db_state)
);

	hexa7seg HEX3(
    .hexa({2'b00, s_apple[1:0]}), .display(db_appleX)
);

	hexa7seg HEX2(
    .hexa({2'b00, s_apple[3:2]}), .display(db_appleY)
);

	hexa7seg HEX1(
    .hexa({2'b00, s_head[1:0]}), .display(db_headX)
);

	hexa7seg HEX0(
    .hexa({2'b00, s_head[3:2]}), .display(db_headY)
);

assign direction = w_direction;
assign leds = buttons;
assign comeu_maca = s_head[1];
assign led_comeu_maca = w_comeu_maca;

endmodule