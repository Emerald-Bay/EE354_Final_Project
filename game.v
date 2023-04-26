//fixed levels
`timescale 1ns / 1ps

module game(
	input clk, //this clock must be a slow enough clock to view the changing positions of the objects
	input bright,
	input rst,
	input up, input down, input left, input right,
	input [9:0] hCount, vCount,
	output reg [11:0] rgb
	);
	wire main_charac;

	// Other regs and wires needed

	reg checkpointFlag;
	reg[11:0] background;

	reg gravity;

	parameter DOWN = 0;
	parameter UP   = 1;

	reg[8:0] stage;

	parameter LVL1 = 9'b000000001; 
	parameter LVL2 = 9'b000000010; 
	parameter LVL3 = 9'b000000100; 
	parameter LVL4 = 9'b000001000; 
	parameter LVL5 = 9'b000010000; 
	parameter LVL6 = 9'b000100000; 
	parameter LVL7 = 9'b001000000; 
	parameter LVL8 = 9'b010000000; 
	parameter WIN  = 9'b100000000;
	
	// these two values dictate the center of the block, incrementing and decrementing them leads the block to move in certain directions
	reg [9:0] xPos, yPos;
	// collision boxes, always relative to xPos and yPos
	wire [9:0] pos_bottom_left_x, pos_bottom_right_x;
	wire [9:0] pos_bottom_y;
	wire [9:0] pos_top_left_x, pos_top_right_x;
	wire [9:0] pos_top_y;
	wire [9:0] pos_right_x;
	wire [9:0] pos_right_bottom_y, pos_right_top_y;
	wire [9:0] pos_left_x;
	wire [9:0] pos_left_bottom_y, pos_left_top_y;

	// the +-5 for the positions give the dimension of the block (i.e. it will be 11x11 pixels)
	assign main_charac = (vCount>=(yPos-5) && vCount<=(yPos+5) && hCount>=(xPos-5) && hCount<=(xPos+5)) ? 1 : 0;
	// collision boxes on each side of the character box (2x6 box)
	assign pos_bottom_left_x = xPos - 5;
	assign pos_bottom_right_x = xPos + 5;
	assign pos_bottom_y = yPos + 7;
	assign pos_top_left_x = xPos - 5;
	assign pos_top_right_x = xPos + 5;
	assign pos_top_y = yPos - 7;
	assign pos_right_x = xPos + 7;
	assign pos_right_bottom_y = yPos + 5;
	assign pos_right_top_y = yPos - 5;
	assign pos_left_x = xPos - 7;
	assign pos_left_bottom_y = yPos + 5;
	assign pos_left_top_y = yPos - 5;

	//
	// Level 1
	//
	wire lvl1Block1; // down and left
	wire lvl1Block2; // left
	wire lvl1Block3; // up
	wire lvl1Block4; // up and right
	wire lvl1Block5; // down and right
	wire lvl1Block6; // down
	
	wire safelevel1; // to concatenate all safe level one blocks

	wire lvl1Lava;

	wire lvl1_To_lvl2;

	// Block - Lava - Transistion Displays
	assign lvl1Block1 = ((hCount >= 10'd144) && (hCount <= 10'd400)) && ((vCount >= 10'd259) && (vCount <= 10'd515)) ? 1 : 0;
	assign lvl1Block2 = ((hCount >= 10'd144) && (hCount <= 10'd208)) && ((vCount >= 10'd35) && (vCount <= 10'd258)) ? 1 : 0;
	assign lvl1Block3 = ((hCount >= 10'd209) && (hCount <= 10'd784)) && ((vCount >= 10'd35) && (vCount <= 10'd115)) ? 1 : 0;
	assign lvl1Block4 = ((hCount >= 10'd639) && (hCount <= 10'd784)) && ((vCount >= 10'd116) && (vCount <= 10'd163)) ? 1 : 0;
	assign lvl1Block5 = ((hCount >= 10'd703) && (hCount <= 10'd784)) && ((vCount >= 10'd227) && (vCount <= 10'd427)) ? 1 : 0;
	assign lvl1Block6 = ((hCount >= 10'd561) && (hCount <= 10'd784)) && ((vCount >= 10'd387) && (vCount <= 10'd515)) ? 1 : 0;
	
	assign lvl1Lava = ((hCount >= 10'd401) && (hCount <= 10'd560)) && ((vCount >= 10'd387) && (vCount <= 10'd515)) ? 1 : 0;
	
	assign lvl1_To_lvl2 = ((hCount >= 10'd767) && (hCount <= 10'd784)) && ((vCount >= 10'd164) && (vCount <= 10'd226)) ? 1 : 0;

	assign safelevel1 = lvl1Block1 || lvl1Block2 || lvl1Block3 || lvl1Block4 || lvl1Block5 || lvl1Block6;

	// Down Block Collisions
	assign lvl1Block1_col_down1 = ((pos_bottom_left_x >= 10'd144) && (pos_bottom_left_x <= 10'd400)) && ((pos_bottom_y >= 10'd259) && (pos_bottom_y <= 10'd515)) ? 1 : 0;
	assign lvl1Block1_col_down2 = ((pos_bottom_right_x >= 10'd144) && (pos_bottom_right_x <= 10'd400)) && ((pos_bottom_y >= 10'd259) && (pos_bottom_y <= 10'd515)) ? 1 : 0;
	assign lvl1Block5_col_down1 = ((pos_bottom_left_x >= 10'd703) && (pos_bottom_left_x <= 10'd784)) && ((pos_bottom_y >= 10'd227) && (pos_bottom_y <= 10'd427)) ? 1 : 0;
	assign lvl1Block5_col_down2 = ((pos_bottom_right_x >= 10'd703) && (pos_bottom_right_x <= 10'd784)) && ((pos_bottom_y >= 10'd227) && (pos_bottom_y <= 10'd427)) ? 1 : 0;
	assign lvl1Block6_col_down1 = ((pos_bottom_left_x >= 10'd561) && (pos_bottom_left_x <= 10'd784)) && ((pos_bottom_y >= 10'd387) && (pos_bottom_y <= 10'd515)) ? 1 : 0;
	assign lvl1Block6_col_down2 = ((pos_bottom_right_x >= 10'd561) && (pos_bottom_right_x <= 10'd784)) && ((pos_bottom_y >= 10'd387) && (pos_bottom_y <= 10'd515)) ? 1 : 0;

	assign lvl1_col_down = lvl1Block1_col_down1 || lvl1Block1_col_down2 || lvl1Block5_col_down1 || lvl1Block5_col_down2 || lvl1Block6_col_down1 || lvl1Block6_col_down2;

	// Left Block Collisions
	assign lvl1Block1_col_left1 = ((pos_left_x >= 10'd144) && (pos_left_x <= 10'd400)) && ((pos_left_bottom_y >= 10'd259) && (pos_left_bottom_y <= 10'd515)) ? 1 : 0;
	assign lvl1Block1_col_left2 = ((pos_left_x >= 10'd144) && (pos_left_x <= 10'd400)) && ((pos_left_top_y >= 10'd259) && (pos_left_top_y <= 10'd515)) ? 1 : 0;
	assign lvl1Block2_col_left1 = ((pos_left_x >= 10'd144) && (pos_left_x <= 10'd208)) && ((pos_left_bottom_y >= 10'd35) && (pos_left_bottom_y <= 10'd258)) ? 1 : 0;
	assign lvl1Block2_col_left2 = ((pos_left_x >= 10'd144) && (pos_left_x <= 10'd208)) && ((pos_left_top_y >= 10'd35) && (pos_left_top_y <= 10'd258)) ? 1 : 0;

	assign lvl1_col_left = lvl1Block1_col_left1 || lvl1Block1_col_left2 || lvl1Block2_col_left1 || lvl1Block2_col_left2;

	// Up Block Collisions
	assign lvl1Block3_col_up1 = ((pos_top_left_x >= 10'd209) && (pos_top_left_x <= 10'd784)) && ((pos_top_y >= 10'd35) && (pos_top_y <= 10'd115)) ? 1 : 0;
	assign lvl1Block3_col_up2 = ((pos_top_right_x >= 10'd209) && (pos_top_right_x <= 10'd784)) && ((pos_top_y >= 10'd35) && (pos_top_y <= 10'd115)) ? 1 : 0;
	assign lvl1Block4_col_up1 = ((pos_top_left_x >= 10'd639) && (pos_top_left_x <= 10'd784)) && ((pos_top_y >= 10'd116) && (pos_top_y <= 10'd163)) ? 1 : 0;
	assign lvl1Block4_col_up2 = ((pos_top_right_x >= 10'd639) && (pos_top_right_x <= 10'd784)) && ((pos_top_y >= 10'd116) && (pos_top_y <= 10'd163)) ? 1 : 0;

	assign lvl1_col_up = lvl1Block3_col_up1 || lvl1Block3_col_up2 || lvl1Block4_col_up1 || lvl1Block4_col_up2;

	// Right Block Collisions
	assign lvl1Block4_col_right1 = ((pos_right_x >= 10'd639) && (pos_right_x <= 10'd784)) && ((pos_right_bottom_y >= 10'd116) && (pos_right_bottom_y <= 10'd163)) ? 1 : 0;
	assign lvl1Block4_col_right2 = ((pos_right_x >= 10'd639) && (pos_right_x <= 10'd784)) && ((pos_right_top_y >= 10'd116) && (pos_right_top_y <= 10'd163)) ? 1 : 0;
	assign lvl1Block5_col_right1 = ((pos_right_x >= 10'd703) && (pos_right_x <= 10'd784)) && ((pos_right_bottom_y >= 10'd227) && (pos_right_bottom_y <= 10'd427)) ? 1 : 0;
	assign lvl1Block5_col_right2 = ((pos_right_x >= 10'd703) && (pos_right_x <= 10'd784)) && ((pos_right_top_y >= 10'd227) && (pos_right_top_y <= 10'd427)) ? 1 : 0;

	assign lvl1_col_right = lvl1Block4_col_right1 || lvl1Block4_col_right2 || lvl1Block5_col_right1 || lvl1Block5_col_right2;
	
	// Lava Collisions
	assign lvl1Lava_col = ((xPos >= 10'd401) && (xPos <= 10'd560)) && ((yPos >= 10'd387) && (yPos <= 10'd515)) ? 1 : 0;
	
	// Transitition Collisions
	assign lvl1_To_lvl2_col = ((xPos >= 10'd767) && (xPos <= 10'd784)) && ((yPos >= 10'd164) && (yPos <= 10'd226)) ? 1 : 0;

	//
	// Level Two
	//
    wire lvl2Block1; // down and left
    wire lvl2Block2; // up and left
    wire lvl2Block3; // up and left and right
    wire lvl2Block4; // down and left and right
    wire lvl2Block5; // down
    wire lvl2Block6; // up and right

	wire safelvl2;

    wire lvl2Lava;

    wire lvl2_To_lvl1;
    wire lvl2_To_lvl3;
    wire lvl2_To_lvl7;
    wire lvl2_To_lvl8;

    assign lvl2Block1 = ((hCount >= 10'd144) && (hCount <= 10'd400)) && ((vCount >= 10'd227) && (vCount <= 10'd515));
    assign lvl2Block2 = ((hCount >= 10'd144) && (hCount <= 10'd336)) && ((vCount >= 10'd35) && (vCount <= 10'd163)) ? 1 : 0;
    assign lvl2Block3 = ((hCount >= 10'd593) && (hCount <= 10'd656)) && ((vCount >= 10'd35) && (vCount <= 10'd163)) ? 1 : 0;
    assign lvl2Block4 = ((hCount >= 10'd529) && (hCount <= 10'd656)) && ((vCount >= 10'd227) && (vCount <= 10'd515)) ? 1 : 0;
    assign lvl2Block5 = ((hCount >= 10'd655) && (hCount <= 10'd784)) && ((vCount >= 10'd386) && (vCount <= 10'd515)) ? 1 : 0;
    assign lvl2Block6 = ((hCount >= 10'd719) && (hCount <= 10'd784)) && ((vCount >= 10'd35) && (vCount <= 10'd323)) ? 1 : 0;

	assign safelevel2 = lvl2Block1 || lvl2Block2 || lvl2Block3 || lvl2Block4 || lvl2Block5 || lvl2Block6;

    assign lvl2Lava = ((hCount >= 10'd337) && (hCount <= 10'd592)) && ((vCount >= 10'd35) && (vCount <= 10'd67)) ? 1 : 0;

    assign lvl2_To_lvl1 = ((hCount >= 10'd144) && (hCount <= 10'd160)) && ((vCount >= 10'd164) && (vCount <= 10'd226)) ? 1 : 0;
    assign lvl2_To_lvl3 = ((hCount >= 10'd401) && (hCount <= 10'd528)) && ((vCount >= 10'd499) && (vCount <= 10'd515)) ? 1 : 0;
    assign lvl2_To_lvl7 = ((hCount >= 10'd767) && (hCount <= 10'd784)) && ((vCount >= 10'd324) && (vCount <= 10'd387)) ? 1 : 0;
    assign lvl2_To_lvl8 = ((hCount >= 10'd657) && (hCount <= 10'd720)) && ((vCount >= 10'd35) && (vCount <= 10'd51)) ? 1 : 0;

	// Down Block Collisions
	assign lvl2Block1_col_down1 = ((pos_bottom_left_x >= 10'd144) && (pos_bottom_left_x <= 10'd400)) && ((pos_bottom_y >= 10'd227) && (pos_bottom_y <= 10'd515)) ? 1 : 0;
	assign lvl2Block1_col_down2 = ((pos_bottom_right_x >= 10'd144) && (pos_bottom_right_x <= 10'd400)) && ((pos_bottom_y >= 10'd227) && (pos_bottom_y <= 10'd515)) ? 1 : 0;
	assign lvl2Block4_col_down1 = ((pos_bottom_left_x >= 10'd529) && (pos_bottom_left_x <= 10'd656)) && ((pos_bottom_y >= 10'd227) && (pos_bottom_y <= 10'd515)) ? 1 : 0;
	assign lvl2Block4_col_down2 = ((pos_bottom_right_x >= 10'd529) && (pos_bottom_right_x <= 10'd656)) && ((pos_bottom_y >= 10'd227) && (pos_bottom_y <= 10'd515)) ? 1 : 0;
	assign lvl2Block5_col_down1 = ((pos_bottom_left_x >= 10'd655) && (pos_bottom_left_x <= 10'd784)) && ((pos_bottom_y >= 10'd386) && (pos_bottom_y <= 10'd515)) ? 1 : 0;
	assign lvl2Block5_col_down2 = ((pos_bottom_right_x >= 10'd655) && (pos_bottom_right_x <= 10'd784)) && ((pos_bottom_y >= 10'd386) && (pos_bottom_y <= 10'd515)) ? 1 : 0;

	assign lvl2_col_down = lvl2Block1_col_down1 || lvl2Block1_col_down2 || lvl2Block4_col_down1 || lvl2Block4_col_down2 || lvl2Block5_col_down1 || lvl2Block5_col_down2;
   
	// Left Block Collisions
	assign lvl2Block1_col_left1 = ((pos_left_x >= 10'd144) && (pos_left_x <= 10'd400)) && ((pos_left_bottom_y >= 10'd227) && (pos_left_bottom_y <= 10'd515)) ? 1 : 0;
	assign lvl2Block1_col_left2 = ((pos_left_x >= 10'd144) && (pos_left_x <= 10'd400)) && ((pos_left_top_y >= 10'd227) && (pos_left_top_y <= 10'd515)) ? 1 : 0;
	assign lvl2Block2_col_left1 = ((pos_left_x >= 10'd144) && (pos_left_x <= 10'd336)) && ((pos_left_bottom_y >= 10'd35) && (pos_left_bottom_y <= 10'd163)) ? 1 : 0;
	assign lvl2Block2_col_left2 = ((pos_left_x >= 10'd144) && (pos_left_x <= 10'd336)) && ((pos_left_top_y >= 10'd35) && (pos_left_top_y <= 10'd163)) ? 1 : 0;
	assign lvl2Block3_col_left1 = ((pos_left_x >= 10'd593) && (pos_left_x <= 10'd656)) && ((pos_left_bottom_y >= 10'd35) && (pos_left_bottom_y <= 10'd163)) ? 1 : 0;
	assign lvl2Block3_col_left2 = ((pos_left_x >= 10'd593) && (pos_left_x <= 10'd656)) && ((pos_left_top_y >= 10'd35) && (pos_left_top_y <= 10'd163)) ? 1 : 0;
	assign lvl2Block4_col_left1 = ((pos_left_x >= 10'd529) && (pos_left_x <= 10'd656)) && ((pos_left_bottom_y >= 10'd227) && (pos_left_bottom_y <= 10'd515)) ? 1 : 0;
	assign lvl2Block4_col_left2 = ((pos_left_x >= 10'd529) && (pos_left_x <= 10'd656)) && ((pos_left_top_y >= 10'd227) && (pos_left_top_y <= 10'd515)) ? 1 : 0;

	assign lvl2_col_left = lvl2Block1_col_left1 || lvl2Block1_col_left2 || lvl2Block2_col_left1 || lvl2Block2_col_left2 || lvl2Block3_col_left1 || lvl2Block3_col_left2 || lvl2Block4_col_left1 || lvl2Block4_col_left2;

	// Up Block Collisions
	assign lvl2Block2_col_up1 = ((pos_top_left_x >= 10'd144) && (pos_top_left_x <= 10'd336)) && ((pos_top_y >= 10'd35) && (pos_top_y <= 10'd163)) ? 1 : 0;
	assign lvl2Block2_col_up2 = ((pos_top_right_x >= 10'd144) && (pos_top_right_x <= 10'd336)) && ((pos_top_y >= 10'd35) && (pos_top_y <= 10'd163)) ? 1 : 0;
	assign lvl2Block3_col_up1 = ((pos_top_left_x >= 10'd593) && (pos_top_left_x <= 10'd656)) && ((pos_top_y >= 10'd35) && (pos_top_y <= 10'd163)) ? 1 : 0;
	assign lvl2Block3_col_up2 = ((pos_top_right_x >= 10'd593) && (pos_top_right_x <= 10'd656)) && ((pos_top_y >= 10'd35) && (pos_top_y <= 10'd163)) ? 1 : 0;
	assign lvl2Block6_col_up1 = ((pos_top_left_x >= 10'd719) && (pos_top_left_x <= 10'd784)) && ((pos_top_y >= 10'd35) && (pos_top_y <= 10'd323)) ? 1 : 0;
	assign lvl2Block6_col_up2 = ((pos_top_right_x >= 10'd719) && (pos_top_right_x <= 10'd784)) && ((pos_top_y >= 10'd35) && (pos_top_y <= 10'd323)) ? 1 : 0;
	
	assign lvl2_col_up = lvl2Block2_col_up1 || lvl2Block2_col_up2 || lvl2Block3_col_up1 || lvl2Block3_col_up2 || lvl2Block6_col_up1 || lvl2Block6_col_up2;

	// Right Block Collisions
	assign lvl2Block3_col_right1 = ((pos_right_x >= 10'd593) && (pos_right_x <= 10'd656)) && ((pos_right_bottom_y >= 10'd35) && (pos_right_bottom_y <= 10'd163)) ? 1 : 0;
	assign lvl2Block3_col_right2 = ((pos_right_x >= 10'd593) && (pos_right_x <= 10'd656)) && ((pos_right_top_y >= 10'd35) && (pos_right_top_y <= 10'd163)) ? 1 : 0;
	assign lvl2Block4_col_right1 = ((pos_right_x >= 10'd529) && (pos_right_x <= 10'd656)) && ((pos_right_bottom_y >= 10'd227) && (pos_right_bottom_y <= 10'd515)) ? 1 : 0;
	assign lvl2Block4_col_right2 = ((pos_right_x >= 10'd529) && (pos_right_x <= 10'd656)) && ((pos_right_top_y >= 10'd227) && (pos_right_top_y <= 10'd515)) ? 1 : 0;
	assign lvl2Block6_col_right1 = ((pos_right_x >= 10'd719) && (pos_right_x <= 10'd784)) && ((pos_right_bottom_y >= 10'd35) && (pos_right_bottom_y <= 10'd323)) ? 1 : 0;
	assign lvl2Block6_col_right2 = ((pos_right_x >= 10'd719) && (pos_right_x <= 10'd784)) && ((pos_right_top_y >= 10'd35) && (pos_right_top_y <= 10'd323)) ? 1 : 0;
	
	assign lvl2_col_right = lvl2Block3_col_right1 || lvl2Block3_col_right2 || lvl2Block4_col_right1 || lvl2Block4_col_right2 || lvl2Block6_col_right1 || lvl2Block6_col_right2;
	
	// Lava Collisions
	assign lvl2Lava_col = ((xPos >= 10'd337) && (xPos <= 10'd592)) && ((yPos >= 10'd35) && (yPos <= 10'd67)) ? 1 : 0;

	
	// Transition Collisions
	assign lvl2_To_lvl1_col = ((xPos >= 10'd144) && (xPos <= 10'd160)) && ((yPos >= 10'd164) && (yPos <= 10'd226)) ? 1 : 0;
	assign lvl2_To_lvl3_col = ((xPos >= 10'd401) && (xPos <= 10'd528)) && ((yPos >= 10'd499) && (yPos <= 10'd515)) ? 1 : 0;
	assign lvl2_To_lvl7_col = ((xPos >= 10'd767) && (xPos <= 10'd784)) && ((yPos >= 10'd324) && (yPos <= 10'd387)) ? 1 : 0;
	assign lvl2_To_lvl8_col = ((xPos >= 10'd657) && (xPos <= 10'd720)) && ((yPos >= 10'd35) && (yPos <= 10'd51)) ? 1 : 0;

	//
    // Level Three
	//
    wire lvl3Block1; // left
    wire lvl3Block2; // right

	wire safelevel3;

    wire lvl3Lava;

    wire lvl3_To_lvl2;
    wire lvl3_To_lvl4;

    assign lvl3Block1 = ((hCount >= 10'd144) && (hCount <= 10'd400)) && ((vCount >= 10'd35) && (vCount <= 10'd515)) ? 1 : 0;
    assign lvl3Block2 = ((hCount >= 10'd529) && (hCount <= 10'd784)) && ((vCount >= 10'd35) && (vCount <= 10'd515)) ? 1 : 0;

	assign safelevel3 = lvl3Block1 || lvl3Block2;
	
    assign lvl3Lava = ((hCount >= 10'd448) && (hCount <= 10'd480)) && ((vCount >= 10'd355) && (vCount <= 10'd467)) ? 1 : 0;

    assign lvl3_To_lvl2 = ((hCount >= 10'd401) && (hCount <= 10'd528)) && ((vCount >= 10'd35) && (vCount <= 10'd51)) ? 1 : 0;
    assign lvl3_To_lvl4 = ((hCount >= 10'd401) && (hCount <= 10'd528)) && ((vCount >= 10'd499) && (vCount <= 10'd515)) ? 1 : 0;
	
	// Left Block Collisions
	assign lvl3Block1_col_left1 = ((pos_left_x >= 10'd144) && (pos_left_x <= 10'd400)) && ((pos_left_bottom_y >= 10'd35) && (pos_left_bottom_y <= 10'd515)) ? 1 : 0;
	assign lvl3Block1_col_left2 = ((pos_left_x >= 10'd144) && (pos_left_x <= 10'd400)) && ((pos_left_top_y >= 10'd35) && (pos_left_top_y <= 10'd515)) ? 1 : 0;
	
	assign lvl3_col_left = lvl3Block1_col_left1 || lvl3Block1_col_left2;

	// Right Block Collisions
	assign lvl3Block2_col_right1 = ((pos_right_x >= 10'd529) && (pos_right_x <= 10'd784)) && ((pos_right_bottom_y >= 10'd35) && (pos_right_bottom_y <= 10'd515)) ? 1 : 0;
	assign lvl3Block2_col_right2 = ((pos_right_x >= 10'd529) && (pos_right_x <= 10'd784)) && ((pos_right_top_y >= 10'd35) && (pos_right_top_y <= 10'd515)) ? 1 : 0;
	
	assign lvl3_col_right = lvl3Block2_col_right1 || lvl3Block2_col_right2;
	
	// Lava Collisions
	assign lvl3Lava_col = ((xPos >= 10'd448) && (xPos <= 10'd480)) && ((yPos >= 10'd355) && (yPos <= 10'd467)) ? 1 : 0;
	
	// Transition Collisions
	assign lvl3_To_lvl2_col = ((xPos >= 10'd401) && (xPos <= 10'd528)) && ((yPos >= 10'd35) && (yPos <= 10'd51)) ? 1 : 0;
	assign lvl3_To_lvl4_col = ((xPos >= 10'd401) && (xPos <= 10'd528)) && ((yPos >= 10'd499) && (yPos <= 10'd515)) ? 1 : 0;

	//
    // Level Four
	//
    wire lvl4Block1; // up and down and right
    wire lvl4Block2; // up and left
    wire lvl4Block3; // left
    wire lvl4Block4; // down
    wire lvl4Block5; // right
    wire lvl4Block6; // up and right

	wire safelevel4;

    wire lvl4Lava1;
    wire lvl4Lava2;
    wire lvl4Lava3;
    wire lvl4Lava4;
	
	wire lvl4Lava;

    wire lvl4_To_lvl3;
    wire lvl4_To_lvl5;

    assign lvl4Block1 = ((hCount >= 10'd272) && (hCount <= 10'd784)) && ((vCount >= 10'd164) && (vCount <= 10'd275)) ? 1 : 0;
    assign lvl4Block2 = ((hCount >= 10'd144) && (hCount <= 10'd400)) && ((vCount >= 10'd35) && (vCount <= 10'd99)) ? 1 : 0;
    assign lvl4Block3 = ((hCount >= 10'd144) && (hCount <= 10'd208)) && ((vCount >= 10'd100) && (vCount <= 10'd515)) ? 1 : 0;
    assign lvl4Block4 = ((hCount >= 10'd209) && (hCount <= 10'd784)) && ((vCount >= 10'd451) && (vCount <= 10'd515)) ? 1 : 0;
    assign lvl4Block5 = ((hCount >= 10'd529) && (hCount <= 10'd784)) && ((vCount >= 10'd35) && (vCount <= 10'd163)) ? 1 : 0;
    assign lvl4Block6 = ((hCount >= 10'd719) && (hCount <= 10'd784)) && ((vCount >= 10'd276) && (vCount <= 10'd387)) ? 1 : 0;

	assign safelevel4 = lvl4Block1 || lvl4Block2 || lvl4Block3 || lvl4Block4 || lvl4Block5 || lvl4Block6;

    assign lvl4Lava1 = ((hCount >= 10'd288) && (hCount <= 10'd384)) && ((vCount >= 10'd434) && (vCount <= 10'd450)) ? 1 : 0;
    assign lvl4Lava2 = ((hCount >= 10'd400) && (hCount <= 10'd496)) && ((vCount >= 10'd276) && (vCount <= 10'd291)) ? 1 : 0;
    assign lvl4Lava3 = ((hCount >= 10'd512) && (hCount <= 10'd608)) && ((vCount >= 10'd434) && (vCount <= 10'd450)) ? 1 : 0;
    assign lvl4Lava4 = ((hCount >= 10'd624) && (hCount <= 10'd718)) && ((vCount >= 10'd276) && (vCount <= 10'd291)) ? 1 : 0;

	assign lvl4Lava = lvl4Lava1 || lvl4Lava2 || lvl4Lava3 || lvl4Lava4;

    assign lvl4_To_lvl3 = ((hCount >= 10'd401) && (hCount <= 10'd528)) && ((vCount >= 10'd35) && (vCount <= 10'd51)) ? 1 : 0;
    assign lvl4_To_lvl5 = ((hCount >= 10'd768) && (hCount <= 10'd784)) && ((vCount >= 10'd388) && (vCount <= 10'd450)) ? 1 : 0;

	// Down Block Collisions
	assign lvl4Block1_col_down1 = ((pos_bottom_left_x >= 10'd272) && (pos_bottom_left_x <= 10'd784)) && ((pos_bottom_y >= 10'd164) && (pos_bottom_y <= 10'd275)) ? 1 : 0;
	assign lvl4Block1_col_down2 = ((pos_bottom_right_x >= 10'd272) && (pos_bottom_right_x <= 10'd784)) && ((pos_bottom_y >= 10'd164) && (pos_bottom_y <= 10'd275)) ? 1 : 0;
	assign lvl4Block4_col_down1 = ((pos_bottom_left_x >= 10'd209) && (pos_bottom_left_x <= 10'd784)) && ((pos_bottom_y >= 10'd451) && (pos_bottom_y <= 10'd515)) ? 1 : 0;
	assign lvl4Block4_col_down2 = ((pos_bottom_right_x >= 10'd209) && (pos_bottom_right_x <= 10'd784)) && ((pos_bottom_y >= 10'd451) && (pos_bottom_y <= 10'd515)) ? 1 : 0;

	assign lvl4_col_down = lvl4Block1_col_down1 || lvl4Block1_col_down2 || lvl4Block4_col_down1 || lvl4Block4_col_down2;

	// Left Block Collisions
	assign lvl4Block2_col_left1 = ((pos_left_x >= 10'd144) && (pos_left_x <= 10'd400)) && ((pos_left_bottom_y >= 10'd35) && (pos_left_bottom_y <= 10'd99)) ? 1 : 0;
	assign lvl4Block2_col_left2 = ((pos_left_x >= 10'd144) && (pos_left_x <= 10'd400)) && ((pos_left_top_y >= 10'd35) && (pos_left_top_y <= 10'd99)) ? 1 : 0;
	assign lvl4Block3_col_left1 = ((pos_left_x >= 10'd144) && (pos_left_x <= 10'd208)) && ((pos_left_bottom_y >= 10'd100) && (pos_left_bottom_y <= 10'd515)) ? 1 : 0;
	assign lvl4Block3_col_left2 = ((pos_left_x >= 10'd144) && (pos_left_x <= 10'd208)) && ((pos_left_top_y >= 10'd100) && (pos_left_top_y <= 10'd515)) ? 1 : 0;

	assign lvl4_col_left = lvl4Block2_col_left1 || lvl4Block2_col_left2 || lvl4Block3_col_left1 || lvl4Block3_col_left2;

	// Up Block Collisions
    assign lvl4Block1_col_up1 = ((pos_top_left_x >= 10'd272) && (pos_top_left_x <= 10'd784)) && ((pos_top_y >= 10'd164) && (pos_top_y <= 10'd275)) ? 1 : 0;
    assign lvl4Block1_col_up2 = ((pos_top_right_x >= 10'd272) && (pos_top_right_x <= 10'd784)) && ((pos_top_y >= 10'd164) && (pos_top_y <= 10'd275)) ? 1 : 0;
	assign lvl4Block2_col_up1 = ((pos_top_left_x >= 10'd144) && (pos_top_left_x <= 10'd400)) && ((pos_top_y >= 10'd35) && (pos_top_y <= 10'd99)) ? 1 : 0;
	assign lvl4Block2_col_up2 = ((pos_top_right_x >= 10'd144) && (pos_top_right_x <= 10'd400)) && ((pos_top_y >= 10'd35) && (pos_top_y <= 10'd99)) ? 1 : 0;
	assign lvl4Block6_col_up1 = ((pos_top_left_x >= 10'd719) && (pos_top_left_x <= 10'd784)) && ((pos_top_y >= 10'd276) && (pos_top_y <= 10'd387)) ? 1 : 0;
	assign lvl4Block6_col_up2 = ((pos_top_right_x >= 10'd719) && (pos_top_right_x <= 10'd784)) && ((pos_top_y >= 10'd276) && (pos_top_y <= 10'd387)) ? 1 : 0;

	assign lvl4_col_up = lvl4Block1_col_up1 || lvl4Block1_col_up2 || lvl4Block2_col_up1 || lvl4Block2_col_up2 || lvl4Block6_col_up1 || lvl4Block6_col_up2;

	// Right Block Collisions
	assign lvl4Block1_col_right1 = ((pos_right_x >= 10'd272) && (pos_right_x <= 10'd784)) && ((pos_right_bottom_y >= 10'd164) && (pos_right_bottom_y <= 10'd275)) ? 1 : 0;
	assign lvl4Block1_col_right2 = ((pos_right_x >= 10'd272) && (pos_right_x <= 10'd784)) && ((pos_right_top_y >= 10'd164) && (pos_right_top_y <= 10'd275)) ? 1 : 0;
	assign lvl4Block5_col_right1 = ((pos_right_x >= 10'd529) && (pos_right_x <= 10'd784)) && ((pos_right_bottom_y >= 10'd35) && (pos_right_bottom_y <= 10'd163)) ? 1 : 0;
	assign lvl4Block5_col_right2 = ((pos_right_x >= 10'd529) && (pos_right_x <= 10'd784)) && ((pos_right_top_y >= 10'd35) && (pos_right_top_y <= 10'd163)) ? 1 : 0;
	assign lvl4Block6_col_right1 = ((pos_right_x >= 10'd719) && (pos_right_x <= 10'd784)) && ((pos_right_bottom_y >= 10'd276) && (pos_right_bottom_y <= 10'd387)) ? 1 : 0;
	assign lvl4Block6_col_right2 = ((pos_right_x >= 10'd719) && (pos_right_x <= 10'd784)) && ((pos_right_top_y >= 10'd276) && (pos_right_top_y <= 10'd387)) ? 1 : 0;

	assign lvl4_col_right = lvl4Block1_col_right1 || lvl4Block1_col_right2 || lvl4Block5_col_right1 || lvl4Block5_col_right2 || lvl4Block6_col_right1 || lvl4Block6_col_right2;

	// Lava Collisions
	assign lvl4Lava1_col = ((xPos >= 10'd288) && (xPos <= 10'd384)) && ((yPos >= 10'd434) && (yPos <= 10'd450)) ? 1 : 0;
    assign lvl4Lava2_col = ((xPos >= 10'd400) && (xPos <= 10'd496)) && ((yPos >= 10'd276) && (yPos <= 10'd291)) ? 1 : 0;
    assign lvl4Lava3_col = ((xPos >= 10'd512) && (xPos <= 10'd608)) && ((yPos >= 10'd434) && (yPos <= 10'd450)) ? 1 : 0;
    assign lvl4Lava4_col = ((xPos >= 10'd624) && (xPos <= 10'd718)) && ((yPos >= 10'd276) && (yPos <= 10'd291)) ? 1 : 0;

	assign lvl4Lava_col = lvl4Lava1_col || lvl4Lava2_col || lvl4Lava3_col || lvl4Lava4_col;

	// Transistions Collisions
	assign lvl4_To_lvl3_col = ((xPos >= 10'd401) && (xPos <= 10'd528)) && ((yPos >= 10'd35) && (yPos <= 10'd51)) ? 1 : 0;
    assign lvl4_To_lvl5_col = ((xPos >= 10'd768) && (xPos <= 10'd784)) && ((yPos >= 10'd388) && (yPos <= 10'd450)) ? 1 : 0;

	//
    // Level Five
	//
    wire lvl5Block1; // up and left
    wire lvl5Block2; // up and left
    wire lvl5Block3; // up and left
    wire lvl5Block4; // up and left
    wire lvl5Block5; // up and left
    wire lvl5Block6; // right
    wire lvl5Block7; // down and right
    wire lvl5Block8; // down

	wire safelevel5;

    wire lvl5Lava1;
    wire lvl5Lava2;
    wire lvl5Lava3;
    wire lvl5Lava4;

	wire lvl5Lava;

    wire lvl5_To_lvl4;
    wire lvl5_To_lvl6;

    wire checkpointLoc;

    assign lvl5Block1 = ((hCount >= 10'd144) && (hCount <= 10'd336)) && ((vCount >= 10'd35) && (vCount <= 10'd386)) ? 1 : 0;
    assign lvl5Block2 = ((hCount >= 10'd337) && (hCount <= 10'd400)) && ((vCount >= 10'd35) && (vCount <= 10'd354)) ? 1 : 0;
    assign lvl5Block3 = ((hCount >= 10'd401) && (hCount <= 10'd464)) && ((vCount >= 10'd35) && (vCount <= 10'd322)) ? 1 : 0;
    assign lvl5Block4 = ((hCount >= 10'd465) && (hCount <= 10'd528)) && ((vCount >= 10'd35) && (vCount <= 10'd290)) ? 1 : 0;
    assign lvl5Block5 = ((hCount >= 10'd529) && (hCount <= 10'd656)) && ((vCount >= 10'd35) && (vCount <= 10'd258)) ? 1 : 0;
    assign lvl5Block6 = ((hCount >= 10'd721) && (hCount <= 10'd784)) && ((vCount >= 10'd35) && (vCount <= 10'd450)) ? 1 : 0;
    assign lvl5Block7 = ((hCount >= 10'd592) && (hCount <= 10'd720)) && ((vCount >= 10'd323) && (vCount <= 10'd450)) ? 1 : 0;
    assign lvl5Block8 = ((hCount >= 10'd144) && (hCount <= 10'd784)) && ((vCount >= 10'd451) && (vCount <= 10'd515)) ? 1 : 0;

	assign safelevel5 = lvl5Block1 || lvl5Block2 || lvl5Block3 || lvl5Block4 || lvl5Block5 || lvl5Block6 || lvl5Block7 || lvl5Block8;

    assign lvl5Lava1 = ((hCount >= 10'd337) && (hCount <= 10'd400)) && ((vCount >= 10'd434) && (vCount <= 10'd450)) ? 1 : 0;
    assign lvl5Lava2 = ((hCount >= 10'd401) && (hCount <= 10'd464)) && ((vCount >= 10'd418) && (vCount <= 10'd450)) ? 1 : 0;
    assign lvl5Lava3 = ((hCount >= 10'd465) && (hCount <= 10'd528)) && ((vCount >= 10'd402) && (vCount <= 10'd450)) ? 1 : 0;
    assign lvl5Lava4 = ((hCount >= 10'd529) && (hCount <= 10'd591)) && ((vCount >= 10'd386) && (vCount <= 10'd450)) ? 1 : 0;

	assign lvl5Lava = lvl5Lava1 || lvl5Lava2 || lvl5Lava3 || lvl5Lava4;

    assign lvl5_To_lvl4 = ((hCount >= 10'd144) && (hCount <= 10'd160)) && ((vCount >= 10'd387) && (vCount <= 10'd450)) ? 1 : 0;
    assign lvl5_To_lvl6 = ((hCount >= 10'd657) && (hCount <= 10'd720)) && ((vCount >= 10'd35) && (vCount <= 10'd51)) ? 1 : 0;
    
    assign checkpointLoc = ((hCount >= 10'd687) && (hCount <= 10'd703)) && ((vCount >= 10'd307) && (vCount <= 10'd322)) ? 1 : 0;

	// Down Block Collisions
	assign lvl5Block7_col_down1 = ((pos_bottom_left_x >= 10'd592) && (pos_bottom_left_x <= 10'd720)) && ((pos_bottom_y >= 10'd323) && (pos_bottom_y <= 10'd450)) ? 1 : 0;
	assign lvl5Block7_col_down2 = ((pos_bottom_right_x >= 10'd592) && (pos_bottom_right_x <= 10'd720)) && ((pos_bottom_y >= 10'd323) && (pos_bottom_y <= 10'd450)) ? 1 : 0;
	assign lvl5Block8_col_down1 = ((pos_bottom_left_x >= 10'd144) && (pos_bottom_left_x <= 10'd784)) && ((pos_bottom_y >= 10'd451) && (pos_bottom_y <= 10'd515)) ? 1 : 0;
	assign lvl5Block8_col_down2 = ((pos_bottom_right_x >= 10'd144) && (pos_bottom_right_x <= 10'd784)) && ((pos_bottom_y >= 10'd451) && (pos_bottom_y <= 10'd515)) ? 1 : 0;

	assign lvl5_col_down = lvl5Block7_col_down1 || lvl5Block7_col_down2 || lvl5Block8_col_down1 || lvl5Block8_col_down2;

	// Left Block Collisions
	assign lvl5Block1_col_left1 = ((pos_left_x >= 10'd144) && (pos_left_x <= 10'd336)) && ((pos_left_bottom_y >= 10'd35) && (pos_left_bottom_y <= 10'd386)) ? 1 : 0;
	assign lvl5Block1_col_left2 = ((pos_left_x >= 10'd144) && (pos_left_x <= 10'd336)) && ((pos_left_top_y >= 10'd35) && (pos_left_top_y <= 10'd386)) ? 1 : 0;
    assign lvl5Block2_col_left1 = ((pos_left_x >= 10'd337) && (pos_left_x <= 10'd400)) && ((pos_left_bottom_y >= 10'd35) && (pos_left_bottom_y <= 10'd354)) ? 1 : 0;
    assign lvl5Block2_col_left2 = ((pos_left_x >= 10'd337) && (pos_left_x <= 10'd400)) && ((pos_left_top_y >= 10'd35) && (pos_left_top_y <= 10'd354)) ? 1 : 0;
	assign lvl5Block3_col_left1 = ((pos_left_x >= 10'd401) && (pos_left_x <= 10'd464)) && ((pos_left_bottom_y >= 10'd35) && (pos_left_bottom_y <= 10'd322)) ? 1 : 0;
	assign lvl5Block3_col_left2 = ((pos_left_x >= 10'd401) && (pos_left_x <= 10'd464)) && ((pos_left_top_y >= 10'd35) && (pos_left_top_y <= 10'd322)) ? 1 : 0;
	assign lvl5Block4_col_left1 = ((pos_left_x >= 10'd465) && (pos_left_x <= 10'd528)) && ((pos_left_bottom_y >= 10'd35) && (pos_left_bottom_y <= 10'd290)) ? 1 : 0;
	assign lvl5Block4_col_left2 = ((pos_left_x >= 10'd465) && (pos_left_x <= 10'd528)) && ((pos_left_top_y >= 10'd35) && (pos_left_top_y <= 10'd290)) ? 1 : 0;
	assign lvl5Block5_col_left1 = ((pos_left_x >= 10'd529) && (pos_left_x <= 10'd656)) && ((pos_left_bottom_y >= 10'd35) && (pos_left_bottom_y <= 10'd258)) ? 1 : 0;
	assign lvl5Block5_col_left2 = ((pos_left_x >= 10'd529) && (pos_left_x <= 10'd656)) && ((pos_left_top_y >= 10'd35) && (pos_left_top_y <= 10'd258)) ? 1 : 0;

	assign lvl5_col_left = lvl5Block1_col_left1 || lvl5Block1_col_left2 || lvl5Block2_col_left1 || lvl5Block2_col_left2 || lvl5Block3_col_left1 || lvl5Block3_col_left2 || lvl5Block4_col_left1 || lvl5Block4_col_left2 || lvl5Block5_col_left1 || lvl5Block5_col_left2;

	// Up Block Collisions
    assign lvl5Block1_col_up1 = ((pos_top_left_x >= 10'd144) && (pos_top_left_x <= 10'd336)) && ((pos_top_y >= 10'd35) && (pos_top_y <= 10'd386)) ? 1 : 0;
	assign lvl5Block1_col_up2 = ((pos_top_right_x >= 10'd144) && (pos_top_right_x <= 10'd336)) && ((pos_top_y >= 10'd35) && (pos_top_y <= 10'd386)) ? 1 : 0;
    assign lvl5Block2_col_up1 = ((pos_top_left_x >= 10'd337) && (pos_top_left_x <= 10'd400)) && ((pos_top_y >= 10'd35) && (pos_top_y <= 10'd354)) ? 1 : 0;
    assign lvl5Block2_col_up2 = ((pos_top_right_x >= 10'd337) && (pos_top_right_x <= 10'd400)) && ((pos_top_y >= 10'd35) && (pos_top_y <= 10'd354)) ? 1 : 0;
	assign lvl5Block3_col_up1 = ((pos_top_left_x >= 10'd401) && (pos_top_left_x <= 10'd464)) && ((pos_top_y >= 10'd35) && (pos_top_y <= 10'd322)) ? 1 : 0;
	assign lvl5Block3_col_up2 = ((pos_top_right_x >= 10'd401) && (pos_top_right_x <= 10'd464)) && ((pos_top_y >= 10'd35) && (pos_top_y <= 10'd322)) ? 1 : 0;
	assign lvl5Block4_col_up1 = ((pos_top_left_x >= 10'd465) && (pos_top_left_x <= 10'd528)) && ((pos_top_y >= 10'd35) && (pos_top_y <= 10'd290)) ? 1 : 0;
	assign lvl5Block4_col_up2 = ((pos_top_right_x >= 10'd465) && (pos_top_right_x <= 10'd528)) && ((pos_top_y >= 10'd35) && (pos_top_y <= 10'd290)) ? 1 : 0;
	assign lvl5Block5_col_up1 = ((pos_top_left_x >= 10'd529) && (pos_top_left_x <= 10'd656)) && ((pos_top_y >= 10'd35) && (pos_top_y <= 10'd258)) ? 1 : 0;
	assign lvl5Block5_col_up2 = ((pos_top_right_x >= 10'd529) && (pos_top_right_x <= 10'd656)) && ((pos_top_y >= 10'd35) && (pos_top_y <= 10'd258)) ? 1 : 0;

	assign lvl5_col_up = lvl5Block1_col_up1 || lvl5Block1_col_up2 || lvl5Block2_col_up1 || lvl5Block2_col_up2 || lvl5Block3_col_up1 || lvl5Block3_col_up2 || lvl5Block4_col_up1 || lvl5Block4_col_up2 || lvl5Block5_col_up1 || lvl5Block5_col_up1;

	// Right Block Collisions
	assign lvl5Block6_col_right1 = ((pos_right_x >= 10'd721) && (pos_right_x <= 10'd784)) && ((pos_right_bottom_y >= 10'd35) && (pos_right_bottom_y <= 10'd450)) ? 1 : 0;
	assign lvl5Block6_col_right2 = ((pos_right_x >= 10'd721) && (pos_right_x <= 10'd784)) && ((pos_right_top_y >= 10'd35) && (pos_right_top_y <= 10'd450)) ? 1 : 0;
	assign lvl5Block7_col_right1 = ((pos_right_x >= 10'd592) && (pos_right_x <= 10'd720)) && ((pos_right_bottom_y >= 10'd323) && (pos_right_bottom_y <= 10'd450)) ? 1 : 0;
	assign lvl5Block7_col_right2 = ((pos_right_x >= 10'd592) && (pos_right_x <= 10'd720)) && ((pos_right_top_y >= 10'd323) && (pos_right_top_y <= 10'd450)) ? 1 : 0;

	assign lvl5_col_right = lvl5Block6_col_right1 || lvl5Block6_col_right2 || lvl5Block7_col_right1 || lvl5Block7_col_right2;

	// Lava Collisions

    assign lvl5Lava1_col = ((xPos >= 10'd337) && (xPos <= 10'd400)) && ((yPos >= 10'd434) && (yPos <= 10'd450)) ? 1 : 0;
    assign lvl5Lava2_col = ((xPos >= 10'd401) && (xPos <= 10'd464)) && ((yPos >= 10'd418) && (yPos <= 10'd450)) ? 1 : 0;
    assign lvl5Lava3_col = ((xPos >= 10'd465) && (xPos <= 10'd528)) && ((yPos >= 10'd402) && (yPos <= 10'd450)) ? 1 : 0;
    assign lvl5Lava4_col = ((xPos >= 10'd529) && (xPos <= 10'd591)) && ((yPos >= 10'd386) && (yPos <= 10'd450)) ? 1 : 0;

	assign lvl5Lava_col = lvl5Lava1_col || lvl5Lava2_col || lvl5Lava3_col || lvl5Lava4_col;

	//Transistions Collisions

	assign lvl5_To_lvl4_col = ((xPos >= 10'd144) && (xPos <= 10'd160)) && ((yPos >= 10'd387) && (yPos <= 10'd450)) ? 1 : 0;
    assign lvl5_To_lvl6_col = ((xPos >= 10'd657) && (xPos <= 10'd720)) && ((yPos >= 10'd35) && (yPos <= 10'd51)) ? 1 : 0;

	// Checkpoint Collisions

	assign checkpointLoc_col = ((xPos >= 10'd687) && (xPos <= 10'd703)) && ((yPos >= 10'd307) && (yPos <= 10'd322)) ? 1 : 0;

	//
    // Level 6
	//
    wire lvl6Block1; // up and down and left and right
    wire lvl6Block2; // right and left
    wire lvl6Block3; // right and left
    wire lvl6Block4; // down and left
    wire lvl6Block5; // left
    wire lvl6Block6; // up and left
    wire lvl6Block7; // right
    wire lvl6Block8; // up and right

	wire safelevel6;

    wire lvl6Lava1;
    wire lvl6Lava2;
    wire lvl6Lava3;
    wire lvl6Lava4;

	wire lvl6Lava;

    wire lvl6_To_lvl5;
    wire lvl6_To_lvl7;

    assign lvl6Block1 = ((hCount >= 10'd384) && (hCount <= 10'd576)) && ((vCount >= 10'd147) && (vCount <= 10'd163)) ? 1 : 0;
    assign lvl6Block2 = ((hCount >= 10'd272) && (hCount <= 10'd400)) && ((vCount >= 10'd324) && (vCount <= 10'd355)) ? 1 : 0;
    assign lvl6Block3 = ((hCount >= 10'd528) && (hCount <= 10'd656)) && ((vCount >= 10'd419) && (vCount <= 10'd450)) ? 1 : 0;
    assign lvl6Block4 = ((hCount >= 10'd209) && (hCount <= 10'd656)) && ((vCount >= 10'd451) && (vCount <= 10'd515)) ? 1 : 0;
    assign lvl6Block5 = ((hCount >= 10'd144) && (hCount <= 10'd208)) && ((vCount >= 10'd35) && (vCount <= 10'd515)) ? 1 : 0;
    assign lvl6Block6 = ((hCount >= 10'd209) && (hCount <= 10'd656)) && ((vCount >= 10'd35) && (vCount <= 10'd99)) ? 1 : 0;
    assign lvl6Block7 = ((hCount >= 10'd719) && (hCount <= 10'd784)) && ((vCount >= 10'd35) && (vCount <= 10'd515)) ? 1 : 0;
    assign lvl6Block8 = ((hCount >= 10'd272) && (hCount <= 10'd718)) && ((vCount >= 10'd227) && (vCount <= 10'd323)) ? 1 : 0;

	assign safelevel6 = lvl6Block1 || lvl6Block2 || lvl6Block3 || lvl6Block4 || lvl6Block5 || lvl6Block6 || lvl6Block7 || lvl6Block8;

    assign lvl6Lava1 = ((hCount >= 10'd528) && (hCount <= 10'd656)) && ((vCount >= 10'd402) && (vCount <= 10'd418)) ? 1 : 0;
    assign lvl6Lava2 = ((hCount >= 10'd272) && (hCount <= 10'd400)) && ((vCount >= 10'd356) && (vCount <= 10'd371)) ? 1 : 0;
    assign lvl6Lava3 = ((hCount >= 10'd432) && (hCount <= 10'd528)) && ((vCount >= 10'd211) && (vCount <= 10'd226)) ? 1 : 0;
    assign lvl6Lava4 = ((hCount >= 10'd336) && (hCount <= 10'd624)) && ((vCount >= 10'd100) && (vCount <= 10'd115)) ? 1 : 0;

	assign lvl6Lava = lvl6Lava1 || lvl6Lava2 || lvl6Lava3 || lvl6Lava4;

    assign lvl6_To_lvl5 = ((hCount >= 10'd657) && (hCount <= 10'd718)) && ((vCount >= 10'd499) && (vCount <= 10'd515)) ? 1 : 0;
    assign lvl6_To_lvl7 = ((hCount >= 10'd657) && (hCount <= 10'd718)) && ((vCount >= 10'd35) && (vCount <= 10'd51)) ? 1 : 0;

	// Down Block Collisions

	assign lvl6Block1_col_down1 = ((pos_bottom_left_x >= 10'd384) && (pos_bottom_left_x <= 10'd576)) && ((pos_bottom_y >= 10'd147) && (pos_bottom_y <= 10'd163)) ? 1 : 0;
	assign lvl6Block1_col_down2 = ((pos_bottom_right_x >= 10'd384) && (pos_bottom_right_x <= 10'd576)) && ((pos_bottom_y >= 10'd147) && (pos_bottom_y <= 10'd163)) ? 1 : 0;
	assign lvl6Block4_col_down1 = ((pos_bottom_left_x >= 10'd209) && (pos_bottom_left_x <= 10'd656)) && ((pos_bottom_y >= 10'd451) && (pos_bottom_y <= 10'd515)) ? 1 : 0;
	assign lvl6Block4_col_down2 = ((pos_bottom_right_x >= 10'd209) && (pos_bottom_right_x <= 10'd656)) && ((pos_bottom_y >= 10'd451) && (pos_bottom_y <= 10'd515)) ? 1 : 0;
	assign lvl6Block8_col_down1 = ((pos_bottom_left_x >= 10'd272) && (pos_bottom_left_x <= 10'd718)) && ((pos_bottom_y >= 10'd227) && (pos_bottom_y <= 10'd323)) ? 1 : 0;
	assign lvl6Block8_col_down2 = ((pos_bottom_right_x >= 10'd272) && (pos_bottom_right_x <= 10'd718)) && ((pos_bottom_y >= 10'd227) && (pos_bottom_y <= 10'd323)) ? 1 : 0;

	assign lvl6_col_down = lvl6Block1_col_down1 || lvl6Block1_col_down2 || lvl6Block4_col_down1 || lvl6Block4_col_down2 || lvl6Block8_col_down1 || lvl6Block8_col_down2;

	// Left Block Collisions
	assign lvl6Block1_col_left1 = ((pos_left_x >= 10'd384) && (pos_left_x <= 10'd576)) && ((pos_left_bottom_y >= 10'd147) && (pos_left_bottom_y <= 10'd163)) ? 1 : 0;
	assign lvl6Block1_col_left2 = ((pos_left_x >= 10'd384) && (pos_left_x <= 10'd576)) && ((pos_left_top_y >= 10'd147) && (pos_left_top_y <= 10'd163)) ? 1 : 0;
	assign lvl6Block2_col_left1 = ((pos_left_x >= 10'd272) && (pos_left_x <= 10'd400)) && ((pos_left_bottom_y >= 10'd324) && (pos_left_bottom_y <= 10'd355)) ? 1 : 0;
	assign lvl6Block2_col_left2 = ((pos_left_x >= 10'd272) && (pos_left_x <= 10'd400)) && ((pos_left_top_y >= 10'd324) && (pos_left_top_y <= 10'd355)) ? 1 : 0;
	assign lvl6Block3_col_left1 = ((pos_left_x >= 10'd528) && (pos_left_x <= 10'd656)) && ((pos_left_bottom_y >= 10'd419) && (pos_left_bottom_y <= 10'd450)) ? 1 : 0;
	assign lvl6Block3_col_left2 = ((pos_left_x >= 10'd528) && (pos_left_x <= 10'd656)) && ((pos_left_top_y >= 10'd419) && (pos_left_top_y <= 10'd450)) ? 1 : 0;
	assign lvl6Block4_col_left1 = ((pos_left_x >= 10'd209) && (pos_left_x <= 10'd656)) && ((pos_left_bottom_y >= 10'd451) && (pos_left_bottom_y <= 10'd515)) ? 1 : 0;
	assign lvl6Block4_col_left2 = ((pos_left_x >= 10'd209) && (pos_left_x <= 10'd656)) && ((pos_left_top_y >= 10'd451) && (pos_left_top_y <= 10'd515)) ? 1 : 0;
	assign lvl6Block5_col_left1 = ((pos_left_x >= 10'd144) && (pos_left_x <= 10'd208)) && ((pos_left_bottom_y >= 10'd35) && (pos_left_bottom_y <= 10'd515)) ? 1 : 0;
	assign lvl6Block5_col_left2 = ((pos_left_x >= 10'd144) && (pos_left_x <= 10'd208)) && ((pos_left_top_y >= 10'd35) && (pos_left_top_y <= 10'd515)) ? 1 : 0;
	assign lvl6Block6_col_left1 = ((pos_left_x >= 10'd209) && (pos_left_x <= 10'd656)) && ((pos_left_bottom_y >= 10'd35) && (pos_left_bottom_y <= 10'd99)) ? 1 : 0;
	assign lvl6Block6_col_left2 = ((pos_left_x >= 10'd209) && (pos_left_x <= 10'd656)) && ((pos_left_top_y >= 10'd35) && (pos_left_top_y <= 10'd99)) ? 1 : 0;

	assign lvl6_col_left = lvl6Block1_col_left1 || lvl6Block1_col_left2 || lvl6Block2_col_left1 || lvl6Block2_col_left2 || lvl6Block3_col_left1 || lvl6Block3_col_left2 || lvl6Block4_col_left1 || lvl6Block4_col_left2 || lvl6Block5_col_left1 || lvl6Block5_col_left2 || lvl6Block6_col_left1 || lvl6Block6_col_left2;

	// Up Block Collisions
	assign lvl6Block1_col_up1 = ((pos_top_left_x >= 10'd384) && (pos_top_left_x <= 10'd576)) && ((pos_top_y >= 10'd147) && (pos_top_y <= 10'd163)) ? 1 : 0;
	assign lvl6Block1_col_up2 = ((pos_top_right_x >= 10'd384) && (pos_top_right_x <= 10'd576)) && ((pos_top_y >= 10'd147) && (pos_top_y <= 10'd163)) ? 1 : 0;
	assign lvl6Block6_col_up1 = ((pos_top_left_x >= 10'd209) && (pos_top_left_x <= 10'd656)) && ((pos_top_y >= 10'd35) && (pos_top_y <= 10'd99)) ? 1 : 0;
	assign lvl6Block6_col_up2 = ((pos_top_right_x >= 10'd209) && (pos_top_right_x <= 10'd656)) && ((pos_top_y >= 10'd35) && (pos_top_y <= 10'd99)) ? 1 : 0;
	assign lvl6Block8_col_up1 = ((pos_top_left_x >= 10'd272) && (pos_top_left_x <= 10'd718)) && ((pos_top_y >= 10'd227) && (pos_top_y <= 10'd323)) ? 1 : 0;
	assign lvl6Block8_col_up2 = ((pos_top_right_x >= 10'd272) && (pos_top_right_x <= 10'd718)) && ((pos_top_y >= 10'd227) && (pos_top_y <= 10'd323)) ? 1 : 0;


	assign lvl6_col_up = lvl6Block1_col_up1 || lvl6Block1_col_up2 || lvl6Block6_col_up1 || lvl6Block6_col_up2 || lvl6Block8_col_up1 || lvl6Block8_col_up2;

	// Right Block Collisions
	assign lvl6Block1_col_right1 = ((pos_right_x >= 10'd384) && (pos_right_x <= 10'd576)) && ((pos_right_bottom_y >= 10'd147) && (pos_right_bottom_y <= 10'd163)) ? 1 : 0;
	assign lvl6Block1_col_right2 = ((pos_right_x >= 10'd384) && (pos_right_x <= 10'd576)) && ((pos_right_top_y >= 10'd147) && (pos_right_top_y <= 10'd163)) ? 1 : 0;
	assign lvl6Block2_col_right1 = ((pos_right_x >= 10'd272) && (pos_right_x <= 10'd400)) && ((pos_right_bottom_y >= 10'd324) && (pos_right_bottom_y <= 10'd355)) ? 1 : 0;
	assign lvl6Block2_col_right2 = ((pos_right_x >= 10'd272) && (pos_right_x <= 10'd400)) && ((pos_right_top_y >= 10'd324) && (pos_right_top_y <= 10'd355)) ? 1 : 0;
	assign lvl6Block3_col_right1 = ((pos_right_x >= 10'd528) && (pos_right_x <= 10'd656)) && ((pos_right_bottom_y >= 10'd419) && (pos_right_bottom_y <= 10'd450)) ? 1 : 0;
	assign lvl6Block3_col_right2 = ((pos_right_x >= 10'd528) && (pos_right_x <= 10'd656)) && ((pos_right_top_y >= 10'd419) && (pos_right_top_y <= 10'd450)) ? 1 : 0;
	assign lvl6Block7_col_right1 = ((pos_right_x >= 10'd719) && (pos_right_x <= 10'd784)) && ((pos_right_bottom_y >= 10'd35) && (pos_right_bottom_y <= 10'd515)) ? 1 : 0;
	assign lvl6Block7_col_right2 = ((pos_right_x >= 10'd719) && (pos_right_x <= 10'd784)) && ((pos_right_top_y >= 10'd35) && (pos_right_top_y <= 10'd515)) ? 1 : 0;
	assign lvl6Block8_col_right1 = ((pos_right_x >= 10'd272) && (pos_right_x <= 10'd718)) && ((pos_right_bottom_y >= 10'd227) && (pos_right_bottom_y <= 10'd323)) ? 1 : 0;
	assign lvl6Block8_col_right2 = ((pos_right_x >= 10'd272) && (pos_right_x <= 10'd718)) && ((pos_right_top_y >= 10'd227) && (pos_right_top_y <= 10'd323)) ? 1 : 0;

	assign lvl6_col_right = lvl6Block1_col_right1 || lvl6Block1_col_right2 || lvl6Block2_col_right1 || lvl6Block2_col_right2 || lvl6Block3_col_right1 || lvl6Block3_col_right2 || lvl6Block7_col_right1 || lvl6Block7_col_right2 || lvl6Block8_col_right1 || lvl6Block8_col_right2;

	// Lava Collisions

	assign lvl6Lava1_col = ((xPos >= 10'd528) && (xPos <= 10'd656)) && ((yPos >= 10'd402) && (yPos <= 10'd418)) ? 1 : 0;
    assign lvl6Lava2_col = ((xPos >= 10'd272) && (xPos <= 10'd400)) && ((yPos >= 10'd356) && (yPos <= 10'd371)) ? 1 : 0;
    assign lvl6Lava3_col = ((xPos >= 10'd432) && (xPos <= 10'd528)) && ((yPos >= 10'd211) && (yPos <= 10'd226)) ? 1 : 0;
    assign lvl6Lava4_col = ((xPos >= 10'd336) && (xPos <= 10'd624)) && ((yPos >= 10'd100) && (yPos <= 10'd115)) ? 1 : 0;

	assign lvl6Lava_col = lvl6Lava1_col || lvl6Lava2_col || lvl6Lava3_col || lvl6Lava4_col;

	// Transistions Collisions

	assign lvl6_To_lvl5_col = ((xPos >= 10'd657) && (xPos <= 10'd718)) && ((yPos >= 10'd499) && (yPos <= 10'd515)) ? 1 : 0;
	assign lvl6_To_lvl7_col = ((xPos >= 10'd657) && (xPos <= 10'd718)) && ((yPos >= 10'd35) && (yPos <= 10'd51)) ? 1 : 0;

	//
    // Level 7
	//
    wire lvl7Block1; // up and down and right
    wire lvl7Block2; // up and down and left and right
    wire lvl7Block3; // right and left
    wire lvl7Block4; // down and left
    wire lvl7Block5; // up and left and right
    wire lvl7Block6; // up and left
    wire lvl7Block7; // up
    wire lvl7Block8; // right
    wire lvl7Block9; // down and left

	wire safelevel7;

    wire lvl7Lava1;
    wire lvl7Lava2;
    wire lvl7Lava3;
    wire lvl7Lava4;

	wire lvl7Lava;

    wire lvl7_To_lvl6;
    wire lvl7_To_lvl2;

    assign lvl7Block1 = ((hCount >= 10'd608) && (hCount <= 10'd720)) && ((vCount >= 10'd275) && (vCount <= 10'd339)) ? 1 : 0;
    assign lvl7Block2 = ((hCount >= 10'd432) && (hCount <= 10'd544)) && ((vCount >= 10'd244) && (vCount <= 10'd259)) ? 1 : 0;
    assign lvl7Block3 = ((hCount >= 10'd481) && (hCount <= 10'd496)) && ((vCount >= 10'd100) && (vCount <= 10'd243)) ? 1 : 0;
    assign lvl7Block4 = ((hCount >= 10'd144) && (hCount <= 10'd208)) && ((vCount >= 10'd386) && (vCount <= 10'd450)) ? 1 : 0;
    assign lvl7Block5 = ((hCount >= 10'd241) && (hCount <= 10'd368)) && ((vCount >= 10'd100) && (vCount <= 10'd163)) ? 1 : 0;
    assign lvl7Block6 = ((hCount >= 10'd144) && (hCount <= 10'd176)) && ((vCount >= 10'd100) && (vCount <= 10'd323)) ? 1 : 0;
    assign lvl7Block7 = ((hCount >= 10'd144) && (hCount <= 10'd720)) && ((vCount >= 10'd35) && (vCount <= 10'd99)) ? 1 : 0;
    assign lvl7Block8 = ((hCount >= 10'd721) && (hCount <= 10'd784)) && ((vCount >= 10'd35) && (vCount <= 10'd515)) ? 1 : 0;
    assign lvl7Block9 = ((hCount >= 10'd144) && (hCount <= 10'd656)) && ((vCount >= 10'd451) && (vCount <= 10'd515)) ? 1 : 0;

	assign safelevel7 = lvl7Block1 || lvl7Block2 || lvl7Block3 || lvl7Block4 || lvl7Block5 || lvl7Block6 || lvl7Block7 || lvl7Block8 || lvl7Block9;

    assign lvl7Lava1 = ((hCount >= 10'd209) && (hCount <= 10'd656)) && ((vCount >= 10'd418) && (vCount <= 10'd450)) ? 1 : 0;
    assign lvl7Lava2 = ((hCount >= 10'd177) && (hCount <= 10'd240)) && ((vCount >= 10'd100) && (vCount <= 10'd131)) ? 1 : 0;
    assign lvl7Lava3 = ((hCount >= 10'd369) && (hCount <= 10'd480)) && ((vCount >= 10'd100) && (vCount <= 10'd131)) ? 1 : 0;
    assign lvl7Lava4 = ((hCount >= 10'd497) && (hCount <= 10'd720)) && ((vCount >= 10'd100) && (vCount <= 10'd131)) ? 1 : 0;

	assign lvl7Lava = lvl7Lava1 || lvl7Lava2 || lvl7Lava3 || lvl7Lava4;

    assign lvl7_To_lvl6 = ((hCount >= 10'd657) && (hCount <= 10'd720)) && ((vCount >= 10'd499) && (vCount <= 10'd515)) ? 1 : 0;
    assign lvl7_To_lvl2 = ((hCount >= 10'd144) && (hCount <= 10'd160)) && ((vCount >= 10'd323) && (vCount <= 10'd385)) ? 1 : 0;

	// Down Block Collisions

	assign lvl7Block1_col_down1 = ((pos_bottom_left_x >= 10'd608) && (pos_bottom_left_x <= 10'd720)) && ((pos_bottom_y >= 10'd275) && (pos_bottom_y <= 10'd339)) ? 1 : 0;
	assign lvl7Block1_col_down2 = ((pos_bottom_right_x >= 10'd608) && (pos_bottom_right_x <= 10'd720)) && ((pos_bottom_y >= 10'd275) && (pos_bottom_y <= 10'd339)) ? 1 : 0;
	assign lvl7Block2_col_down1 = ((pos_bottom_left_x >= 10'd432) && (pos_bottom_left_x <= 10'd544)) && ((pos_bottom_y >= 10'd244) && (pos_bottom_y <= 10'd259)) ? 1 : 0;
	assign lvl7Block2_col_down2 = ((pos_bottom_right_x >= 10'd432) && (pos_bottom_right_x <= 10'd544)) && ((pos_bottom_y >= 10'd244) && (pos_bottom_y <= 10'd259)) ? 1 : 0;
	assign lvl7Block4_col_down1 = ((pos_bottom_left_x >= 10'd144) && (pos_bottom_left_x <= 10'd208)) && ((pos_bottom_y >= 10'd386) && (pos_bottom_y <= 10'd450)) ? 1 : 0;
	assign lvl7Block4_col_down2 = ((pos_bottom_right_x >= 10'd144) && (pos_bottom_right_x <= 10'd208)) && ((pos_bottom_y >= 10'd386) && (pos_bottom_y <= 10'd450)) ? 1 : 0;
	assign lvl7Block9_col_down1 = ((pos_bottom_left_x >= 10'd144) && (pos_bottom_left_x <= 10'd656)) && ((pos_bottom_y >= 10'd451) && (pos_bottom_y <= 10'd515)) ? 1 : 0;
	assign lvl7Block9_col_down2 = ((pos_bottom_right_x >= 10'd144) && (pos_bottom_right_x <= 10'd656)) && ((pos_bottom_y >= 10'd451) && (pos_bottom_y <= 10'd515)) ? 1 : 0;

	assign lvl7_col_down = lvl7Block1_col_down1 || lvl7Block1_col_down2 || lvl7Block2_col_down1 || lvl7Block2_col_down2 ||lvl7Block4_col_down1 || lvl7Block4_col_down2 || lvl7Block9_col_down1 || lvl7Block9_col_down2;

	// Left Block Collisions

	assign lvl7Block2_col_left1 = ((pos_left_x >= 10'd432) && (pos_left_x <= 10'd544)) && ((pos_left_bottom_y >= 10'd244) && (pos_left_bottom_y <= 10'd259)) ? 1 : 0;
	assign lvl7Block2_col_left2 = ((pos_left_x >= 10'd432) && (pos_left_x <= 10'd544)) && ((pos_left_top_y >= 10'd244) && (pos_left_top_y <= 10'd259)) ? 1 : 0;
	assign lvl7Block3_col_left1 = ((pos_left_x >= 10'd481) && (pos_left_x <= 10'd496)) && ((pos_left_bottom_y >= 10'd100) && (pos_left_bottom_y <= 10'd243)) ? 1 : 0;
	assign lvl7Block3_col_left2 = ((pos_left_x >= 10'd481) && (pos_left_x <= 10'd496)) && ((pos_left_top_y >= 10'd100) && (pos_left_top_y <= 10'd243)) ? 1 : 0;
	assign lvl7Block4_col_left1 = ((pos_left_x >= 10'd481) && (pos_left_x <= 10'd496)) && ((pos_left_bottom_y >= 10'd100) && (pos_left_bottom_y <= 10'd243)) ? 1 : 0;
	assign lvl7Block4_col_left2 = ((pos_left_x >= 10'd481) && (pos_left_x <= 10'd496)) && ((pos_left_top_y >= 10'd100) && (pos_left_top_y <= 10'd243)) ? 1 : 0;
	assign lvl7Block5_col_left1 = ((pos_left_x >= 10'd144) && (pos_left_x <= 10'd208)) && ((pos_left_bottom_y >= 10'd386) && (pos_left_bottom_y <= 10'd450)) ? 1 : 0;
	assign lvl7Block5_col_left2 = ((pos_left_x >= 10'd144) && (pos_left_x <= 10'd208)) && ((pos_left_top_y >= 10'd386) && (pos_left_top_y <= 10'd450)) ? 1 : 0;
	assign lvl7Block6_col_left1 = ((pos_left_x >= 10'd144) && (pos_left_x <= 10'd176)) && ((pos_left_bottom_y >= 10'd100) && (pos_left_bottom_y <= 10'd323)) ? 1 : 0;
	assign lvl7Block6_col_left2 = ((pos_left_x >= 10'd144) && (pos_left_x <= 10'd176)) && ((pos_left_top_y >= 10'd100) && (pos_left_top_y <= 10'd323)) ? 1 : 0;
	assign lvl7Block9_col_left1 = ((pos_left_x >= 10'd241) && (pos_left_x <= 10'd368)) && ((pos_left_bottom_y >= 10'd100) && (pos_left_bottom_y <= 10'd163)) ? 1 : 0;
	assign lvl7Block9_col_left2 = ((pos_left_x >= 10'd241) && (pos_left_x <= 10'd368)) && ((pos_left_top_y >= 10'd100) && (pos_left_top_y <= 10'd163)) ? 1 : 0;
	
	assign lvl7_col_left = lvl7Block2_col_left1 || lvl7Block2_col_left2 || lvl7Block3_col_left1 || lvl7Block3_col_left2|| lvl7Block4_col_left1 || lvl7Block6_col_left1 || lvl7Block6_col_left2 || lvl7Block4_col_left2 || lvl7Block5_col_left1 || lvl7Block5_col_left2|| lvl7Block9_col_left1 || lvl7Block9_col_left2;

	// Up Block Collisions

    assign lvl7Block1_col_up1 = ((pos_top_left_x >= 10'd608) && (pos_top_left_x <= 10'd720)) && ((pos_top_y >= 10'd275) && (pos_top_y <= 10'd339)) ? 1 : 0;
    assign lvl7Block1_col_up2 = ((pos_top_right_x >= 10'd608) && (pos_top_right_x <= 10'd720)) && ((pos_top_y >= 10'd275) && (pos_top_y <= 10'd339)) ? 1 : 0;
	assign lvl7Block2_col_up1 = ((pos_top_left_x >= 10'd432) && (pos_top_left_x <= 10'd544)) && ((pos_top_y >= 10'd244) && (pos_top_y <= 10'd259)) ? 1 : 0;
	assign lvl7Block2_col_up2 = ((pos_top_right_x >= 10'd432) && (pos_top_right_x <= 10'd544)) && ((pos_top_y >= 10'd244) && (pos_top_y <= 10'd259)) ? 1 : 0;
	assign lvl7Block5_col_up1 = ((pos_top_left_x >= 10'd241) && (pos_top_left_x <= 10'd368)) && ((pos_top_y >= 10'd100) && (pos_top_y <= 10'd163)) ? 1 : 0;
	assign lvl7Block5_col_up2 = ((pos_top_right_x >= 10'd241) && (pos_top_right_x <= 10'd368)) && ((pos_top_y >= 10'd100) && (pos_top_y <= 10'd163)) ? 1 : 0;
	assign lvl7Block6_col_up1 = ((pos_top_left_x >= 10'd144) && (pos_top_left_x <= 10'd176)) && ((pos_top_y >= 10'd100) && (pos_top_y <= 10'd323)) ? 1 : 0;
	assign lvl7Block6_col_up2 = ((pos_top_right_x >= 10'd144) && (pos_top_right_x <= 10'd176)) && ((pos_top_y >= 10'd100) && (pos_top_y <= 10'd323)) ? 1 : 0;
	assign lvl7Block7_col_up1 = ((pos_top_left_x >= 10'd144) && (pos_top_left_x <= 10'd720)) && ((pos_top_y >= 10'd35) && (pos_top_y <= 10'd99)) ? 1 : 0;
	assign lvl7Block7_col_up2 = ((pos_top_right_x >= 10'd144) && (pos_top_right_x <= 10'd720)) && ((pos_top_y >= 10'd35) && (pos_top_y <= 10'd99)) ? 1 : 0;

	assign lvl7_col_up = lvl7Block1_col_up1 || lvl7Block1_col_up2 || lvl7Block2_col_up1 || lvl7Block2_col_up2 || lvl7Block5_col_up1 || lvl7Block5_col_up2 || lvl7Block6_col_up1 || lvl7Block6_col_up2 || lvl7Block7_col_up1 || lvl7Block7_col_up2;

	// Right Block Collisions

	assign lvl7Block1_col_right1 = ((pos_right_x >= 10'd608) && (pos_right_x <= 10'd720)) && ((pos_right_bottom_y >= 10'd275) && (pos_right_bottom_y <= 10'd339)) ? 1 : 0;
	assign lvl7Block1_col_right2 = ((pos_right_x >= 10'd608) && (pos_right_x <= 10'd720)) && ((pos_right_top_y >= 10'd275) && (pos_right_top_y <= 10'd339)) ? 1 : 0;
	assign lvl7Block2_col_right1 = ((pos_right_x >= 10'd432) && (pos_right_x <= 10'd544)) && ((pos_right_bottom_y >= 10'd244) && (pos_right_bottom_y <= 10'd259)) ? 1 : 0;
	assign lvl7Block2_col_right2 = ((pos_right_x >= 10'd432) && (pos_right_x <= 10'd544)) && ((pos_right_top_y >= 10'd244) && (pos_right_top_y <= 10'd259)) ? 1 : 0;
	assign lvl7Block3_col_right1 = ((pos_right_x >= 10'd481) && (pos_right_x <= 10'd496)) && ((pos_right_bottom_y >= 10'd100) && (pos_right_bottom_y <= 10'd243)) ? 1 : 0;
	assign lvl7Block3_col_right2 = ((pos_right_x >= 10'd481) && (pos_right_x <= 10'd496)) && ((pos_right_top_y >= 10'd100) && (pos_right_top_y <= 10'd243)) ? 1 : 0;
	assign lvl7Block5_col_right1 = ((pos_right_x >= 10'd241) && (pos_right_x <= 10'd368)) && ((pos_right_bottom_y >= 10'd100) && (pos_right_bottom_y <= 10'd163)) ? 1 : 0;
	assign lvl7Block5_col_right2 = ((pos_right_x >= 10'd241) && (pos_right_x <= 10'd368)) && ((pos_right_top_y >= 10'd100) && (pos_right_top_y <= 10'd163)) ? 1 : 0;
	assign lvl7Block8_col_right1 = ((pos_right_x >= 10'd721) && (pos_right_x <= 10'd784)) && ((pos_right_bottom_y >= 10'd35) && (pos_right_bottom_y <= 10'd515)) ? 1 : 0;
	assign lvl7Block8_col_right2 = ((pos_right_x >= 10'd721) && (pos_right_x <= 10'd784)) && ((pos_right_top_y >= 10'd35) && (pos_right_top_y <= 10'd515)) ? 1 : 0;

	assign lvl7_col_right = lvl7Block1_col_right1 || lvl7Block1_col_right2 || lvl7Block2_col_right1 || lvl7Block2_col_right2 || lvl7Block3_col_right1 || lvl7Block3_col_right2|| lvl7Block5_col_right1 || lvl7Block5_col_right2 || lvl7Block8_col_right1 || lvl7Block8_col_right2; 

	// Lava Collisions

    assign lvl7Lava1_col = ((xPos >= 10'd209) && (xPos <= 10'd656)) && ((yPos >= 10'd418) && (yPos <= 10'd450)) ? 1 : 0;
    assign lvl7Lava2_col = ((xPos >= 10'd177) && (xPos <= 10'd240)) && ((yPos >= 10'd100) && (yPos <= 10'd131)) ? 1 : 0;
    assign lvl7Lava3_col = ((xPos >= 10'd369) && (xPos <= 10'd480)) && ((yPos >= 10'd100) && (yPos <= 10'd131)) ? 1 : 0;
    assign lvl7Lava4_col = ((xPos >= 10'd497) && (xPos <= 10'd720)) && ((yPos >= 10'd100) && (yPos <= 10'd131)) ? 1 : 0;

	assign lvl7Lava_col = lvl7Lava1_col || lvl7Lava2_col || lvl7Lava3_col || lvl7Lava4_col;
	
	// Transition and Win Collisions

	assign lvl7_To_lvl6_col = ((xPos >= 10'd657) && (xPos <= 10'd720)) && ((yPos >= 10'd499) && (yPos <= 10'd515)) ? 1 : 0;
	assign lvl7_To_lvl2_col = ((xPos >= 10'd144) && (xPos <= 10'd160)) && ((yPos >= 10'd323) && (yPos <= 10'd385)) ? 1 : 0;

	//
    // Level 8
	//
    wire lvl8Block1; // up and left
    wire lvl8Block2; // left
    wire lvl8Block3; // up
    wire lvl8Block4; // up and right
    wire lvl8Block5; // right
    wire lvl8Block6; // down and left

    wire lvl8Block7; // left pillars
    wire lvl8Block8;
    wire lvl8Block9;
    wire lvl8Block10;
    wire lvl8Block11;
    wire lvl8Block12;

    wire lvl8Block13; // right pillars
    wire lvl8Block14;
    wire lvl8Block15;
    wire lvl8Block16;
    wire lvl8Block17;
    wire lvl8Block18;

    wire lvl8Block19; // middle pillars
    wire lvl8Block20;
    wire lvl8Block21;
    wire lvl8Block22;
    wire lvl8Block23;
    wire lvl8Block24;
    wire lvl8Block25;
    wire lvl8Block26;
    wire lvl8Block27;
    wire lvl8Block28;
    wire lvl8Block29;
    wire lvl8Block30;
    wire lvl8Block31;
    wire lvl8Block32;
    wire lvl8Block33;

	wire safelvl8;

    wire lvl8Lava1; // left lava
    wire lvl8Lava2;
    wire lvl8Lava3;
    wire lvl8Lava4;
    wire lvl8Lava5;
    wire lvl8Lava6;
    wire lvl8Lava7;

    wire lvl8Lava8; // right lava
    wire lvl8Lava9;
    wire lvl8Lava10;
    wire lvl8Lava11;
    wire lvl8Lava12;
    wire lvl8Lava13;
    wire lvl8Lava14;

    wire lvl8Lava15; // middle lava
    wire lvl8Lava16;
    wire lvl8Lava17;
    wire lvl8Lava18;
    wire lvl8Lava19;
    wire lvl8Lava20;
    wire lvl8Lava21;
    wire lvl8Lava22;
    wire lvl8Lava23;
    wire lvl8Lava24;
    wire lvl8Lava25;
    wire lvl8Lava26;
    wire lvl8Lava27;
    wire lvl8Lava28;
    wire lvl8Lava29;
    wire lvl8Lava30;
    wire lvl8Lava31;

	wire lvl8Lava;

    wire lvl8_To_lvl2;

    wire victoryZone;
	wire winText;

    assign lvl8Block1 = ((hCount >= 10'd209) && (hCount <= 10'd272)) && ((vCount >= 10'd35) && (vCount <= 10'd323)) ? 1 : 0;
    assign lvl8Block2 = ((hCount >= 10'd144) && (hCount <= 10'd208)) && ((vCount >= 10'd35) && (vCount <= 10'd387)) ? 1 : 0;
    assign lvl8Block3 = ((hCount >= 10'd273) && (hCount <= 10'd624)) && ((vCount >= 10'd35) && (vCount <= 10'd179)) ? 1 : 0;
    assign lvl8Block4 = ((hCount >= 10'd625) && (hCount <= 10'd720)) && ((vCount >= 10'd35) && (vCount <= 10'd323)) ? 1 : 0;
    assign lvl8Block5 = ((hCount >= 10'd721) && (hCount <= 10'd784)) && ((vCount >= 10'd35) && (vCount <= 10'd515)) ? 1 : 0;
    assign lvl8Block6 = ((hCount >= 10'd144) && (hCount <= 10'd656)) && ((vCount >= 10'd387) && (vCount <= 10'd515)) ? 1 : 0;

    assign lvl8Block7 = ((hCount >= 10'd273) && (hCount <= 10'd288)) && ((vCount >= 10'd180) && (vCount <= 10'd275)) ? 1 : 0; // left pillars
    assign lvl8Block8 = ((hCount >= 10'd289) && (hCount <= 10'd304)) && ((vCount >= 10'd180) && (vCount <= 10'd259)) ? 1 : 0;
    assign lvl8Block9 = ((hCount >= 10'd305) && (hCount <= 10'd320)) && ((vCount >= 10'd180) && (vCount <= 10'd243)) ? 1 : 0;
    assign lvl8Block10 = ((hCount >= 10'd321) && (hCount <= 10'd336)) && ((vCount >= 10'd180) && (vCount <= 10'd227)) ? 1 : 0;
    assign lvl8Block11 = ((hCount >= 10'd337) && (hCount <= 10'd352)) && ((vCount >= 10'd180) && (vCount <= 10'd211)) ? 1 : 0;
    assign lvl8Block12 = ((hCount >= 10'd353) && (hCount <= 10'd368)) && ((vCount >= 10'd180) && (vCount <= 10'd195)) ? 1 : 0;

    assign lvl8Block13 = ((hCount >= 10'd529) && (hCount <= 10'd544)) && ((vCount >= 10'd180) && (vCount <= 10'd195)) ? 1 : 0; // right pillars
    assign lvl8Block14 = ((hCount >= 10'd545) && (hCount <= 10'd560)) && ((vCount >= 10'd180) && (vCount <= 10'd211)) ? 1 : 0;
    assign lvl8Block15 = ((hCount >= 10'd561) && (hCount <= 10'd576)) && ((vCount >= 10'd180) && (vCount <= 10'd227)) ? 1 : 0;
    assign lvl8Block16 = ((hCount >= 10'd577) && (hCount <= 10'd592)) && ((vCount >= 10'd180) && (vCount <= 10'd243)) ? 1 : 0;
    assign lvl8Block17 = ((hCount >= 10'd593) && (hCount <= 10'd608)) && ((vCount >= 10'd180) && (vCount <= 10'd259)) ? 1 : 0;
    assign lvl8Block18 = ((hCount >= 10'd609) && (hCount <= 10'd719)) && ((vCount >= 10'd180) && (vCount <= 10'd275)) ? 1 : 0;

    assign lvl8Block19 = ((hCount >= 10'd321) && (hCount <= 10'd336)) && ((vCount >= 10'd370) && (vCount <= 10'd386)) ? 1 : 0; // middle pillars
    assign lvl8Block20 = ((hCount >= 10'd337) && (hCount <= 10'd352)) && ((vCount >= 10'd354) && (vCount <= 10'd386)) ? 1 : 0;
    assign lvl8Block21 = ((hCount >= 10'd353) && (hCount <= 10'd368)) && ((vCount >= 10'd338) && (vCount <= 10'd386)) ? 1 : 0;
    assign lvl8Block22 = ((hCount >= 10'd369) && (hCount <= 10'd384)) && ((vCount >= 10'd322) && (vCount <= 10'd386)) ? 1 : 0;
    assign lvl8Block23 = ((hCount >= 10'd385) && (hCount <= 10'd400)) && ((vCount >= 10'd306) && (vCount <= 10'd386)) ? 1 : 0;
    assign lvl8Block24 = ((hCount >= 10'd401) && (hCount <= 10'd416)) && ((vCount >= 10'd290) && (vCount <= 10'd386)) ? 1 : 0;
    assign lvl8Block25 = ((hCount >= 10'd417) && (hCount <= 10'd432)) && ((vCount >= 10'd274) && (vCount <= 10'd386)) ? 1 : 0;
    assign lvl8Block26 = ((hCount >= 10'd433) && (hCount <= 10'd464)) && ((vCount >= 10'd258) && (vCount <= 10'd386)) ? 1 : 0; // mid
    assign lvl8Block27 = ((hCount >= 10'd465) && (hCount <= 10'd480)) && ((vCount >= 10'd274) && (vCount <= 10'd386)) ? 1 : 0;
    assign lvl8Block28 = ((hCount >= 10'd481) && (hCount <= 10'd496)) && ((vCount >= 10'd290) && (vCount <= 10'd386)) ? 1 : 0;
    assign lvl8Block29 = ((hCount >= 10'd497) && (hCount <= 10'd512)) && ((vCount >= 10'd306) && (vCount <= 10'd386)) ? 1 : 0;
    assign lvl8Block30 = ((hCount >= 10'd513) && (hCount <= 10'd528)) && ((vCount >= 10'd322) && (vCount <= 10'd386)) ? 1 : 0;
    assign lvl8Block31 = ((hCount >= 10'd529) && (hCount <= 10'd544)) && ((vCount >= 10'd338) && (vCount <= 10'd386)) ? 1 : 0;
    assign lvl8Block32 = ((hCount >= 10'd545) && (hCount <= 10'd560)) && ((vCount >= 10'd354) && (vCount <= 10'd386)) ? 1 : 0;
    assign lvl8Block33 = ((hCount >= 10'd561) && (hCount <= 10'd576)) && ((vCount >= 10'd370) && (vCount <= 10'd386)) ? 1 : 0;

	assign safelevel8 = lvl8Block1 || lvl8Block2 || lvl8Block3 || lvl8Block4 || lvl8Block5 || lvl8Block6 || lvl8Block7 || lvl8Block8 || lvl8Block9 || lvl8Block10 || lvl8Block11 || lvl8Block12 || lvl8Block13 || lvl8Block14 || lvl8Block15 || lvl8Block16 || lvl8Block17 || lvl8Block18 || lvl8Block19 || lvl8Block20 || lvl8Block21 || lvl8Block22 || lvl8Block23 || lvl8Block24 || lvl8Block25 || lvl8Block26 || lvl8Block27 || lvl8Block28 || lvl8Block29 || lvl8Block30 || lvl8Block31 || lvl8Block32 || lvl8Block33;

    assign lvl8Lava1 = ((hCount >= 10'd273) && (hCount <= 10'd288)) && ((vCount >= 10'd276) && (vCount <= 10'd291)) ? 1 : 0; // left lava
    assign lvl8Lava2 = ((hCount >= 10'd289) && (hCount <= 10'd304)) && ((vCount >= 10'd260) && (vCount <= 10'd275)) ? 1 : 0;
    assign lvl8Lava3 = ((hCount >= 10'd305) && (hCount <= 10'd320)) && ((vCount >= 10'd244) && (vCount <= 10'd259)) ? 1 : 0;
    assign lvl8Lava4 = ((hCount >= 10'd321) && (hCount <= 10'd336)) && ((vCount >= 10'd228) && (vCount <= 10'd243)) ? 1 : 0;
    assign lvl8Lava5 = ((hCount >= 10'd337) && (hCount <= 10'd352)) && ((vCount >= 10'd212) && (vCount <= 10'd227)) ? 1 : 0;
    assign lvl8Lava6 = ((hCount >= 10'd353) && (hCount <= 10'd368)) && ((vCount >= 10'd196) && (vCount <= 10'd211)) ? 1 : 0;
    assign lvl8Lava7 = ((hCount >= 10'd369) && (hCount <= 10'd384)) && ((vCount >= 10'd180) && (vCount <= 10'd195)) ? 1 : 0;

    assign lvl8Lava8 = ((hCount >= 10'd513) && (hCount <= 10'd528)) && ((vCount >= 10'd180) && (vCount <= 10'd195)) ? 1 : 0; // right lava
    assign lvl8Lava9 = ((hCount >= 10'd529) && (hCount <= 10'd544)) && ((vCount >= 10'd196) && (vCount <= 10'd211)) ? 1 : 0;
    assign lvl8Lava10 = ((hCount >= 10'd545) && (hCount <= 10'd560)) && ((vCount >= 10'd212) && (vCount <= 10'd227)) ? 1 : 0;
    assign lvl8Lava11 = ((hCount >= 10'd561) && (hCount <= 10'd576)) && ((vCount >= 10'd228) && (vCount <= 10'd243)) ? 1 : 0;
    assign lvl8Lava12 = ((hCount >= 10'd577) && (hCount <= 10'd592)) && ((vCount >= 10'd244) && (vCount <= 10'd259)) ? 1 : 0;
    assign lvl8Lava13 = ((hCount >= 10'd593) && (hCount <= 10'd608)) && ((vCount >= 10'd260) && (vCount <= 10'd275)) ? 1 : 0;
    assign lvl8Lava14 = ((hCount >= 10'd609) && (hCount <= 10'd719)) && ((vCount >= 10'd276) && (vCount <= 10'd291)) ? 1 : 0;

    assign lvl8Lava15 = ((hCount >= 10'd305) && (hCount <= 10'd320)) && ((vCount >= 10'd370) && (vCount <= 10'd386)) ? 1 : 0; // middle lava
    assign lvl8Lava16 = ((hCount >= 10'd321) && (hCount <= 10'd336)) && ((vCount >= 10'd354) && (vCount <= 10'd369)) ? 1 : 0;
    assign lvl8Lava17 = ((hCount >= 10'd337) && (hCount <= 10'd352)) && ((vCount >= 10'd338) && (vCount <= 10'd353)) ? 1 : 0;
    assign lvl8Lava18 = ((hCount >= 10'd353) && (hCount <= 10'd368)) && ((vCount >= 10'd322) && (vCount <= 10'd337)) ? 1 : 0;
    assign lvl8Lava19 = ((hCount >= 10'd369) && (hCount <= 10'd384)) && ((vCount >= 10'd306) && (vCount <= 10'd321)) ? 1 : 0;
    assign lvl8Lava20 = ((hCount >= 10'd385) && (hCount <= 10'd400)) && ((vCount >= 10'd290) && (vCount <= 10'd305)) ? 1 : 0;
    assign lvl8Lava21 = ((hCount >= 10'd401) && (hCount <= 10'd416)) && ((vCount >= 10'd274) && (vCount <= 10'd289)) ? 1 : 0;
    assign lvl8Lava22 = ((hCount >= 10'd417) && (hCount <= 10'd432)) && ((vCount >= 10'd258) && (vCount <= 10'd273)) ? 1 : 0;
    assign lvl8Lava23 = ((hCount >= 10'd433) && (hCount <= 10'd464)) && ((vCount >= 10'd242) && (vCount <= 10'd257)) ? 1 : 0; // mid
    assign lvl8Lava24 = ((hCount >= 10'd465) && (hCount <= 10'd480)) && ((vCount >= 10'd258) && (vCount <= 10'd273)) ? 1 : 0;
    assign lvl8Lava25 = ((hCount >= 10'd481) && (hCount <= 10'd496)) && ((vCount >= 10'd274) && (vCount <= 10'd289)) ? 1 : 0;
    assign lvl8Lava26 = ((hCount >= 10'd497) && (hCount <= 10'd512)) && ((vCount >= 10'd290) && (vCount <= 10'd305)) ? 1 : 0;
    assign lvl8Lava27 = ((hCount >= 10'd513) && (hCount <= 10'd528)) && ((vCount >= 10'd306) && (vCount <= 10'd321)) ? 1 : 0;
    assign lvl8Lava28 = ((hCount >= 10'd529) && (hCount <= 10'd544)) && ((vCount >= 10'd322) && (vCount <= 10'd337)) ? 1 : 0;
    assign lvl8Lava29 = ((hCount >= 10'd545) && (hCount <= 10'd560)) && ((vCount >= 10'd338) && (vCount <= 10'd353)) ? 1 : 0;
    assign lvl8Lava30 = ((hCount >= 10'd561) && (hCount <= 10'd576)) && ((vCount >= 10'd354) && (vCount <= 10'd369)) ? 1 : 0;
    assign lvl8Lava31 = ((hCount >= 10'd577) && (hCount <= 10'd592)) && ((vCount >= 10'd370) && (vCount <= 10'd386)) ? 1 : 0;

	assign lvl8Lava = lvl8Lava1 || lvl8Lava2 || lvl8Lava3 || lvl8Lava4 || lvl8Lava5 || lvl8Lava6 || lvl8Lava7 || lvl8Lava8 || lvl8Lava9 || lvl8Lava10 || lvl8Lava11 || lvl8Lava12 || lvl8Lava13 || lvl8Lava14 || lvl8Lava15 || lvl8Lava16 || lvl8Lava17 || lvl8Lava18 || lvl8Lava19 || lvl8Lava20 || lvl8Lava21 || lvl8Lava22 || lvl8Lava23 || lvl8Lava24 || lvl8Lava25 || lvl8Lava26 || lvl8Lava27 || lvl8Lava28 || lvl8Lava29 || lvl8Lava30 || lvl8Lava31;

    assign lvl8_To_lvl2 = ((hCount >= 10'd657) && (hCount <= 10'd720)) && ((vCount >= 10'd499) && (vCount <= 10'd515)) ? 1 : 0;

    assign victoryZone = ((hCount >= 10'd224) && (hCount <= 10'd239)) && ((vCount >= 10'd371) && (vCount <= 10'd386)) ? 1 : 0;

	assign winTextBlock1 = ((hCount >= 10'd144) && (hCount <= 10'd208)) && ((vCount >= 10'd259) && (vCount <= 10'd291)) ? 1 : 0; // sides
	assign winTextBlock2 = ((hCount >= 10'd704) && (hCount <= 10'd784)) && ((vCount >= 10'd259) && (vCount <= 10'd291)) ? 1 : 0;
	assign winTextBlock3 = ((hCount >= 10'd304) && (hCount <= 10'd608)) && ((vCount >= 10'd115) && (vCount <= 10'd131)) ? 1 : 0;
	assign winTextBlock4 = ((hCount >= 10'd304) && (hCount <= 10'd608)) && ((vCount >= 10'd419) && (vCount <= 10'd435)) ? 1 : 0;

	assign winTextBlock5 = ((hCount >= 10'd208) && (hCount <= 10'd224)) && ((vCount >= 10'd195) && (vCount <= 10'd355)) ? 1 : 0; // left pillars
	assign winTextBlock6 = ((hCount >= 10'd225) && (hCount <= 10'd240)) && ((vCount >= 10'd179) && (vCount <= 10'd371)) ? 1 : 0;
	assign winTextBlock7 = ((hCount >= 10'd241) && (hCount <= 10'd256)) && ((vCount >= 10'd163) && (vCount <= 10'd387)) ? 1 : 0;
	assign winTextBlock8 = ((hCount >= 10'd257) && (hCount <= 10'd272)) && ((vCount >= 10'd147) && (vCount <= 10'd403)) ? 1 : 0;
	assign winTextBlock9 = ((hCount >= 10'd273) && (hCount <= 10'd288)) && ((vCount >= 10'd131) && (vCount <= 10'd419)) ? 1 : 0;
	assign winTextBlock10 = ((hCount >= 10'd289) && (hCount <= 10'd303)) && ((vCount >= 10'd115) && (vCount <= 10'd435)) ? 1 : 0;

	assign winTextBlock11 = ((hCount >= 10'd609) && (hCount <= 10'd624)) && ((vCount >= 10'd115) && (vCount <= 10'd435)) ? 1 : 0; // right pillars
	assign winTextBlock12 = ((hCount >= 10'd625) && (hCount <= 10'd640)) && ((vCount >= 10'd131) && (vCount <= 10'd419)) ? 1 : 0;
	assign winTextBlock13 = ((hCount >= 10'd641) && (hCount <= 10'd656)) && ((vCount >= 10'd147) && (vCount <= 10'd403)) ? 1 : 0;
	assign winTextBlock14 = ((hCount >= 10'd657) && (hCount <= 10'd672)) && ((vCount >= 10'd163) && (vCount <= 10'd387)) ? 1 : 0;
	assign winTextBlock15 = ((hCount >= 10'd673) && (hCount <= 10'd688)) && ((vCount >= 10'd179) && (vCount <= 10'd371)) ? 1 : 0;
	assign winTextBlock16 = ((hCount >= 10'd689) && (hCount <= 10'd703)) && ((vCount >= 10'd195) && (vCount <= 10'd355)) ? 1 : 0;

	assign winText_Y_block1 = ((hCount >= 10'd320) && (hCount <= 10'd336)) && ((vCount >= 10'd147) && (vCount <= 10'd211)) ? 1 : 0;
	assign winText_Y_block2 = ((hCount >= 10'd337) && (hCount <= 10'd384)) && ((vCount >= 10'd195) && (vCount <= 10'd211)) ? 1 : 0;
	assign winText_Y_block3 = ((hCount >= 10'd385) && (hCount <= 10'd400)) && ((vCount >= 10'd147) && (vCount <= 10'd211)) ? 1 : 0;
	assign winText_Y_block4 = ((hCount >= 10'd352) && (hCount <= 10'd368)) && ((vCount >= 10'd212) && (vCount <= 10'd259)) ? 1 : 0;

	assign winText_O_block1 = ((hCount >= 10'd416) && (hCount <= 10'd432)) && ((vCount >= 10'd147) && (vCount <= 10'd259)) ? 1 : 0;
	assign winText_O_block2 = ((hCount >= 10'd433) && (hCount <= 10'd480)) && ((vCount >= 10'd147) && (vCount <= 10'd162)) ? 1 : 0;
	assign winText_O_block3 = ((hCount >= 10'd433) && (hCount <= 10'd480)) && ((vCount >= 10'd243) && (vCount <= 10'd259)) ? 1 : 0;
	assign winText_O_block4 = ((hCount >= 10'd481) && (hCount <= 10'd496)) && ((vCount >= 10'd147) && (vCount <= 10'd259)) ? 1 : 0;

	assign winText_U_block1 = ((hCount >= 10'd512) && (hCount <= 10'd528)) && ((vCount >= 10'd147) && (vCount <= 10'd259)) ? 1 : 0;
	assign winText_U_block2 = ((hCount >= 10'd529) && (hCount <= 10'd576)) && ((vCount >= 10'd243) && (vCount <= 10'd259)) ? 1 : 0;
	assign winText_U_block3 = ((hCount >= 10'd577) && (hCount <= 10'd592)) && ((vCount >= 10'd147) && (vCount <= 10'd259)) ? 1 : 0;

	assign winText_W_block1 = ((hCount >= 10'd320) && (hCount <= 10'd336)) && ((vCount >= 10'd291) && (vCount <= 10'd403)) ? 1 : 0;
	assign winText_W_block2 = ((hCount >= 10'd337) && (hCount <= 10'd352)) && ((vCount >= 10'd371) && (vCount <= 10'd403)) ? 1 : 0;
	assign winText_W_block3 = ((hCount >= 10'd353) && (hCount <= 10'd368)) && ((vCount >= 10'd355) && (vCount <= 10'd387)) ? 1 : 0;
	assign winText_W_block4 = ((hCount >= 10'd369) && (hCount <= 10'd384)) && ((vCount >= 10'd371) && (vCount <= 10'd403)) ? 1 : 0;
	assign winText_W_block5 = ((hCount >= 10'd385) && (hCount <= 10'd400)) && ((vCount >= 10'd291) && (vCount <= 10'd403)) ? 1 : 0;

	assign winText_I_block1 = ((hCount >= 10'd416) && (hCount <= 10'd496)) && ((vCount >= 10'd291) && (vCount <= 10'd306)) ? 1 : 0;
	assign winText_I_block2 = ((hCount >= 10'd448) && (hCount <= 10'd464)) && ((vCount >= 10'd307) && (vCount <= 10'd386)) ? 1 : 0;
	assign winText_I_block3 = ((hCount >= 10'd416) && (hCount <= 10'd496)) && ((vCount >= 10'd387) && (vCount <= 10'd403)) ? 1 : 0;

	assign winText_N_block1 = ((hCount >= 10'd512) && (hCount <= 10'd528)) && ((vCount >= 10'd291) && (vCount <= 10'd403)) ? 1 : 0;
	assign winText_N_block2 = ((hCount >= 10'd529) && (hCount <= 10'd544)) && ((vCount >= 10'd307) && (vCount <= 10'd323)) ? 1 : 0;
	assign winText_N_block3 = ((hCount >= 10'd545) && (hCount <= 10'd560)) && ((vCount >= 10'd324) && (vCount <= 10'd371)) ? 1 : 0;
	assign winText_N_block4 = ((hCount >= 10'd561) && (hCount <= 10'd576)) && ((vCount >= 10'd372) && (vCount <= 10'd387)) ? 1 : 0;
	assign winText_N_block5 = ((hCount >= 10'd577) && (hCount <= 10'd592)) && ((vCount >= 10'd291) && (vCount <= 10'd403)) ? 1 : 0;

	assign winText = winTextBlock1 || winTextBlock2 || winTextBlock3 || winTextBlock4 || winTextBlock5 || winTextBlock6 || winTextBlock7 || winTextBlock8 || winTextBlock9 || winTextBlock10 || winTextBlock11 || winTextBlock12 || winTextBlock13 || winTextBlock14 || winTextBlock15 || winTextBlock16 || winText_Y_block1 || winText_Y_block2 || winText_Y_block3 || winText_Y_block4 || winText_O_block1 || winText_O_block2 || winText_O_block3 || winText_O_block4 || winText_U_block1 || winText_U_block2 || winText_U_block3 || winText_W_block1 || winText_W_block2 || winText_W_block3 || winText_W_block4 || winText_W_block5 || winText_I_block1 || winText_I_block2 || winText_I_block3 || winText_N_block1 || winText_N_block2 || winText_N_block3 || winText_N_block4 || winText_N_block5;

	// Down Block Collisions

	assign lvl8Block6_col_down1 = ((pos_bottom_left_x >= 10'd144) && (pos_bottom_left_x <= 10'd656)) && ((pos_bottom_y >= 10'd387) && (pos_bottom_y <= 10'd515)) ? 1 : 0;
	assign lvl8Block6_col_down2 = ((pos_bottom_right_x >= 10'd144) && (pos_bottom_right_x <= 10'd656)) && ((pos_bottom_y >= 10'd387) && (pos_bottom_y <= 10'd515)) ? 1 : 0;

	assign lvl8_col_down = lvl8Block6_col_down1 || lvl8Block6_col_down2;

	// Left Block Collisions

	assign lvl8Block1_col_left1 = ((pos_left_x >= 10'd209) && (pos_left_x <= 10'd272)) && ((pos_left_bottom_y >= 10'd35) && (pos_left_bottom_y <= 10'd323)) ? 1 : 0;
	assign lvl8Block1_col_left2 = ((pos_left_x >= 10'd209) && (pos_left_x <= 10'd272)) && ((pos_left_top_y >= 10'd35) && (pos_left_top_y <= 10'd323)) ? 1 : 0;
	assign lvl8Block2_col_left1 = ((pos_left_x >= 10'd144) && (pos_left_x <= 10'd208)) && ((pos_left_bottom_y >= 10'd35) && (pos_left_bottom_y <= 10'd387)) ? 1 : 0;
	assign lvl8Block2_col_left2 = ((pos_left_x >= 10'd144) && (pos_left_x <= 10'd208)) && ((pos_left_top_y >= 10'd35) && (pos_left_top_y <= 10'd387)) ? 1 : 0;
	assign lvl8Block6_col_left1 = ((pos_left_x >= 10'd144) && (pos_left_x <= 10'd656)) && ((pos_left_bottom_y >= 10'd387) && (pos_left_bottom_y <= 10'd515)) ? 1 : 0;
	assign lvl8Block6_col_left2 = ((pos_left_x >= 10'd144) && (pos_left_x <= 10'd656)) && ((pos_left_top_y >= 10'd387) && (pos_left_top_y <= 10'd515)) ? 1 : 0;

	assign lvl8_col_left = lvl8Block1_col_left1 || lvl8Block1_col_left2 || lvl8Block2_col_left1 || lvl8Block2_col_left2 || lvl8Block6_col_left1 || lvl8Block6_col_left2;

	// Up Block Collisions

    assign lvl8Block1_col_up1 = ((pos_top_left_x >= 10'd209) && (pos_top_left_x <= 10'd272)) && ((pos_top_y >= 10'd35) && (pos_top_y <= 10'd323)) ? 1 : 0;
    assign lvl8Block1_col_up2 = ((pos_top_right_x >= 10'd209) && (pos_top_right_x <= 10'd272)) && ((pos_top_y >= 10'd35) && (pos_top_y <= 10'd323)) ? 1 : 0;
	assign lvl8Block3_col_up1 = ((pos_top_left_x >= 10'd273) && (pos_top_left_x <= 10'd624)) && ((pos_top_y >= 10'd35) && (pos_top_y <= 10'd179)) ? 1 : 0;
	assign lvl8Block3_col_up2 = ((pos_top_right_x >= 10'd273) && (pos_top_right_x <= 10'd624)) && ((pos_top_y >= 10'd35) && (pos_top_y <= 10'd179)) ? 1 : 0;
	assign lvl8Block4_col_up1 = ((pos_top_left_x >= 10'd625) && (pos_top_left_x <= 10'd720)) && ((pos_top_y >= 10'd35) && (pos_top_y <= 10'd323)) ? 1 : 0;
	assign lvl8Block4_col_up2 = ((pos_top_right_x >= 10'd625) && (pos_top_right_x <= 10'd720)) && ((pos_top_y >= 10'd35) && (pos_top_y <= 10'd323)) ? 1 : 0;

	assign lvl8_col_up = lvl8Block1_col_up1 || lvl8Block1_col_up2 || lvl8Block3_col_up1 || lvl8Block3_col_up2 || lvl8Block4_col_up1 || lvl8Block4_col_up2;

	// Right Block Collisions

	assign lvl8Block4_col_right1 = ((pos_right_x >= 10'd625) && (pos_right_x <= 10'd720)) && ((pos_right_bottom_y >= 10'd35) && (pos_right_bottom_y <= 10'd323)) ? 1 : 0;
	assign lvl8Block4_col_right2 = ((pos_right_x >= 10'd625) && (pos_right_x <= 10'd720)) && ((pos_right_top_y >= 10'd35) && (pos_right_top_y <= 10'd323)) ? 1 : 0;
	assign lvl8Block5_col_right1 = ((pos_right_x >= 10'd721) && (pos_right_x <= 10'd784)) && ((pos_right_bottom_y >= 10'd35) && (pos_right_bottom_y <= 10'd515)) ? 1 : 0;
	assign lvl8Block5_col_right2 = ((pos_right_x >= 10'd721) && (pos_right_x <= 10'd784)) && ((pos_right_top_y >= 10'd35) && (pos_right_top_y <= 10'd515)) ? 1 : 0;

	assign lvl8_col_right = lvl8Block4_col_right1 || lvl8Block4_col_right2 || lvl8Block5_col_right1 || lvl8Block5_col_right2; 

	// Lava Collisions

	assign lvl8Lava1_col = ((xPos >= 10'd273) && (xPos <= 10'd288)) && ((yPos >= 10'd276) && (yPos <= 10'd291)) ? 1 : 0; // left lava
	assign lvl8Lava2_col = ((xPos >= 10'd289) && (xPos <= 10'd304)) && ((yPos >= 10'd260) && (yPos <= 10'd275)) ? 1 : 0;
	assign lvl8Lava3_col = ((xPos >= 10'd305) && (xPos <= 10'd320)) && ((yPos >= 10'd244) && (yPos <= 10'd259)) ? 1 : 0;
	assign lvl8Lava4_col = ((xPos >= 10'd321) && (xPos <= 10'd336)) && ((yPos >= 10'd228) && (yPos <= 10'd243)) ? 1 : 0;
	assign lvl8Lava5_col = ((xPos >= 10'd337) && (xPos <= 10'd352)) && ((yPos >= 10'd212) && (yPos <= 10'd227)) ? 1 : 0;
	assign lvl8Lava6_col = ((xPos >= 10'd353) && (xPos <= 10'd368)) && ((yPos >= 10'd196) && (yPos <= 10'd211)) ? 1 : 0;
	assign lvl8Lava7_col = ((xPos >= 10'd369) && (xPos <= 10'd384)) && ((yPos >= 10'd180) && (yPos <= 10'd195)) ? 1 : 0;

	assign lvl8Lava8_col = ((xPos >= 10'd513) && (xPos <= 10'd528)) && ((yPos >= 10'd180) && (yPos <= 10'd195)) ? 1 : 0; // right lava
	assign lvl8Lava9_col = ((xPos >= 10'd529) && (xPos <= 10'd544)) && ((yPos >= 10'd196) && (yPos <= 10'd211)) ? 1 : 0;
	assign lvl8Lava10_col = ((xPos >= 10'd545) && (xPos <= 10'd560)) && ((yPos >= 10'd212) && (yPos <= 10'd227)) ? 1 : 0;
	assign lvl8Lava11_col = ((xPos >= 10'd561) && (xPos <= 10'd576)) && ((yPos >= 10'd228) && (yPos <= 10'd243)) ? 1 : 0;
	assign lvl8Lava12_col = ((xPos >= 10'd577) && (xPos <= 10'd592)) && ((yPos >= 10'd244) && (yPos <= 10'd259)) ? 1 : 0;
	assign lvl8Lava13_col = ((xPos >= 10'd593) && (xPos <= 10'd608)) && ((yPos >= 10'd260) && (yPos <= 10'd275)) ? 1 : 0;
	assign lvl8Lava14_col = ((xPos >= 10'd609) && (xPos <= 10'd719)) && ((yPos >= 10'd276) && (yPos <= 10'd291)) ? 1 : 0;

	assign lvl8Lava15_col = ((xPos >= 10'd305) && (xPos <= 10'd320)) && ((yPos >= 10'd370) && (yPos <= 10'd386)) ? 1 : 0; // middle lava
	assign lvl8Lava16_col = ((xPos >= 10'd321) && (xPos <= 10'd336)) && ((yPos >= 10'd354) && (yPos <= 10'd369)) ? 1 : 0;
	assign lvl8Lava17_col = ((xPos >= 10'd337) && (xPos <= 10'd352)) && ((yPos >= 10'd338) && (yPos <= 10'd353)) ? 1 : 0;
	assign lvl8Lava18_col = ((xPos >= 10'd353) && (xPos <= 10'd368)) && ((yPos >= 10'd322) && (yPos <= 10'd337)) ? 1 : 0;
	assign lvl8Lava19_col = ((xPos >= 10'd369) && (xPos <= 10'd384)) && ((yPos >= 10'd306) && (yPos <= 10'd321)) ? 1 : 0;
	assign lvl8Lava20_col = ((xPos >= 10'd385) && (xPos <= 10'd400)) && ((yPos >= 10'd290) && (yPos <= 10'd305)) ? 1 : 0;
	assign lvl8Lava21_col = ((xPos >= 10'd401) && (xPos <= 10'd416)) && ((yPos >= 10'd274) && (yPos <= 10'd289)) ? 1 : 0;
	assign lvl8Lava22_col = ((xPos >= 10'd417) && (xPos <= 10'd432)) && ((yPos >= 10'd258) && (yPos <= 10'd273)) ? 1 : 0;
	assign lvl8Lava23_col = ((xPos >= 10'd433) && (xPos <= 10'd464)) && ((yPos >= 10'd242) && (yPos <= 10'd257)) ? 1 : 0; // mid
	assign lvl8Lava24_col = ((xPos >= 10'd465) && (xPos <= 10'd480)) && ((yPos >= 10'd258) && (yPos <= 10'd273)) ? 1 : 0;
	assign lvl8Lava25_col = ((xPos >= 10'd481) && (xPos <= 10'd496)) && ((yPos >= 10'd274) && (yPos <= 10'd289)) ? 1 : 0;
	assign lvl8Lava26_col = ((xPos >= 10'd497) && (xPos <= 10'd512)) && ((yPos >= 10'd290) && (yPos <= 10'd305)) ? 1 : 0;
	assign lvl8Lava27_col = ((xPos >= 10'd513) && (xPos <= 10'd528)) && ((yPos >= 10'd306) && (yPos <= 10'd321)) ? 1 : 0;
	assign lvl8Lava28_col = ((xPos >= 10'd529) && (xPos <= 10'd544)) && ((yPos >= 10'd322) && (yPos <= 10'd337)) ? 1 : 0;
	assign lvl8Lava29_col = ((xPos >= 10'd545) && (xPos <= 10'd560)) && ((yPos >= 10'd338) && (yPos <= 10'd353)) ? 1 : 0;
	assign lvl8Lava30_col = ((xPos >= 10'd561) && (xPos <= 10'd576)) && ((yPos >= 10'd354) && (yPos <= 10'd369)) ? 1 : 0;
	assign lvl8Lava31_col = ((xPos >= 10'd577) && (xPos <= 10'd592)) && ((yPos >= 10'd370) && (yPos <= 10'd386)) ? 1 : 0;

	assign lvl8Lava_col = lvl8Lava1_col || lvl8Lava2_col || lvl8Lava3_col || lvl8Lava4_col || lvl8Lava5_col || lvl8Lava6_col || lvl8Lava7_col || lvl8Lava8_col || lvl8Lava9_col || lvl8Lava10_col || lvl8Lava11_col || lvl8Lava12_col || lvl8Lava13_col || lvl8Lava14_col || lvl8Lava15_col || lvl8Lava16_col || lvl8Lava17_col || lvl8Lava18_col || lvl8Lava19_col || lvl8Lava20_col || lvl8Lava21_col || lvl8Lava22_col || lvl8Lava23_col || lvl8Lava24_col || lvl8Lava25_col || lvl8Lava26_col || lvl8Lava27_col || lvl8Lava28_col || lvl8Lava29_col || lvl8Lava30_col || lvl8Lava31_col;

	// Transition and Win Collisions
	assign lvl8_To_lvl2_col = ((xPos >= 10'd657) && (xPos <= 10'd720)) && ((yPos >= 10'd499) && (yPos <= 10'd515)) ? 1 : 0;
	
	assign victoryZone_col = ((xPos >= 10'd224) && (xPos <= 10'd239)) && ((yPos >= 10'd371) && (yPos <= 10'd386)) ? 1 : 0;

	// 12-bit color codes
	parameter RED     = 12'b1111_0000_0000; // Lava color
	parameter BLACK   = 12'b0000_0000_0000; // Background color
	parameter GREEN   = 12'b0000_1111_0000; // Level-Transistion color
	parameter YELLOW  = 12'b1111_1111_0000; // Goal color
	parameter ORANGE  = 12'b1111_0111_0000; // Character color
	parameter PURPLE  = 12'b1010_0000_1111; // Checkpoint color
	parameter BLUE    = 12'b0000_0000_1111; // Ground color
	
	/*when outputting the rgb value in an always block like this, make sure to include the if(~bright) statement, as this ensures the monitor 
	will output some data to every pixel and not just the images you are trying to display*/
	
	// Block controls the display for each level/stage
	always@ (*) begin
    	if(~bright)	// force black if not inside the display area
			rgb = BLACK;
		else begin
			if (stage == LVL1) begin
				if (safelevel1 == 1)
					rgb = BLUE;
				else if (lvl1Lava == 1)
					rgb = RED;
				else if (lvl1_To_lvl2 == 1)
					rgb = GREEN;
				else
					rgb = background;
			end
			else if (stage == LVL2) begin
				if (safelevel2 == 1)
					rgb = BLUE;
				else if (lvl2Lava == 1)
					rgb = RED;
				else if (lvl2_To_lvl3 || lvl2_To_lvl7 || lvl2_To_lvl8 || lvl2_To_lvl1)
					rgb = GREEN;
				else
					rgb = background;
			end
			else if (stage == LVL3) begin
				if (safelevel3 == 1)
					rgb = BLUE;
				else if (lvl3Lava == 1)
					rgb = RED;
				else if (lvl3_To_lvl2 || lvl3_To_lvl4)
					rgb = GREEN;
				else
					rgb = background;
			end
			else if (stage == LVL4) begin
				if (safelevel4 == 1)
					rgb = BLUE;
				else if (lvl4Lava == 1)
					rgb = RED;
				else if (lvl4_To_lvl3 || lvl4_To_lvl5)
					rgb = GREEN;
				else
					rgb = background;
			end
			else if (stage == LVL5) begin
				if (safelevel5 == 1)
					rgb = BLUE;
				else if (lvl5Lava == 1)
					rgb = RED;
				else if (lvl5_To_lvl4 || lvl5_To_lvl6)
					rgb = GREEN;
				else if (checkpointLoc)
					rgb = PURPLE;
				else
					rgb = background;
			end
			else if (stage == LVL6) begin
				if (safelevel6 == 1)
					rgb = BLUE;
				else if (lvl6Lava == 1)
					rgb = RED;
				else if (lvl6_To_lvl5 || lvl6_To_lvl7)
					rgb = GREEN;
				else
					rgb = background;
			end
			else if (stage == LVL7) begin
				if (safelevel7 == 1)
					rgb = BLUE;
				else if (lvl7Lava == 1)
					rgb = RED;
				else if (lvl7_To_lvl6 || lvl7_To_lvl2)
					rgb = GREEN;
				else
					rgb = background;
			end
			else if (stage == LVL8) begin
				if (safelevel8 == 1)
					rgb = BLUE;
				else if (lvl8Lava == 1)
					rgb = RED;
				else if (lvl8_To_lvl2 == 1)
					rgb = GREEN;
				else if (victoryZone)
					rgb = YELLOW;
				else
					rgb = background;
			end
			else if (stage == WIN)  begin
				if (winText == 1)
					rgb = YELLOW;
				else
					rgb = background;
			end

			if (main_charac == 1) // Always draw the character on top
				rgb = ORANGE;
		end
	end

	// Block controls user inputs and level interactions
	always@(posedge clk, posedge rst) 
     begin
		if(rst) begin
			xPos <= 304;
			yPos <= 220;

			stage <= LVL1;
			gravity <= DOWN;

			background <= BLACK;
			checkpointFlag <= 0;
		end
		else if (clk) begin
			if (stage == LVL1) begin
				if(gravity == DOWN && ~lvl1_col_down) begin
					yPos <= yPos + 2; // go down
				end
				else if (gravity == DOWN && up) begin
					gravity <= UP;
				end

				if (gravity == UP && ~lvl1_col_up) begin
					yPos <= yPos - 2; // go up
				end
				else if (gravity == UP && up) begin
					gravity <= DOWN;
				end

				if (right && left) begin
					xPos <= xPos;
				end
				else if (right && ~lvl1_col_right) begin
					xPos <= xPos + 2; // go right
				end
				else if (left && ~lvl1_col_left) begin
					xPos <= xPos - 2; // go left
				end

				if (lvl1Lava_col) begin
					if (~checkpointFlag) begin // Haven't reached the checkpoint
						xPos <= 304;
						yPos <= 220;
					end
					else begin // Reached the checkpoint
						stage <= LVL5;

						xPos <= 695;
						yPos <= 307;
					end

					gravity <= DOWN;
				end

				if (lvl1_To_lvl2_col) begin
					stage <= LVL2;

					xPos <= 176;
					yPos <= yPos;
				end
			end
			else if (stage == LVL2) begin
				if(gravity == DOWN && ~lvl2_col_down) begin
					yPos <= yPos + 2; // go down
				end
				else if (gravity == DOWN && up) begin
					gravity <= UP;
				end

				if (gravity == UP && ~lvl2_col_up) begin
					yPos <= yPos - 2; // go up
				end
				else if (gravity == UP && up) begin
					gravity <= DOWN;
				end

				if (right && left) begin
					xPos <= xPos;
				end
				else if (right && ~lvl2_col_right) begin
					xPos <= xPos + 2; // go right
				end
				else if (left && ~lvl2_col_left) begin
					xPos <= xPos - 2; // go left
				end

				if (lvl2Lava_col) begin
					if (~checkpointFlag) begin // Haven't reached the checkpoint
						stage <= LVL1;

						xPos <= 304;
						yPos <= 220;
					end
					else begin // Reached the checkpoint
						stage <= LVL5;

						xPos <= 695;
						yPos <= 307;
					end

					gravity <= DOWN;
				end

				if (lvl2_To_lvl3_col) begin
					stage <= LVL3;

					xPos <= xPos;
					yPos <= 61;
					gravity <= DOWN;
				end
				else if (lvl2_To_lvl8_col) begin
					stage <= LVL8;

					xPos <= xPos;
					yPos <= 489;
					gravity <= UP;
				end
				else if (lvl2_To_lvl1_col) begin
					stage <= LVL1;

					xPos <= 758;
					yPos <= yPos;
				end
				else if (lvl2_To_lvl7_col) begin
					stage <= LVL7;

					xPos <= 170;
					yPos <= yPos;
				end
			end
			else if (stage == LVL3) begin
				if (gravity == DOWN)
					yPos <= yPos + 2;
				else
					yPos <= yPos - 2;

				if (right && left) begin
					xPos <= xPos;
				end
				else if (right && ~lvl3_col_right) begin
					xPos <= xPos + 2; // go right
				end
				else if (left && ~lvl3_col_left) begin
					xPos <= xPos - 2; // go left
				end

				if (lvl3Lava_col) begin
					if (~checkpointFlag) begin // Haven't reached the checkpoint
						stage <= LVL1;

						xPos <= 304;
						yPos <= 220;
					end
					else begin // Reached the checkpoint
						stage <= LVL5;

						xPos <= 695;
						yPos <= 307;
					end

					gravity <= DOWN;
				end

				if (lvl3_To_lvl4_col) begin
					stage <= LVL4;

					xPos <= xPos;
					yPos <= 61;
					gravity <= DOWN;
				end
				else if (lvl3_To_lvl2_col) begin
					stage <= LVL2;

					xPos <= xPos;
					yPos <= 489;
					gravity <= UP;
				end
			end
			else if (stage == LVL4) begin
				if(gravity == DOWN && ~lvl4_col_down) begin
					yPos <= yPos + 2; // go down
				end
				else if (gravity == DOWN && up) begin
					gravity <= UP;
				end

				if (gravity == UP && ~lvl4_col_up) begin
					yPos <= yPos - 2; // go up
				end
				else if (gravity == UP && up) begin
					gravity <= DOWN;
				end

				if (right && left) begin
					xPos <= xPos;
				end
				else if (right && ~lvl4_col_right) begin
					xPos <= xPos + 2; // go right
				end
				else if (left && ~lvl4_col_left) begin
					xPos <= xPos - 2; // go left
				end

				if (lvl4Lava_col) begin
					if (~checkpointFlag) begin // Haven't reached the checkpoint
						stage <= LVL1;

						xPos <= 304;
						yPos <= 220;
					end
					else begin // Reached the checkpoint
						stage <= LVL5;

						xPos <= 695;
						yPos <= 307;
					end

					gravity <= DOWN;
				end

				if (lvl4_To_lvl5_col) begin
					stage <= LVL5;

					xPos <= 170;
					yPos <= yPos;
				end
				else if (lvl4_To_lvl3_col) begin
					stage <= LVL3;

					xPos <= xPos;
					yPos <= 489;
					gravity <= UP;
				end
			end
			else if (stage == LVL5) begin
				if(gravity == DOWN && ~lvl5_col_down) begin
					yPos <= yPos + 2; // go down
				end
				else if (gravity == DOWN && up) begin
					gravity <= UP;
				end

				if (gravity == UP && ~lvl5_col_up) begin
					yPos <= yPos - 2; // go up
				end
				else if (gravity == UP && up) begin
					gravity <= DOWN;
				end

				if (right && left) begin
					xPos <= xPos;
				end
				else if (right && ~lvl5_col_right) begin
					xPos <= xPos + 2; // go right
				end
				else if (left && ~lvl5_col_left) begin
					xPos <= xPos - 2; // go left
				end

				if (lvl5Lava_col) begin
					if (~checkpointFlag) begin // Haven't reached the checkpoint
						stage <= LVL1;

						xPos <= 304;
						yPos <= 220;
					end
					else begin // Reached the checkpoint
						stage <= LVL5;

						xPos <= 695;
						yPos <= 307;
					end

					gravity <= DOWN;
				end

				if (lvl5_To_lvl6_col) begin
					stage <= LVL6;

					xPos <= xPos;
					yPos <= 489;
					gravity <= UP;
				end
				else if (lvl5_To_lvl4_col) begin
					stage <= LVL4;

					xPos <= 758;
					yPos <= yPos;
				end
				else if (checkpointLoc_col) begin
					checkpointFlag <= 1;
				end
			end
			else if (stage == LVL6) begin
				if(gravity == DOWN && ~lvl6_col_down) begin
					yPos <= yPos + 2; // go down
				end
				else if (gravity == DOWN && up) begin
					gravity <= UP;
				end

				if (gravity == UP && ~lvl6_col_up) begin
					yPos <= yPos - 2; // go up
				end
				else if (gravity == UP && up) begin
					gravity <= DOWN;
				end

				if (right && left) begin
					xPos <= xPos;
				end
				else if (right && ~lvl6_col_right) begin
					xPos <= xPos + 2; // go right
				end
				else if (left && ~lvl6_col_left) begin
					xPos <= xPos - 2; // go left
				end

				if (lvl6Lava_col) begin
					if (~checkpointFlag) begin // Haven't reached the checkpoint
						stage <= LVL1;

						xPos <= 304;
						yPos <= 220;
					end
					else begin // Reached the checkpoint
						stage <= LVL5;

						xPos <= 695;
						yPos <= 307;
					end

					gravity <= DOWN;
				end

				if (lvl6_To_lvl7_col) begin
					stage <= LVL7;

					xPos <= xPos;
					yPos <= 489;
					gravity <= UP;
				end
				else if (lvl6_To_lvl5_col) begin
					stage <= LVL5;

					xPos <= xPos;
					yPos <= 61;
					gravity <= DOWN;
				end
			end
			else if (stage == LVL7) begin
				if(gravity == DOWN && ~lvl7_col_down) begin
					yPos <= yPos + 2; // go down
				end
				else if (gravity == DOWN && up) begin
					gravity <= UP;
				end

				if (gravity == UP && ~lvl7_col_up) begin
					yPos <= yPos - 2; // go up
				end
				else if (gravity == UP && up) begin
					gravity <= DOWN;
				end

				if (right && left) begin
					xPos <= xPos;
				end
				else if (right && ~lvl7_col_right) begin
					xPos <= xPos + 2; // go right
				end
				else if (left && ~lvl7_col_left) begin
					xPos <= xPos - 2; // go left
				end

				if (lvl7Lava_col) begin
					if (~checkpointFlag) begin // Haven't reached the checkpoint
						stage <= LVL1;

						xPos <= 304;
						yPos <= 220;
					end
					else begin // Reached the checkpoint
						stage <= LVL5;

						xPos <= 695;
						yPos <= 307;
					end

					gravity <= DOWN;
				end

				if (lvl7_To_lvl2_col) begin
					stage <= LVL2;

					xPos <= 758;
					yPos <= yPos;
				end
				else if (lvl7_To_lvl6_col) begin
					stage <= LVL6;

					xPos <= xPos;
					yPos <= 61;
					gravity <= DOWN;
				end
			end
			else if (stage == LVL8) begin
				if(gravity == DOWN && ~lvl8_col_down) begin
					yPos <= yPos + 2; // go down
				end
				else if (gravity == DOWN && up) begin
					gravity <= UP;
				end

				if (gravity == UP && ~lvl8_col_up) begin
					yPos <= yPos - 2; // go up
				end
				else if (gravity == UP && up) begin
					gravity <= DOWN;
				end

				if (right && left) begin
					xPos <= xPos;
				end
				else if (right && ~lvl8_col_right) begin
					xPos <= xPos + 2; // go right
				end
				else if (left && ~lvl8_col_left) begin
					xPos <= xPos - 2; // go left
				end

				if (lvl8Lava_col) begin
					if (~checkpointFlag) begin // Haven't reached the checkpoint
						stage <= LVL1;

						xPos <= 304;
						yPos <= 220;
					end
					else begin // Reached the checkpoint
						stage <= LVL5;

						xPos <= 695;
						yPos <= 307;
					end

					gravity <= DOWN;
				end

				if (lvl8_To_lvl2_col) begin
					stage <= LVL2;

					xPos <= xPos;
					yPos <= 61;
				end
				else if (victoryZone_col) begin
					stage <= WIN;

					xPos <= 464;
					yPos <= 275;
				end
			end
			else if (stage == WIN) begin
				if (up && down) 
					yPos <= yPos;
				else if (up && yPos >= 41) 
					yPos <= yPos - 2;
				else if (down && yPos <= 509)
					yPos <= yPos + 2;

				if (right && left)
					xPos <= xPos;
				else if (right && xPos <= 778)
					xPos <= xPos + 2;
				else if (left && xPos >= 150)
					xPos <= xPos - 2;
			end
		end
	end

endmodule