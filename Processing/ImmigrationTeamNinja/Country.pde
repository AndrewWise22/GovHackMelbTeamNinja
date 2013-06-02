
// Even though there are multiple objects, we still only need one class. 
// No matter how many cookies we make, only one cookie cutter is needed.

class State {
  float ima_r, nonima_r, immi_r;
  Location location;
  float dw = 4.0, dh = 4.0;
}


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

  State nsw = new State(),vic = new State(),qld = new State(),sa = new State(),wa = new State(),tas = new State();
  void load_states() {
    nsw.ima_r = 0.285089141004862;
    // whoops, the "non-ima" figures are actually offshore refugees - totally different :( Means the proportions are wrong.
    nsw.nonima_r = 0.264094955489614;
    nsw.immi_r = 0.370586887389829;
    nsw.location = new Location(-38.0,150.0); // not the actual lat long - no idea why I have to fudge all these
    
            // NSW
    vic.ima_r = 0.519611021069692;
    vic.nonima_r = 0.552063663339628;
    vic.immi_r = 0.463099476322746;
    vic.location = new Location (-36, 150);
            // VIC
    qld.ima_r = 0.658184764991896;
    qld.nonima_r = 0.715942810898301;
    qld.immi_r = 0.523889630966819;
    qld.location = new Location (-25.4, 150.0);
    qld.dh = 6;
    
    sa.ima_r =  0.754781199351702;
    sa.nonima_r = 0.848934448340977;
    sa.immi_r = 0.764060203323143;
    sa.location = new Location (-33.9, 138.7);

    wa.ima_r = 0.972285251215559;
    wa.nonima_r = 0.951173455624494;
    wa.immi_r = 0.992142046756498;
    wa.location = new Location (-34.5, 119.2);
    wa.dh = 8;
    
    tas.ima_r = 1.0;        //TAS
    tas.nonima_r = 1.0;
    tas.immi_r = 1.0;
    tas.location = new Location (-44.0, 148.1);
    tas.dw = 0.025; 
    tas.dh = 0.025;    
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
        
        float SCALE = 1.0;
        
         load_states();
        
        
        
        /*
        // Create immigrant particles
        
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
          float[] nonima_r = {0.264094955489614, 0.552063663339628, 0.715942810898301, 0.848934448340977, 0.951173455624494, 1};
          particle p = new particle( px, py, pz, 0, 0, 0, 0.1 ); 
          p.colour = 0.0;
//          p.home = new Location(-7, 106);
          p.home = currentCountryMarker.getLocation();

          /// Pick a state!
          float r = random (1);
          float dw = 4.0, dh = 4.0; // size of target area          
          // choose a home based on immigration figures derived from http://www.immi.gov.au/media/statistics/statistical-info/_pdf/tbl1-permanent-additions-eligibility-category-state.pdf
          State dest_state;
          if (r < nsw.nonima_r) { 
            dest_state = nsw;
          } else if (r < vic.nonima_r) {
            dest_state = vic;
          } else if (r < qld.nonima_r) {
            dest_state = qld;
          } else if (r < sa.nonima_r) {
            dest_state = sa;
          } else if (r < wa.nonima_r) {
            dest_state = wa;
          } else {
            dest_state = tas;
          }
          p.dest = new Location(dest_state.location);
          dh = dest_state.dh;
          dw = dest_state.dw;
          
          p.dest.x = p.dest.x + dh/2.0 - random(dh);
          p.dest.y = p.dest.y + dw/2.0 - random(dw);
          
          p.respawn();
        
          Z.add(p);
       
        }
        // boat people "IMA" (irregular maritime arrival)
        for(int i = 0; i < immigrantCountry.ima / SCALE; i++) {
          pz = random(width);
          particle p = new particle( px, py, pz, 0, 0, 0, 0.1 ); 
          p.colour = 0.8;
          
          
          /// Pick a state!
          float r = random (1);
          float dw = 4.0, dh = 4.0; // size of target area          
          // choose a home based on immigration figures derived from http://www.immi.gov.au/media/statistics/statistical-info/_pdf/tbl1-permanent-additions-eligibility-category-state.pdf
          State dest_state;
          if (r < nsw.ima_r) { 
            dest_state = nsw;
          } else if (r < vic.ima_r) {
            dest_state = vic;
          } else if (r < qld.ima_r) {
            dest_state = qld;
          } else if (r < sa.ima_r) {
            dest_state = sa;
          } else if (r < wa.ima_r) {
            dest_state = wa;
          } else {
            dest_state = tas;
          }
          p.dest = new Location(dest_state.location);
          dh = dest_state.dh;
          dw = dest_state.dw;
          
          p.dest.x = p.dest.x + dh/2.0 - random(dh);
          p.dest.y = p.dest.y + dw/2.0 - random(dw);



          p.home = new Location(-7, 106); // all boat people leave from indonesia somewhere in our model...

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




