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
	
	parameter RED    = 12'b1111_0000_0000; //Lava color
	parameter BLACK  = 12'b0000_0000_0000; //Platform Color
	parameter GREEN  = 12'b0000_0000_1111; //Level-Transistion Color
	parameter YELLOW = 12'b1111_1111_0000; //Goal Color
	parameter CYAN   = 12'b0000_1111_1111; //Checkpoint Color
	
	parameter MAGENTA = 12'b1111_0000_1111; // Background color 1
	parameter ORANGE  = 12'b1111_1100_0000; // Background color 2
	parameter PURPLE  = 12'b1100_0011_1100; // Background color 3
	parameter PINK    = 12'b1111_0000_1111; // Background color 4
	
		
	/*when outputting the rgb value in an always block like this, make sure to include the if(~bright) statement, as this ensures the monitor 
	will output some data to every pixel and not just the images you are trying to display*/
	
	always@ (*) begin
    	if(~bright)	//force black if not inside the display area
			rgb = BLACK;
		else if (safelevel1==1)
			rgb = BLACK; // black box
		else if (main_charac ==1 || lvl1_To_lvl2 == 1) 
			rgb = GREEN;
		else if (lvl1Lava==1 )
			rgb = RED; // black box
		else
			rgb = background; // background colors, need to add colors
	end
	

	//these two values dictate the center of the block, incrementing and decrementing them leads the block to move in certain directions
	reg [9:0] xpos, ypos;
	
	/*when outputting the rgb value in an always block like this, make sure to include the if(~bright) statement, as this ensures the monitor 
	will output some data to every pixel and not just the images you are trying to display*/
	
	
		//the +-5 for the positions give the dimension of the block (i.e. it will be 10x10 pixels)
	assign main_charac=vCount>=(ypos-5) && vCount<=(ypos+5) && hCount>=(xpos-5) && hCount<=(xpos+5);
	
	assign safelevel1 = lvl1Block1 | lvl1Block2 | lvl1Block3 | lvl1Block4 | lvl1Block5 | lvl1Block6;
	
	assign lvl1Block1 = ((hCount >= 10'd144) && (hCount <= 10'd400)) && ((vCount >= 10'd259) && (vCount <= 10'd515)) ? 1 : 0;
	assign lvl1Block2 = ((hCount >= 10'd144) && (hCount <= 10'd208)) && ((vCount >= 10'd35) && (vCount <= 10'd258)) ? 1 : 0;
	assign lvl1Block3 = ((hCount >= 10'd209) && (hCount <= 10'd783)) && ((vCount >= 10'd35) && (vCount <= 10'd155)) ? 1 : 0;
	assign lvl1Block4 = ((hCount >= 10'd639) && (hCount <= 10'd783)) && ((vCount >= 10'd156) && (vCount <= 10'd203)) ? 1 : 0;
	assign lvl1Block5 = ((hCount >= 10'd703) && (hCount <= 10'd783)) && ((vCount >= 10'd268) && (vCount <= 10'd427)) ? 1 : 0;
	assign lvl1Block6 = ((hCount >= 10'd561) && (hCount <= 10'd783)) && ((vCount >= 10'd387) && (vCount <= 10'd515)) ? 1 : 0;
	
	assign lvl1Lava = ((hCount >= 10'd401) && (hCount <= 10'd560)) && ((vCount >= 10'd387) && (vCount <= 10'd515)) ? 1 : 0;
	
	assign lvl1_To_lvl2 = ((hCount >= 10'd767) && (hCount <= 10'd783)) && ((vCount >= 10'd204) && (vCount <= 10'd267)) ? 1 : 0;
	
	
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
				background <= PINK;
	end
	
	
	always@(posedge clk, posedge rst) 
	begin
		if(rst)
		begin 
			//rough values for center of screen
			xpos<=450;
			ypos<=250;
			
		end
		else if (clk) begin
		/* Note that the top left of the screen does NOT correlate to vCount=0 and hCount=0. The display_controller.v file has the 
			synchronizing pulses for both the horizontal sync and the vertical sync begin at vcount=0 and hcount=0. Recall that after 
			the length of the pulse, there is also a short period called the back porch before the display area begins. So effectively, 
			the top left corner corresponds to (hcount,vcount)~(144,35). Which means with a 640x480 resolution, the bottom right corner 
			corresponds to ~(783,515).  
		*/
			if(right) begin
				xpos<=xpos+2; //change the amount you increment to make the speed faster 
				if(xpos==800) //these are rough values to attempt looping around, you can fine-tune them to make it more accurate- refer to the block comment above
					xpos<=150;
			end
			else if(left) begin
				xpos<=xpos-2;
				if(xpos==150)
					xpos<=800;
			end
			else if(up) begin
				ypos<=ypos-2;
				if(ypos==34)
					ypos<=514;
			end
			else if(down) begin
				ypos<=ypos+2;
				if(ypos==514)
					ypos<=34;
			end
		end
	end
	
endmodule
