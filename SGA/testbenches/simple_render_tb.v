/* --------------------------------------------------------------------
 * Arquivo   : simple_render_tb.v
 * Projeto   : Snake Game Arcade
 * --------------------------------------------------------------------
 * Descricao : testbench Verilog para renderizar o jogo na matriz de leds 
 *
 *             1) plano de teste: 16 casos de teste
 *
 * --------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor                       Descricao
 *     16/01/2024  1.0     Erick Sousa, João Bassetti  versao inicial
 * --------------------------------------------------------------------
*/

`timescale 1ns/1ns

module simple_render_tb;

    // Sinais para conectar com o DUT
    // valores iniciais para fins de simulacao (ModelSim)
    reg        clock_in   = 1;
    reg        restart_in   = 0;
    reg        start_in = 0;
    reg        [3:0] buttons_in  = 4'b0000;
    reg        pause_in = 0;
    wire       finished_out;
    wire       win_out;
    wire       lost_out;
    wire [6:0]  db_state;
    wire [6:0]  db_state2;
    wire [35:0] db_leds;
    wire [3:0]  db_size;

    // Configuração do clock
    parameter clockPeriod = 20; // in ns, f=50MHz

    // Identificacao do caso de teste
    reg [31:0] caso = 0;

    // Gerador de clock
    always #((clockPeriod / 2)) clock_in = ~clock_in;

    // instanciacao do DUT (Device Under Test)
    SGA dut (
        .clock(clock_in),
        .buttons(buttons_in),
        .start(start_in),
        .restart(restart_in),
        .db_state(db_state),
        .db_state2(db_state2),
        .db_appleX(),
        .db_appleY(),
        .db_headX(),
        .db_headY(),
        .leds(),
        .db_size(db_size)
    );

    // geracao dos sinais de entrada (estimulos)
    initial begin
      $display("Inicio da simulacao");

      // condicoes iniciais
      caso       = 0;
      clock_in   = 1;
      restart_in = 0;
      start_in = 0;
      buttons_in  = 4'b0000;
      pause_in = 0;
      #clockPeriod;

      // Teste 1 (resetar circuito)
      caso = 1;
      // gera pulso de reset
      @(negedge clock_in);
      restart_in = 1;
      #(clockPeriod);
      restart_in = 0;

      // Teste 2 (iniciar=0 por 5 periodos de clock)
      caso = 2;
      #(clockPeriod);

      // Teste 3 (ajustar chaves para 0100, acionar iniciar por 1 periodo de clock)
      caso = 3;
      @(negedge clock_in);
      // pulso em iniciar
      start_in = 1;
      #(clockPeriod);
      start_in = 0;

      #(500*clockPeriod);

      buttons_in = 4'b0001;

      #(100*clockPeriod);

      // Teste 4 (manter chaves em 0100 por 1 periodo de clock)

      // final dos casos de teste da simulacao
      caso = 99;
      #100;
      $display("Fim da simulacao");
      $stop;
    end

  endmodule
