
/*//////////////////////////////////////////////////////////////////
              -    FB Aka Heartman/Hearty 2016     -                   
              -   http://heartygfx.blogspot.com    -                  
              -       OpenScad Parametric Box      -                     
              -         CC BY-NC 3.0 License       -                      
////////////////////////////////////////////////////////////////////                                                                                                             
12/02/2016 - Fixed minor bug 
28/02/2016 - Added holes ventilation option                    
09/03/2016 - Added PCB feet support, fixed the shell artefact on export mode. 

*/////////////////////////// - Info - //////////////////////////////

// All coordinates are starting as integrated circuit pins.
// From the top view :

//   CoordD           <---       CoordC
//                                 ^
//                                 ^
//                                 ^
//   CoordA           --->       CoordB


////////////////////////////////////////////////////////////////////


////////// - Paramètres de la boite - Box parameters - /////////////

/* [Box dimensions] */
// - Longueur - Length  
  Length        = 50;       
// - Largeur - Width
  Width         = 20;                     
// - Hauteur - Height  
  Height        = 18;  
// - Epaisseur - Wall thickness  
  Thick         = 1.5;//[2:5]  
  
/* [Box options] */
// - Diamètre Coin arrondi - Filet diameter  
  Filet         = 1.5;//[0.1:12] 
// - lissage de l'arrondi - Filet smoothness  
  Resolution    = 50;//[1:100] 
// - Tolérance - Tolerance (Panel/rails gap)
  m             = 0.45;
// Pieds PCB - PCB feet (x4) 
  PCBFeet       = 0;// [0:No, 1:Yes]
  TPCBFeet      = 0;// Top [0:No, 1:Yes]
  LCDFeet       = 0;// Top [0:No, 1:Yes]
// - Decorations to ventilation holes
  Vent          = 0;// [0:No, 1:Yes]
// - Decoration-Holes width (in mm)
  Vent_width    = 0;   

/* [PCB_Feet bottom] */
//All dimensions are from the center foot axis
// - Coin bas gauche - Low left corner X position
PCBPosX         = -3.8;
// - Coin bas gauche - Low left corner Y position
PCBPosY         = 0.5;
// - Longueur PCB - PCB Length
PCBLength       = 68.6;
// - Largeur PCB - PCB Width
PCBWidth        = 53.3;
// - Heuteur pied - Feet height
FootHeight      = 8;
// - Diamètre pied - Foot diameter
FootDia         = 6;
// - Diamètre trou - Hole diameter
FootHole        = 2;  
// - Foot Inset
FootInset       = 2.5;
// feet 1 and 4 are offset horizontally, 2 and 3 are offset vertically
Foot1Offset     = 11.5;
Foot2Offset     = 5.2;
Foot3Offset     = 15.2;
Foot4Offset     = 12.8;

/* [PCB_Feet top] */
//All dimensions are from the center foot axis
// - Coin bas gauche - Low left corner X position
TPCBPosX         = 0;
// - Coin bas gauche - Low left corner Y position
TPCBPosY         = 8;
// - Longueur PCB - PCB Length
TPCBLength       = 52.5;
// - Largeur PCB - PCB Width
TPCBWidth        = 73;
// - Heuteur pied - Feet height
TFootHeight      = 8;
// - Diamètre pied - Foot diameter
TFootDia         = 6;
// - Diamètre trou - Hole diameter
TFootHole        = 2;  

/* [LCD Panel] */
//All dimensions are from the center foot axis
// - Coin bas gauche - Low left corner X position
LCDPosX         = 8;
// - Coin bas gauche - Low left corner Y position
LCDPosY         = -4.25;
// - Longueur PCB - PCB Length
LCDLength       = 80;
// - Largeur PCB - PCB Width
LCDWidth        = 36;
// - Diamètre pied - Foot diameter
LCDFootDia      = 5;
// - Heuteur pied - Feet height
LCDFootHeight      = 9.5;

/* [STL element to export] */
//Coque haut - Top shell
TShell          = 0;// [0:No, 1:Yes]
//Coque bas- Bottom shell
BShell          = 1;// [0:No, 1:Yes]
//Panneau avant - Front panel
FPanL           = 1;// [0:No, 1:Yes]
//Panneau arrière - Back panel  
BPanL           = 1;// [0:No, 1:Yes]

/* [Hidden] */
// - Couleur coque - Shell color  
Couleur1        = "Orange";       
// - Couleur panneaux - Panels color    
Couleur2        = "OrangeRed";    
// Thick X 2 - making decorations thicker if it is a vent to make sure they go through shell
Dec_Thick       = Vent ? Thick*2 : Thick; 
// - Depth decoration
Dec_size        = Vent ? Thick*2 : 0.8;

