
// Resolution for milling:
$fa            = 1;    // Minimum angle
$fs            = 0.025;  // Minimum size
delta          = 0.001;

// Knopf
a_step         =  1; // Resolution for circle
knob_radius    = 18.00;
knob_height    = 15.00;
knob_scale     =  0.90;
knob_fluting   =  1;
n_flutes       =  9;

top_rounding   = knob_radius * 4.5;
knob_inner_r   = knob_radius * 0.7;
knob_inner_h   =  3.50;
knob_hole_r    =  3.20;
knob_hole_h    =  8.50;

knob_top       = knob_height - 1.5;
ufp_outset     =  0.75;

include <ufp.scad>

function f_x(x, a) = x + cos(a) 
                     * (knob_fluting * cos(a*n_flutes));

function f_y(x, a) = x + sin(a) 
                     * (knob_fluting * cos(a*n_flutes));

module knob_shape_1(order = 360 / a_step, r = knob_radius)
{
    angles=[ for (i = [0:order-1]) i*(360/order) ];
    coords=[ for (th=angles) [
        f_x(r*cos(th), th), 
        f_y(r*sin(th), th)
    ]];
    polygon(coords);
}

module knob_shape_alpha() {
    difference() {
        circle(r = knob_radius + 5);
        circle(r = knob_radius);
    }
}

module knob_shape() {
    difference() {
        knob_shape_1();
        knob_shape_alpha();
    }
}

module alpha1() {
    translate([0, 0, knob_height - top_rounding])
        difference() {
            cylinder(h = top_rounding + 5,
                     r = knob_radius * knob_scale
                         + knob_fluting);
            sphere(r = top_rounding);
        }
}

module alpha2() {
    translate([0, 0, -delta])
        cylinder(r = knob_inner_r,
                 h = knob_inner_h + delta);
}

module alpha3() {
    cylinder(r = knob_hole_r,
             h = knob_hole_h);
}

module alpha4() {
    translate([0, 0, knob_top])
        cylinder(r = knob_radius * 0.7, h = 2);
}

module logo() {
    translate([0, 0, knob_top - delta])
        scale([0.35, 0.35, 1])
            linear_extrude(ufp_outset + delta)
                ufp();
}

module knob1() {
    linear_extrude(
        height = knob_height, scale = knob_scale)
        knob_shape();
}

module alpha() {
    union() {
        alpha1();
        alpha2();
        alpha3();
        alpha4();
    }
}

module knob()
{
    union() {
        difference() {
            knob1();
            alpha();
        };
        logo();
    }
}

knob();
