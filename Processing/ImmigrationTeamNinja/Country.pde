
// Even though there are multiple objects, we still only need one class. 
// No matter how many cookies we make, only one cookie cutter is needed.

class State {
  float ima_r, nonima_r, immi_r;
  Location location;
  int total=0;
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

  State nsw = new State(),vic = new State(),qld = new State(),sa = new State(),wa = new State(),tas = new State(), nt = new State(), act = new State();

float ima_r[];
float nonima_r[];
float immi_r[];
int totals[];
   State[] states = new State[] { nsw, vic, qld, sa, wa, tas, nt, act };

  void load_states() {
    // whoops, the "non-ima" figures are actually offshore refugees - totally different :( Means the proportions are wrong.
  ima_r = new float[] { 0.268713718301253, 0.48976474182707, 0.620378857317446, 0.711426825542316, 0.916437519095631, 0.942560342193706, 0.98380690498014, 1 };
  nonima_r = new float [] { 0.25844772967265, 0.540258711721225, 0.700633579725449, 0.83078141499472, 0.930834213305174, 0.978616684266104, 0.988648363252376, 1 };
  immi_r = new float [] { 0.354698248654663, 0.443244428753303, 0.501428250473409, 0.731301687154304, 0.955339089129249, 0.96286013843866, 0.978394368306747, 1 };
  totals = new int [] { 70025, 20135, 12947, 44555, 42910, 1939, 3250, 4231 } ;
   
   for (int i = 0; i < states.length; i++) {
     states[i].ima_r = ima_r[i];
     states[i].nonima_r = nonima_r[i];
     states[i].immi_r = immi_r[i];
     states[i].total = totals[i];
   }
    nsw.location = new Location(-33.0,150.0);
    vic.location = new Location (-38, 145.0);
    qld.location = new Location (-25.4, 150.0);
    sa.location = new Location (-33.0, 137.5);
    wa.location = new Location (-32.5, 118.5);
    tas.location = new Location (-42.5, 147.0);
    
    act.location = nsw.location; // har!
    nsw.total += act.total; // har har!
    act.total = nsw.total; // trust me.
    
    nt.location = new Location (-12, 131);    
  }

State selectState(float[] r_table) {
  float r = random(1);
  float result = r_table[0];
  int i=0;
  while (r > r_table[i]) 
    i++;
  
  return states[i];
}      
      

// Pick a random location given a state
Location chooseDestination(State state) {
  final float pi = 3.141592654;
  float t = 2*pi*random(1);
  float u = random(1)+random(1);
  float r;
  if (u>1) { r =  2 - u; } else { r =  u; }
  float CIRCLESCALE = 50.0; // this magic figure determines the size of the circle at each state.
  float radius = sqrt(state.total) / CIRCLESCALE;
  return new Location(state.location.x + r * cos(t) * radius, state.location.y + r * sin(t) * radius);
}


void DebugFeatures(List<Feature> countriesFeatureList) {
  
  
  List<Marker> customMarkers = new ArrayList<Marker>();   
  
  float longitude = 0;
  float latitude = 0;
  String name = "";
  
  int total_immi=0, total_nonima=0, total_ima=0;
  
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
  
        //map.addMarkers(currentCountryMarker); // country circles
        countryHashMap.put(ISO2, currentCountry);
        
        // Create particles representing immigrants etc 
        float px, py, pz;
        float m, v, theta, phi;
        px = currentCountryMarker.getLocation().x;
        py = currentCountryMarker.getLocation().y;
        
        float dx = australiaLocation.x - px;
        float dy = australiaLocation.y - py;
        
        float SCALE = 10.0; // each dot represents how many people?
          float dw, dh;
        
         load_states();
        
        
        
        
        // Create immigrant particles
        float BODGY_SCALE = 184998.0 / (58233.0 + 44311.0); // there's 120,000 immigrants missing - bad countries?
/*        int total_incoming = immigrantCountry.total * BODGY_SCALE / SCALE + 
                             immigrantCountry.nonima / SCALE * 2272.0 / 2014.0 + 
                             immigrantCountry.ima / SCALE * 4766.0 / 3891.0;
  */                           
        for(int i = 0; i < immigrantCountry.total * BODGY_SCALE / SCALE; i++) {
          total_immi ++; 
          pz = random(width);
          particle p = new particle( px, py, pz, 0, 0, 0, 0.1 ); 
          
          p.home = new Location(currentCountryMarker.getLocation());
          p.home.x += (1 - random(2)) * 3;
          p.home.y += (1 - random(2)) * 3;

          /// Pick a state!
          float r = random (1);
          // choose a home based on immigration figures derived from http://www.immi.gov.au/media/statistics/statistical-info/_pdf/tbl1-permanent-additions-eligibility-category-state.pdf
          p.dest = chooseDestination(selectState(immi_r));
          
          p.respawn();
          p.colour = 17.0/360.0;// + (0.5 - random(1.0)) * 5.0;
          p.lum = 0.5 + random (0.5);
          p.sat = 0.5 + random(0.5);
        
          Z.add(p);
       
        }

        for(int i = 0; i < immigrantCountry.nonima / SCALE * 2272.0 / 2014.0; i++) {
          total_nonima ++; 
          pz = random(width);
          particle p = new particle( px, py, pz, 0, 0, 0, 0.1 ); 
          p.colour = 0.0;
//          p.home = new Location(-7, 106);
          p.home = currentCountryMarker.getLocation();

          /// Pick a state!
          // choose a home based on immigration figures derived from http://www.immi.gov.au/media/statistics/statistical-info/_pdf/tbl1-permanent-additions-eligibility-category-state.pdf
          p.dest = chooseDestination(selectState(nonima_r));
          
          p.respawn();
          p.colour = 120.0/360.0;
          p.lum = 0.6 + random (0.4)  + (0.5 - random(1.0)) * 5.0;
          p.sat = 0.5 + random(0.5);
        
          Z.add(p);
       
        }
        // boat people "IMA" (irregular maritime arrival)
        for(int i = 0; i < immigrantCountry.ima / SCALE * 4766.0 / 3891.0; i++) {
          total_ima ++; 
          pz = random(width);
          particle p = new particle( px, py, pz, 0, 0, 0, 0.1 ); 
          p.colour = 0.8;
          
          
          /// Pick a state!
          p.dest = chooseDestination(selectState(ima_r));

          p.home = new Location(-7, 106); // all boat people leave from indonesia somewhere in our model...

          //p.colour = 33;
          
          p.respawn();
          p.colour = 126.0/256.0;
          p.lum = 0.5 + random (0.5) + (0.5 - random(1.0)) * 5.0;
          p.sat = 0.5 + random(0.5);
          Z.add(p);
       
        }



     }//if
     
  } //for
  println ("Total immi, non-ima, ima: " + total_immi + ", " + total_nonima + ", " + total_ima);
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