/////////// - Boitier générique bord arrondis - Generic rounded box - //////////

module RoundBox($a=Length, $b=Width, $c=Height){// Cube bords arrondis
                    $fn=Resolution;            
                    translate([0,Filet,Filet]){  
                    minkowski (){                                              
                        cube ([$a-(Length/2),$b-(2*Filet),$c-(2*Filet)], center = false);
                        rotate([0,90,0]){    
                        cylinder(r=Filet,h=Length/2, center = false);
                            } 
                        }
                    }
                }// End of RoundBox Module

      
////////////////////////////////// - Module Coque/Shell - //////////////////////////////////         

module Coque(){//Coque - Shell  
    Thick = Thick*2;  
    difference(){ //sides positive   
        difference(){ //sides decoration
            union(){ //union main
                difference() {//soustraction de la forme centrale - Substraction Fileted box
                    difference(){//soustraction cube median - Median cube slicer
                        union() {//union               
                            difference(){//Coque    
                                RoundBox();
                                translate([Thick/2,Thick/2,Thick/2]){     
                                    RoundBox($a=Length-Thick, $b=Width-Thick, $c=Height-Thick);
                                }
                            }//Fin diff Coque                            

                            difference(){//largeur Rails        
                                translate([Thick+m,Thick/2,Thick/2]){// Rails
                                    RoundBox($a=Length-((2*Thick)+(2*m)), $b=Width-Thick, $c=Height-(Thick*2));
                                }//fin Rails

                                translate([((Thick+m/2)*1.55),Thick/2,Thick/2+0.1]){ // +0.1 added to avoid the artefact
                                    RoundBox($a=Length-((Thick*3)+2*m), $b=Width-Thick, $c=Height-Thick);
                                }           
                            }//Fin largeur Rails
                        }//Fin union                                   
 
                        translate([-Thick,-Thick,Height/2]){// Cube à soustraire
                            cube ([Length+100, Width+100, Height], center=false);
                        }                                            
                    }//fin soustraction cube median - End Median cube slicer

                    translate([-Thick/2,Thick,Thick]){// Forme de soustraction centrale 
                        RoundBox($a=Length+Thick, $b=Width-Thick*2, $c=Height-Thick);       
                    }                          
                } // fin soustraction de la forme centrale

                difference(){// wall fixation box legs
                    union(){
                        translate([3*Thick +5,Thick,Height/2]){
                            rotate([90,0,0]){
                                $fn=6;
                                cylinder(d=11,Thick/2);
                            }   
                        }
                            
                        translate([Length-((3*Thick)+5),Thick,Height/2]){
                            rotate([90,0,0]){
                                $fn=6;
                                cylinder(d=11,Thick/2);
                            }   
                        }
                    }
                    translate([4,Thick+Filet,Height/2-57]){   
                        rotate([45,0,0]){
                            cube([Length,40,40]);    
                        }
                    }
                    translate([0,-(Thick*1.46),Height/2]){
                        cube([Length,Thick*2,10]);
                    }
                } //Fin fixation box legs
            }//fin union main

            union(){// negative of outbox sides decorations
                for(i=[0:Thick:Length/2]){
                    // Ventilation holes part code submitted by Ettie - Thanks ;) 
                    translate([10+i,-Dec_Thick+Dec_size,1]){
                        cube([Vent_width,Dec_Thick,Height/4]);
                    }
                    translate([(Length-10) - i,-Dec_Thick+Dec_size,1]){
                        cube([Vent_width,Dec_Thick,Height/4]);
                    }
                    translate([(Length-10) - i,Width-Dec_size,1]){
                        cube([Vent_width,Dec_Thick,Height/4]);
                    }
                    translate([10+i,Width-Dec_size,1]){
                        cube([Vent_width,Dec_Thick,Height/4]);
                    }
                }// fin de for
            }//fin un decoration negative
        }//fin difference decoration


        union(){ //sides holes
            $fn=50;
            translate([3*Thick+5,20,Height/2+2]){
                rotate([90,0,0]){
                    cylinder(d=2,20);
                }
            }
            translate([Length-((3*Thick)+5),20,Height/2+2]){
                rotate([90,0,0]){
                    cylinder(d=2,20);
                }
            }
            translate([3*Thick+5,Width+5,Height/2-2]){
                rotate([90,0,0]){
                    cylinder(d=2,Thick+5);
                }
            }
            translate([Length-((3*Thick)+5),Width+5,Height/2-2]){
                rotate([90,0,0]){
                    cylinder(d=2,Thick+5);
                }
            }
        }//fin de sides holes
    }//fin de difference holes

