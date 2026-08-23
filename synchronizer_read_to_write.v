module synchronizer_read_to_write
(
    input              write_clk,
    input              rst,
    input      [3:0]   gray_read_pointer,

    output reg [3:0]   synchronized_gray_read_pointer
);

reg [3:0] gray_read_pointer_stage1;

always @(posedge write_clk or posedge rst)
begin
    if(rst)
    begin
        gray_read_pointer_stage1       <= 4'b0000;
        synchronized_gray_read_pointer <= 4'b0000;
    end
    else
    begin
        gray_read_pointer_stage1       <= gray_read_pointer;
        synchronized_gray_read_pointer <= gray_read_pointer_stage1;
    end
end

endmodule