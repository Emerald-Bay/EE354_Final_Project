`timescale 1ns / 1ps

module block_controller(
	input clk, //this clock must be a slow enough clock to view the changing positions of the objects
	input clock,
	input bright,
	input rst,
	input flip, input left, input right,
	input [9:0] hCount, vCount,
	output reg [11:0] rgb,
	output reg [11:0] background
	);
	wire block_fill;
	wire goodblock_fill;
	
	//these two values dictate the center of the block, incrementing and decrementing them leads the block to move in certain directions
	reg [9:0] xpos, ypos;
	
	wire redZone;
	
	parameter RED    = 12'b1111_0000_0000; //Lava color
	parameter BLACK  = 12'b0000_0000_0000; //Platform Color
	parameter GREEN  = 12'b0000_0000_1111; //Level-Transistion Color
	parameter BLUE   = 12'b0000_1111_0000; //Character Color
	parameter YELLOW = 12'b1111_1111_0000; //Goal Color
	parameter CYAN   = 12'b0000_1111_1111; //Checkpoint Color

	//All Platform, Lava, Transistions, Etc. Objects - Level 1 through 8
	//Level One
	wire lvl1Block1; //down and left
	wire lvl1Block2; //left
	wire lvl1Block3; //up
	wire lvl1Block4; //up and right
	wire lvl1Block5; //down and right
	wire lvl1Block6; //down

	wire lvl1Lava;

	wire lvl1_To_lvl2;

	assign lvl1Block1 = ((hCount >= 144) && (hCount <= 400) && ((vCount >= 259) && (vCount <= 515));
	assign lvl1Block2 = ((hCount >= 144) && (hCount <= 208) && ((vCount >= 35) && (vCount <= 258));
	assign lvl1Block3 = ((hCount >= 209) && (hCount <= 783) && ((vCount >= 35) && (vCount <= 155));
	assign lvl1Block4 = ((hCount >= 639) && (hCount <= 783) && ((vCount >= 156) && (vCount <= 203));
	assign lvl1Block5 = ((hCount >= 703) && (hCount <= 783) && ((vCount >= 268) && (vCount <= 427));
	assign lvl1Block6 = ((hCount >= 561) && (hCount <= 783) && ((vCount >= 387) && (vCount <= 515));

	assign lvl1Lava = ((hCount >= 401) && (hCount <= 560) && ((vCount >= 387) && (vCount <= 515));

	assign lvl1_To_lvl2 = ((hCount >= 767) && (hCount <= 783) && ((vCount >= 204) && (vCount <= 267));

	//Level Two
	wire lvl2Block1; //down and left
	wire lvl2Block2; //up and left
	wire lvl2Block3; //up and left and right
	wire lvl2Block4; //up and left and right
	wire lvl2Block5; //down
	wire lvl2Block6; //up and right

	wire lvl2Lava;

	wire lvl2_To_lvl1;
	wire lvl2_To_lvl3;
	wire lvl2_To_lvl7;
	wire lvl2_To_lvl8;

	assign lvl1Block1 = ((hCount >= 144) && (hCount <= 400) && ((vCount >= 227) && (vCount <= 515));
	assign lvl1Block2 = ((hCount >= 144) && (hCount <= 400) && ((vCount >= 35) && (vCount <= 163));
	assign lvl1Block3 = ((hCount >= 529) && (hCount <= 656) && ((vCount >= 35) && (vCount <= 163));
	assign lvl1Block4 = ((hCount >= 529) && (hCount <= 656) && ((vCount >= 227) && (vCount <= 515));
	assign lvl1Block5 = ((hCount >= 655) && (hCount <= 783) && ((vCount >= 268) && (vCount <= 427));
	assign lvl1Block6 = ((hCount >= 719) && (hCount <= 783) && ((vCount >= 35) && (vCount <= 323));

	assign lvl2Lava = ((hCount >= 401) && (hCount <= 528) && ((vCount >= 35) && (vCount <= 67));

	assign lvl2_To_lvl1 = ((hCount >= 144) && (hCount <= 160) && ((vCount >= 164) && (vCount <= 226));
	assign lvl2_To_lvl3 = ((hCount >= 401) && (hCount <= 528) && ((vCount >= 499) && (vCount <= 515));
	assign lvl2_To_lvl7 = ((hCount >= 767) && (hCount <= 783) && ((vCount >= 324) && (vCount <= 387));
	assign lvl2_To_lvl8 = ((hCount >= 657) && (hCount <= 720) && ((vCount >= 35) && (vCount <= 51));

	//Level Three
	wire lvl3Block1; //left
	wire lvl3Block2; //right

	wire lvl3Lava;

	wire lvl3_To_lvl2;
	wire lvl3_To_lvl4;

	assign lvl3Block1 = ((hCount >= 144) && (hCount <= 400) && ((vCount >= 35) && (vCount <= 515));
	assign lvl3Block2 = ((hCount >= 529) && (hCount <= 783) && ((vCount >= 35) && (vCount <= 515));

	assign lvl3Lava = ((hCount >= 448) && (hCount <= 480) && ((vCount >= 355) && (vCount <= 467));

	assign lvl3_To_lvl2 = ((hCount >= 401) && (hCount <= 528) && ((vCount >= 35) && (vCount <= 51));
	assign lvl3_To_lvl4 = ((hCount >= 401) && (hCount <= 528) && ((vCount >= 499) && (vCount <= 515));

	//Level Four
	wire lvl4Block1; //up and down and right
	wire lvl4Block2; //up and left
	wire lvl4Block3; //left
	wire lvl4Block4; //down
	wire lvl4Block5; //right
	wire lvl4Block6; //up and right

	wire lvl4Lava1;
	wire lvl4Lava2;
	wire lvl4Lava3;
	wire lvl4Lava4;

	wire lvl4_To_lvl3;
	wire lvl4_To_lvl5;

	assign lvl4Block1 = ((hCount >= 272) && (hCount <= 783) && ((vCount >= 164) && (vCount <= 275));
	assign lvl4Block2 = ((hCount >= 144) && (hCount <= 400) && ((vCount >= 35) && (vCount <= 99));
	assign lvl4Block3 = ((hCount >= 144) && (hCount <= 208) && ((vCount >= 100) && (vCount <= 515));
	assign lvl4Block4 = ((hCount >= 209) && (hCount <= 783) && ((vCount >= 451) && (vCount <= 515));
	assign lvl4Block5 = ((hCount >= 529) && (hCount <= 783) && ((vCount >= 35) && (vCount <= 163));
	assign lvl4Block6 = ((hCount >= 719) && (hCount <= 783) && ((vCount >= 276) && (vCount <= 387));

	assign lvl4Lava1 = ((hCount >= 288) && (hCount <= 384) && ((vCount >= 434) && (vCount <= 450));
	assign lvl4Lava2 = ((hCount >= 400) && (hCount <= 496) && ((vCount >= 276) && (vCount <= 291));
	assign lvl4Lava3 = ((hCount >= 512) && (hCount <= 608) && ((vCount >= 434) && (vCount <= 450));
	assign lvl4Lava4 = ((hCount >= 624) && (hCount <= 718) && ((vCount >= 276) && (vCount <= 291));

	assign lvl4_To_lvl3 = ((hCount >= 401) && (hCount <= 528) && ((vCount >= 35) && (vCount <= 51));
	assign lvl4_To_lvl5 = ((hCount >= 401) && (hCount <= 528) && ((vCount >= 387) && (vCount <= 514));

	//Level Five
	wire lvl5Block1; //up and left
	wire lvl5Block2; //up and left
	wire lvl5Block3; //up and left
	wire lvl5Block4; //up and left
	wire lvl5Block5; //up and left
	wire lvl5Block6; //right
	wire lvl5Block7; //down and right
	wire lvl5Block8; //down

	wire lvl5Lava1;
	wire lvl5Lava2;
	wire lvl5Lava3;
	wire lvl5Lava4;

	wire lvl5_To_lvl4;
	wire lvl5_To_lvl6;

	wire checkpointLoc;

	assign lvl5Block1 = ((hCount >= 144) && (hCount <= 336) && ((vCount >= 35) && (vCount <= 386));
	assign lvl5Block2 = ((hCount >= 337) && (hCount <= 400) && ((vCount >= 35) && (vCount <= 354));
	assign lvl5Block3 = ((hCount >= 401) && (hCount <= 464) && ((vCount >= 35) && (vCount <= 322));
	assign lvl5Block4 = ((hCount >= 465) && (hCount <= 528) && ((vCount >= 35) && (vCount <= 290));
	assign lvl5Block5 = ((hCount >= 529) && (hCount <= 656) && ((vCount >= 35) && (vCount <= 258));
	assign lvl5Block6 = ((hCount >= 721) && (hCount <= 783) && ((vCount >= 35) && (vCount <= 450));
	assign lvl5Block7 = ((hCount >= 592) && (hCount <= 720) && ((vCount >= 323) && (vCount <= 450));
	assign lvl5Block8 = ((hCount >= 144) && (hCount <= 783) && ((vCount >= 451) && (vCount <= 515));

	assign lvl5Lava1 = ((hCount >= 337) && (hCount <= 400) && ((vCount >= 434) && (vCount <= 450));
	assign lvl5Lava2 = ((hCount >= 401) && (hCount <= 464) && ((vCount >= 418) && (vCount <= 450));
	assign lvl5Lava3 = ((hCount >= 465) && (hCount <= 528) && ((vCount >= 402) && (vCount <= 450));
	assign lvl5Lava4 = ((hCount >= 529) && (hCount <= 591) && ((vCount >= 386) && (vCount <= 450));

	assign lvl5_To_lvl4 = ((hCount >= 144) && (hCount <= 160) && ((vCount >= 387) && (vCount <= 450));
	assign lvl5_To_lvl6 = ((hCount >= 657) && (hCount <= 720) && ((vCount >= 35) && (vCount <= 51));
	
	assign checkpointLoc = ((hCount >= 687) && (hCount <= 703) && ((vCount >= 307) && (vCount <= 322));

	//Level 6
	wire lvl6Block1; //up and down and left and right
	wire lvl6Block2; //right and left
	wire lvl6Block3; //right and left
	wire lvl6Block4; //down and left
	wire lvl6Block5; //left
	wire lvl6Block6; //up and left
	wire lvl6Block7; //right
	wire lvl6Block8; //up and right

	wire lvl6Lava1;
	wire lvl6Lava2;
	wire lvl6Lava3;
	wire lvl6Lava4;

	wire lvl6_To_lvl5;
	wire lvl6_To_lvl7;

	assign lvl6Block1 = ((hCount >= 384) && (hCount <= 576) && ((vCount >= 147) && (vCount <= 163));
	assign lvl6Block2 = ((hCount >= 272) && (hCount <= 400) && ((vCount >= 324) && (vCount <= 355));
	assign lvl6Block3 = ((hCount >= 528) && (hCount <= 656) && ((vCount >= 419) && (vCount <= 450));
	assign lvl6Block4 = ((hCount >= 209) && (hCount <= 656) && ((vCount >= 451) && (vCount <= 515));
	assign lvl6Block5 = ((hCount >= 144) && (hCount <= 208) && ((vCount >= 35) && (vCount <= 515));
	assign lvl6Block6 = ((hCount >= 209) && (hCount <= 656) && ((vCount >= 35) && (vCount <= 99));
	assign lvl6Block7 = ((hCount >= 719) && (hCount <= 783) && ((vCount >= 35) && (vCount <= 515));
	assign lvl6Block8 = ((hCount >= 272) && (hCount <= 718) && ((vCount >= 227) && (vCount <= 323));

	assign lvl6Lava1 = ((hCount >= 528) && (hCount <= 656) && ((vCount >= 434) && (vCount <= 449));
	assign lvl6Lava2 = ((hCount >= 272) && (hCount <= 400) && ((vCount >= 356) && (vCount <= 371));
	assign lvl6Lava3 = ((hCount >= 432) && (hCount <= 528) && ((vCount >= 211) && (vCount <= 226));
	assign lvl6Lava4 = ((hCount >= 336) && (hCount <= 624) && ((vCount >= 100) && (vCount <= 115));

	assign lvl6_To_lvl5 = ((hCount >= 657) && (hCount <= 718) && ((vCount >= 499) && (vCount <= 515));
	assign lvl6_To_lvl7 = ((hCount >= 657) && (hCount <= 718) && ((vCount >= 35) && (vCount <= 51));

	//Level 7
	wire lvl7Block1; //up and down and left
	wire lvl7Block2; //up and down and left and right
	wire lvl7Block3; //right and left
	wire lvl7Block4; //down and left
	wire lvl7Block5; //up and left and right
	wire lvl7Block6; //up and right
	wire lvl7Block7; //up
	wire lvl7Block8; //right
	wire lvl7Block9; //down and left

	wire lvl7Lava1;
	wire lvl7Lava2;
	wire lvl7Lava3;
	wire lvl7Lava4;

	wire lvl7_To_lvl6;
	wire lvl7_To_lvl2;

	assign lvl7Block1 = ((hCount >= 608) && (hCount <= 720) && ((vCount >= 275) && (vCount <= 339));
	assign lvl7Block2 = ((hCount >= 432) && (hCount <= 544) && ((vCount >= 244) && (vCount <= 259));
	assign lvl7Block3 = ((hCount >= 481) && (hCount <= 496) && ((vCount >= 100) && (vCount <= 243));
	assign lvl7Block4 = ((hCount >= 144) && (hCount <= 208) && ((vCount >= 386) && (vCount <= 450));
	assign lvl7Block5 = ((hCount >= 241) && (hCount <= 368) && ((vCount >= 100) && (vCount <= 163));
	assign lvl7Block6 = ((hCount >= 144) && (hCount <= 176) && ((vCount >= 100) && (vCount <= 323));
	assign lvl7Block7 = ((hCount >= 144) && (hCount <= 720) && ((vCount >= 35) && (vCount <= 99));
	assign lvl7Block8 = ((hCount >= 721) && (hCount <= 783) && ((vCount >= 35) && (vCount <= 515));
	assign lvl7Block9 = ((hCount >= 144) && (hCount <= 656) && ((vCount >= 451) && (vCount <= 515));

	assign lvl7Lava1 = ((hCount >= 209) && (hCount <= 656) && ((vCount >= 418) && (vCount <= 450));
	assign lvl7Lava2 = ((hCount >= 177) && (hCount <= 240) && ((vCount >= 100) && (vCount <= 131));
	assign lvl7Lava3 = ((hCount >= 369) && (hCount <= 480) && ((vCount >= 100) && (vCount <= 131));
	assign lvl7Lava4 = ((hCount >= 497) && (hCount <= 720) && ((vCount >= 100) && (vCount <= 131));

	assign lvl7_To_lvl6 = ((hCount >= 657) && (hCount <= 720) && ((vCount >= 499) && (vCount <= 515));
	assign lvl7_To_lvl2 = ((hCount >= 144) && (hCount <= 160) && ((vCount >= 323) && (vCount <= 385));

	//Level 8
	wire lvl7Block1; //up and left
	wire lvl7Block2; //left
	wire lvl7Block3; //up
	wire lvl7Block4; //up and right
	wire lvl7Block5; //right
	wire lvl7Block6; //down and left

	wire lvl7Block7; //left pillars
	wire lvl7Block8;
	wire lvl7Block9;
	wire lvl7Block10;
	wire lvl7Block11;
	wire lvl7Block12;

	wire lvl7Block13; //right pillars
	wire lvl7Block14;
	wire lvl7Block15;
	wire lvl7Block16;
	wire lvl7Block17;
	wire lvl7Block18;

	wire lvl7Block19; //middle pillars
	wire lvl7Block20;
	wire lvl7Block21;
	wire lvl7Block22;
	wire lvl7Block23;
	wire lvl7Block24;
	wire lvl7Block25;
	wire lvl7Block26;
	wire lvl7Block27;
	wire lvl7Block28;
	wire lvl7Block29;
	wire lvl7Block30;
	wire lvl7Block31;
	wire lvl7Block32;
	wire lvl7Block33;

	wire lvl7Lava1; //left lava
	wire lvl7Lava2;
	wire lvl7Lava3;
	wire lvl7Lava4;
	wire lvl7Lava5;
	wire lvl7Lava6;
	wire lvl7Lava7;

	wire lvl7Lava8; //right lava
	wire lvl7Lava9;
	wire lvl7Lava10;
	wire lvl7Lava11;
	wire lvl7Lava12;
	wire lvl7Lava13;
	wire lvl7Lava14;

	wire lvl7Lava15; //middle lava
	wire lvl7Lava16;
	wire lvl7Lava17;
	wire lvl7Lava18;
	wire lvl7Lava19;
	wire lvl7Lava20;
	wire lvl7Lava21;
	wire lvl7Lava22;
	wire lvl7Lava23;
	wire lvl7Lava24;
	wire lvl7Lava25;
	wire lvl7Lava26;
	wire lvl7Lava27;
	wire lvl7Lava28;
	wire lvl7Lava29;
	wire lvl7Lava30;
	wire lvl7Lava31;

	wire lvl8_To_lvl2;

	wire victoryZone;

	assign lvl7Block1 = ((hCount >= 209) && (hCount <= 272) && ((vCount >= 35) && (vCount <= 291));
	assign lvl7Block2 = ((hCount >= 144) && (hCount <= 208) && ((vCount >= 35) && (vCount <= 387));
	assign lvl7Block3 = ((hCount >= 273) && (hCount <= 624) && ((vCount >= 35) && (vCount <= 179));
	assign lvl7Block4 = ((hCount >= 625) && (hCount <= 720) && ((vCount >= 35) && (vCount <= 387));
	assign lvl7Block5 = ((hCount >= 721) && (hCount <= 783) && ((vCount >= 35) && (vCount <= 515));
	assign lvl7Block6 = ((hCount >= 144) && (hCount <= 656) && ((vCount >= 387) && (vCount <= 515));

	assign lvl7Block7 = ((hCount >= 273) && (hCount <= 288) && ((vCount >= 180) && (vCount <= 275)); // left pillars
	assign lvl7Block8 = ((hCount >= 289) && (hCount <= 304) && ((vCount >= 180) && (vCount <= 259));
	assign lvl7Block9 = ((hCount >= 305) && (hCount <= 320) && ((vCount >= 180) && (vCount <= 243));
	assign lvl7Block10 = ((hCount >= 321) && (hCount <= 336) && ((vCount >= 180) && (vCount <= 227));
	assign lvl7Block11 = ((hCount >= 337) && (hCount <= 352) && ((vCount >= 180) && (vCount <= 211));
	assign lvl7Block12 = ((hCount >= 353) && (hCount <= 368) && ((vCount >= 180) && (vCount <= 195));

	assign lvl7Block13 = ((hCount >= 529) && (hCount <= 544) && ((vCount >= 180) && (vCount <= 195)); // right pillars
	assign lvl7Block14 = ((hCount >= 545) && (hCount <= 560) && ((vCount >= 180) && (vCount <= 211));
	assign lvl7Block15 = ((hCount >= 561) && (hCount <= 576) && ((vCount >= 180) && (vCount <= 227));
	assign lvl7Block16 = ((hCount >= 577) && (hCount <= 592) && ((vCount >= 180) && (vCount <= 243));
	assign lvl7Block17 = ((hCount >= 593) && (hCount <= 608) && ((vCount >= 180) && (vCount <= 259));
	assign lvl7Block18 = ((hCount >= 609) && (hCount <= 719) && ((vCount >= 180) && (vCount <= 275));

	assign lvl7Block19 = ((hCount >= 321) && (hCount <= 336) && ((vCount >= 370) && (vCount <= 386)); // middle pillars
	assign lvl7Block20 = ((hCount >= 337) && (hCount <= 352) && ((vCount >= 354) && (vCount <= 386));
	assign lvl7Block21 = ((hCount >= 353) && (hCount <= 368) && ((vCount >= 338) && (vCount <= 386));
	assign lvl7Block22 = ((hCount >= 369) && (hCount <= 384) && ((vCount >= 322) && (vCount <= 386));
	assign lvl7Block23 = ((hCount >= 385) && (hCount <= 400) && ((vCount >= 306) && (vCount <= 386));
	assign lvl7Block24 = ((hCount >= 401) && (hCount <= 416) && ((vCount >= 290) && (vCount <= 386));
	assign lvl7Block25 = ((hCount >= 417) && (hCount <= 432) && ((vCount >= 274) && (vCount <= 386));
	assign lvl7Block26 = ((hCount >= 433) && (hCount <= 464) && ((vCount >= 258) && (vCount <= 386)); // mid
	assign lvl7Block27 = ((hCount >= 465) && (hCount <= 480) && ((vCount >= 274) && (vCount <= 386));
	assign lvl7Block28 = ((hCount >= 481) && (hCount <= 496) && ((vCount >= 290) && (vCount <= 386));
	assign lvl7Block29 = ((hCount >= 497) && (hCount <= 512) && ((vCount >= 306) && (vCount <= 386));
	assign lvl7Block30 = ((hCount >= 513) && (hCount <= 528) && ((vCount >= 322) && (vCount <= 386));
	assign lvl7Block31 = ((hCount >= 529) && (hCount <= 544) && ((vCount >= 338) && (vCount <= 386));
	assign lvl7Block32 = ((hCount >= 545) && (hCount <= 560) && ((vCount >= 354) && (vCount <= 386));
	assign lvl7Block33 = ((hCount >= 561) && (hCount <= 576) && ((vCount >= 370) && (vCount <= 386));

	assign lvl7Lava1 = ((hCount >= 273) && (hCount <= 288) && ((vCount >= 276) && (vCount <= 291)); //left lava
	assign lvl7Lava2 = ((hCount >= 289) && (hCount <= 304) && ((vCount >= 260) && (vCount <= 275));
	assign lvl7Lava3 = ((hCount >= 305) && (hCount <= 320) && ((vCount >= 244) && (vCount <= 259));
	assign lvl7Lava4 = ((hCount >= 321) && (hCount <= 336) && ((vCount >= 228) && (vCount <= 243));
	assign lvl7Lava5 = ((hCount >= 337) && (hCount <= 352) && ((vCount >= 212) && (vCount <= 227));
	assign lvl7Lava6 = ((hCount >= 353) && (hCount <= 368) && ((vCount >= 196) && (vCount <= 211));
	assign lvl7Lava7 = ((hCount >= 369) && (hCount <= 384) && ((vCount >= 180) && (vCount <= 195));

	assign lvl7Lava8 = ((hCount >= 513) && (hCount <= 528) && ((vCount >= 180) && (vCount <= 195)); // right lava
	assign lvl7Lava9 = ((hCount >= 529) && (hCount <= 544) && ((vCount >= 196) && (vCount <= 211));
	assign lvl7Lava10 = ((hCount >= 545) && (hCount <= 560) && ((vCount >= 212) && (vCount <= 227));
	assign lvl7Lava11 = ((hCount >= 561) && (hCount <= 576) && ((vCount >= 228) && (vCount <= 243));
	assign lvl7Lava12 = ((hCount >= 577) && (hCount <= 592) && ((vCount >= 244) && (vCount <= 259));
	assign lvl7Lava13 = ((hCount >= 593) && (hCount <= 608) && ((vCount >= 260) && (vCount <= 275));
	assign lvl7Lava14 = ((hCount >= 609) && (hCount <= 719) && ((vCount >= 276) && (vCount <= 291));

	assign lvl7Lava15 = ((hCount >= 305) && (hCount <= 320) && ((vCount >= 370) && (vCount <= 386)); // middle lava
	assign lvl7Lava16 = ((hCount >= 321) && (hCount <= 336) && ((vCount >= 354) && (vCount <= 369));
	assign lvl7Lava17 = ((hCount >= 337) && (hCount <= 352) && ((vCount >= 338) && (vCount <= 353));
	assign lvl7Lava18 = ((hCount >= 353) && (hCount <= 368) && ((vCount >= 322) && (vCount <= 337));
	assign lvl7Lava19 = ((hCount >= 369) && (hCount <= 384) && ((vCount >= 306) && (vCount <= 321));
	assign lvl7Lava20 = ((hCount >= 385) && (hCount <= 400) && ((vCount >= 290) && (vCount <= 305));
	assign lvl7Lava21 = ((hCount >= 401) && (hCount <= 416) && ((vCount >= 274) && (vCount <= 289));
	assign lvl7Lava22 = ((hCount >= 417) && (hCount <= 432) && ((vCount >= 258) && (vCount <= 273));
	assign lvl7Lava23 = ((hCount >= 433) && (hCount <= 464) && ((vCount >= 242) && (vCount <= 257)); // mid
	assign lvl7Lava24 = ((hCount >= 465) && (hCount <= 480) && ((vCount >= 258) && (vCount <= 273));
	assign lvl7Lava25 = ((hCount >= 481) && (hCount <= 496) && ((vCount >= 274) && (vCount <= 289));
	assign lvl7Lava26 = ((hCount >= 497) && (hCount <= 512) && ((vCount >= 290) && (vCount <= 305));
	assign lvl7Lava27 = ((hCount >= 513) && (hCount <= 528) && ((vCount >= 306) && (vCount <= 321));
	assign lvl7Lava28 = ((hCount >= 529) && (hCount <= 544) && ((vCount >= 322) && (vCount <= 337));
	assign lvl7Lava29 = ((hCount >= 545) && (hCount <= 560) && ((vCount >= 338) && (vCount <= 353));
	assign lvl7Lava30 = ((hCount >= 561) && (hCount <= 576) && ((vCount >= 354) && (vCount <= 369));
	assign lvl7Lava31 = ((hCount >= 577) && (hCount <= 592) && ((vCount >= 370) && (vCount <= 386));

	assign lvl8_To_lvl2 = ((hCount >= 657) && (hCount <= 720) && ((vCount >= 499) && (vCount <= 515));

	assign victoryZone = ((hCount >= 272) && (hCount <= 288) && ((vCount >= 371) && (vCount <= 386));

	
	/*when outputting the rgb value in an always block like this, make sure to include the if(~bright) statement, as this ensures the monitor 
	will output some data to every pixel and not just the images you are trying to display*/
	always@ (*) begin
    	if(~bright)	//force black if not inside the display area
			rgb = BLACK;
		else if (block_fill) 
			rgb = RED;
		else if (goodblock_fill == 1)
			rgb = BLACK; // black box
		else if (redZone == 1)
			rgb = RED; // black box
		else
			rgb = background; // background colors
	end
		//the +-5 for the positions give the dimension of the block (i.e. it will be 10x10 pixels)
	assign block_fill=vCount>=(ypos-5) && vCount<=(ypos+5) && hCount>=(xpos-5) && hCount<=(xpos+5);

	assign goodblock_fill = (((hCount >= 10'd144) && (hCount <= 10'd416)) && ((vCount >= 10'd300) && (vCount <= 10'd475))) || (((hCount >= 10'd528) && (hCount <= 10'd784)) && ((vCount >= 10'd570) && (vCount <= 10'd650))) ? 1 : 0;
	assign redZone = ((hCount >= 10'd417) && (hCount <= 10'd527)) && ((vCount >= 10'd300) && (vCount <= 10'd475)) ? 1 : 0;

	
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
	
	//the background color reflects the most recent button press
	always@(posedge clk, posedge rst) begin
		if(rst)
			background <= 12'b1111_1111_1111;
		else 
			if(right)
				background <= 12'b1111_1111_0000;
			else if(left)
				background <= 12'b0000_1111_1111;
			else if(down)
				background <= 12'b0000_1111_0000;
			else if(up)
				background <= 12'b0000_0000_1111;
	end

	
	
endmodule