    difference(){
        translate([Thick+11.5,1,.5])
            Panel(Length,Width+1.5,Thick/2,Filet/2);
        translate([11+Thick,-2,3])
            cube([Thick+2,Width+Thick*2+1,Height-5]);
    }

}// fin coque 

////////////////////////////// - Experiment - ///////////////////////////////////////////





/////////////////////// - Foot with base filet - /////////////////////////////
module foot(Footx, Footy, Footz, FootDia,FootHole,FootHeight){
    Filet=2;
    color(Couleur1)   
    translate([Footx,Footy,Footz+Filet-1.5])
    difference(){
        cylinder(d=FootDia+Filet,FootHeight-Thick, $fn=100);
        rotate_extrude($fn=100){
            translate([(FootDia+Filet*2)/2,Filet,0]){
                minkowski(){
                    square(10);
                    circle(Filet, $fn=100);
                }
            }
        }
        cylinder(d=FootHole,FootHeight+1, $fn=100);
    }          
}// Fin module foot
  
module Feet(BoardLength,BoardWidth,FHeight,FDia,FHole,F1Offset,F2Offset,F3Offset,F4Offset){     
    //////////////// - PCB only visible in the preview mode - /////////////////////    
    translate([3*Thick+2,Thick+5,FHeight+(Thick/2)-0.5]){
    
        %square ([BoardLength,BoardWidth]);
        translate([BoardLength/2,BoardWidth/2,0.5]){ 
            color("Olive")
            %text("PCB", halign="center", valign="center", font="Arial black");
        }
    } // Fin PCB 
  
    
////////////////////////////// - Feet - //////////////////////////////////////////
//    translate([(3*Thick+2)+FootInset+F1Offset,(Thick+5)+FootInset,Thick/2]){
        foot((3*Thick+2)+FootInset+F1Offset,(Thick+5)+FootInset,Thick/2,FDia,FHole,FHeight);
//    }
//    translate([(3*Thick+2)+BoardLength-FootInset,(Thick+5)+F2Offset+FootInset,Thick/2]){
        foot((3*Thick+2)+BoardLength-FootInset,(Thick+5)+F2Offset+FootInset,Thick/2,FDia,FHole,FHeight);
//    }
//    translate([(3*Thick+2)+BoardLength-FootInset,(Thick+5)+BoardWidth-FootInset-F3Offset,Thick/2] {
        foot((3*Thick+2)+BoardLength-FootInset,(Thick+5)+BoardWidth-FootInset-F3Offset,Thick/2,FDia,FHole,FHeight);
//    -}        
//    translate([(3*Thick+2)+FootInset+F4Offset,(Thick+5)+BoardWidth-FootInset,Thick/2]){
        foot((3*Thick+2)+FootInset+F4Offset,(Thick+5)+BoardWidth-FootInset,Thick/2,FDia,FHole,FHeight);
//    }        

} // Fin du module Feet
 
 ////////////////////////////////////////////////////////////////////////
////////////////////// <- Holes Panel Manager -> ///////////////////////
////////////////////////////////////////////////////////////////////////

//                           <- Panel ->  
module Panel(Length,Width,Thick,Filet){
    scale([0.5,1,1])
    minkowski(){
            cube([Thick,Width-(Thick*2+Filet*2+m),Height-(Thick*2+Filet*2+m)]);
            translate([0,Filet,Filet])
                rotate([0,90,0])
                    cylinder(r=Filet,h=Thick, $fn=100);
    }
}

//                          <- Circle hole -> 
// Cx=Cylinder X position | Cy=Cylinder Y position | Cdia= Cylinder dia | Cheight=Cyl height
module CylinderHole(OnOff,Cx,Cy,Cdia){
    if(OnOff==1)
        translate([Cx,Cy,-1])
            cylinder(d=Cdia,10, $fn=50);
}
//                          <- Square hole ->  
// Sx=Square X position | Sy=Square Y position | Sl= Square Length | Sw=Square Width | Filet = Round corner
module SquareHole(OnOff,Sx,Sy,Sl,Sw,Filet){
    if(OnOff==1)
     minkowski(){
        translate([Sx+Filet/2,Sy+Filet/2,-1])
            cube([Sl-Filet,Sw-Filet,10]);
            cylinder(d=Filet,h=10, $fn=100);
       }
}


 
//                      <- Linear text panel -> 
module LText(OnOff,Tx,Ty,Font,Size,Content){
    if(OnOff==1)
    translate([Tx,Ty,Thick+.5])
    linear_extrude(height = 1){
    text(Content, size=Size, font=Font);
    }
}
//                     <- Circular text panel->  
module CText(OnOff,Tx,Ty,Font,Size,TxtRadius,Angl,Turn,Content){ 
      if(OnOff==1) {
      Angle = -Angl / len(Content);
      translate([Tx,Ty,Thick+.5])
          for (i= [0:len(Content)-1] ){   
              rotate([0,0,i*Angle+90+Turn])
              translate([0,TxtRadius,0]) {
                linear_extrude(height = 1){
                text(Content[i], font = Font, size = Size,  valign ="baseline", halign ="center");
                    }
                }   
             }
      }
}
////////////////////// <- New module Panel -> //////////////////////
module FPanL(){
    if (LCDFeet==1) {
        rotate([180,270,180]){
            translate([LCDPosX,LCDPosY,0-Thick]){ 
                Feet(LCDWidth,LCDLength,LCDFootHeight,LCDFootDia,FootHole,0,0,0,0);
            }
        }
    }

