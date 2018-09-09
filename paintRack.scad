//------Created by Dsphar------//

//User Entered Values
wallThickness = 1.25;
minDiameter = 35;
height = 35;
tiltDeg = 10;
screwDiameter = 5;
screwHoleOffset = 9;

//Execute example 1
numRows = 6;
numCols = 5;
buildCombRect(numRows,numCols);
addMountingPlate(2, numRows, 2, numCols); //(row, numRows, col, numCols)
addMountingPlate(2, numRows, 4, numCols); //(row, numRows, col, numCols)
addMountingPlate(5, numRows, 3, numCols); //(row, numRows, col, numCols)

//------Hope you find it usefull, for updates, see repo below------//
//

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

module buildHex(){
    linear_extrude(height)
    translate([-minRad-wallThickness,rad+wallThickness,0])   
    rotate(30)
    difference(){
        circle(rad+wallThickness, $fn=6);
        circle(rad, $fn=6);
    };
}

module buildCol(size){  
    for(i = [0:1:size-1])   
        shiftObjectX(i)       
        tiltHex(tiltDeg)  
        buildHex();
}

module offsetCol(colNum){
    
    xShift = (colNum%2 == 0) ? 0 
        : (evenRowBaseOffset+(minDiam)*sin(tiltDeg)/tan(90-tiltDeg))/2;
    yShift = (colNum%2 == 0) ? colNum/2*(diam+rad+wallThickness*cos(30)*2) 
        : colNum*(diam-rad/2+wallThickness*cos(30));
        
    translate([xShift,yShift,0])
    {
        for(i=[0:$children-1])
        children(i);
    }
}

module shiftObjectX(units){
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

module addMountingPlate(row, numRows, col,  numCols){
    place(numRows-row,numCols-col) 
    translate([-minDiam*cos(tiltDeg) - (minDiam)*sin(tiltDeg)/tan(90-tiltDeg)+wallThickness/2,(minDiameter+wallThickness)*.33,0])
    difference(){
        
        cube([minDiam*cos(tiltDeg) + (minDiam)*sin(tiltDeg)/tan(90-tiltDeg)-wallThickness/2,minRadWall+wallThickness/2,wallThickness]);
    
        translate([minDiam-screwHoleOffset, (minRadWall+wallThickness/2)/2, -1])
        cylinder(wallThickness+2, screwDiameter/2, screwDiameter/2+.5);
    }
}

module place(row,column){
    offsetCol(column)
    shiftObjectX(row)
    {
        for(i=[0:$children-1])
        children(i);
    }
    
}

