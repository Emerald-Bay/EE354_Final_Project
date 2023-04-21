//fixed levels
`timescale 1ns / 1ps

module block_controller(
	input clk, //this clock must be a slow enough clock to view the changing positions of the objects
	input bright,
	input rst,
	input up, input down, input left, input right,
	input [9:0] hCount, vCount,
	output reg [11:0] rgb,
	output reg [11:0] background,
	input [3:0] Sin
	);
	wire main_charac;
	wire downflag;
	
	wire stopUpflag;
	wire stopDownflag;
	wire stopRightflag;
	wire stopLeftflag;
	
	wire blockerup;
	wire blockerdown;
	wire blockerright;
	wire blockerleft;
	
	wire deadflag;
	
	reg [4:0] stage;
	
	//these two values dictate the center of the block, incrementing and decrementing them leads the block to move in certain directions
	reg [9:0] xpos, ypos;
	
	//////////////////////////////////
	parameter RED    = 12'b1111_0000_0000; //Lava color
	parameter BLACK  = 12'b0000_0000_0000; //Platform Color
	parameter GREEN  = 12'b0000_1111_0000; //Character and Level-Transistion Color
	parameter YELLOW = 12'b1111_1111_0000; //Goal Color
	parameter CYAN   = 12'b0000_1111_1111; //Checkpoint Color
	
	parameter MAGENTA = 12'b1111_0000_1111; // Background color 1
	parameter ORANGE  = 12'b1111_1100_0000; // Background color 2
	parameter PURPLE  = 12'b1100_0011_1100; // Background color 3
	parameter BLUE    = 12'b0000_0000_1111; // Background color 4
	//////////////////////////////////
		
	
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
	
	//////////////////////////////////
	
	wire lvl1Block1; //down and left
	wire lvl1Block2; //left
	wire lvl1Block3; //up
	wire lvl1Block4; //up and right
	wire lvl1Block5; //down and right
	wire lvl1Block6; //down
	wire lvl1Lava;
	wire lvl1_To_lvl2;
	wire safelevel1; //to concatenate all safe level one blocks
	
	
	assign safelevel1up= lvl1Block3 || lvl1Block4;
	assign safelevel1down= lvl1Block1 || lvl1Block5 || lvl1Block6;
	assign safelevel1right= lvl1Block5 || lvl1Block4;
	assign safelevel1left= lvl1Block1 || lvl1Block2;
	
	
	assign blockerup = vCount>=(ypos-7) && vCount<=(ypos-5) && hCount>=(xpos+3) && hCount<=(xpos-3)? 1 : 0;
	assign blockerdown = vCount>=(ypos+3) && vCount<=(ypos+5) && hCount>=(xpos+3) && hCount<=(xpos-3)? 1 : 0;
	assign blockerright = vCount>=(ypos+3) && vCount<=(ypos-3) && hCount>=(xpos+7) && hCount<=(xpos+5)? 1 : 0;
	assign blockerleft = vCount>=(ypos+3) && vCount<=(ypos-3) && hCount>=(xpos-7) && hCount<=(xpos-5)? 1 : 0;
	
	always@ (*) begin
    	if(~hCount && ~vCount)begin
    		stopDownflag=0;
    		stopUpflag=0;
    		stopRightflag=0;
    		stopLeftflag=0;
    	end
    	
    	if(~bright)	//force black if not inside the display area
			rgb = BLACK;
		else if (lvl1_To_lvl2 == 1 ) 
			rgb = GREEN;
		
		else if (state == LVL1) begin
			if (safelevel1) begin
				rgb = BLACK;
				if (safelevel1down == 1 && blockerdown == 1)
					stopDownFlag = 1;
					
				if (safelevel1up == 1 && blockerup == 1)
					stopUpFlag = 1;
					
				if (safelevel1right == 1 && blockerright == 1)
					stopRightFlag = 1;
				
				if (safelevel1left == 1 && blockerleft == 1)
					stopLeftFlag = 1;
			end		
			if (lvl1Lava)
				rgb = RED;
				if(deaddown==1 && blockerdown ==1)
					deadflag=1;
					
			if(lvl1_To_lvl2)
				changelevel=1;		
		end
		
		else if (state == LEVEL2) begin
			rgb= BLUE;
			
		end
		else if (state == LEVEL3) begin
			rgb= YELLOW;
		end
		else if (state == LEVEL4) begin
			rgb= RED;
		end
		
		if (main_charac)
			rbg=GREEN;
		
		/*
		else if (state == LEVEL5) begin end
		else if (state == LEVEL6) beginend
		else if (state == LEVEL7) beginend
		else if (state == LEVEL8) beginend
		else if (state == WIN) beginend
		*/
	end

	
	assign safelevel1 = lvl1Block1 | lvl1Block2 | lvl1Block3 | lvl1Block4 | lvl1Block5 | lvl1Block6;
	
	assign lvl1Block1 = ((hCount >= 10'd144) && (hCount <= 10'd400)) && ((vCount >= 10'd259) && (vCount <= 10'd515)) ? 1 : 0;
	assign lvl1Block2 = ((hCount >= 10'd144) && (hCount <= 10'd208)) && ((vCount >= 10'd35) && (vCount <= 10'd258)) ? 1 : 0;
	assign lvl1Block3 = ((hCount >= 10'd209) && (hCount <= 10'd783)) && ((vCount >= 10'd35) && (vCount <= 10'd155)) ? 1 : 0;
	assign lvl1Block4 = ((hCount >= 10'd639) && (hCount <= 10'd783)) && ((vCount >= 10'd156) && (vCount <= 10'd203)) ? 1 : 0;
	assign lvl1Block5 = ((hCount >= 10'd703) && (hCount <= 10'd783)) && ((vCount >= 10'd268) && (vCount <= 10'd427)) ? 1 : 0;
	assign lvl1Block6 = ((hCount >= 10'd561) && (hCount <= 10'd783)) && ((vCount >= 10'd387) && (vCount <= 10'd515)) ? 1 : 0;
	
	assign lvl1Lava = ((hCount >= 10'd401) && (hCount <= 10'd560)) && ((vCount >= 10'd387) && (vCount <= 10'd515)) ? 1 : 0;
	
	assign lvl1_To_lvl2 = ((hCount >= 10'd767) && (hCount <= 10'd783)) && ((vCount >= 10'd204) && (vCount <= 10'd267)) ? 1 : 0;
	
	
	//////////////////////////////////
	
	always@ (Sin) begin
		if (Sin != 4'b0000) begin
			if (Sin == 4'b0001)
				state <= LEVEL1;
			else if (Sin == 4'b0010)
				state <= LEVEL2;
			else if (Sin == 4'b0100)
				state <= LEVEL3;
			else if (Sin == 4'b1000)
				state <= LEVEL4;
		end 
	end

	localparam
	INITIAL = 5'b00001,
	LEVEL1	= 5'b00010,
	LEVEL2	= 5'b00100,
	LEVEL3  = 5'b01000,
	LEVEL4  = 5'b10000;
	
	assign main_charac=vCount>=(ypos-5) && vCount<=(ypos+5) && hCount>=(xpos-5) && hCount<=(xpos+5);
	//the +-5 for the positions give the dimension of the block (i.e. it will be 10x10 pixels)
	
	always @(posedge clk, posedge rst) begin  : Moving_Logic
		if (state != INITIAL) //fix
			if(right && stoprightflag) begin
				xpos<=xpos;
			end
			else if(right) begin
				xpos<=xpos+2; //change the amount you increment to make the speed faster 
			end			
			else if(left && stopLeftflag) begin
				xpos<=xpos;
			end
			else if(left) begin
				xpos<=xpos-2;
			end	
			
			if(downflag==0 && stopUpflag) begin
				ypos<=ypos;
			end
			else if(downflag==0) begin
				ypos<=ypos-2; // test theory that if no stopped and downflag==0, should just go up
			end		
			else if(downflag==1 && stopDownflag)begin
				ypos<=ypos; // go down
			end
			else if(downflag==1)begin
				ypos<=ypos+2; // on ground
			end
		
	end
	
	
	always @(posedge clk, posedge rst) 
		begin  : The_Game
    	   if (rst)
       	    begin
       		   state <= INITIAL;  
           	   xpos<=304;
	       	   ypos<=220;
			   downflag = 1; 
       	    end
       	else
       	begin
         (* full_case, parallel_case *)
         case (state)
            INITIAL : 
              begin
                  if (down)
                    state <= LEVEL1;
              end

            LEVEL1:
            begin
				if(rst)
				begin 
					xpos<=304;
					ypos<=220;
					downflag = 1;
				end		
				else if (clk) begin
					if (level2to3) begin
                      	state <= LEVEL2;
						xpos<=304;
						ypos<=220; //TODO: transition for levels go to level 2
					end
		            else if(deadflag==1 && ypos>=382 && ypos<=414 && xpos>406 && xpos<570)begin
					   ypos<=ypos+1;
				     // slow death, only possible because of falling
				    end
				    else if(deadflag== 1 && ypos==414 && xpos>406 && xpos<570)begin
				    	xpos<=304;
				    	ypos<=220; // reset because of death, only possible because of falling
				    end
				 end
			
		  LEVEL2:begin
		  end
		
		  LEVEL3:begin
		  end
		
		  LEVEL4:begin
		  end
		
    end
    
    end
		
endmodule
