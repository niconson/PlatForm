  /*-----------------------------------------------\
  |  OpenSCAD code generator by Schemator&Platform |
  |  repositories https://github.com/niconson      |
  |  Niconson(R), All rights reserved              |
  \-----------------------------------------------*/
include <Driver_01.lib>
include <Package.lib>

// display parameter
Convexity = 3;

// pcb thickness
board_h = 1.500;

// drawing mode
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


// double-sided section for modes 4,5,11...13
sector = 0.01;

// distance between projections for mode 10
pdist = 20;

// use positive values to isolate a custom object
// use negative values to disable a custom object
object = 0;

// cube size for 4,5,11-13 modes
cube_scale = 2;

// total offset
offset = 0.01;

// rotate around the X axis
rotate_x = 0;

// rotate around the Y axis
rotate_y = 0;

// make projection for modes 1, 11...14
projection_true = false;

// projection via origin for modes 1, 11...14
via_origin = false;

// view direction for modes 6...13
view_dir= false;

// enable PCB section for modes 11...12
pcb_section = true;

// drawing control
E = true;

drw_board_outline      = true;
drw_copper             = true;
drw_holes              = true;
drw_pads               = true;
drw_Driver_01_C0402    = true; // controls Draw_Driver_01_C0402();
drw_Driver_01_RTLECS   = true; // controls Draw_Driver_01_RTLECS();
drw_Driver_01_CD54     = true; // controls Draw_Driver_01_CD54();
drw_Driver_01_MSOP_8T  = true; // controls Draw_Driver_01_MSOP_8T();
drw_Driver_01_SMTDIODE = true; // controls Draw_Driver_01_SMTDIODE();
drw_Driver_01_CC0805   = true; // controls Draw_Driver_01_CC0805();

//// 3d cube for boolean operations:
cube_scaleX = cube_scale;
cube_scaleY = cube_scale;
cube_scaleZ = cube_scale;



//// Drawing modules
// frozen position
frozen = false; /* coordinates: Wherever you move
the PCB in the PCB editor, the position of the 3D
model will remain the same. Make true if you want
to use this option */

module Main (custom=true)
{
  // (this module cannot be modified by the user)
  if(E) Pcb_Driver_01(frozen);
  if(custom) Custom(object);
}

//==================================================
//================  CUSTOM ZONE  ===================
//==================================================
module Custom (obj=0)
{
  translate([frozen?0:originX_Driver_01, frozen?0:originY_Driver_01, 0])
  {
    // custom field
    // add external objects here (optional)
    hide = (obj<0?-obj:0);
    item = (obj<0?0:obj);

    if(hide == 1){} else if (item == 1 || item == 0)
    {
      // add your object 1
      // for example, uncomment the following:
      /*
      color("aqua", 0.5)
      translate([0,0,0])
      rotate([0,0,0])
      cube(10);
      */
      translate([-6,-3.5,-9.000])
        Pcb_Package (true);
    }
    if(hide == 2){} else if (item == 2 || item == 0)
    {
      // add your object 2, for example, another PCB
      // from the project folder. For any PCB, you will
      // need to include the <.lib> header file(see above):
      /*
      render(Convexity)
      translate([0,0,50.000])
      Pcb_Driver_01 (true);
      */
    }
    if(hide == 3){} else if (item == 3 || item == 0)
    {
      // add your object 3

    }
    if(hide == 4){} else if (item == 4 || item == 0)
    {
      // add your object 4

    }
    // object 5, etc.
    // end of custom field
  }
}
//==================================================
//==============  END OF CUSTOM ZONE  ==============
//==================================================

module CubeX (d=view_dir)
{
    color("white")
    translate([0, frozen?-originY_Driver_01:0, frozen?(d?-max_height_Driver_01/2:max_height_Driver_01/2):0])
    rotate([d?90:-90, 0, 0])
    Draw_Driver_01_CUBE(0, frozen, sector);
}
module CubeY (d=view_dir)
{
    color("white")
    translate([frozen?-originX_Driver_01:0, 0, frozen?(d?max_height_Driver_01/2:-max_height_Driver_01/2):0])
    rotate([0, d?90:-90, 0])
    Draw_Driver_01_CUBE(0, frozen, sector);
}
module CubeZ (d=view_dir)
{
    color("white")
    translate([0,0,0])
    Draw_Driver_01_CUBE(d?1:0, frozen, sector);
}



module Drawing()
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
  CubeZ(0);}
else if (MODE == 5)
 //mirror([1, 0, 0])
  projection()difference(){
   Main(0);
   CubeZ(1);}
else if (MODE == 6)
 projection()
  rotate([0, view_dir?-90:90, 0])
   Main(0);
else if (MODE == 7)
 projection()
  rotate([view_dir?90:-90, 0, 0])
   Main(0);
else if (MODE == 8)
 projection(true)
  translate([0, 0, frozen?(view_dir?originX_Driver_01:-originX_Driver_01):0])
   rotate([0, view_dir?-90:90, 0])
    Main();
else if (MODE == 9)
 projection(true)
  translate([0, 0, frozen?(view_dir?originY_Driver_01:-originY_Driver_01):0])
   rotate([view_dir?90:-90, 0, 0])
    Main();
else if (MODE == 10)
{
  translate([frozen?-pdist:(originX_Driver_01+originY_Driver_01-pdist), 0, 0])
  rotate(90)
  {
    projection(true)
    translate([0, 0, frozen?(view_dir?originX_Driver_01:-originX_Driver_01):0])
    rotate([0, view_dir?-90:90, 0])
    Custom(object); 
    projection()
    rotate([0, view_dir?-90:90, 0])
    Main(0); 
  }
  render()// (combines intersecting projections)
  {
    projection(true)
    translate([0, 0, frozen?(view_dir?originY_Driver_01:-originY_Driver_01):0])
    rotate([view_dir?90:-90, 0, 0])
    Custom(object); 
    projection()
    rotate([view_dir?90:-90, 0, 0])
    Main(0);
  }
  projection(true)
   translate([0, frozen?10.000-pdist:(10.000+pdist-originY_Driver_01), board_h/2])
    Main();
}
else if (MODE == 11)
{
  //projection() rotate([-90,0,0])
  {
    if(!pcb_section) Main(0);
    render(Convexity) difference(){
    if(!pcb_section) Custom(object);
    else Main();
    CubeX();}
  }
}
else if (MODE == 12)
{
  //projection() rotate([0,90,0])
  {
    if(!pcb_section) Main(0);
    render(Convexity) difference(){
    if(!pcb_section) Custom(object);
    else Main();
    CubeY();}
  }
}
else if (MODE == 13)
{
  //projection()
  {
    Main(0);
    render(Convexity) difference(){
    Custom(object);
    CubeZ();}
  }
}
else if (MODE == 14)
{
  //projection() translate([0,0,0]) rotate([0,0,0])
  render(Convexity) difference()
  {
    Custom(object);
    //CubeX();
    //CubeY();
    //CubeZ();
    Main(0);
  }
}





if (projection_true && (MODE > 10 || MODE == 1))
{
  projection(via_origin)
    translate([0,0,offset])
      rotate([rotate_x,rotate_y,0])
        Drawing();
}
else
  translate([0,0,offset])
    rotate([rotate_x,rotate_y,0])
      Drawing();
