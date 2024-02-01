/* --------------------------------------------------------------------
 * Arquivo   : 16_acertos_tb.v
 * Projeto   : Experiencia 5 - Desenvolvimento de Projeto de 
 *             Circuitos Digitais em FPGA
 * --------------------------------------------------------------------
 * Descricao : testbench Verilog MODELO para circuito da Experiencia 5 
 *
 *             1) Plano de teste com 15 acertos, 1 erro mudança de estado das chaves sem ativar iniciar_in.
 *
 * --------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     01/02/2024  1.1     Carlos Engler    versão inicial
 * --------------------------------------------------------------------
*/

`timescale 1ns/1ns

module circuito_exp5_tb_modelo;

    // Sinais para conectar com o DUT
    // valores iniciais para fins de simulacao (ModelSim)
    reg        clock_in   = 1;
    reg        reset_in   = 0;
    reg        iniciar_in = 0;
    reg  [3:0] chaves_in  = 4'b0000;

    wire       acertou_out;
    wire       errou_out  ;
    wire       pronto_out ;
    wire [3:0] leds_out   ;

    wire       db_igual_out      ;
    wire [6:0] db_contagem_out   ;
    wire [6:0] db_memoria_out    ;
    wire [6:0] db_estado_out     ;
    wire [6:0] db_jogadafeita_out;
    wire       db_clock_out      ;
    wire       db_iniciar_out    ;
    wire       db_tem_jogada_out ;

    // Configuração do clock
    parameter clockPeriod = 20; // in ns, f=50MHz

    // Identificacao do caso de teste
    reg [31:0] caso = 0;

    // Gerador de clock
    always #((clockPeriod / 2)) clock_in = ~clock_in;

    // instanciacao do DUT (Device Under Test)
    circuito_exp5 dut (
      .clock          ( clock_in    ),
      .reset          ( reset_in    ),
      .iniciar        ( iniciar_in  ),
      .chaves         ( chaves_in   ),
      .acertou        ( acertou_out ),
      .errou          ( errou_out   ),
      .pronto         ( pronto_out  ),
      .leds           ( leds_out    ),
      .db_igual       ( db_igual_out       ),
      .db_contagem    ( db_contagem_out    ),
      .db_memoria     ( db_memoria_out     ),
      .db_estado      ( db_estado_out      ),
      .db_jogadafeita ( db_jogadafeita_out ),
      .db_clock       ( db_clock_out       ),
      .db_iniciar     ( db_iniciar_out     ),    
      .db_tem_jogada  ( db_tem_jogada_out  )
    );

    // geracao dos sinais de entrada (estimulos)
    initial begin
      $display("Inicio da simulacao");

      // condicoes iniciais
      caso       = 0;
      clock_in   = 1;
      reset_in   = 0;
      iniciar_in = 0;
      chaves_in  = 4'b0000;
      #clockPeriod;

      /*
       * Cenario de Teste 1 - acerta as 16 jogadas
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

      // Teste 2. iniciar=1 por 5 periodos de clock
      caso = 2;
      iniciar_in = 1;
      #(5*clockPeriod);
      iniciar_in = 0;
      // espera
      #(10*clockPeriod);

      // Teste 3. jogada #1 
      caso = 3;
      @(negedge clock_in);
      chaves_in = 4'b0001;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 4. jogada #2 
      caso = 4;
      @(negedge clock_in);
      chaves_in = 4'b0010;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 5. jogada #3 
      caso = 5;
      @(negedge clock_in);
      chaves_in = 4'b0100;
      #(10*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 6. jogada #4 
      caso = 6;
      @(negedge clock_in);
      chaves_in = 4'b1000; 
      #(5*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 7. jogada #5  
      caso = 7;
      @(negedge clock_in);
      chaves_in = 4'b0100; 
      #(5*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 8. jogada #6 
      caso = 8;
      @(negedge clock_in);
      chaves_in = 4'b0010; 
      #(5*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 9. jogada #7 
      caso = 9;
      @(negedge clock_in);
      chaves_in = 4'b0001; 
      #(5*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 10. jogada #8 
      caso = 10;
      @(negedge clock_in);
      chaves_in = 4'b0001; 
      #(5*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 11. jogada #9 
      caso = 11;
      @(negedge clock_in);
      chaves_in = 4'b0010; 
      #(5*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 12. jogada #10 
      caso = 12;
      @(negedge clock_in);
      chaves_in = 4'b0010; 
      #(5*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 13. jogada #11 
      caso = 13;
      @(negedge clock_in);
      chaves_in = 4'b0100; 
      #(5*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 14. jogada #12 
      caso = 14;
      @(negedge clock_in);
      chaves_in = 4'b0100; 
      #(5*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 15. jogada #13 
      caso = 15;
      @(negedge clock_in);
      chaves_in = 4'b1000; 
      #(5*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 16. jogada #14 
      caso = 16;
      @(negedge clock_in);
      chaves_in = 4'b1000; 
      #(5*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 17. jogada #15 
      caso = 17;
      @(negedge clock_in);
      chaves_in = 4'b0001; 
      #(5*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 18. jogada #16  //erro para validar off by one
      caso = 18;
      @(negedge clock_in);
      chaves_in = 4'b0010; 
      #(5*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      // Teste 19. jogada #117 
      caso = 19;
      @(negedge clock_in);
      chaves_in = 4'b0100; //jogada que seria certa na jogada anterior
      #(5*clockPeriod);
      chaves_in = 4'b0000;
      // espera entre jogadas
      #(10*clockPeriod);

      //teste 12. iniciar novamente
      caso = 20;
      iniciar_in = 1;
      #(5*clockPeriod);
      iniciar_in = 0;
      // espera
      #(10*clockPeriod);
    

      // final dos casos de teste da simulacao
      caso = 99;
      #100;
      $display("Fim da simulacao");
      $stop;
    end

  endmodule
