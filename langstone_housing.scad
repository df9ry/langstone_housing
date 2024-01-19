
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

module blocks() {
    blocks_0();
}

blocks();
//fastener();

