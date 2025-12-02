  /*-----------------------------------------------\
  |  OpenSCAD code generator by Schemator&Platform |
  |  repositories https://github.com/niconson      |
  |  Niconson(R), All rights reserved              |
  \-----------------------------------------------*/
include <Driver_01.lib>
include <Package.lib>
Convexity = 4;
board_h = 1.500;



//// Drawing mode
MODE = 1;  // 1: full 3D view
           // 2: projection of top copper
           // 3: projection of bottom copper
           // 4: projection of top packages
           // 5: projection of bottom packages
           // 6: lateral pcb projection
           // 7: frontal pcb projection.
           // Set the origin in the pcb editor to the
           // location where you want the cut to be:
           // 8: custom lateral projection
           // 9: custom frontal projection
           // 10: custom combo projection
           // 11: frontal 3D section 
           // 12: lateral 3D section 
           // 13: top 3D section 
           // 14: boolean difference (makes
           //     holes in the Custom objects
           //     using 3d-models of pcb parts).

dir = 0;   // view direction for 6...13 modes
sector = 4;// double-sided section for modes 11, 12, 13
pdist = 20;// distance between projections for mode 10



//// Drawing control
E = true;
drw_board_outline      = (MODE!=4&&MODE!=5&&MODE!=14)?1:0;
drw_copper             = (MODE<4||MODE>10)?1:0;
drw_holes              = (MODE<4||MODE>10)?1:0;
drw_pads               = (MODE<4||MODE>10)?1:0;
drw_Driver_01_C0402    = E; // controls Draw_Driver_01_C0402();
drw_Driver_01_RTLECS   = E; // controls Draw_Driver_01_RTLECS();
drw_Driver_01_CD54     = E; // controls Draw_Driver_01_CD54();
drw_Driver_01_MSOP_8T  = E; // controls Draw_Driver_01_MSOP_8T();
drw_Driver_01_SMTDIODE = E; // controls Draw_Driver_01_SMTDIODE();
drw_Driver_01_CC0805   = E; // controls Draw_Driver_01_CC0805();



//// Drawing modules
/*
coordinates:*/frozen = false;/* Wherever you move
the PCB in the PCB editor, the position of the 3D
model will remain the same. Make true if you want
to use this option*/

module Main (custom=true)
{
  // (this module cannot be modified by the user)
  Pcb_Driver_01(frozen);
  if(custom) Custom();
}

module Custom ()
{
  translate([frozen?0:originX_Driver_01, frozen?0:originY_Driver_01, 0])
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

    // add  any  PCB  from  the  project  folder,
    // any pcb in the project folder will require
    // the <.lib> header (See top) to be included:
    
    render(Convexity)
    translate([-6,-3.5,-9.000])
    Pcb_Package (true);
    

    // end of user field
  }
}



//// Drawing
cube_scaleX = 2.0;// (cube sizeX for 4,5,11,12,13 modes)
cube_scaleY = 1.0;// (cube sizeY for 4,5,11,12,13 modes)
cube_scaleZ = 1.0;// (cube sizeZ for 4,5,11,12,13 modes)
if (MODE == 1)
 Main();
else if (MODE == 2)
 projection(true)
  translate([0, 0, -0.010])
   Main();
else if (MODE == 3)
 //mirror([1, 0, 0])
  projection(true)
   translate([0, 0, board_h + 0.010])
    Main();
else if (MODE == 4)
 projection()difference(){
  Main(0);
  Draw_Driver_01_CUBE(0, frozen, 0);}
else if (MODE == 5)
 //mirror([1, 0, 0])
  projection()difference(){
   Main(0);
   Draw_Driver_01_CUBE(1, frozen, 0);}
else if (MODE == 6)
 projection()
  rotate([0, dir?-90:90, 0])
   Main(0);
else if (MODE == 7)
 projection()
  rotate([dir?90:-90, 0, 0])
   Main(0);
else if (MODE == 8)
 projection(true)
  translate([0, 0, frozen?(dir?originX_Driver_01:-originX_Driver_01):0])
   rotate([0, dir?-90:90, 0])
    Main();
else if (MODE == 9)
 projection(true)
  translate([0, 0, frozen?(dir?originY_Driver_01:-originY_Driver_01):0])
   rotate([dir?90:-90, 0, 0])
    Main();
else if (MODE == 10)
{
  translate([frozen?-pdist:(originX_Driver_01+originY_Driver_01-pdist), 0, 0])
  rotate(90)
  {
    projection(true)
     translate([0, 0, frozen?(dir?originX_Driver_01:-originX_Driver_01):0])
      rotate([0, dir?-90:90, 0])
       Custom(); 
    projection()
     rotate([0, dir?-90:90, 0])
      Main(0); 
  }
  render()// (combines intersecting projections)
  {
  projection(true)
   translate([0, 0, frozen?(dir?originY_Driver_01:-originY_Driver_01):0])
    rotate([dir?90:-90, 0, 0])
     Custom(); 
  projection()
   rotate([dir?90:-90, 0, 0])
    Main(0);
  }
  projection(true)
   translate([0, frozen?10.000-pdist:(10.000+pdist-originY_Driver_01), board_h/2])
    Main();
}
else if (MODE == 11)
{
  PcbFull = 0; // make 1 for full pcb view
  //projection() rotate([-90,0,0])
  {
    if(PcbFull) Main(0);
    difference(){
    if(PcbFull) Custom();
    else Main();
    color("white")
    translate([0, frozen?-originY_Driver_01:0, frozen?(dir?-max_height_Driver_01/2:max_height_Driver_01/2):0])
    rotate([dir?90:-90, 0, 0])
    Draw_Driver_01_CUBE(0, frozen, sector);}
  }
}
else if (MODE == 12)
{
  PcbFull = 0; // make 1 for full pcb view
  //projection() rotate([0,90,0])
  {
    if(PcbFull) Main(0);
    difference(){
    if(PcbFull) Custom();
    else Main();
    color("white")
    translate([frozen?-originX_Driver_01:0, 0, frozen?(dir?max_height_Driver_01/2:-max_height_Driver_01/2):0])
    rotate([0, dir?90:-90, 0])
    Draw_Driver_01_CUBE(0, frozen, sector);}
  }
}
else if (MODE == 13)
{
  //projection()
  {
    Main(0);
    difference(){
    Custom();
    color("white")
    translate([0,0,0])
    Draw_Driver_01_CUBE(dir?1:0, frozen, sector);}
  }
}
else if (MODE == 14)
 difference(){
  Custom();
  Main(0);}
