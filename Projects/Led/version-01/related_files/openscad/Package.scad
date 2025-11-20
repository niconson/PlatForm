  /*-----------------------------------------------\
  |  OpenSCAD code generator by Schemator&Platform |
  |  repositories https://github.com/niconson      |
  |  Niconson(R), All rights reserved              |
  \-----------------------------------------------*/
include <Package.lib>
Convexity = 2;
board_h = 1.500;



//// Drawing mode
MODE = 1;  // 1: full 3D view
           // 2: projection of top copper
           // 3: projection of bottom copper
           // 4: projection of top packages
           // 5: projection of bottom packages
           // 6: lateral projection
           // 7: frontal projection
           // Set the origin in the pcb editor to the
           // location where you want the cut to be:
           // 8: custom lateral projection
           // 9: custom frontal projection
           // 10: custom combo projection.

dir = 0;   // view direction for mode 6 and 7
pdist = 0; // distance between projections for mode 10



//// Drawing control
E = true;
drw_board_outline   = (MODE<4||MODE>5)?1:0;
drw_copper          = MODE<4?1:0;
drw_holes           = MODE<4?1:0;
drw_pads            = MODE<4?1:0;
drw_Package_Package = E;



//// Drawing module
frozenCoordinates = false; /* Wherever you move
the PCB in the PCB editor, the position of the 3D
model will remain the same. Make true if you want
to use this option*/

module Main (frozen, custom=true)
{
  Pcb_Package (frozen);
  if(custom) translate([frozen?0:originX_Package, frozen?0:originY_Package, 0])
  {
    // user field
    // add external objects here (optional)
    // for example, uncomment the following:
    /*
    color("aqua", 0.5)
    translate([0,0,0])
    rotate([0,0,0])
    cube(10);
    */
    /*
    // any pcb in the project folder
    // requires inclusion of <.lib> header:
    render()
    translate([0,0,50.000])
    Pcb_Package (1);
    */
    // end of user field
  }
}



//// Drawing
if (MODE == 1)
 Main (frozenCoordinates);
else if (MODE == 2)
 projection(true)
  translate([0, 0, -0.010])
   Main (frozenCoordinates, 0);
else if (MODE == 3)
 //mirror([1, 0, 0])
  projection(true)
   translate([0, 0, board_h + 0.010])
    Main (frozenCoordinates, 0);
else if (MODE == 4)
 projection()difference(){
  Main (frozenCoordinates, 0);
  Draw_Package_CUBE(0, frozenCoordinates);}
else if (MODE == 5)
 //mirror([1, 0, 0])
  projection()difference(){
   Main (frozenCoordinates, 0);
   Draw_Package_CUBE(1, frozenCoordinates);}
else if (MODE == 6)
 projection()
  rotate([0, dir?-90:90, 0])
   Main (frozenCoordinates, 0);
else if (MODE == 7)
 projection()
  rotate([dir?90:-90, 0, 0])
   Main (frozenCoordinates, 0);
else if (MODE == 8)
 projection(true)
  translate([0, 0, frozenCoordinates?-originX_Package:0])
   rotate([0, dir?-90:90, 0])
    Main(frozenCoordinates);
else if (MODE == 9)
 projection(true)
  translate([0, 0, frozenCoordinates?-originY_Package:0])
   rotate([dir?90:-90, 0, 0])
    Main(frozenCoordinates);
else if (MODE == 10)
{
  translate([frozenCoordinates?0:originX_Package+originY_Package-pdist, 0, 0])
  rotate(90)
  {
    projection(true)
     translate([0, 0, frozenCoordinates?-originX_Package:0])
      rotate([0, dir ? -90 : 90, 0])
       Main(frozenCoordinates); 
    projection()
     rotate([0, dir ? -90 : 90, 0])
      Main(frozenCoordinates, 0); 
  }
  projection(true)
   translate([0, 0, frozenCoordinates?-originY_Package:0])
    rotate([dir?90:-90, 0, 0])
     Main(frozenCoordinates); 
  projection()
   rotate([dir?90:-90, 0, 0])
    Main(frozenCoordinates, 0); 
}
