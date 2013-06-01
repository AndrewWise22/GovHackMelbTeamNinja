
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

//treemap
import treemap.*;

/*
Variable declarations

*/

UnfoldingMap map;
float timeStamp = 0;
float frameRate = 30;
Calendar currentDate = Calendar.getInstance();
MovieMaker mm;
String movieName = "immigrationData";
boolean outputToMovie = false;
boolean autoAnimation = false;


/*
  Particle variables
*/

particle[] Z = new particle[8000];
float colour = random(1);
boolean tracer = false;
int depth;
// end particle variables

void setup() {
  size(1280, 720);//, GLConstants.GLGRAPHICS);
  
  particleSetup();
  
  String mbTilesConnectionString = "jdbc:sqlite:";
  //mbTilesConnectionString += sketchPath("data/blank-1-3.mbtiles");
  mbTilesConnectionString += sketchPath("data/CycleMapMelbourne.mbtiles");

  map = new UnfoldingMap(this, new MBTilesMapProvider(mbTilesConnectionString));
  MapUtils.createDefaultEventDispatcher(this, map);
  map.setZoomRange(1, 12);
  
  
  List<Feature> countries = GeoJSONReader.loadData(this, "countries-simple.geo.json");
  List<Marker> countryMarkers = MapUtils.createSimpleMarkers(countries);
  map.addMarkers(countryMarkers);
 
  if(outputToMovie) {
    //mm = new MovieMaker(this, width, height, movieName+".mov", 30, MovieMaker.ANIMATION, MovieMaker.HIGH);
    mm = new MovieMaker(this, width, height, movieName+".mov");
  }
  background(160, 32, 32);


  currentDate.set(Calendar.YEAR, 1900);

  //frameRate(30);   
  
}

void draw() {
  
  Location mouseLocation = map.getLocation(mouseX, mouseY);
  //mouseLocation.
  //map.zoomAndPanTo
  //map.z
  map.draw();

  fill(255,0,0,191);
  rect(0,50,200,40);
  text(mouseLocation.getLat() + ", " + mouseLocation.getLon(), mouseX, mouseY);
  rect(100,100,20,100);


  particleDraw();  
  colorMode(RBG,1); // reset colour mode back to RBG as particles force different mode


  
  drawTeamNinja();
  drawCalendarStamp();

  
  timeStamp = timeStamp + 1;
  
  if(outputToMovie)
  {
  movieRender();
  }

}



void movieRender() {
  
  if(timeStamp < frameRate * 5) // render 5 seconds
  {
    if(outputToMovie)
    {
    println("Outputting Movie Fame: " + Float.toString(timeStamp));  
    mm.addFrame();
    }
  }
  else
  {
     mm.finish();
     exit();    
  }
 
  
}

void drawCalendarStamp() {
  fill(255,0,0);
  textSize(48);
  println("Current DateTime = " + currentDate);
  
  text(currentDate.get(Calendar.YEAR), 1000, 680);

  if(timeStamp % frameRate == 0)
  {
    currentDate.add(Calendar.YEAR,1);
  }
  
}


void drawTeamNinja() {
  fill(255);
  textSize(24);
  text("#GovHack 2103 Melbourne - Team Ninja's Immigration Presentation", 50, 700);
  
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
  if (key == 'm') {
    // Start recording the movie
    mm.finish();

  }


  if (key == 'q') {
    // Finish the movie if space bar is pressed
    mm.finish();
    // Quit running the sketch once the file is written
    exit();
  }
  
  if (key == ' ') {
    // Pause the animation time increase
    autoAnimation = false;

  }  
}



