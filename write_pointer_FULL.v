module write_pointer_full
(
    input              write_clk,
    input              rst,
    input              write_request,

    input      [3:0]   synchronized_gray_read_pointer,

    output reg [3:0]   binary_write_pointer,
    output reg [3:0]   gray_write_pointer,

    output reg         full
);

wire [3:0] binary_write_pointer_next;
wire [3:0] gray_write_pointer_next;
wire       full_next;

assign binary_write_pointer_next =
        (write_request && !full) ?
        (binary_write_pointer + 4'd1) :
         binary_write_pointer;

assign gray_write_pointer_next =
        (binary_write_pointer_next >> 1) ^
         binary_write_pointer_next;

assign full_next =
        (gray_write_pointer_next ==
        {~synchronized_gray_read_pointer[3:2],
          synchronized_gray_read_pointer[1:0]});

always @(posedge write_clk or posedge rst)
begin
    if(rst)
    begin
        binary_write_pointer <= 4'b0000;
        gray_write_pointer   <= 4'b0000;
        full                 <= 1'b0;
    end
    else
    begin
        binary_write_pointer <= binary_write_pointer_next;
        gray_write_pointer   <= gray_write_pointer_next;
        full                 <= full_next;
    end
end

endmodule