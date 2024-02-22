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
    input      [3:0] hexa;
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
        4'h0:    display = 7'b1000000;
        4'h1:    display = 7'b1111001;
        4'h2:    display = 7'b0100100;
        4'h3:    display = 7'b0110000;
        4'h4:    display = 7'b0011001;
        4'h5:    display = 7'b0010010;
        4'h6:    display = 7'b0000010;
        4'h7:    display = 7'b1111000;
        4'h8:    display = 7'b0000000;
        4'h9:    display = 7'b0010000;
        4'ha:    display = 7'b0001000;
        4'hb:    display = 7'b0000011;
        4'hc:    display = 7'b1000110;
        4'hd:    display = 7'b0100001;
        4'he:    display = 7'b0000110;
        4'hf:    display = 7'b0001110;
        default: display = 7'b1111111;
    endcase
endmodule

    /*
always @ (hexa) begin
    case (hexa)
        5'b00000: display = 7'b1000000;
        5'b00001: display = 7'b1111001;
        5'b00010: display = 7'b0100100;
        5'b00011: display = 7'b0110000;
        5'b00100: display = 7'b0011001;
        5'b00101: display = 7'b0010010;
        5'b00110: display = 7'b0000010;
        5'b00111: display = 7'b1111000;
        5'b01000: display = 7'b0000000;
        5'b01001: display = 7'b0010000;
        5'b01010: display = 7'b0001000;
        5'b01011: display = 7'b0000011;
        5'b01100: display = 7'b1000110;
        5'b01101: display = 7'b0100001;
        5'b01110: display = 7'b0000110;
        5'b01111: display = 7'b0001110;
        5'b10000: display = 7'b0000000; // Para 'g'
        5'b10001: display = 7'b0001000; // Para 'h'
        5'b10010: display = 7'b0110000; // Para 'i'
        5'b10011: display = 7'b0111000; // Para 'j'
        default: display = 7'b1111111;
    endcase
end
 */

