//------------------------------------------------------------------
// Arquivo   : registrador_4.v
// Projeto   : Experiencia 4 - Projeto de uma Unidade de Controle 
//------------------------------------------------------------------
// Descricao : Registrador de 4 bits
//             
//------------------------------------------------------------------
// Revisoes  :
//     Data        Versao  Autor             Descricao
//     14/12/2023  1.0     João Bassetti  versao inicial
//------------------------------------------------------------------
//
module registrador_1 (
    input        clock,
    input        clear,
    input        enable,
    input   D,
    output  Q
);

    reg IQ;

    always @(posedge clock or posedge clear) begin
        if (clear)
            IQ <= 0;
        else if (enable)
            IQ <= D;
    end

    assign Q = IQ;

endmodule