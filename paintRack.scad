

//User Entered Values
wallThickness = 1;
minDiameter = 35;
tiltDeg = 30;
height = 50;
numColumns = 2;


//Calculated Values
minRad = minDiameter/2;
minRadWall = minRad+wallThickness;
minDiam = minRadWall*2;
Rad = 2*minRad / sqrt(3);
Diam = Rad*2;
evenRowBaseOffset = Rad*sin(60)+wallThickness;

module buildRow(){  
    for(col = [0:1:numColumns-1])   
        shiftX(col)       
        tiltHex(tiltDeg)  
        buildHex();
}

module buildPlate(){
translate([Diam ,-minRad/2-wallThickness,0])
cube([minDiameter+wallThickness,10,wallThickness]);

}

module buildHex(){
    linear_extrude(height)
    translate([-minRad-wallThickness,minRad/2+wallThickness*2,0])   
    rotate(30)
    difference(){
        circle(Rad+wallThickness, $fn=6);
        circle(Rad, $fn=6);
    };
}

buildRow();
buildPlate();

//middle
//translate([((inDiameter+wallThickness)*cos(tiltDeg)+(inDiameter+wallThickness)*sin(tiltDeg)/tan(90-tiltDeg))/2,0,1])
//buildRow();

//middle
translate([(minDiam*cos(tiltDeg)+(minDiam)*sin(tiltDeg)/tan(90-tiltDeg))/2,Diam-minRadWall/2,1])
buildRow();

translate([0,Diam+minRadWall+wallThickness,0])
buildRow();

module shiftX(units){
    translate([units*((minDiameter+wallThickness)*cos(tiltDeg)+(minDiameter+wallThickness)*sin(tiltDeg)/tan(90-tiltDeg)), 0, 0])
	//translate([units*((wallThickness+inDiameter)/cos(tiltDeg)), 0, 0])
    {
        for(i=[0:$children-1])
          children(i);
    }
}

module  tiltHex(deg){
    rotate([0,deg,0]){
        for(i=[0:$children-1])
          children(i);
    }
}

