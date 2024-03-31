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

module mux4x1_n #(
    parameter BITS = 6
) (
    input      [BITS-1:0] D0,
    input      [BITS-1:0] D1,
    input      [BITS-1:0] D2,
    input      [BITS-1:0] D3,
    input      [1:0]      SEL,
    output reg [BITS-1:0] OUT
);

always @(*) begin
    case (SEL)
        2'b00:    OUT = D0;
        2'b01:    OUT = D1;
        2'b10:    OUT = D2;
        2'b11:    OUT = D3;
        default: OUT = {BITS{2'b11}};
    endcase
end

endmodule
