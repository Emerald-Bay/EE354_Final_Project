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

    assign lvl1Block1 = ((hCount >= 10'd144) && (hCount <= 10'd400) && ((vCount >= 10'd259) && (vCount <= 10'd515)) ? 1 : 0;
    assign lvl1Block2 = ((hCount >= 10'd144) && (hCount <= 10'd208) && ((vCount >= 10'd35) && (vCount <= 10'd258)) ? 1 : 0;
    assign lvl1Block3 = ((hCount >= 10'd209) && (hCount <= 10'd783) && ((vCount >= 10'd35) && (vCount <= 10'd155)) ? 1 : 0;
    assign lvl1Block4 = ((hCount >= 10'd639) && (hCount <= 10'd783) && ((vCount >= 10'd156) && (vCount <= 10'd203)) ? 1 : 0;
    assign lvl1Block5 = ((hCount >= 10'd703) && (hCount <= 10'd783) && ((vCount >= 10'd268) && (vCount <= 10'd427)) ? 1 : 0;
    assign lvl1Block6 = ((hCount >= 10'd561) && (hCount <= 10'd783) && ((vCount >= 10'd387) && (vCount <= 10'd515)) ? 1 : 0;

    assign lvl1Lava = ((hCount >= 10'd401) && (hCount <= 10'd560) && ((vCount >= 10'd387) && (vCount <= 10'd515)) ? 1 : 0;

    assign lvl1_To_lvl2 = ((hCount >= 10'd767) && (hCount <= 10'd783) && ((vCount >= 10'd204) && (vCount <= 10'd267)) ? 1 : 0;

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

    assign lvl1Block1 = ((hCount >= 10'd144) && (hCount <= 10'd400) && ((vCount >= 10'd227) && (vCount <= 10'd515)) ? 1 : 0;
    assign lvl1Block2 = ((hCount >= 10'd144) && (hCount <= 10'd400) && ((vCount >= 10'd35) && (vCount <= 10'd163)) ? 1 : 0;
    assign lvl1Block3 = ((hCount >= 10'd529) && (hCount <= 10'd656) && ((vCount >= 10'd35) && (vCount <= 10'd163)) ? 1 : 0;
    assign lvl1Block4 = ((hCount >= 10'd529) && (hCount <= 10'd656) && ((vCount >= 10'd227) && (vCount <= 10'd515)) ? 1 : 0;
    assign lvl1Block5 = ((hCount >= 10'd655) && (hCount <= 10'd783) && ((vCount >= 10'd268) && (vCount <= 10'd427)) ? 1 : 0;
    assign lvl1Block6 = ((hCount >= 10'd719) && (hCount <= 10'd783) && ((vCount >= 10'd35) && (vCount <= 10'd323)) ? 1 : 0;

    assign lvl2Lava = ((hCount >= 10'd401) && (hCount <= 10'd528) && ((vCount >= 10'd35) && (vCount <= 10'd67)) ? 1 : 0;

    assign lvl2_To_lvl1 = ((hCount >= 10'd144) && (hCount <= 10'd160) && ((vCount >= 10'd164) && (vCount <= 10'd226)) ? 1 : 0;
    assign lvl2_To_lvl3 = ((hCount >= 10'd401) && (hCount <= 10'd528) && ((vCount >= 10'd499) && (vCount <= 10'd515)) ? 1 : 0;
    assign lvl2_To_lvl7 = ((hCount >= 10'd767) && (hCount <= 10'd783) && ((vC10'd10'dount >= 10'd324) && (vCount <= 10'd387)) ? 1 : 0;
    assign lvl2_To_lvl8 = ((hCount >= 10'd657) && (hCount <= 10'd720) && ((vCount >= 10'd35) && (vCount <= 10'd51)) ? 1 : 0;

    //Level Three
    wire lvl3Block1; //left
    wire lvl3Block2; //right

    wire lvl3Lava;

    wire lvl3_To_lvl2;
    wire lvl3_To_lvl4;

    assign lvl3Block1 = ((hCount >= 10'd10'd144) && (hCount <= 10'd10'd400) && ((vCount >= 10'd10'd35) && (vCount <= 10'd10'd515)) ? 1 : 0;
    assign lvl3Block2 = ((hCount >= 10'd10'd529) && (hCount <= 10'd10'd783) && ((vCount >= 10'd10'd35) && (vCount <= 10'd10'd515)) ? 1 : 0;

    assign lvl3Lava = ((hCount >= 10'd10'd448) && (hCount <= 10'd10'd480) && ((vCount >= 10'd10'd355) && (vCount <= 10'd10'd467)) ? 1 : 0;

    assign lvl3_To_lvl2 = ((hCount >= 10'd10'd401) && (hCount <= 10'd10'd528) && ((vCount >= 10'd10'd35) && (vCount <= 10'd10'd51)) ? 1 : 0;
    assign lvl3_To_lvl4 = ((hCount >= 10'd10'd401) && (hCount <= 10'd10'd528) && ((vCount >= 10'd10'd499) && (vCount <= 10'd10'd515)) ? 1 : 0;

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

    assign lvl4Block1 = ((hCount >= 10'd272) && (hCount <= 10'd783) && ((vCount >= 10'd164) && (vCount <= 10'd275)) ? 1 : 0;
    assign lvl4Block2 = ((hCount >= 10'd144) && (hCount <= 10'd400) && ((vCount >= 10'd35) && (vCount <= 10'd99)) ? 1 : 0;
    assign lvl4Block3 = ((hCount >= 10'd144) && (hCount <= 10'd208) && ((vCount >= 10'd100) && (vCount <= 10'd515)) ? 1 : 0;
    assign lvl4Block4 = ((hCount >= 10'd209) && (hCount <= 10'd783) && ((vCount >= 10'd451) && (vCount <= 10'd515)) ? 1 : 0;
    assign lvl4Block5 = ((hCount >= 10'd529) && (hCount <= 10'd783) && ((vCount >= 10'd35) && (vCount <= 10'd163)) ? 1 : 0;
    assign lvl4Block6 = ((hCount >= 10'd719) && (hCount <= 10'd783) && ((vCount >= 10'd276) && (vCount <= 10'd387)) ? 1 : 0;

    assign lvl4Lava1 = ((hCount >= 10'd288) && (hCount <= 10'd384) && ((vCount >= 10'd434) && (vCount <= 10'd450)) ? 1 : 0;
    assign lvl4Lava2 = ((hCount >= 10'd400) && (hCount <= 10'd496) && ((vCount >= 10'd276) && (vCount <= 10'd291)) ? 1 : 0;
    assign lvl4Lava3 = ((hCount >= 10'd512) && (hCount <= 10'd608) && ((vCount >= 10'd434) && (vCount <= 10'd450)) ? 1 : 0;
    assign lvl4Lava4 = ((hCount >= 10'd624) && (hCount <= 10'd718) && ((vCount >= 10'd276) && (vCount <= 10'd291)) ? 1 : 0;

    assign lvl4_To_lvl3 = ((hCount >= 10'd401) && (hCount <= 10'd528) && ((vCount >= 10'd35) && (vCount <= 10'd51)) ? 1 : 0;
    assign lvl4_To_lvl5 = ((hCount >= 10'd401) && (hCount <= 10'd528) && ((vCount >= 10'd387) && (vCount <= 10'd514)) ? 1 : 0;

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

    assign lvl5Block1 = ((hCount >= 10'd144) && (hCount <= 10'd336) && ((vCount >= 10'd35) && (vCount <= 10'd386)) ? 1 : 0;
    assign lvl5Block2 = ((hCount >= 10'd337) && (hCount <= 10'd400) && ((vCount >= 10'd35) && (vCount <= 10'd354)) ? 1 : 0;
    assign lvl5Block3 = ((hCount >= 10'd401) && (hCount <= 10'd464) && ((vCount >= 10'd35) && (vCount <= 10'd322)) ? 1 : 0;
    assign lvl5Block4 = ((hCount >= 10'd465) && (hCount <= 10'd528) && ((vCount >= 10'd35) && (vCount <= 10'd290)) ? 1 : 0;
    assign lvl5Block5 = ((hCount >= 10'd529) && (hCount <= 10'd656) && ((vCount >= 10'd35) && (vCount <= 10'd258)) ? 1 : 0;
    assign lvl5Block6 = ((hCount >= 10'd721) && (hCount <= 10'd783) && ((vCount >= 10'd35) && (vCount <= 10'd450)) ? 1 : 0;
    assign lvl5Block7 = ((hCount >= 10'd592) && (hCount <= 10'd720) && ((vCount >= 10'd323) && (vCount <= 10'd450)) ? 1 : 0;
    assign lvl5Block8 = ((hCount >= 10'd144) && (hCount <= 10'd783) && ((vCount >= 10'd451) && (vCount <= 10'd515)) ? 1 : 0;

    assign lvl5Lava1 = ((hCount >= 10'd337) && (hCount <= 10'd400) && ((vCount >= 10'd434) && (vCount <= 10'd450)) ? 1 : 0;
    assign lvl5Lava2 = ((hCount >= 10'd401) && (hCount <= 10'd464) && ((vCount >= 10'd418) && (vCount <= 10'd450)) ? 1 : 0;
    assign lvl5Lava3 = ((hCount >= 10'd465) && (hCount <= 10'd528) && ((vCount >= 10'd402) && (vCount <= 10'd450)) ? 1 : 0;
    assign lvl5Lava4 = ((hCount >= 10'd529) && (hCount <= 10'd591) && ((vCount >= 10'd386) && (vCount <= 10'd450)) ? 1 : 0;

    assign lvl5_To_lvl4 = ((hCount >= 10'd144) && (hCount <= 10'd160) && ((vCount >= 10'd387) && (vCount <= 10'd450)) ? 1 : 0;
    assign lvl5_To_lvl6 = ((hCount >= 10'd657) && (hCount <= 10'd720) && ((vCount >= 10'd35) && (vCount <= 10'd51)) ? 1 : 0;
    
    assign checkpointLoc = ((hCount >= 10'd687) && (hCount <= 10'd703) && ((vCount >= 10'd307) && (vCount <= 10'd322)) ? 1 : 0;

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

    assign lvl6Block1 = ((hCount >= 10'd384) && (hCount <= 10'd576) && ((vCount >= 10'd147) && (vCount <= 10'd163)) ? 1 : 0;
    assign lvl6Block2 = ((hCount >= 10'd272) && (hCount <= 10'd400) && ((vCount >= 10'd324) && (vCount <= 10'd355)) ? 1 : 0;
    assign lvl6Block3 = ((hCount >= 10'd528) && (hCount <= 10'd656) && ((vCount >= 10'd419) && (vCount <= 10'd450)) ? 1 : 0;
    assign lvl6Block4 = ((hCount >= 10'd209) && (hCount <= 10'd656) && ((vCount >= 10'd451) && (vCount <= 10'd515)) ? 1 : 0;
    assign lvl6Block5 = ((hCount >= 10'd144) && (hCount <= 10'd208) && ((vCount >= 10'd35) && (vCount <= 10'd515)) ? 1 : 0;
    assign lvl6Block6 = ((hCount >= 10'd209) && (hCount <= 10'd656) && ((vCount >= 10'd35) && (vCount <= 10'd99)) ? 1 : 0;
    assign lvl6Block7 = ((hCount >= 10'd719) && (hCount <= 10'd783) && ((vCount >= 10'd35) && (vCount <= 10'd515)) ? 1 : 0;
    assign lvl6Block8 = ((hCount >= 10'd272) && (hCount <= 10'd718) && ((vCount >= 10'd227) && (vCount <= 10'd323)) ? 1 : 0;

    assign lvl6Lava1 = ((hCount >= 10'd528) && (hCount <= 10'd656) && ((vCount >= 10'd434) && (vCount <= 10'd449)) ? 1 : 0;
    assign lvl6Lava2 = ((hCount >= 10'd272) && (hCount <= 10'd400) && ((vCount >= 10'd356) && (vCount <= 10'd371)) ? 1 : 0;
    assign lvl6Lava3 = ((hCount >= 10'd432) && (hCount <= 10'd528) && ((vCount >= 10'd211) && (vCount <= 10'd226)) ? 1 : 0;
    assign lvl6Lava4 = ((hCount >= 10'd336) && (hCount <= 10'd624) && ((vCount >= 10'd100) && (vCount <= 10'd115)) ? 1 : 0;

    assign lvl6_To_lvl5 = ((hCount >= 10'd657) && (hCount <= 10'd718) && ((vCount >= 10'd499) && (vCount <= 10'd515)) ? 1 : 0;
    assign lvl6_To_lvl7 = ((hCount >= 10'd657) && (hCount <= 10'd718) && ((vCount >= 10'd35) && (vCount <= 10'd51)) ? 1 : 0;

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

    assign lvl7Block1 = ((hCount >= 10'd608) && (hCount <= 10'd720) && ((vCount >= 10'd275) && (vCount <= 10'd339)) ? 1 : 0;
    assign lvl7Block2 = ((hCount >= 10'd432) && (hCount <= 10'd544) && ((vCount >= 10'd244) && (vCount <= 10'd259)) ? 1 : 0;
    assign lvl7Block3 = ((hCount >= 10'd481) && (hCount <= 10'd496) && ((vCount >= 10'd100) && (vCount <= 10'd243)) ? 1 : 0;
    assign lvl7Block4 = ((hCount >= 10'd144) && (hCount <= 10'd208) && ((vCount >= 10'd386) && (vCount <= 10'd450)) ? 1 : 0;
    assign lvl7Block5 = ((hCount >= 10'd241) && (hCount <= 10'd368) && ((vCount >= 10'd100) && (vCount <= 10'd163)) ? 1 : 0;
    assign lvl7Block6 = ((hCount >= 10'd144) && (hCount <= 10'd176) && ((vCount >= 10'd100) && (vCount <= 10'd323)) ? 1 : 0;
    assign lvl7Block7 = ((hCount >= 10'd144) && (hCount <= 10'd720) && ((vCount >= 10'd35) && (vCount <= 10'd99)) ? 1 : 0;
    assign lvl7Block8 = ((hCount >= 10'd721) && (hCount <= 10'd783) && ((vCount >= 10'd35) && (vCount <= 10'd515)) ? 1 : 0;
    assign lvl7Block9 = ((hCount >= 10'd144) && (hCount <= 10'd656) && ((vCount >= 10'd451) && (vCount <= 10'd515)) ? 1 : 0;

    assign lvl7Lava1 = ((hCount >= 10'd209) && (hCount <= 10'd656) && ((vCount >= 10'd418) && (vCount <= 10'd450)) ? 1 : 0;
    assign lvl7Lava2 = ((hCount >= 10'd177) && (hCount <= 10'd240) && ((vCount >= 10'd100) && (vCount <= 10'd131)) ? 1 : 0;
    assign lvl7Lava3 = ((hCount >= 10'd369) && (hCount <= 10'd480) && ((vCount >= 10'd100) && (vCount <= 10'd131)) ? 1 : 0;
    assign lvl7Lava4 = ((hCount >= 10'd497) && (hCount <= 10'd720) && ((vCount >= 10'd100) && (vCount <= 10'd131)) ? 1 : 0;

    assign lvl7_To_lvl6 = ((hCount >= 10'd657) && (hCount <= 10'd720) && ((vCount >= 10'd499) && (vCount <= 10'd515)) ? 1 : 0;
    assign lvl7_To_lvl2 = ((hCount >= 10'd144) && (hCount <= 10'd160) && ((vCount >= 10'd323) && (vCount <= 10'd385)) ? 1 : 0;

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

    assign lvl7Block1 = ((hCount >= 10'd209) && (hCount <= 10'd272) && ((vCount >= 10'd35) && (vCount <= 10'd291)) ? 1 : 0;
    assign lvl7Block2 = ((hCount >= 10'd144) && (hCount <= 10'd208) && ((vCount >= 10'd35) && (vCount <= 10'd387)) ? 1 : 0;
    assign lvl7Block3 = ((hCount >= 10'd273) && (hCount <= 10'd624) && ((vCount >= 10'd35) && (vCount <= 10'd179)) ? 1 : 0;
    assign lvl7Block4 = ((hCount >= 10'd625) && (hCount <= 10'd720) && ((vCount >= 10'd35) && (vCount <= 10'd387)) ? 1 : 0;
    assign lvl7Block5 = ((hCount >= 10'd721) && (hCount <= 10'd783) && ((vCount >= 10'd35) && (vCount <= 10'd515)) ? 1 : 0;
    assign lvl7Block6 = ((hCount >= 10'd144) && (hCount <= 10'd656) && ((vCount >= 10'd387) && (vCount <= 10'd515)) ? 1 : 0;

    assign lvl7Block7 = ((hCount >= 10'd273) && (hCount <= 10'd288) && ((vCount >= 10'd180) && (vCount <= 10'd275)) ? 1 : 0; // left pillars
    assign lvl7Block8 = ((hCount >= 10'd289) && (hCount <= 10'd304) && ((vCount >= 10'd180) && (vCount <= 10'd259)) ? 1 : 0;
    assign lvl7Block9 = ((hCount >= 10'd305) && (hCount <= 10'd320) && ((vCount >= 10'd180) && (vCount <= 10'd243)) ? 1 : 0;
    assign lvl7Block10 = ((hCount >= 10'd321) && (hCount <= 10'd336) && ((vCount >= 10'd180) && (vCount <= 10'd227)) ? 1 : 0;
    assign lvl7Block11 = ((hCount >= 10'd337) && (hCount <= 10'd352) && ((vCount >= 10'd180) && (vCount <= 10'd211)) ? 1 : 0;
    assign lvl7Block12 = ((hCount >= 10'd353) && (hCount <= 10'd368) && ((vCount >= 10'd180) && (vCount <= 10'd195)) ? 1 : 0;

    assign lvl7Block13 = ((hCount >= 10'd529) && (hCount <= 10'd544) && ((vCount >= 10'd180) && (vCount <= 10'd195)) ? 1 : 0; // right pillars
    assign lvl7Block14 = ((hCount >= 10'd545) && (hCount <= 10'd560) && ((vCount >= 10'd180) && (vCount <= 10'd211)) ? 1 : 0;
    assign lvl7Block15 = ((hCount >= 10'd561) && (hCount <= 10'd576) && ((vCount >= 10'd180) && (vCount <= 10'd227)) ? 1 : 0;
    assign lvl7Block16 = ((hCount >= 10'd577) && (hCount <= 10'd592) && ((vCount >= 10'd180) && (vCount <= 10'd243)) ? 1 : 0;
    assign lvl7Block17 = ((hCount >= 10'd593) && (hCount <= 10'd608) && ((vCount >= 10'd180) && (vCount <= 10'd259)) ? 1 : 0;
    assign lvl7Block18 = ((hCount >= 10'd609) && (hCount <= 10'd719) && ((vCount >= 10'd180) && (vCount <= 10'd275)) ? 1 : 0;

    assign lvl7Block19 = ((hCount >= 10'd321) && (hCount <= 10'd336) && ((vCount >= 10'd370) && (vCount <= 10'd386)) ? 1 : 0; // middle pillars
    assign lvl7Block20 = ((hCount >= 10'd337) && (hCount <= 10'd352) && ((vCount >= 10'd354) && (vCount <= 10'd386)) ? 1 : 0;
    assign lvl7Block21 = ((hCount >= 10'd353) && (hCount <= 10'd368) && ((vCount >= 10'd338) && (vCount <= 10'd386)) ? 1 : 0;
    assign lvl7Block22 = ((hCount >= 10'd369) && (hCount <= 10'd384) && ((vCount >= 10'd322) && (vCount <= 10'd386)) ? 1 : 0;
    assign lvl7Block23 = ((hCount >= 10'd385) && (hCount <= 10'd400) && ((vCount >= 10'd306) && (vCount <= 10'd386)) ? 1 : 0;
    assign lvl7Block24 = ((hCount >= 10'd401) && (hCount <= 10'd416) && ((vCount >= 10'd290) && (vCount <= 10'd386)) ? 1 : 0;
    assign lvl7Block25 = ((hCount >= 10'd417) && (hCount <= 10'd432) && ((vCount >= 10'd274) && (vCount <= 10'd386)) ? 1 : 0;
    assign lvl7Block26 = ((hCount >= 10'd433) && (hCount <= 10'd464) && ((vCount >= 10'd258) && (vCount <= 10'd386)) ? 1 : 0; // mid
    assign lvl7Block27 = ((hCount >= 10'd465) && (hCount <= 10'd480) && ((vCount >= 10'd274) && (vCount <= 10'd386)) ? 1 : 0;
    assign lvl7Block28 = ((hCount >= 10'd481) && (hCount <= 10'd496) && ((vCount >= 10'd290) && (vCount <= 10'd386)) ? 1 : 0;
    assign lvl7Block29 = ((hCount >= 10'd497) && (hCount <= 10'd512) && ((vCount >= 10'd306) && (vCount <= 10'd386)) ? 1 : 0;
    assign lvl7Block30 = ((hCount >= 10'd513) && (hCount <= 10'd528) && ((vCount >= 10'd322) && (vCount <= 10'd386)) ? 1 : 0;
    assign lvl7Block31 = ((hCount >= 10'd529) && (hCount <= 10'd544) && ((vCount >= 10'd338) && (vCount <= 10'd386)) ? 1 : 0;
    assign lvl7Block32 = ((hCount >= 10'd545) && (hCount <= 10'd560) && ((vCount >= 10'd354) && (vCount <= 10'd386)) ? 1 : 0;
    assign lvl7Block33 = ((hCount >= 10'd561) && (hCount <= 10'd576) && ((vCount >= 10'd370) && (vCount <= 10'd386)) ? 1 : 0;

    assign lvl7Lava1 = ((hCount >= 10'd273) && (hCount <= 10'd288) && ((vCount >= 10'd276) && (vCount <= 10'd291)) ? 1 : 0; //left lava
    assign lvl7Lava2 = ((hCount >= 10'd289) && (hCount <= 10'd304) && ((vCount >= 10'd260) && (vCount <= 10'd275)) ? 1 : 0;
    assign lvl7Lava3 = ((hCount >= 10'd305) && (hCount <= 10'd320) && ((vCount >= 10'd244) && (vCount <= 10'd259)) ? 1 : 0;
    assign lvl7Lava4 = ((hCount >= 10'd321) && (hCount <= 10'd336) && ((vCount >= 10'd228) && (vCount <= 10'd243)) ? 1 : 0;
    assign lvl7Lava5 = ((hCount >= 10'd337) && (hCount <= 10'd352) && ((vCount >= 10'd212) && (vCount <= 10'd227)) ? 1 : 0;
    assign lvl7Lava6 = ((hCount >= 10'd353) && (hCount <= 10'd368) && ((vCount >= 10'd196) && (vCount <= 10'd211)) ? 1 : 0;
    assign lvl7Lava7 = ((hCount >= 10'd369) && (hCount <= 10'd384) && ((vCount >= 10'd180) && (vCount <= 10'd195)) ? 1 : 0;

    assign lvl7Lava8 = ((hCount >= 10'd513) && (hCount <= 10'd528) && ((vCount >= 10'd180) && (vCount <= 10'd195)) ? 1 : 0; // right lava
    assign lvl7Lava9 = ((hCount >= 10'd529) && (hCount <= 10'd544) && ((vCount >= 10'd196) && (vCount <= 10'd211)) ? 1 : 0;
    assign lvl7Lava10 = ((hCount >= 10'd545) && (hCount <= 10'd560) && ((vCount >= 10'd212) && (vCount <= 10'd227)) ? 1 : 0;
    assign lvl7Lava11 = ((hCount >= 10'd561) && (hCount <= 10'd576) && ((vCount >= 10'd228) && (vCount <= 10'd243)) ? 1 : 0;
    assign lvl7Lava12 = ((hCount >= 10'd577) && (hCount <= 10'd592) && ((vCount >= 10'd244) && (vCount <= 10'd259)) ? 1 : 0;
    assign lvl7Lava13 = ((hCount >= 10'd593) && (hCount <= 10'd608) && ((vCount >= 10'd260) && (vCount <= 10'd275)) ? 1 : 0;
    assign lvl7Lava14 = ((hCount >= 10'd609) && (hCount <= 10'd719) && ((vCount >= 10'd276) && (vCount <= 10'd291)) ? 1 : 0;

    assign lvl7Lava15 = ((hCount >= 10'd305) && (hCount <= 10'd320) && ((vCount >= 10'd370) && (vCount <= 10'd386)) ? 1 : 0; // middle lava
    assign lvl7Lava16 = ((hCount >= 10'd321) && (hCount <= 10'd336) && ((vCount >= 10'd354) && (vCount <= 10'd369)) ? 1 : 0;
    assign lvl7Lava17 = ((hCount >= 10'd337) && (hCount <= 10'd352) && ((vCount >= 10'd338) && (vCount <= 10'd353)) ? 1 : 0;
    assign lvl7Lava18 = ((hCount >= 10'd353) && (hCount <= 10'd368) && ((vCount >= 10'd322) && (vCount <= 10'd337)) ? 1 : 0;
    assign lvl7Lava19 = ((hCount >= 10'd369) && (hCount <= 10'd384) && ((vCount >= 10'd306) && (vCount <= 10'd321)) ? 1 : 0;
    assign lvl7Lava20 = ((hCount >= 10'd385) && (hCount <= 10'd400) && ((vCount >= 10'd290) && (vCount <= 10'd305)) ? 1 : 0;
    assign lvl7Lava21 = ((hCount >= 10'd401) && (hCount <= 10'd416) && ((vCount >= 10'd274) && (vCount <= 10'd289)) ? 1 : 0;
    assign lvl7Lava22 = ((hCount >= 10'd417) && (hCount <= 10'd432) && ((vCount >= 10'd258) && (vCount <= 10'd273)) ? 1 : 0;
    assign lvl7Lava23 = ((hCount >= 10'd433) && (hCount <= 10'd464) && ((vCount >= 10'd242) && (vCount <= 10'd257)) ? 1 : 0; // mid
    assign lvl7Lava24 = ((hCount >= 10'd465) && (hCount <= 10'd480) && ((vCount >= 10'd258) && (vCount <= 10'd273)) ? 1 : 0;
    assign lvl7Lava25 = ((hCount >= 10'd481) && (hCount <= 10'd496) && ((vCount >= 10'd274) && (vCount <= 10'd289)) ? 1 : 0;
    assign lvl7Lava26 = ((hCount >= 10'd497) && (hCount <= 10'd512) && ((vCount >= 10'd290) && (vCount <= 10'd305)) ? 1 : 0;
    assign lvl7Lava27 = ((hCount >= 10'd513) && (hCount <= 10'd528) && ((vCount >= 10'd306) && (vCount <= 10'd321)) ? 1 : 0;
    assign lvl7Lava28 = ((hCount >= 10'd529) && (hCount <= 10'd544) && ((vCount >= 10'd322) && (vCount <= 10'd337)) ? 1 : 0;
    assign lvl7Lava29 = ((hCount >= 10'd545) && (hCount <= 10'd560) && ((vCount >= 10'd338) && (vCount <= 10'd353)) ? 1 : 0;
    assign lvl7Lava30 = ((hCount >= 10'd561) && (hCount <= 10'd576) && ((vCount >= 10'd354) && (vCount <= 10'd369)) ? 1 : 0;
    assign lvl7Lava31 = ((hCount >= 10'd577) && (hCount <= 10'd592) && ((vCount >= 10'd370) && (vCount <= 10'd386)) ? 1 : 0;

    assign lvl8_To_lvl2 = ((hCount >= 10'd657) && (hCount <= 10'd720) && ((vCount >= 10'd499) && (vCount <= 10'd515)) ? 1 : 0;

    assign victoryZone = ((hCount >= 10'd272) && (hCount <= 10'd288) && ((vCount >= 10'd371) && (vCount <= 10'd386)) ? 1 : 0;
