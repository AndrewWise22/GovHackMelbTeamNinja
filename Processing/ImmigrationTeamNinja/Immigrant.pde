

class Immigrant {
  String sourceCountry;
  String destinationCountry;
  String stream; //family // skill //Special Eligibility
  int year = 1900;
  String ISO2;
  String ISO3;
  int number= 0;
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
                        
                        Immigrant dataEntry = new Immigrant();
                        
			// Reads country name and population density value from CSV row
                        dataEntry.ISO2 = columns[0];
                        dataEntry.sourceCountry = columns[0];
                        dataEntry.stream = columns[1];
                        dataEntry.number = Integer.parseInt(columns[2]);
                        immigrantHashMap.put(dataEntry.sourceCountry, dataEntry);
                        println(dataEntry);
                        i++;
		}

		return immigrantHashMap;
	}
