//------Created by Dsphar------//

//User Entered Values
wallThickness = 2;
minDiameter = 35;
height = 30;
tiltDeg = 10;

//Execute
buildCombRect(5,5);

//Calculated Values
minRad = minDiameter/2;
minRadWall = minRad+wallThickness;
minDiam = minRadWall*2;
rad = 2*minRad / sqrt(3);
diam = rad*2;
evenRowBaseOffset = (minDiam-wallThickness)*cos(tiltDeg);

//modules
module buildCombRect(numRows, numColumns){
    for(col = [0:1:numColumns-1]){
        offsetCol(col)
        buildCol(numRows);
    }
}

module offsetCol(colNum){
    if (colNum%2 == 0){
        translate([0,colNum/2*(diam+rad+wallThickness*cos(30)*2),0])
        {
            for(i=[0:$children-1])
                children(i);
        }
    } else {
        translate([(evenRowBaseOffset+(minDiam)*sin(tiltDeg)/tan(90-tiltDeg))/2,    colNum*(diam-rad/2+wallThickness*cos(30)),0])
        {
            for(i=[0:$children-1])
            children(i);
        }
    }
}

module buildCol(size){  
    for(col = [0:1:size-1])   
        shiftX(col)       
        tiltHex(tiltDeg)  
        buildHex();
}

module buildHex(){
    linear_extrude(height)
    translate([-minRad-wallThickness,minRad/2+wallThickness*2,0])   
    rotate(30)
    difference(){
        circle(rad+wallThickness, $fn=6);
        circle(rad, $fn=6);
    };
}

module shiftX(units){
    translate([units*((minDiameter+wallThickness)*cos(tiltDeg)+(minDiameter+wallThickness)*sin(tiltDeg)/tan(90-tiltDeg)), 0, 0])
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

module buildPlate(){
translate([diam ,-minRad/2-wallThickness,0])
cube([minDiameter+wallThickness,10,wallThickness]);

}

