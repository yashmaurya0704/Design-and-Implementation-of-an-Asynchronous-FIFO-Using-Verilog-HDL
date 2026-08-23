module fifo_memory
(
    input write_clk,
    input enable,
    
    input [7:0] write_data,
    output [7:0] read_data,
    
    input [2:0] write_address,
    input [2:0] read_address
    
);

    reg [7:0] memory [0:7];
    
    always@(posedge write_clk)
    begin
        if(enable)
        begin
            memory[write_address] <= write_data; 
        end
    end
    
    assign read_data = memory[read_address];
    
endmodule