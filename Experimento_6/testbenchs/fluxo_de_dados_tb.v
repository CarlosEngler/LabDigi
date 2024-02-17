/* --------------------------------------------------------------------
 * Arquivo   : circuito_exp5_tb-MODELO.vhd
 * Projeto   : Experiencia 5 - Desenvolvimento de Projeto de 
 *             Circuitos Digitais em FPGA
 * --------------------------------------------------------------------
 * Descricao : testbench Verilog MODELO para circuito da Experiencia 5 
 *
 *             1) Plano de testes com erra na décima sexta rodada 
 *
 * --------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     27/01/2024  1.0     Edson Midorikawa  versao inicial
 *     01/02/2024  1.1     Carlos Engler    3 acertos apenas
 * --------------------------------------------------------------------
*/

`timescale 1ns/1ns

module circuito_exp6_tb2;

    // Sinais para conectar com o DUT
    // valores iniciais para fins de simulacao (ModelSim)
    reg        clock_in   = 1;
    reg        reset_in   = 0;
    reg        jogar_in = 0;
    reg  [3:0] botoes_in  = 4'b0000;

    wire [3:0] leds_out;
    wire ganhou_out;
    wire perdeu_out;
    wire pronto_out;
    wire [6:0] db_contagem_out;
    wire [6:0] db_memoria_out;
    wire [6:0] db_estado_out;
    wire [6:0] db_jogadafeita_out; 
    wire [6:0] db_rodada_out; 
    wire db_clock_out;
    wire db_jogadaCorreta_out;
    wire db_tem_jogada_out;
    wire db_enderecoIgualJogada_out;
    wire db_timeout_out;

    // Configuração do clock
    parameter clockPeriod = 20; // in ns, f=50MHz

    // Identificacao do caso de teste
    reg [31:0] caso = 0;
    reg [31:0] rodada = 0;
    reg [31:0] jogada = 0;

    // Gerador de clock
    always #((clockPeriod / 2)) clock_in = ~clock_in;

    // Instancia do DUT
    exp6_fluxo_dados ffut(
    .clock      (clock),
    .botoes     (botoes),
    .limpaRC         (w_limparRC),
    .registraRC       (w_registraRC),
    .zeraLeds       (w_zeraLeds),
    .registraLeds   (w_registraLeds),
    .contaCR    (w_contaCR),
    .zeraCR (w_zeraCR),
    .contaE (w_contaE),
    .zeraE  (w_zeraE),
    .enderecoIgualRodada    (w_enderecoIgualRodada),
    .jogada_correta (w_jogada_correta),
    .fimC   ( ),
    .fimL   (w_fimL),
	.contaT (w_contaT),
	.timeout    (s_timeout),
    .db_contagem    (s_contagem),
    .db_jogada  (s_botoes),
    .db_memoria (s_memoria),
    .db_rodada  (s_rodada),
    .jogada_feita   (w_jogada_feita),
    .db_tem_jogada  (db_tem_jogada),
    .leds   (leds),
    .led_selector   (w_led_selector)    
);

    integer rodadaInt = 0;
    integer jogadaInt = 0;

    // geracao dos sinais de entrada (estimulos)
    initial begin
      $display("Inicio da simulacao");

      // condicoes iniciais
      caso       = 0;
      clock_in   = 1;
      reset_in   = 0;
      jogar_in = 0;
      botoes_in  = 4'b0000;
      #clockPeriod;

      /*
       * Cenario de Teste 1 - acerta tudo
       */

      // Teste 1. resetar circuito
      caso = 1;
      // gera pulso de reset
      @(negedge clock_in);
      reset_in = 1;
      #(clockPeriod);
      reset_in = 0;
      // espera
      #(10*clockPeriod);

      // Teste 2. jogar=1 por 5 periodos de clock
      // Começa o jogo
      caso = 2;
      jogar_in = 1;
      #(5*clockPeriod);
      jogar_in = 0;
      // espera
      #(10*clockPeriod);


      for(rodadaInt = 0; rodadaInt <= 15; rodadaInt = rodadaInt + 1) begin
        for(jogadaInt = 0; jogadaInt <= rodadaInt; jogadaInt = jogadaInt + 1) begin
          caso = 3;

          case (jogadaInt)
            4'b0000: botoes_in = 4'b0001;
            4'b0001: botoes_in = 4'b0010;
            4'b0010: botoes_in = 4'b0100;
            4'b0011: botoes_in = 4'b1000;
          endcase

          if(rodadaInt == 4 && jogadaInt == 2) begin
            botoes_in = 4'b0001;
          end

          #(5*clockPeriod);
          botoes_in = 4'b0000;
          #(5*clockPeriod);
        end
      end

      // Incia o jogo novamente
      caso = 5;
      @(negedge clock_in);
      jogar_in = 4'b0001;
      #(10*clockPeriod);
      jogar_in = 4'b0000;
      #(10*clockPeriod);

      // final dos casos de teste da simulacao
      caso = 99;
      #100;
      $display("Fim da simulacao");
      $stop;
    end

  endmodule
