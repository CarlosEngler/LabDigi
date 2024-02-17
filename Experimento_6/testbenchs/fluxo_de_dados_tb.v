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
  reg zeraCR_in;
  reg zeraE_in;
  reg contaCR_in;
  reg contaE_in;
  reg limpaRC_in;
  reg registraRC_in;
  reg zeraLeds_in;
  reg registraLeds_in;
  reg contaT_in;
  reg [3:0] botoes_in;
  reg led_selector_in;
  reg jogar;
  wire jogada_correta_out;
  wire enderecoIgualRodada_out;
  wire fimC_out;
  wire fimL_out;
  wire jogada_feita_out;
  wire db_tem_jogada_out;
  wire timeout_out;
  wire [3:0] db_contagem_out;
  wire [3:0] db_memoria_out;
  wire [3:0] db_jogada_out;
  wire [3:0] db_rodada_out;
  wire [3:0] leds_out;


  reg [3:0] Eatual, Eprox;

    // Configuração do clock
    parameter clockPeriod = 20; // in ns, f=50MHz


    // Define estados
    parameter idle              = 4'b0000;  // 0
    parameter preparacao        = 4'b0001;  // 1
    parameter inicio            = 4'b0010;  // 2
    parameter espera            = 4'b0011;  // 3
    parameter registra          = 4'b0100;  // 4
    parameter comparacao        = 4'b0101;  // 5
    parameter proxima_jogada    = 4'b0110;  // 6
    parameter ultima_jogada     = 4'b0111;  // 7
    parameter proxima_rodada    = 4'b1000;  // 8
  	parameter fim_A             = 4'b1010;  // A
    parameter atualiza_memoria  = 4'b1011;  // B
	  parameter fim_T             = 4'b1101;  // D
    parameter fim_E             = 4'b1110;  // E

    // Gerador de clock
    always #((clockPeriod / 2)) clock_in = ~clock_in;

    // Instancia do DUT
 	exp6_fluxo_dados FD(
    .clock                (clock_in),                     
    .zeraCR               (zeraCR_in),   
    .zeraE                (zeraE_in),    
    .contaCR              (contaCR_in),    
    .contaE               (contaE_in),   
    .limpaRC              (limpaRC_in),    
    .registraRC           (registraRC_in),   
    .zeraLeds             (zeraLeds_in),   
    .registraLeds         (registraLeds_in),   
	  .contaT               (contaT_in),   
    .botoes               (botoes_in),   
    .led_selector         (led_selector_in),   
    .jogada_correta       (jogada_correta_out),   
    .enderecoIgualRodada  (enderecoIgualRodada_out),      
    .fimC                 (fimC_out),   
    .fimL                 (fimL_out),   
    .jogada_feita         (jogada_feita_out),   
    .db_tem_jogada        (db_tem_jogada_out),    
	  .timeout              (timeout_out),    
    .db_contagem          (db_contagem_out),    
    .db_memoria           (db_memoria_out),   
    .db_jogada            (db_jogada_out),    
    .db_rodada            (db_rodada_out),    
    .leds                 (leds_out)   
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


      // Início Rodada 1
      #(10*clockPeriod);

      // Espera
      #(50*clockPeriod);

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

      // Ultima Jogada
      botoes_in = 0000;
      #(clockPeriod);
      
      // Proxima rodada
      botoes_in = 0000;
      #(clockPeriod);

      // rodada 2

      // Início Rodada 2
      botoes_in = 0000;
      #(clockPeriod);
      
      // Proxima rodada
      botoes_in = 0000;
      #(clockPeriod);

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
          
        zeraCR_in        = (Eatual == idle || Eatual == preparacao) ? 1'b1 : 1'b0;
        zeraE_in         = (Eatual == idle || Eatual == preparacao || Eatual == inicio) ? 1'b1 : 1'b0;
        limpaRC_in       = (Eatual == idle || Eatual == preparacao) ? 1'b1 : 1'b0;
        registraRC_in    = (Eatual == registra) ? 1'b1 : 1'b0;
        zeraLeds_in      = (Eatual == idle || Eatual == preparacao) ? 1'b1 : 1'b0;
        registraLeds_in  = (Eatual == registra || Eatual == inicio) ? 1'b1 : 1'b0;
        contaCR_in       = (Eatual == proxima_rodada) ? 1'b1 : 1'b0;
        contaE_in        = (Eatual == proxima_jogada) ? 1'b1 : 1'b0;
	    	contaT_in        = (Eatual == espera) ? 1'b1 : 1'b0;
        led_selector_in  = (Eatual == inicio || Eatual == preparacao || Eatual == proxima_rodada) ? 1'b1 : 1'b0;

    end

    always @* begin
      case (Eatual)
        idle:               Eprox = jogar ? preparacao : idle;
        preparacao:         Eprox = inicio;
        inicio:             Eprox = espera;
        espera:             Eprox = timeout_out ? fim_T : (jogada_feita_out ? registra : espera);
        registra:           Eprox = atualiza_memoria;
        atualiza_memoria:   Eprox = comparacao;
        comparacao:         Eprox = !jogada_correta_out ? fim_E : (enderecoIgualRodada_out ? ultima_jogada : proxima_jogada);
        proxima_jogada:     Eprox = espera;
        ultima_jogada:      Eprox = fimL_out ? fim_A : proxima_rodada;
        proxima_rodada:     Eprox = inicio;
        fim_T:              Eprox = jogar ? preparacao : fim_T;
        fim_E:              Eprox = jogar ? preparacao : fim_E;
        fim_A:              Eprox = jogar ? preparacao : fim_A;
        default:            Eprox = idle;
      endcase
    end 

  endmodule
