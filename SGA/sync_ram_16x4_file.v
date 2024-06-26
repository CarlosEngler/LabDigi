//------------------------------------------------------------------
// Arquivo   : sync_ram_16x4_file.v
// Projeto   : Experiencia 7 - Projeto do Jogo do Desafio da Memória
 
//------------------------------------------------------------------
// Descricao : RAM sincrona 16x4
//
//   - conteudo inicial armazenado em arquivo .txt
//   - descricao baseada em template 'single_port_ram_with_init.v' 
//     do Intel Quartus Prime
//             
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     02/02/2024  1.0     Edson Midorikawa  versao inicial
//------------------------------------------------------------------
//

module sync_ram_16x4_file #(
    parameter BINFILE = "ram_init.txt"
)
(
    input        clk,
    input        we,
	input        restart,
    input  [5:0] data,
    input  [5:0] addr,
    output [5:0] q,
    output [5:0] head
);

    // Variavel RAM (armazena dados)
    reg [5:0] ram[63:0];

    // Registra endereco de acesso
    reg [5:0] addr_reg;

    // Especifica conteudo inicial da RAM
    // a partir da leitura de arquivo usando $readmemb

    always @ (posedge clk or posedge restart)
    begin
	 if(restart) begin
		  ram[0] <= 6'b001011;
          ram[1] <= 6'b000101;
	 end else begin
		 if (we)
				ram[addr] <= data;

			   addr_reg <= addr;
		 end
	 end

    // Atribuicao continua retorna dado
    assign q = ram[addr_reg];
    assign head = ram[0];

endmodule