    difference(){
        color(Couleur2) {
            Panel(Length,Width,Thick,Filet);
        }

        rotate([90,0,90]){
            color(Couleur2){
                //                     <- Cutting shapes from here ->  
                SquareHole  (0,6.5,22,72,25,1); //(On/Off, Xpos,Ypos,Length,Width,Filet)
                CylinderHole(0,Width/2-Thick,Height-5,6);       //(On/Off, Xpos, Ypos, Diameter)
                //                            <- To here -> 
            }
            translate ([-.75,0,-.85]){
//                     <- Adding text from here ->          
                LText(0,42,49,"Arial Black",4,"VPDMon 1.0");//(On/Off, Xpos, Ypos, "Font", Size, "Text")
                CText(0,20,11.8,"Arial Black",2.4,5,260,25,"1.3.5.7.9");//(On/Off, Xpos, Ypos, "Font", Size, Diameter, Arc(Deg), Starting Angle(Deg),"Text")
//                            <- To here ->
            }
        }
    }
}

module BPanL(Colour){
    difference(){
        Panel(Length,Width,Thick,Filet);
 
        rotate([90,0,90]){
            color(Colour){
//                     <- Cutting shapes from here ->
            SquareHole  (0,36.7,7,12,10.5,1); //(On/Off, Xpos,Ypos,Length,Width,Filet)
            CylinderHole(1,Width/2-Thick,Height-9,6.5);       //(On/Off, Xpos, Ypos, Diameter)
//                            <- To here -> 

            rotate([0,180,0])
            translate ([-96,-1,-3.35]){
//                     <- Adding text from here ->          
                LText(0,3,50,"Arial Black",3,"7g");//(On/Off, Xpos, Ypos, "Font", Size, "Text")
                CText(0,20,11.8,"Arial Black",2.4,5,260,25,"1.3.5.7.9");//(On/Off, Xpos, Ypos, "Font", Size, Diameter, Arc(Deg), Starting Angle(Deg),"Text")
//                            <- To here ->
            }
         }
      }
   }
}


/////////////////////////// <- Main part -> /////////////////////////

if(BShell==1) {
    // Coque bas - Bottom shell
    color(Couleur1){ 
        difference() {
            Coque();
            SquareHole(1,9,Width/2-6.3,16,12.6,0); //(On/Off, Xpos,Ypos,Length,Width,Filet)
        }
    }

    // Pied support PCB - PCB feet
    if (PCBFeet==1) {
    // Feet
        translate([PCBPosX,PCBPosY,0]){ 
            Feet(PCBLength,PCBWidth,FootHeight,FootDia,FootHole,Foot1Offset,Foot2Offset,Foot3Offset,Foot4Offset);
        }
    }
    foot(30, Width/2, Thick, FootDia,FootHole,Thick+2);
}

if(TShell==1) {
// Coque haut - Top Shell
    translate([0,Width,Height+0.2]){
        rotate([0,180,180]){
            color( Couleur1,1){
                Coque();
            }
            if (TPCBFeet==1) {
                translate([TPCBPosX,TPCBPosY,0]){ 
                    Feet(TPCBLength,TPCBWidth,TFootHeight,TFootDia,TFootHole,0,0,0,0);
                }
            }
        }
    }
}

// Panneau avant - Front panel  <<<<<< Text and holes only on this one.
//rotate([0,-90,-90]) 
if(FPanL==1)
        translate([Length-(Thick*2+m/2),Thick+m/2,Thick+m/2])
        FPanL();

//Panneau arrière - Back panel
if(BPanL==1)
        color(Couleur2)
        translate([Thick+m/2,Thick+m/2,Thick+m/2])
        BPanL(Couleur2);
