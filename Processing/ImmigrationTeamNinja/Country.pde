// Even though there are multiple objects, we still only need one class. 
// No matter how many cookies we make, only one cookie cutter is needed.
class Country { 
  color c;
  float xpos;
  float ypos;
  float xspeed;
  String name;
  float population;
  float refugeeCount;
  int code;
  String ISO2;
  String ISO3;
  Marker countryMarker;
  float refugeePercent;
   
  //Location countryCentroid;

  Country() {
    
    
  }

  // The Constructor is defined with arguments.
  Country(String tempName, color tempC, float tempXpos, float tempYpos, float tempXspeed) { 
    name = tempName;
    c = tempC;
    xpos = tempXpos;
    ypos = tempYpos;
    xspeed = tempXspeed;
  }

  void display() {
    stroke(0);
    fill(c);
    rectMode(CENTER);
    rect(xpos,ypos,20,10);
  }

}


void DebugFeatures(List<Feature> countriesFeatureList) {
  
  
  List<Marker> customMarkers = new ArrayList<Marker>();   
  
  float longitude = 0;
  float latitude = 0;
  String name = "";
  for(Feature currentFeature : countriesFeatureList) {
     HashMap featureHashMap = currentFeature.getProperties();
     //println(featureHashMap);
     name = currentFeature.getStringProperty("NAME");
     //println(name);
     //Object temp = currentFeature.getProperty("LON");
     //Double longi = (Double) temp;
     //println(temp.getClass());
     //println(longi);

     
     Double latDouble = (Double) currentFeature.getProperty("LAT");
     Double longDouble = (Double) currentFeature.getProperty("LON");
     
     Object temp = currentFeature.getProperty("POP2005");
     //println(temp.getClass());
     Integer popInt = (Integer) currentFeature.getProperty("POP2005");
     int population = popInt.intValue();
     
     latitude = latDouble.floatValue();
     longitude = longDouble.floatValue();
     
     //latitude = Float.parseFloat((Double)  currentFeature.getStringProperty("LAT"));
     name = currentFeature.getStringProperty("NAME");
     String ISO2 = currentFeature.getStringProperty("ISO2");
     // println(name);
      Immigrant immigrantCountry = immigrantHashMap.get(ISO2);
      println("Testing country ISO2 " + ISO2 + " " + name);
      if (immigrantCountry != null && immigrantCountry.ISO2 != null) {     
     
       Country currentCountry = new Country();
       currentCountry.name = name;


       currentCountry.population = population;
       
       if(population > 0)
       {
         currentCountry.refugeePercent = (float)immigrantCountry.total / (float) population;
       }
        else
       { 
          currentCountry.refugeePercent = 0;
       }
       
       println("!!!!!!!!!! This country has immigrants: " + ISO2 + " " + name + currentCountry.refugeePercent);

       Location currentCountryLocation = new Location(latitude,longitude);
       SimplePointMarker currentCountryMarker = new SimplePointMarker(currentCountryLocation);
         // Adapt style
      currentCountryMarker.setColor(color(0, 0, 255, 100));
      currentCountryMarker.setStrokeColor(color(0, 0, 255));

      currentCountryMarker.setStrokeWeight(1);

      map.addMarkers(currentCountryMarker);
      countryHashMap.put(ISO2, currentCountry);
  
  
      
      /* test adding particles too */
      float px, py, pz;
      float m, v, theta, phi;
      px = currentCountryMarker.getScreenPosition(map).x;
      py = currentCountryMarker.getScreenPosition(map).y;
      println(ISO2 + " " + immigrantCountry.total);
        for(int i = 0; i < immigrantCountry.total; i++) {
          pz = random(width);
          //v = sq(random(sqrt(width/4)));
          v = 2.0-random(5.0);
          theta = random(TWO_PI);
          particle p = new particle( px+v*cos(theta), py+v*sin(theta), pz, 0, 0, 0, 1 ); 
          // push it in the right direction
         p.gravitate( new particle( 
          map.getScreenPosition(australiaLocation).x + 20 - random(40),
          map.getScreenPosition(australiaLocation).y + 20 - random(40),
          depth/2, 0, 0, 0, 5.0 + random (5.0) ));
      
          Z.add(p);

//          println("Added particle." + px + "," + py);
       
        }

      
     }
  }
}


void LoadCountries() {

  List<Feature> countriesFeatureList = GeoJSONReader.loadData(this, "countries-simple.geo.json");
  List<Marker> countryPolygonMarkers = MapUtils.createSimpleMarkers(countriesFeatureList);
  setCountryMarkers(countryPolygonMarkers);
  map.addMarkers(countryPolygonMarkers);
 
  DebugFeatures(countriesFeatureList);
  
}

// shader maps taken from unolding examples
// https://github.com/tillnagel/unfolding/blob/master/examples/de/fhpotsdam/unfolding/examples/data/choropleth/ChoroplethMapApp.java

void setCountryMarkers(List<Marker> countryPolygonMarkers) {
  
	for (Marker marker : countryPolygonMarkers) {
		// Find data for country of the current marker
		String countryId = marker.getId();
		//DataEntry dataEntry = dataEntriesMap.get(countryId);
                float transparency = map(random(1000), 0, 700, 10, 255);
                marker.setColor(color(255, 0, 0, transparency));
    }


}



