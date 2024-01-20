
use <ttf/Roddenberry-DgLm.ttf>
use <ttf/RoddenberryItalic-VYz6.ttf>
use <ttf/RoddenberryBold-AgG2.ttf>
use <ttf/RoddenberryBoldItalic-q4ol.ttf>

// Resolution for milling:
$fa            = 1;    // Minimum angle
$fs            = 0.1;  // Minimum size
delta          = 0.001;

width_0        = 242.0;
height_0       =  73.0;
r0             =   5.0; // Rundung
h0             =  12.0; // Hoehe des aeusseren Blocks

width_1        = 238.0;
height_1       =  69.4;
r1             = r0;
h1             =   5.0;

fastener_width = 234.0;
fastener_x     =   2.5;
fastener_y     =  32.5;
fastener_z     =   5.5;

rundung_radius = (width_1 - fastener_width) / 2;

schlitz_x      =  12.0;
schlitz_y      =   3.0;
schlitz_z      =   2.5;
schlitz_dx     = 174.0;
schlitz_dy     =  62.0;

wand_dicke     =   3.0;
rand_dicke     =   1.5; // Rand aussen
rand_dicke_2   =   5.0; // Rand innen

module sketch0() {
    r = r0;
    h = height_0;
    w = width_0;
    
    hull() {
        translate([r, r])
            circle(r = r);
        translate([r, h - r])
            circle(r = r);
        translate([w - r, r])
            circle(r = r);
        translate([w - r, h - r])
            circle(r = r);
    }
}

module sketch01() {
    r = r0 - rand_dicke;
    h = height_0 - 2 * rand_dicke;
    w = width_0 - 2 * rand_dicke;
    
    translate([rand_dicke, rand_dicke]) {
        hull() {
            translate([r, r])
                circle(r = r);
            translate([r, h - r])
                circle(r = r);
            translate([w - r, r])
                circle(r = r);
            translate([w - r, h - r])
                circle(r = r);
        }
    }
}

module sketch1() {
    delta_w = (width_0 - width_1) / 2;
    delta_h = (height_0 - height_1) / 2;
    translate([delta_w, delta_h]) {
        hull() {
            r = r1;
            h = height_1;
            w = width_1;
            
            translate([r, r])
                circle(r = r);
            translate([r, h - r])
                circle(r = r);
            translate([w - r, r])
                circle(r = r);
            translate([w - r, h - r])
                circle(r = r);
        }
    }
}

module block0_aussen() {
    linear_extrude(height = h0)
        sketch01();
}

module block0_innen() {
    delta_dicke = rand_dicke_2 - rand_dicke;
    scale_x = (width_0 - delta_dicke) / width_0;
    scale_y = (height_0 - delta_dicke) / height_0;
        
    translate([width_0 / 2, height_0 / 2, -delta])
        linear_extrude(height = h0 + 2 * delta, 
                       scale = [scale_x, scale_y])
            translate([-width_0 / 2, 
                       -height_0 / 2])
                sketch01();
}
    
module block0() {
    difference() {
        block0_aussen();
        block0_innen();
    }
}

module block1() {
    linear_extrude(height = h1 + delta)
        sketch1();
}

// Fastener zum Festschrauben:

module fastener_loch(d, h) {
    ld =   4.0; // Lochdurchmesser
    translate([-delta, 0, 0])
        rotate([0, 90, 0])
            cylinder(d = d, h = h);
}

module fastener() {
    x  =  fastener_x;
    y  =  fastener_y;
    z  =  fastener_z;
    
    la =  24.0; // Lochabstand
    ld =   3.2;

    difference() {
        cube([x, y + delta, z]);
        {
            y0 = (y - la) / 2;
            translate([0, y0, z / 2 + delta])
                fastener_loch(ld, x + 2*delta);
            translate([0, y0 + la, z / 2 + delta])
                fastener_loch(ld, x + 2*delta);
        }
    }
}


module blocks_0() {
    block0();
    translate([0, 0, h0 - delta])
        block1();
    {
        delta_x0 = (width_0 - fastener_width) / 2;
        delta_x1 = delta_x0 + fastener_width - 
                     fastener_x;
        delta_y  = (height_0 - fastener_y) / 2;
        delta_z  = h0 + h1;
        
        translate([delta_x0, delta_y, delta_z])
            fastener();
        translate([delta_x1, delta_y, delta_z])
            fastener();
    }
}

