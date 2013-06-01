

class Immigrant {
  String sourceCountry;
  String destinationCountry;
  int family;
  int skill;
  int specialeligibility;
  int year = 1900;
  int total = 0;
  String ISO2;
  String ISO3;
  //particle immigrantParticle = new particle
  
  Immigrant() {
    
    
  }  
  
  Immigrant(String sourceCountry) {
    
    
  }
  
  void display() {
    stroke(0);
    //fill(c);
    rectMode(CENTER);
    //rect(xpos,ypos,20,10);
  }
  
  
}



void LoadImmigrantData() {
    HashMap<String, Immigrant> dataEntriesMap;  
  dataEntriesMap = loadPopulationDensityFromCSV("migration_citizenship_small.csv");
  println("Loaded " + dataEntriesMap.size() + " data entries"); 

  
}


	public HashMap<String, Immigrant> loadPopulationDensityFromCSV(String fileName) {

                int i = 0;
		String[] rows = loadStrings(fileName);
		for (String row : rows) {
                       println(i);
                        String[] columns = row.split(",");
                        String countrycode = columns[0];
                        Immigrant dataEntry;
                        if (immigrantHashMap.containsKey(countrycode)) {
                          // update the existing one
                          dataEntry = (Immigrant)immigrantHashMap.get(countrycode);
                          println("Found countrycode " + countrycode);
                        } else {
                          dataEntry = new Immigrant();
                          dataEntry.ISO2 = columns[0];
                          dataEntry.sourceCountry = columns[0];
                          immigrantHashMap.put(dataEntry.sourceCountry, dataEntry);
                        }
                        
                        if (columns[1].equalsIgnoreCase("Family"))
                          dataEntry.family = Integer.parseInt(columns[2]);
                        else if (columns[2].equalsIgnoreCase("Skill"))
                          dataEntry.family = Integer.parseInt(columns[2]);
                        else if (columns[2].equalsIgnoreCase("Special Eligibility"))
                          dataEntry.specialeligibility = Integer.parseInt(columns[2]);
                          
                        println(dataEntry);
                        dataEntry.total = dataEntry.family + dataEntry.skill + dataEntry.specialeligibility;
                        i++;
		}

		return immigrantHashMap;
	}
