module vvprojectvv_bitchange(
    input clk,
    input bright,
    input button,
    input [9:0] hCount, vCount,
    output reg [11:0] rgb,
    output reg [15:0] score
);

    parameter BLACK = 12'b0000_0000_0000;
    parameter WHITE = 12'b1111_1111_1111;
    parameter RED   = 12'b1111_0000_0000;
    parameter GREEN = 12'b0000_1111_0000;
    
    reg [1:0] boxIndex;
    reg reset;
    
    initial begin
        boxIndex = 2'd0;
        reset = 1'b0;
    end

    always @ (*) begin
        case(boxIndex)
            2'd0, 2'd1: // Black boxes
                rgb = BLACK;
            2'd2: // Red box
                rgb = RED;
            default:
                rgb = BLACK;
        endcase
    end

    always @ (posedge clk) begin
        if (boxIndex == 2'd2)
            boxIndex <= 2'd0;
        else
            boxIndex <= boxIndex + 2'd1;
    end

    always @ (posedge clk) begin
        if ((reset == 1'b0) && (button == 1'b1) && (hCount >= 10'd144) && (hCount <= 10'd784) && (vCount >= 10'd400) && (vCount <= 10'd475)) begin
            reset <= 1'b1;
        end else if (vCount <= 10'd20) begin
            reset <= 1'b0;
        end
    end

    assign whiteZone = ((hCount >= 10'd144) && (hCount <= 10'd784)) && ((vCount >= 10'd400) && (vCount <= 10'd475)) ? 1 : 0;
    assign greenMiddleSquare = ((hCount >= 10'd340) && (hCount < 10'd380)) && ((vCount >= greenMiddleSquareY) && (vCount <= greenMiddleSquareY + 10'd40)) ? 1 : 0;

endmodule
