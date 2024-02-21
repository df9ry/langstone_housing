
include <base.scad>

ptt_d0 =  20.0;
ptt_h0 =   2.0;
ptt_d1 =  16.0;
ptt_h1 =   2.5;
ptt_d2 =  25.0;
ptt_x0 = 210.0;
ptt_y0 =  50.0;

module ptt() {
    translate([ptt_x0, ptt_y0, -delta])
        cylinder(h = ptt_h0 + 2*delta, d = ptt_d0);
    translate([ptt_x0, ptt_y0, ptt_h0])
        cylinder(h = ptt_h1 + delta, d = ptt_d1);
    translate([ptt_x0, ptt_y0, ptt_h0 + ptt_h1])
        cylinder(h = 10, d = ptt_d2);
    // Text:
    text2(ptt_x0 - 5.0, ptt_y0 + 16.5, "PTT", z = -2*delta);
}

ls_bu_d0 =  10.00;
ls_bu_h0 =   1.50;
ls_bu_d1 =   6.25;
ls_bu_h1 =   0.75;
ls_bu_x0 = 180.00;
ls_bu_y0 =  54.50;

module ls_bu() {
    translate([ls_bu_x0, ls_bu_y0, - 2*delta])
        cylinder(h = ls_bu_h0, d = ls_bu_d0);
    translate([ls_bu_x0, ls_bu_y0, ls_bu_h0 - 3*delta])
        cylinder(h = 15, d = ls_bu_d1);
    // Text:
    text2(ls_bu_x0 - 3.0, ls_bu_y0 + 12, "LS", z = -2*delta);
}

ls_bu_dx = 12.00;
ls_bu_dy = 17.00;

module ls_back() {
    translate([ls_bu_x0 - 15, 
               ls_bu_y0 - 6, 
               ls_bu_h0 + ls_bu_h1])
        cube([ls_bu_dx * 2.5, ls_bu_dy, 10]); 
}

key_d0 =  20.0;
key_h0 =   1.5;
key_d1 =   9.0;
key_h1 =   2.5;
key_d2 =  14.0;
key_x0 = 150.0;
key_y0 =  50.0;

module key() {
    translate([key_x0, key_y0, -delta])
        cylinder(h = key_h0 + 2*delta, d = key_d0);
    translate([key_x0, key_y0, key_h0])
        cylinder(h = 10, d = key_d1);
    // Text:
    text2(key_x0 - 5.0, key_y0 + 16.5, "KEY", z = -2*delta);
}

net_width  =  23.25;
net_height =  25.00;
net_x0     =  95.00;
net_y0     =  34.50;

module net() {
    translate([net_x0, net_y0, -delta])
        cube([net_width, net_height, 10]);
    translate([net_x0, net_y0 - 1.5, 2.5])
        cube([net_width, net_height + 3, 10]);
}

ac_width  =  47.75;
ac_height =  27.50;
ac_x0     =  20.00;
ac_y0     =  33.00;

module ac() {
    translate([ac_x0, ac_y0, -delta])
        cube([ac_width, ac_height, 10]);
    translate([ac_x0, ac_y0 - 0.5, 1.25])
        cube([ac_width, ac_height + 1.25, 10]);
    // Text:
    text2(ac_x0 + 5, ac_y0 + 33.5, "AC 230V 50Hz", 
          z = -2*delta);
}

dcin_width   = 15.75;
dcin_width2  = 27.75;
dcin_height  =  8.25;
dcin_height2 = 12.75;
dcin_depth   =  3.00;
dcin_x0      = 25.00;
dcin_y0      = 13.00;
dcin_scr_d   =  3.50;
dcin_scr_d1  =  6.50;
dcin_scr_dx  = 20.00;

module phasing() {
    linear_extrude(height = 2.5, scale = 0.0)
        circle(d = dcin_scr_d1); 
}

module dcin() {
    translate([dcin_x0, dcin_y0, -delta])
        cube([dcin_width - dcin_height / 2, dcin_height, 10]);
    translate([dcin_x0 + dcin_width - dcin_height / 2,
               dcin_y0 + dcin_height / 2, -delta])
        cylinder(h = 10, d = dcin_height);
    // Text:
    text2(dcin_x0 - 5, dcin_y0 + 17, "DC 12V IN", 
          z = -2*delta);
    
    translate([dcin_x0 - (dcin_width2 - dcin_width) / 2,
               dcin_y0 - (dcin_height2 - dcin_height) / 2, 
               dcin_depth - delta])
        cube([dcin_width2, dcin_height2, 10]);
    translate([dcin_x0 - (dcin_scr_dx - dcin_width) / 2,
               dcin_y0 + dcin_height / 2, -delta])
    {
        cylinder(h = 10, d = dcin_scr_d);
        phasing();
    }
    translate([dcin_x0 + dcin_scr_dx - (dcin_scr_dx -
               dcin_width) / 2, dcin_y0 + dcin_height / 2,
               -delta])
    {
        cylinder(h = 10, d = dcin_scr_d);
        phasing();
    }
}

