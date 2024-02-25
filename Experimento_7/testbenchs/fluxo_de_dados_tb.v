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

module circuito_exp6_tb_fd;

    // Sinais para conectar com o DUT
    // valores iniciais para fins de simulacao (ModelSim)

  reg clock_in;
  reg zeraCR;
  reg zeraE;
  reg contaCR;
  reg contaE;
  reg limpaRC;
  reg registraRC;
  reg zeraLeds;
  reg registraLeds;
  reg contaT;
  reg [3:0] botoes_in;
  reg led_selector;
  reg jogar;
  reg pronto;
  reg ganhou;
  reg perdeu;
  wire jogada_correta;
  wire enderecoIgualRodada;
  wire fimC_out;
  wire fim;
  wire jogada_feita_out;
  wire db_tem_jogada_out;
  reg db_timeout;
  reg ram_enable;   
	wire halfsec_reach;
  wire twosec_reach;
  reg contaL;
  reg led_turn_off; 
  wire [3:0] db_contagem_out;
  wire [3:0] db_memoria_out;
  wire [3:0] db_jogada_out;
  wire [3:0] db_rodada_out;
  wire [3:0] leds_out;


  reg [4:0] Eatual, Eprox;

    // Configuração do clock
    parameter clockPeriod = 20; // in ns, f=50MHz


    // Define estados
    parameter idle                = 5'b00000;  // 0
    parameter preparacao          = 5'b00001;  // 1
    parameter inicia_rodada       = 5'b00010;  // 2
    parameter espera              = 5'b00011;  // 3
    parameter registra            = 5'b00100;  // 4
    parameter comparacao          = 5'b00101;  // 5
    parameter proxima_jogada      = 5'b00110;  // 6
    parameter ultima_jogada       = 5'b00111;  // 7
    parameter proxima_rodada      = 5'b01000;  // 8
	  parameter write_enable        = 5'b01001;  // 9
    parameter fim_A               = 5'b01010;  // A
    parameter atualiza_memoria    = 5'b01011;  // B
    parameter show_first_play     = 5'b01100;  // C
	  parameter fim_T               = 5'b01101;  // D
    parameter fim_E               = 5'b01110;  // E
    parameter show_last_play      = 5'b01111;  // F
    parameter show_wrong_play     = 5'b10000;  // G
    parameter show_correct_play   = 5'b10001;  // H

    // Gerador de clock
    always #((clockPeriod / 2)) clock_in = ~clock_in;

    // Instancia do DUT
 	exp7_fluxo_dados FD(
    .clock                (clock_in),                     
    .zeraCR               (zeraCR),   
    .zeraE                (zeraE),    
    .contaCR              (contaCR),    
    .contaE               (contaE),   
    .limpaRC              (limpaRC),    
    .registraRC           (registraRC),   
    .zeraLeds             (zeraLeds),   
    .registraLeds         (registraLeds),   
	  .contaT               (contaT),   
    .botoes               (botoes_in),   
    .led_selector         (led_selector),   
    .jogada_correta       (jogada_correta_out),   
    .enderecoIgualRodada  (enderecoIgualRodada),      
    .fimC                 (fimC_out),   
    .fimL                 (fim),   
    .jogada_feita         (jogada_feita),   
    .db_tem_jogada        (db_tem_jogada_out),    
	  .timeout              (timeout_out),    
    .db_contagem          (db_contagem_out),    
    .db_memoria           (db_memoria_out),   
    .db_jogada            (db_jogada_out),    
    .db_rodada            (db_rodada_out),    
    .leds                 (leds_out),
    .ram_enable           (ram_enable),
	  .halfsec_reach        (halfsec_reach),
    .twosec_reach         (twosec_reach),
    .contaL               (contaL),
    .led_turn_off         (led_turn_off)
);

    integer rodadaInt = 0;
    integer jogadaInt = 0;

    // geracao dos sinais de entrada (estimulos)
    initial begin
      $display("Inicio da simulacao");

      // inicialização
      jogar = 0;
      clock_in = 1;
      botoes_in = 4'd0;
      Eatual <= idle;
 
      //botões
      botoes_in = 4'd0;
      #(10*clockPeriod);

      // Começa o jogo => jogar = 1 => vai para o preparação
      jogar = 1;
      #(10*clockPeriod);
      jogar = 0;

      // Pisca Led
      #(2000*clockPeriod);

      // Início Rodada 1
      #(10*clockPeriod);

      // Espera
      #(5*clockPeriod);

      // Jogada
      botoes_in = 0001;
      #(clockPeriod);

      // Registra
      botoes_in = 0001;
      #(clockPeriod);
      
      // Atualiza Memória
      botoes_in = 0001;
      #(clockPeriod);
      
      // Comparação
      botoes_in = 0000;
      #(clockPeriod);

      //Pisca Led
      #(505*clockPeriod);

      // Ultima Jogada
      botoes_in = 0010;
      #(clockPeriod);
      
      // Proxima rodada
      botoes_in = 0000;
      #(clockPeriod);

      // Write_enable
      #(clockPeriod);

      // Início Rodada 2
      botoes_in = 0000;
      #(clockPeriod);

      //Pisca Led
      #(505*clockPeriod);

      // Espera
      #(50*clockPeriod);
      
      // Jogada 1
      botoes_in = 0001;
      #(clockPeriod);

      // Registra
      botoes_in = 0001;
      #(clockPeriod);

      // Atualiza Memória 
      #(clockPeriod);

      // Comparação 
      botoes_in = 0000;
      #(clockPeriod);

      // Proxima Jogada 
      #(clockPeriod);

      //Pisca Led
      #(505*clockPeriod);

      // Espera
      #(50*clockPeriod);

      // Jogada
      botoes_in = 0001;
      #(clockPeriod);

      // Registra
      botoes_in = 0001;
      #(clockPeriod);

      // Atualiza Memória 
      #(clockPeriod);

      // Comparação 
      botoes_in = 0000;
      #(clockPeriod);

      //Pisca Led
      #(505*clockPeriod);

      // Perdeu
      #(50*clockPeriod);

      #100;
      $display("Fim da simulacao");
      $stop;
    end

      always @(posedge clock_in) begin
            Eatual <= Eprox;
      end
        
        always @* begin
          
        zeraCR        = (Eatual == idle || Eatual == preparacao) ? 1'b1 : 1'b0;
        zeraE         = (Eatual == idle || Eatual == preparacao || Eatual == inicia_rodada) ? 1'b1 : 1'b0;
        limpaRC       = (Eatual == idle || Eatual == preparacao) ? 1'b1 : 1'b0;
        registraRC    = (Eatual == registra || Eatual == proxima_rodada) ? 1'b1 : 1'b0;
        zeraLeds      = (Eatual == idle) ? 1'b1 : 1'b0;
        registraLeds  = (Eatual == registra || Eatual == preparacao || Eatual == espera) ? 1'b1 : 1'b0;
        contaCR       = (Eatual == proxima_rodada) ? 1'b1 : 1'b0;
        contaE        = (Eatual == proxima_jogada || Eatual == proxima_rodada) ? 1'b1 : 1'b0;
        pronto        = (Eatual == fim_A || Eatual == fim_E || Eatual == fim_T) ? 1'b1 : 1'b0;
		    db_timeout    = (Eatual == fim_T) ? 1'b1 : 1'b0;
        ganhou        = (Eatual == fim_A) ? 1'b1 : 1'b0;
        perdeu        = (Eatual == fim_E || Eatual == fim_T) ? 1'b1 : 1'b0;
		    contaT        = (Eatual == espera) ? 1'b1 : 1'b0;
        contaL        = (Eatual == show_correct_play || Eatual == show_last_play || Eatual == show_first_play || Eatual == show_wrong_play) ? 1'b1 : 1'b0;
		    ram_enable    = (Eatual == write_enable) ? 1'b1 : 1'b0;
        led_selector  = (Eatual == inicia_rodada || Eatual == proxima_rodada || Eatual == preparacao || Eatual == idle) ? 1'b1 : 1'b0;
        led_turn_off  = (Eatual == espera || Eatual == ultima_jogada || Eatual == fim_A || Eatual == fim_E) ? 1'b1 : 1'b0;
      end
      always @* begin
        case (Eatual)
            idle:               Eprox = jogar ? preparacao : idle;
            preparacao:         Eprox = show_first_play;
			      show_first_play:    Eprox = twosec_reach ? espera : show_first_play;
            inicia_rodada:      Eprox = show_last_play;
            show_last_play:     Eprox = halfsec_reach ? espera : show_last_play;
            espera:             Eprox = timeout_out ? fim_T : (db_tem_jogada_out ? registra : espera);
            registra:           Eprox = atualiza_memoria;
            atualiza_memoria:   Eprox = comparacao;
            comparacao:         Eprox = !jogada_correta ? show_wrong_play : (enderecoIgualRodada ? show_correct_play : proxima_jogada);
            show_correct_play:  Eprox = halfsec_reach ? ultima_jogada : show_correct_play;
            show_wrong_play:    Eprox = halfsec_reach ? fim_E : show_wrong_play;
            proxima_jogada:     Eprox = show_last_play;
            ultima_jogada:      Eprox = fim ? fim_A : (db_tem_jogada_out ? proxima_rodada : ultima_jogada);
            proxima_rodada:     Eprox = write_enable;
			      write_enable:       Eprox = inicia_rodada;
			      fim_T:              Eprox = jogar ? preparacao : fim_T;
            fim_E:              Eprox = jogar ? preparacao : fim_E;
			      fim_A:              Eprox = jogar ? preparacao : fim_A;
            default:            Eprox = idle;
        endcase
    end

  endmodule
