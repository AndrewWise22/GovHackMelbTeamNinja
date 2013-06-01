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
