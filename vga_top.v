`timescale 1ns / 1ps

module vga_top(
	input ClkPort,
	input BtnC,
	input BtnU,
	input BtnR,
	input BtnL,
	input BtnD,
	//VGA signal
	output hSync, vSync,
	output [3:0] vgaR, vgaG, vgaB,
	
	output MemOE, MemWR, RamCS, QuadSpiFlashCS
	);
	wire Reset;
	assign Reset = BtnC;
	wire bright;
	wire[9:0] hc, vc;
	wire up,down,left,right;
	wire [11:0] rgb;
	wire rst;
	wire Start_Ack_SCEN;
	
	
	reg [27:0]	DIV_CLK;
	always @ (posedge ClkPort, posedge Reset)  
	begin : CLOCK_DIVIDER
      if (Reset)
			DIV_CLK <= 0;
	  else
			DIV_CLK <= DIV_CLK + 1'b1;
	end
	
	wire move_clk;
	assign move_clk=DIV_CLK[19]; //slower clock to drive the movement of objects on the vga screen

	display_controller dc(.clk(ClkPort), .hSync(hSync), .vSync(vSync), .bright(bright), .hCount(hc), .vCount(vc));
	game sc(.clk(move_clk), .bright(bright), .rst(BtnC), .up(BtnU), .down(BtnD), .left(BtnL), .right(BtnR), .hCount(hc), .vCount(vc), .rgb(rgb));
	
	
	assign vgaR = rgb[11 : 8];
	assign vgaG = rgb[7  : 4];
	assign vgaB = rgb[3  : 0];
	
	// disable mamory ports
	assign {MemOE, MemWR, RamCS, QuadSpiFlashCS} = 4'b1111;
	
endmodule
