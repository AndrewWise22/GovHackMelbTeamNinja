
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
//      println("Testing country ISO2 " + ISO2 + " " + name);
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
         
         //println("!!!!!!!!!! This country has immigrants: " + ISO2 + " " + name + currentCountry.refugeePercent);
  
         Location currentCountryLocation = new Location(latitude,longitude);
         SimplePointMarker currentCountryMarker = new SimplePointMarker(currentCountryLocation);
           // Adapt style
        currentCountryMarker.setColor(color(0, 0, 255, 100));
        currentCountryMarker.setStrokeColor(color(0, 0, 255));
  
        currentCountryMarker.setStrokeWeight(1);
  
        map.addMarkers(currentCountryMarker);
        countryHashMap.put(ISO2, currentCountry);
        
        // Create particles representing immigrants etc 
        float px, py, pz;
        float m, v, theta, phi;
        px = currentCountryMarker.getLocation().x;
        py = currentCountryMarker.getLocation().y;
        
        float dx = australiaLocation.x - px;
        float dy = australiaLocation.y - py;
        
        float SCALE = 1.0;/*
        for(int i = 0; i < immigrantCountry.total / SCALE; i++) {
          pz = random(width);
          particle p = new particle( px, py, pz, 0, 0, 0, 0.1 ); 
          p.colour = 0.5;
          p.home = new Location(currentCountryMarker.getLocation());
          p.home.x += (1 - random(2)) * 3;
          p.home.y += (1 - random(2)) * 3;
          p.dest = new Location(australiaLocation);
          println(p.dest.y);
          p.dest.x = p.dest.x + 2 - random(4);
          p.dest.y = p.dest.y + 2 - random(8);
          //p.colour = 33;
          
          p.respawn();
        
          Z.add(p);
       
        }
*/
        for(int i = 0; i < immigrantCountry.nonima / SCALE; i++) {
          pz = random(width);
          particle p = new particle( px, py, pz, 0, 0, 0, 0.1 ); 
          p.colour = 0.0;
//          p.home = new Location(-7, 106);
          p.home = currentCountryMarker.getLocation();
          p.dest = new Location(australiaLocation);
          println(p.dest.y);
          p.dest.x = p.dest.x + 2 - random(4);
          p.dest.y = p.dest.y + 2 - random(4);
          //p.colour = 33;
          
          p.respawn();
        
          Z.add(p);
       
        }
        // boat people "IMA" (irregular maritime arrival)
        for(int i = 0; i < immigrantCountry.ima / SCALE; i++) {
          pz = random(width);
          particle p = new particle( px, py, pz, 0, 0, 0, 0.1 ); 
          p.colour = 0.8;
          
          float r = random (1);
          // choose a home based on immigration figures derived from http://www.immi.gov.au/media/statistics/statistical-info/_pdf/tbl1-permanent-additions-eligibility-category-state.pdf
          if (r < 0.285089141004862) {
            p.dest = new Location(-25.4,148.9);
            // NSW
          } else if (r < 0.519611021069692) {
            p.dest = new Location (-37, 145);
            // VIC
          } else if (r < 0.658184764991896) {
          //QLD
            p.dest = new Location (-25.4, 144.8);
          } else if (r < 0.754781199351702) {
          //SA
            p.dest = new Location (-33.9, 138.7);
          } else if (r < 0.972285251215559) {
          // WA
            p.dest = new Location (-31.9, 117.2);

          } else {
            //TAS
            p.dest = new Location (-42.4, 147.1);

          }
            
          
          
          p.home = new Location(-7, 106); // all boat people leave from indonesia somewhere in our model...
//          p.home = currentCountryMarker.getLocation();
          println(p.dest.y);
          p.dest.x = p.dest.x + 2 - random(4);
          p.dest.y = p.dest.y + 2 - random(4);
          //p.colour = 33;
          
          p.respawn();
        
          Z.add(p);
       
        }



     }//if
     
  } //for
}


void LoadCountries() {

  List<Feature> countriesFeatureList = GeoJSONReader.loadData(this, "countries-simple.geo.json");
  List<Marker> countryPolygonMarkers = MapUtils.createSimpleMarkers(countriesFeatureList);
  setCountryMarkers(countryPolygonMarkers);
//  map.addMarkers(countryPolygonMarkers);
 
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




