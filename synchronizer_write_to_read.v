module synchronizer_write_to_read
(
    input              read_clk,
    input              rst,

    input      [3:0]   gray_write_pointer,

    output reg [3:0]   synchronized_gray_write_pointer
);

reg [3:0] gray_write_pointer_stage1;

always @(posedge read_clk or posedge rst)
begin
    if(rst)
    begin
        gray_write_pointer_stage1       <= 4'b0000;
        synchronized_gray_write_pointer <= 4'b0000;
    end
    else
    begin
        gray_write_pointer_stage1       <= gray_write_pointer;
        synchronized_gray_write_pointer <= gray_write_pointer_stage1;
    end
end

endmodule