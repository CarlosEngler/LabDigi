

module wall_coliser
  (
   input          clock,
   input          [5:0] head,
   input          [1:0] direction,
   input          reset,
   output reg     colide
  );

    // parameter          LEFT  = 2'b01,
    // parameter          UP    = 2'b11,
    // parameter          DOWN  = 2'b10,
    // parameter          RIGHT = 2'b00;

always @ (head) begin
    if (reset) begin
      colide <= 0;
    end else if (clock) begin
      end
        if (head[2:0] == 3'b111 && direction == 2'b00) begin
          colide <= 1;
        end
        else if (head[2:0] == 3'b000 && direction == 2'b01) begin
          colide <= 1;
        end 
        else if (head[5:3] == 3'b111 && direction == 2'b10) begin
          colide <= 1;
        end 
        else if (head[5:3] == 3'b000 && direction == 2'b11) begin
          colide <= 1;
        end 
        else begin
          colide <= 0;
        end
end

endmodule