dcout_width1  =  34.45;
dcout_width2  =  25.25;
dcout_width3  =  21.00;
dcout_width4  =  21.00;
dcout_height1 =  12.25;
dcout_height2 =  16.25;
dcout_height4 =  12.25;
dcout_x0      =  75.00;
dcout_y0      =   9.00;
dcout_z0      =   2.5;
dcout_scr_dx  =  25.00;
dcout_scr_d   =   3.50;

module dcout_sketch() {
    w1_2 = dcout_width1 / 2;
    w2_2 = dcout_width2 / 2;
    w3_2 = dcout_width3 / 2;
    h1_2 = dcout_height1 / 2;
    h2_2 = dcout_height2 / 2;
    translate([w1_2, h2_2])
        polygon(points=[
            [-w1_2,  h1_2],
            [-w2_2,  h1_2],
            [-w3_2,  h2_2],
            [ w3_2,  h2_2],
            [ w2_2,  h1_2],
            [ w1_2,  h1_2],
            [ w1_2, -h1_2],
            [ w2_2, -h1_2],
            [ w3_2, -h2_2],
            [-w3_2, -h2_2],
            [-w3_2, -h2_2],
            [-w2_2, -h1_2],
            [-w1_2, -h1_2]
        ]);   
}

module dcout() {
    dx_2 = (dcout_width1 - dcout_scr_dx) / 2;
    dy_2 = dcout_height2 / 2;
    
    translate([dcout_x0, dcout_y0])
        union() {
            translate([0, 0, -delta])
                linear_extrude(height = dcout_z0)
                    dcout_sketch();
            translate([(dcout_width1 - dcout_width3) / 2,
                       (dcout_height2 - dcout_height1) / 2,
                       0])
                cube([dcout_width4, dcout_height4, 10]);
            translate([dx_2, dy_2, -delta])
                cylinder(h = 10, d = dcout_scr_d);
            translate([dx_2 + dcout_scr_dx, dy_2, -delta])
                cylinder(h = 10, d = dcout_scr_d);
            // Text:
            text2(1.5, dcout_y0 + 12, "DC 12V OUT", 
                  z = -2*delta);
        }
}

fuse_d0  =  16.00;
fuse_h0  =   2.50;
fuse_d1  =  12.25;
fuse_h1  =   2.00;
fuse_d2  =  17.00;
fuse1_x0 =  60.00;
fuse2_x0 = 124.00;
fuse_y0  =  17.50;

module fuse1() {
    translate([fuse1_x0, fuse_y0, -delta])
        cylinder(h = fuse_h0 + 2*delta, d = fuse_d0);
    translate([fuse1_x0, fuse_y0, fuse_h0])
        cylinder(h = 10, d = fuse_d1);
    translate([fuse1_x0, fuse_y0, fuse_h0 + fuse_h1])
        cylinder(h = 10, d = fuse_d2);
    // Text:
    text2(fuse1_x0 - 6.5, fuse_y0 + 12.5, "DC IN", 
          z = -2*delta);
}

module fuse2() {
    translate([fuse2_x0, fuse_y0, -delta])
        cylinder(h = fuse_h0 + 2*delta, d = fuse_d0);
    translate([fuse2_x0, fuse_y0, fuse_h0])
        cylinder(h = 10, d = fuse_d1);
    translate([fuse2_x0, fuse_y0, fuse_h0 + fuse_h1])
        cylinder(h = 10, d = fuse_d2);
    // Text:
    text2(fuse2_x0 - 9.3, fuse_y0 + 12.5, "DC OUT", 
          z = -2*delta);
}

trx_width  =  65.00;
trx_height =  18.50;
trx_rand   =   2.50;
trx_dy     =   3.00;
trx_x0     = 155.00;
trx_y0     =   9.00;

module trx() {
    translate([trx_x0 + trx_rand, trx_y0 + trx_rand,
               -delta])
        cube([trx_width - 2 * trx_rand,
              trx_height - 2 * trx_rand, 10]);
    translate([trx_x0, trx_y0, trx_dy - delta])
        cube([trx_width, trx_height * 1.6, 10]);
    // Text:
    text2(trx_x0 + 13, trx_y0 + 21.5, "RX", z = -2*delta);
    text2(trx_x0 + 43, trx_y0 + 21.5, "TX", z = -2*delta);
}

module trx_pos() {
    union() {
        translate([trx_x0 - trx_rand,
                   trx_y0 - trx_rand,
                   h0 + h1 - 1.0])
            cube([trx_width * 0.67, 2 * trx_rand, 3]);
        translate([trx_x0 - trx_rand - 2.0,
                   trx_y0 - trx_rand,
                   h0 + h1 - 1.0])
            cube([2 * trx_rand + 2, trx_height * 0.8, 3]);
        translate([trx_x0 + trx_width - trx_rand,
                   trx_y0 - trx_rand,
                   h0 + h1 - 1.0])
            cube([2 * trx_rand + 2, trx_height * 0.8, 3]);
    }
}

module diff() {
    translate([0, 0, h0 - delta])
        union() {
            ptt();
            ls_bu();
            ls_back();
            key();
            net();
            ac();
            dcin();
            dcout();
            fuse1();
            fuse2();
            trx();
        }
}

module back() {
    translate([0, height_0, h0 + h1 + fastener_z])
        rotate([180, 0, 0])
            union() {
                difference() {
                    base();
                    diff();
                };
                trx_pos();
            }
}

back();

