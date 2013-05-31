
// YOU NEED TO download the sqlitejdbc driver from http://code.google.com/p/sqlite-jdbc/
// and put the jar file into the 'code' directory.

// mbiles example

import processing.opengl.*;
import codeanticode.glgraphics.*;
import de.fhpotsdam.unfolding.*;
import de.fhpotsdam.unfolding.geo.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.providers.*;

// georss example
import de.fhpotsdam.unfolding.mapdisplay.*;
import de.fhpotsdam.unfolding.utils.*;
import de.fhpotsdam.unfolding.marker.*;
import de.fhpotsdam.unfolding.tiles.*;
import de.fhpotsdam.unfolding.interactions.*;
import de.fhpotsdam.unfolding.ui.*;
import de.fhpotsdam.unfolding.core.*;
import de.fhpotsdam.unfolding.data.*;

import de.fhpotsdam.unfolding.texture.*;
import de.fhpotsdam.unfolding.events.*;
import processing.opengl.*;
import codeanticode.glgraphics.*;

//movie maker
import processing.video.MovieMaker;


UnfoldingMap map;
float timeStamp = 0;
MovieMaker mm;
String movieName = "immigrationData";



void setup() {
  size(1280, 720);//, GLConstants.GLGRAPHICS);
  
  String mbTilesConnectionString = "jdbc:sqlite:";
  //mbTilesConnectionString += sketchPath("data/blank-1-3.mbtiles");
  mbTilesConnectionString += sketchPath("data/CycleMapMelbourne.mbtiles");

  map = new UnfoldingMap(this, new MBTilesMapProvider(mbTilesConnectionString));
  MapUtils.createDefaultEventDispatcher(this, map);
  map.setZoomRange(1, 17);
  
  List<Feature> countries = GeoJSONReader.loadData(this, "countries-simple.geo.json");
  List<Marker> countryMarkers = MapUtils.createSimpleMarkers(countries);
  map.addMarkers(countryMarkers);
 


  //mm = new MovieMaker(this, width, height, movieName+".mov", 30, MovieMaker.ANIMATION, MovieMaker.HIGH);
  mm = new MovieMaker(this, width, height, movieName+".mov");

  background(160, 32, 32);

  //frameRate(30);   
  
}

void draw() {
  
  Location mouseLocation = map.getLocation(mouseX, mouseY);
  //mouseLocation.
  //map.zoomAndPanTo
  //map.z
  map.draw();

  fill(0);
 text(mouseLocation.getLat() + ", " + mouseLocation.getLon(), mouseX, mouseY);
  
  timeStamp = timeStamp + 1;
  if(timeStamp <30)
  {
  mm.addFrame();
  }
  println("Outputting Movie..." + Float.toString(timeStamp));
  if(timeStamp > 30)
  {
     mm.finish();
     exit();
  }


}
 


void updateFame()
{
  
  
//  float ppt;
//  float tmp[];  

//  if (t<=maxt) {
//    for (int i=0; i<location.length; i++) {
//      tmp = lat2pix(location[i]);
//     ppt = immData[i][floor(t)]*dt/100000;
//      for (int j=0; j<ppt; j++)
//        tset.add(new trajectory(tmp[0]+random(10)-5,tmp[1]+random(10)-5,xf,yf,palette[colors[i]]));
//      if (random(1) < ((float)(ppt)-round(ppt)))
//        tset.add(new trajectory(tmp[0]+random(10)-5,tmp[1]+random(10)-5,xf,yf,palette[colors[i]]));
//    }
  
 // stepAll();
//  drawAll();
//  cleanAll();
//  smooth();

}


void displayTreeMap() {
  
}

void keyPressed() {
  if (key == ' ') {
    // Finish the movie if space bar is pressed
    mm.finish();
    // Quit running the sketch once the file is written
    exit();
  }
}



