
include <base.scad>

display_w    = 97.5;
display_h    = 59.0;
display_t    =  1.50; // Absenkung;
display_d    =  6.40; // Display Dicke
display_rand =  1.25;
display_x0   = 48.0;

module display_front() {
    translate([0, 0, display_t])
        cube([display_w, display_h, display_d]);
}

module display() {
    union() {
        translate([display_rand, display_rand, -delta])
            cube([display_w - 2 * display_rand,
                  display_h - 2 * display_rand,
                  display_t + 2*delta]);
        display_front();
    }
}

disp_marg_d  =  1.9;
disp_marg_dy =  2.5;
disp_marg_dx =  4.5;

module display_margin() {
    translate([display_x0 - disp_marg_dx,
               display_h,
               h0 + h1 - delta])
        cube([display_w + 2 * disp_marg_dx,
              ((height_0 - display_h) / 2 + disp_marg_dy),
              display_d + disp_marg_d - 3.5]);
}

display_haken_y      = 8;
display_haken_base_x = 3;
display_haken_base_z = 5;
display_haken_top_x  = 6;
display_haken_top_z  = 2;

module display_haken_rechts() {
    union() {
        cube([display_haken_base_x,
              display_haken_y, 
              display_haken_base_z]);
        translate([0, 0, 
                   display_haken_base_z -
                     display_haken_top_z])
            cube([display_haken_top_x,
                  display_haken_y,
                  display_haken_top_z]);
    }
}

module display_haken_links() {
    translate([display_haken_base_x, 0, 0])
        mirror([1, 0, 0])
            display_haken_rechts();
}

module display_haekchen() {
    y0 = (height_0 - display_h) / 2;
    
    translate([display_x0 - display_haken_base_x, 
               y0 + 2,
               h0 + h1 - 2 * delta])
    { 
        display_haken_links();
        //translate([0, display_h - 12, 0])
        //    display_haken_links();
        translate([display_w + display_haken_base_x, 0, 0])
            display_haken_rechts();
        //translate([display_w + display_haken_base_x,
        //           display_h - 12, 0])
        //    display_haken_rechts();
    }
}

mic_d0 = 20.0;
mic_h0 =  2.0;
mic_d1 = 16.0;
mic_h1 =  2.5;
mic_d2 = 25.0;

module mic() {
    translate([0, 0, -delta])
        cylinder(h = mic_h0 + 2*delta, d = mic_d0);
    translate([0, 0, mic_h0])
        cylinder(h = mic_h1 + delta, d = mic_d1);
    translate([0, 0, mic_h0 + mic_h1])
        cylinder(h = 10, d = mic_d2);
    // Text:
    text2(-mic_d2 * 0.75 - 2.0, mic_d2 * 0.1, "MIC",
          z = -2*delta);
}

taster_d0 = 12.25;

module taster() {
    translate([0, 0, -delta])
        cylinder(h = 10, d = taster_d0);
}

module ptt_taster() {
    taster();
    // Text:
    text2(-mic_d2 * 0.75 - 2.0, 1.3, "PTT", z=-2*delta);
}

onoff_d0 = 16.25;

module onoff() {
    translate([0, 0, -delta])
        cylinder(h = 10, d = onoff_d0);
}

phone_bu_d0 = 10.00;
phone_bu_h0 =  1.50;
phone_bu_d1 =  6.25;
phone_bu_h1 =  0.75;

module phone_bu() {
    translate([0, 0, - 2*delta])
        cylinder(h = phone_bu_h0, d = phone_bu_d0);
    translate([0, 0, phone_bu_h0 - 3*delta])
        cylinder(h = 15, d = phone_bu_d1);
}

phones_dx = 13.25;
phones_dy = 17.00;

module phones() {
    translate([phones_dx * 0.75, 7.0, 0])
        phone_bu();
    svg(-1, 6.5, "microphone.svg", z=-2*delta, 
        scale=0.035);
    translate([phones_dx * 1.75, 7.0, 0])
        phone_bu();
    svg(33, 6.5, "headphones.svg", z=-2*delta, scale=0.035);
    translate([0, 0, phone_bu_h0 + phone_bu_h1])
        cube([phones_dx * 2.5, phones_dy, 10]); 
}

