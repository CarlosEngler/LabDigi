`timescale 1ns/1ns

module mux2x1_n_tb;

    // Parametro
    parameter BITS = 4;
    
    // Entradas
    reg [BITS-1:0] D0, D1;
    reg            SEL;
    
    // Saída
    wire [BITS-1:0] OUT;
    
    // Instanciacao do DUT
    mux2x1_n #(
        .BITS(BITS)
    ) mux_inst (
        .D0  ( D0  ),
        .D1  ( D1  ),
        .SEL ( SEL ),
        .OUT ( OUT )
    );
    
    // Geracao de Estimulos
    initial begin
        $monitor("Time=%0t D0=%b D1=%b SEL=%b MUX_OUT=%b", $time, D0, D1, SEL, OUT);
        
        // Caso de teste 1: SEL = 0
        SEL = 0;
        D0 = 4'b0000; D1 = 4'b1111;
        #10;
        
        // Caso de teste 2: SEL = 1
        SEL = 1;
        D0 = 4'b1010; D1 = 4'b0101;
        #10;
        
        // Caso de teste 3: SEL = X
        SEL = 1'bx;
        D0 = 4'b1100; D1 = 4'b0011;
        #10;
        
        // Fim da simulacao
        $stop;
    end
    
endmodule
