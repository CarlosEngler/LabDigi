

module wall_coliser
  (
   input          clock,
   input          [3:0] head,
   input          [1:0] direction,
   input          reset,
   output reg     colide
  );

    // parameter          LEFT  = 2'b01,
    // parameter          UP    = 2'b11,
    // parameter          DOWN  = 2'b10,
    // parameter          RIGHT = 2'b00;

always @(posedge clock or posedge reset) begin
    if (reset) begin
      colide <= 0;
    end else if (clock) begin
      end
        if (head[1:0] == 2'b11 && direction == 2'b00) begin
          colide <= 1;
        end
        else if (head[1:0] == 2'b00 && direction == 2'b01) begin
          colide <= 1;
        end 
        else if (head[3:2] == 2'b11 && direction == 2'b10) begin
          colide <= 1;
        end 
        else if (head[3:2] == 2'b00 && direction == 2'b11) begin
          colide <= 1;
        end 
        else begin
          colide <= 0;
        end
end

endmodule