module left_side() {
    x0 = 16.0;
    dx = 20.0;
    // Mic:
    translate([x0 + dx / 2,
               54.0,
               h0 - delta])
        mic();
    // PTT Taster:
    translate([x0 + dx / 2,
               16.0,
               h0 - delta])
        ptt_taster();
    // Phone Buchsen:
    translate([x0 + dx / 2 - phones_dx * 1.25,
               26.5,
               h0 - delta])
    {
        phones();

    }
}

module updown() {
    x0  = 150.0;
    dx  = 20.0;
    dx1 = x0 + dx / 2;
    dy  = 16.0;
    translate([dx1, dy, h0 - delta])
        taster();
    text2(dx1-7.5, dy+19, "\u25B2", size=11);
    translate([dx1, height_0 - dy, h0 - delta])
        taster();
    text2(dx1-7.5, dy+32, "\u25BC", size=11);
}

module power_switches() {
    x0 = 210.0;
    dx = 20.0;
    dy = 17.0;
    translate([x0 + dx / 2, dy, h0 - delta])
        onoff();
    text2(x0, dy+17, "230V");
    svg(x0+17, dy+15, "AC.svg", scale=0.025);
    translate([x0 + dx / 2, height_0 - dy, h0 - delta])
        onoff();
    text2(x0+1.65, dy+27, "12V");
    svg(x0+15, dy+25, "DC.svg", scale=0.025);
}

dial_x0 = 190.00;
dial_d0 =   7.25;

dial_free_z =  6.00;
dial_leg    =  6.00;
dial_base_x = 30.00;
dial_base_y = 30.00;
dial_base_z = fastener_z - dial_free_z;

module dial_block_base() {
    union() {
        translate([dial_base_x - dial_leg, 0, -delta])
            cube([dial_leg,
                  dial_leg,
                  dial_free_z + 2*delta]);
        translate([0, dial_base_y - dial_leg, -delta])
            cube([dial_leg,
                  dial_leg,
                  dial_free_z + 2*delta]);
        translate([dial_base_x - dial_leg, 
                   dial_base_y - dial_leg, -delta])
            cube([dial_leg,
                  dial_leg,
                  dial_free_z + 2*delta]);
        translate([0, 0, dial_free_z])
            cube([dial_base_x, dial_base_y, dial_base_z]);
    }
}

module dial_block_gaps() {
    nut_x = 2.5;
    nut_y = 5.0 + dial_d0 / 2;
    
    translate([0, 0, dial_free_z - delta])
        union() {
            translate([-17.5, -35, 0])
                rotate([0, 0, 45])
                    cube([50, 50, dial_base_z + 
                          2*delta]);
            translate([(dial_base_x - nut_x) / 2,
                       dial_base_y / 2, 0])
                cube([nut_x, 
                      nut_y, 
                      dial_base_z + 2*delta]);
        }
}

module dial_block() {
    translate([dial_x0 - dial_base_x / 2,
               height_0 / 2 - dial_base_y / 2,
               h0 + h1])
    difference() {
        dial_block_base();
        dial_block_gaps();
    }
}

module dial_loch() {
    translate([dial_x0,
               height_0 / 2,
               h0 - 2*delta])
        cylinder(h = 20, d = dial_d0);
    text2(dial_x0-5.25, height_0-7, "DIAL");
}


module front() {
    difference() {
        {
            union() {
                base();
                dial_block();
                display_haekchen();
                display_margin();
            }
        }
        ;
        {
            union() {
                // Display:
                translate([display_x0,
                           (height_0 - display_h) / 2,
                           h0 - delta])
                    display();
                left_side();
                updown();
                dial_loch();
                power_switches();
                text2(177, 14.5, "DF9RY", size=8, font =
                      "Roddenberry:style=Bold Italic");
            }
        }
    }
}

module print_front() {
    translate([0, height_0, h0 + h1 + fastener_z])
        rotate([180, 0, 0])
            front();
}

print_front();
//display_margin();



