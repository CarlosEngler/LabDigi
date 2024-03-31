//------------------------------------------------------------------
// Arquivo   : registrador_4.v
// Projeto   : Experiencia 4 - Projeto de uma Unidade de Controle 
//------------------------------------------------------------------
// Descricao : Registrador de 4 bits
//             
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     14/12/2023  1.0     Edson Midorikawa  versao inicial
//------------------------------------------------------------------
//
module registrador_6 (
    input        clock,
    input        clear,
    input        enable,
    input  [5:0] D,
    output [5:0] Q
);

    reg [5:0] IQ;

    always @(posedge clock or posedge clear) begin
        if (clear)
            IQ <= 0;
        else if (enable)
            IQ <= D;
    end

    assign Q = IQ;

endmodule