
module ufp() {
    d0 = 48.0;
    t0 =  0.5;
    d1 = 45.0;
    t1 =  1.0;
    
    union() {
        translate([0, -3])
            import("UFP1.svg", center = true);
        // Aeusserer Kreis:
        difference() {
            circle(d = d0);
            circle(d = d0 - 2*t0);
        }
        // Innerer Kreis:
        difference() {
            circle(d = d1);
            circle(d = d1 - 2*t1);
        }
    }
}

