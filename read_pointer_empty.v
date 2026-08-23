module read_pointer_empty
(
    input              read_clk,
    input              rst,
    input              read_request,

    input      [3:0]   synchronized_gray_write_pointer,

    output reg [3:0]   binary_read_pointer,
    output reg [3:0]   gray_read_pointer,

    output reg         empty
);

wire [3:0] binary_read_pointer_next;
wire [3:0] gray_read_pointer_next;
wire       empty_next;

assign binary_read_pointer_next =
        (read_request && !empty) ?
        (binary_read_pointer + 4'd1) :
         binary_read_pointer;

assign gray_read_pointer_next =
        (binary_read_pointer_next >> 1) ^
         binary_read_pointer_next;

assign empty_next =
        (gray_read_pointer_next ==
         synchronized_gray_write_pointer);

always @(posedge read_clk or posedge rst)
begin
    if(rst)
    begin
        binary_read_pointer <= 4'b0000;
        gray_read_pointer   <= 4'b0000;
        empty               <= 1'b1;
    end
    else
    begin
        binary_read_pointer <= binary_read_pointer_next;
        gray_read_pointer   <= gray_read_pointer_next;
        empty               <= empty_next;
    end
end

endmodule