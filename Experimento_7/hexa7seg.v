/* ----------------------------------------------------------------
 * Arquivo   : hexa7seg.v
 * Projeto   : Experiencia 3 - Um Fluxo de Dados Simples
 *--------------------------------------------------------------
 * Descricao : decodificador hexadecimal para 
 *             display de 7 segmentos 
 * 
 * entrada : hexa - codigo binario de 4 bits hexadecimal
 * saida   : sseg - codigo de 7 bits para display de 7 segmentos
 *
 * baseado no componente bcd7seg.v da Intel FPGA
 *--------------------------------------------------------------
 * dica de uso: mapeamento para displays da placa DE0-CV
 *              bit 6 mais significativo é o bit a esquerda
 *              p.ex. sseg(6) -> HEX0[6] ou HEX06
 *--------------------------------------------------------------
 * Revisoes  :
 *     Data        Versao  Autor             Descricao
 *     24/12/2023  1.0     Edson Midorikawa  criacao
 *--------------------------------------------------------------
 */

module hexa7seg (hexa, display);
    input      [4:0] hexa;
    output reg [6:0] display;

    /*
     *    ---
     *   | 0 |
     * 5 |   | 1
     *   |   |
     *    ---
     *   | 6 |
     * 4 |   | 2
     *   |   |
     *    ---
     *     3
     */
        
    always @(hexa)
    case (hexa)
        5'h0: display = 7'b1000000;
        5'h1: display = 7'b1111001;
        5'h2: display = 7'b0100100;
        5'h3: display = 7'b0110000;
        5'h4: display = 7'b0011001;
        5'h5: display = 7'b0010010;
        5'h6: display = 7'b0000010;
        5'h7: display = 7'b1111000;
        5'h8: display = 7'b0000000;
        5'h9: display = 7'b0010000;
        5'ha: display = 7'b0001000;
        5'hb: display = 7'b0000011;
        5'hc: display = 7'b1000110;
        5'hd: display = 7'b0100001;
        5'he: display = 7'b0000110;
        5'hf: display = 7'b0001110;
        5'b10000: display  = 7'b0000010; // Para 'g'
        5'b10001: display  = 7'b0001011; // Para 'h'
        5'b10011: display  = 7'b0110000; // Para 'i'
        default: display = 7'b1111111;
    endcase
endmodule

