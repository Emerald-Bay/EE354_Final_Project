//fixed levels
`timescale 1ns / 1ps

module block_controller(
	input clk, //this clock must be a slow enough clock to view the changing positions of the objects
	input bright,
	input rst,
	input up, input down, input left, input right,
	input [9:0] hCount, vCount,
	output reg [11:0] rgb,
	output reg [11:0] background
	);
	wire main_charac;

	//All Platform, Lava, Transistions, Etc. Objects - Level 1 through 8
	//Level One
	wire lvl1Block1; //down and left
	wire lvl1Block2; //left
	wire lvl1Block3; //up
	wire lvl1Block4; //up and right
	wire lvl1Block5; //down and right
	wire lvl1Block6; //down
	
	wire safelevel1; //to concatenate all safe level one blocks

	wire lvl1Lava;

	wire lvl1_To_lvl2;
	
	reg downflag;
	
	reg downstop;
	
	wire safeflag;
	
	wire collisionflag=1;
	
	//these two values dictate the center of the block, incrementing and decrementing them leads the block to move in certain directions
	reg [9:0] xpos, ypos;

	parameter RED    = 12'b1111_0000_0000; //Lava color
	parameter BLACK  = 12'b0000_0000_0000; //Platform Color
	parameter GREEN  = 12'b0000_1111_0000; //Character and Level-Transistion Color
	parameter YELLOW = 12'b1111_1111_0000; //Goal Color
	parameter CYAN   = 12'b0000_1111_1111; //Checkpoint Color
	
	parameter MAGENTA = 12'b1111_0000_1111; // Background color 1
	parameter ORANGE  = 12'b1111_1100_0000; // Background color 2
	parameter PURPLE  = 12'b1100_0011_1100; // Background color 3
	parameter BLUE    = 12'b0000_0000_1111; // Background color 4
	
		
	/*when outputting the rgb value in an always block like this, make sure to include the if(~bright) statement, as this ensures the monitor 
	will output some data to every pixel and not just the images you are trying to display*/
	
	always@ (*) begin
    	if(~bright)	//force black if not inside the display area
			rgb = BLACK;			
		else if (safelevel1==1)begin
			rgb = BLACK;
			safeflag=1;
		end
		else if (lvl1Lava==1)
			rgb = RED; // black box
		else
			rgb = background; // background colors, need to add colors
		
		if (main_charac == 1)
			rgb = ORANGE;
			collisionflag=1;
		if (collisionflag && safeflag)
			downstop=1;
	end
	
	

	
	//the background color reflects the most recent button press
	always@(posedge clk, posedge rst) begin
		if(rst)
			background <= 12'b1111_1111_1111;
		else 
			if(right)
				background <= MAGENTA;
			else if(left)
				background <= ORANGE;
			else if(down)
				background <= PURPLE;
			else if(up)
				background <= BLUE;
	end
	
	/*	
	always@ (*) begin
		if(up)begin
			downflag = ~ downflag;
		end
	end
	*/
		
	always@(posedge clk, posedge rst) 
     begin
		if(rst)begin
			xpos<=304;
			ypos<=220;
			downflag<=1;
			downstop<=0;
		end
		else if (clk) begin
			if(xpos==762 && ypos>=208 && ypos<=263) begin
				xpos<=304;
				ypos<=220; //TODO: transition for levels go to level 2
			end		
			
			else if(downflag==1 && downstop==0)begin
				ypos<=ypos+2; // go down
			end
			else if(downstop==1)begin
				ypos<=ypos; // on ground
			end
		    
		    else if(downflag==1 && ypos>=382 && ypos<444 && xpos>405 && xpos<565)begin
				ypos<=ypos+1;
			// slow death, only possible because of falling
			end
		    	else if(downflag==1 && ypos==444 && xpos>405 && xpos<565)begin
				xpos<=304;
				ypos<=220; // reset because of death, only possible because of falling
			end
		end
	end
	
	
	//the +-5 for the positions give the dimension of the block (i.e. it will be 10x10 pixels)
	assign main_charac=vCount>=(ypos-5) && vCount<=(ypos+5) && hCount>=(xpos-5) && hCount<=(xpos+5);
	assign bound_charac=vCount>=(ypos-7) && vCount<=(ypos+7) && hCount>=(xpos-7) && hCount<=(xpos+7);

	assign safelevel1 = lvl1Block1 | lvl1Block2 | lvl1Block3 | lvl1Block4 | lvl1Block5 | lvl1Block6;
	
	assign lvl1Block1 = ((hCount >= 10'd144) && (hCount <= 10'd400)) && ((vCount >= 10'd259) && (vCount <= 10'd515)) ? 1 : 0;
	assign lvl1Block2 = ((hCount >= 10'd144) && (hCount <= 10'd208)) && ((vCount >= 10'd35) && (vCount <= 10'd258)) ? 1 : 0;
	assign lvl1Block3 = ((hCount >= 10'd209) && (hCount <= 10'd784)) && ((vCount >= 10'd35) && (vCount <= 10'd155)) ? 1 : 0;
	assign lvl1Block4 = ((hCount >= 10'd639) && (hCount <= 10'd784)) && ((vCount >= 10'd156) && (vCount <= 10'd203)) ? 1 : 0;
	assign lvl1Block5 = ((hCount >= 10'd703) && (hCount <= 10'd784)) && ((vCount >= 10'd268) && (vCount <= 10'd427)) ? 1 : 0;
	assign lvl1Block6 = ((hCount >= 10'd561) && (hCount <= 10'd784)) && ((vCount >= 10'd387) && (vCount <= 10'd515)) ? 1 : 0;
	
	
	assign lvl1Lava = ((hCount >= 10'd401) && (hCount <= 10'd560)) && ((vCount >= 10'd387) && (vCount <= 10'd515)) ? 1 : 0;
	
	assign lvl1_To_lvl2 = ((hCount >= 10'd767) && (hCount <= 10'd783)) && ((vCount >= 10'd204) && (vCount <= 10'd267)) ? 1 : 0;
	
	
endmodule
