

class Immigrant {
  /* Immigration/refugee statistics for a country */
  String sourceCountry;
  String destinationCountry;
  int family;
  int skill;
  int specialeligibility;
  int nonima=0, ima=0;
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
  dataEntriesMap = loadMigrationDataFromCSV("migration_citizenship_small.csv");
  loadAsylumDataFromCSV("non-ima-asylum-citizenship-2011.csv");
  println("Loaded " + dataEntriesMap.size() + " data entries"); 

  
}

Immigrant getImmigrant(String countrycode) {
        Immigrant dataEntry;
         if (immigrantHashMap.containsKey(countrycode)) {
          // update the existing one
          dataEntry = (Immigrant)immigrantHashMap.get(countrycode);
//          println("Found countrycode " + countrycode);
        } else {
          dataEntry = new Immigrant();
          dataEntry.ISO2 = countrycode;
          dataEntry.sourceCountry = countrycode;
          immigrantHashMap.put(dataEntry.sourceCountry, dataEntry);
        }
        return dataEntry;
 
}

  public HashMap<String, Immigrant> loadMigrationDataFromCSV(String fileName) {
          
      int i = 0;
      String[] rows = loadStrings(fileName);
      for (String row : rows) {
   //println(i);
        String[] columns = row.split(",");
        String countrycode = columns[0];
        
        Immigrant dataEntry = getImmigrant(countrycode);
        
        if (columns[1].equalsIgnoreCase("Family"))
          dataEntry.family = Integer.parseInt(columns[2]);
        else if (columns[2].equalsIgnoreCase("Skill"))
          dataEntry.family = Integer.parseInt(columns[2]);
        else if (columns[2].equalsIgnoreCase("Special Eligibility"))
          dataEntry.specialeligibility = Integer.parseInt(columns[2]);
          
  //          println(dataEntry);
        dataEntry.total = dataEntry.family + dataEntry.skill + dataEntry.specialeligibility;
        i++;
      }
      Immigrant nz = getImmigrant("NZ");
      nz.total = 44311; // NZ immigration is special. From http://www.immi.gov.au/media/statistics/statistical-info/_pdf/tbl1-permanent-additions-eligibility-category-state.pdf
      return immigrantHashMap;
  }
  

void loadAsylumDataFromCSV(String fileName) {
  String[] nonimacountries = "IR,PK,CN,EG,IQ,LK,ZW,TR,FJ,LB,AF,SY,BH,PG,IN,BD,MM,NP,ER,Stateless,Others,".split(",");
  String[] nonimavalues = "351,309,264,204,146,125,101,70,68,54,48,46,45,41,34,30,30,27,21,29,229,2272,".split(",");
  
  int i=0;
  for (String c: nonimacountries) {
    Immigrant dataEntry = getImmigrant(c);
    dataEntry.nonima = Integer.parseInt(nonimavalues[i++]);
//    println("non IMA" + c + " " + dataEntry.nonima);
  }
  

  String[] imacountries = "AF,IR,IQ,LK,Stateless,Other".split(",");
  String[] imavalues = "1972,1272,348,299,624,251".split(",");  

  i=0;
  for (String c: imacountries) {
    Immigrant dataEntry = getImmigrant(c);
    dataEntry.ima = Integer.parseInt(imavalues[i++]);
//    println("IMA" + c + " " + dataEntry.ima);
  }
  
}


