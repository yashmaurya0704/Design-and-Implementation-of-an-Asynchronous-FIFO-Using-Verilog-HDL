module async_fifo
(
    input              write_clk,
    input              read_clk,
    input              rst,

    input              write_request,
    input              read_request,

    input      [7:0]   write_data,

    output     [7:0]   read_data,

    output             full,
    output             empty
);

wire [3:0] binary_write_pointer;
wire [3:0] gray_write_pointer;

wire [3:0] binary_read_pointer;
wire [3:0] gray_read_pointer;

wire [3:0] synchronized_gray_read_pointer;
wire [3:0] synchronized_gray_write_pointer;

fifo_memory u_fifo_memory
(
    .write_clk(write_clk),
    .enable(write_request && !full),

    .write_data(write_data),

    .write_address(binary_write_pointer[2:0]),
    .read_address(binary_read_pointer[2:0]),

    .read_data(read_data)
);

write_pointer_full u_write_pointer
(
    .write_clk(write_clk),
    .rst(rst),

    .write_request(write_request),

    .synchronized_gray_read_pointer
    (
        synchronized_gray_read_pointer
    ),

    .binary_write_pointer(binary_write_pointer),
    .gray_write_pointer(gray_write_pointer),

    .full(full)
);

read_pointer_empty u_read_pointer
(
    .read_clk(read_clk),
    .rst(rst),

    .read_request(read_request),

    .synchronized_gray_write_pointer
    (
        synchronized_gray_write_pointer
    ),

    .binary_read_pointer(binary_read_pointer),
    .gray_read_pointer(gray_read_pointer),

    .empty(empty)
);

synchronizer_read_to_write u_sync_r2w
(
    .write_clk(write_clk),
    .rst(rst),

    .gray_read_pointer(gray_read_pointer),

    .synchronized_gray_read_pointer
    (
        synchronized_gray_read_pointer
    )
);

synchronizer_write_to_read u_sync_w2r
(
    .read_clk(read_clk),
    .rst(rst),

    .gray_write_pointer(gray_write_pointer),

    .synchronized_gray_write_pointer
    (
        synchronized_gray_write_pointer
    )
);

endmodule