module rundung() {
    rotate([-90, 0, 0])
        cylinder(h = height_0, r = rundung_radius);
}

module base() {
    difference() {
        blocks_0();
        {
            { // Rundungen
                delta_x0 = (width_0 - fastener_width) / 2
                              - rundung_radius;
                delta_x1 = delta_x0 + fastener_width
                              + 2 * rundung_radius;
                delta_z  = h0 + h1;
                
                translate([delta_x0, 0, delta_z])
                    rundung();
                translate([delta_x1, 0, delta_z])
                    rundung();
            }
            { // Schlitze
                dx0 = (width_0 - schlitz_dx) / 2;
                dx1 = dx0 + schlitz_dx;
                dy0 = (height_0 - schlitz_dy 
                         - schlitz_y) / 2;
                dy1 = dy0 + schlitz_dy;
                dz  = h0 + h1 - schlitz_z;
                
                translate([dx0, dy0, dz])
                    cube([schlitz_x,
                          schlitz_y,
                          schlitz_z + delta]);
                translate([dx0, dy1, dz])
                    cube([schlitz_x,
                          schlitz_y,
                          schlitz_z + delta]);
                translate([dx1, dy0, dz])
                    cube([schlitz_x,
                          schlitz_y,
                          schlitz_z + delta]);
                translate([dx1, dy1, dz])
                    cube([schlitz_x,
                          schlitz_y,
                          schlitz_z + delta]);
            }
        }
    }
}

display_w    = 97.5;
display_h    = 59.0;
display_t    =  1.50; // Absenkung;
display_rand =  1.25;
display_x0   = 48.0;

module display() {
    translate([display_rand, display_rand, -delta])
        cube([display_w - 2 * display_rand,
              display_h - 2 * display_rand,
              display_t + 2*delta]);
    translate([0, 0, display_t])
        cube([display_w, display_h, 10]);
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
}

taster_d0 = 12.25;

module taster() {
    translate([0, 0, -delta])
        cylinder(h = 10, d = taster_d0);
}

onoff_d0 = 16.25;

module onoff() {
    translate([0, 0, -delta])
        cylinder(h = 10, d = onoff_d0);
}

phone_bu_d0 = 10.00;
phone_bu_h0 =  1.50;
phone_bu_d1 =  6.25;
phone_bu_h1 =  1.50;

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
    translate([phones_dx * 1.75, 7.0, 0])
        phone_bu();
    
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
        taster();
   // Phone Buchsen:
    translate([x0 + dx / 2 - phones_dx * 1.25,
               26.5,
               h0 - delta])
        phones();
}

module updown() {
    x0 = 150.0;
    dx = 20.0;
    dy = 16.0;
    translate([x0 + dx / 2,
               dy,
               h0 - delta])
        taster();
    translate([x0 + dx / 2,
               height_0 - dy,
               h0 - delta])
        taster();
}

module power_switches() {
    x0 = 210.0;
    dx = 20.0;
    dy = 17.0;
    translate([x0 + dx / 2,
               dy,
               h0 - delta])
        onoff();
    translate([x0 + dx / 2,
               height_0 - dy,
               h0 - delta])
        onoff();
}

dial_x0 = 190.00;
dial_d0 =   7.25;
dial_d1 =  16.00;

dial_base_x = 30.00;
dial_base_y = 30.00;
dial_base_z =  3.00;
dial_free_z =  5.00;
dial_leg    =  6.00;

module dial_block() {
    translate([dial_x0 - dial_base_x / 2,
               height_0 / 2 - dial_base_y / 2,
               h0 + h1])
    {
        translate([0, 0, -delta])
            cube([dial_leg,
                  dial_leg,
                  dial_free_z + 2*delta]);
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

module dial_loch() {
    translate([dial_x0,
               height_0 / 2,
               h0 - 2*delta])
        cylinder(h = 20, d = dial_d0);
}

module front() {
    difference() {
        {
            union() {
                base();
                dial_block();
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
            }
        }
    }
}

front();
//dial_block();

