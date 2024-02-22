/*------------------------------------------------------------------------
 * Arquivo   : mux2x1_n.v
 * Projeto   : Jogo do Desafio da Memoria
 *------------------------------------------------------------------------
 * Descricao : multiplexador 2x1 com entradas de n bits (parametrizado) 
 * 
 * adaptado a partir do codigo my_4t1_mux.vhd do livro "Free Range VHDL"
 * 
 * exemplo de uso: ver testbench mux2x1_n_tb.v
 *------------------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     15/02/2024  1.0     Edson Midorikawa  criacao
 *------------------------------------------------------------------------
 */

module mux2x1_n #(
    parameter BITS = 4
) (
    input      [BITS-1:0] D0,
    input      [BITS-1:0] D1,
    input                 SEL,
    output reg [BITS-1:0] OUT
);

always @(*) begin
    case (SEL)
        1'b0:    OUT = D0;
        1'b1:    OUT = D1;
        default: OUT = {BITS{1'b1}}; // todos os bits em 1
    endcase
end

endmodule
