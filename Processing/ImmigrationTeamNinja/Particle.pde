// Sourced from http://www.openprocessing.org/sketch/8062 Claudio Gonzales 
// It's based off one of my old programs that I thought up, when I was just starting to mess around with particles and the idea of attraction. See the Particle Swarm (http://openprocessing.org/visuals/?visualID=2363). I know my particle code has been recycled a few times around the site, but I can't name any sketches offhand.


void particleSetup() {
  depth = width;
  //background(255);
  //frameRate(25);
  
  float n = 100;
  float px, py, pz;
  float m, v, theta, phi;
  
  for(int k = 0; k < n; k++) {
    px = random(width);
    py = random(height);
    pz = random(depth);
    m = random(50);
    for(int i = int((Z.size()-1000)*k/n); i < int((Z.size()-1000)*(k+1)/n); i++) {
      v = sq(random(sqrt(m)));
      theta = random(TWO_PI);
      phi = random(TWO_PI);
      Z.add(new particle( px+v*cos(phi)*cos(theta), py+v*cos(phi)*sin(theta), pz+v*sin(phi), 0, 0, 0, 1 ));
    }
  }
  px = width/2;
  py = height/2;
  int i;
  for(i = 0; i < 100; i++) {
    pz = random(depth);
    v = sq(random(sqrt(width/4)));
    theta = random(TWO_PI);
    Z.add(new particle( px+v*cos(theta), py+v*sin(theta), pz, 0, 0, 0, 1 )); 
 
  }
}


void particleDraw() {

  float r;
  for(int i = 0; i < Z.size(); i++) {
/*    if( mousePressed && mouseButton == LEFT ) {
      if(i==0) { println("Particle 0 at " + ((particle) Z.get(i)).x); } 
    }
    else if( mousePressed && mouseButton == RIGHT ) {
      ((particle) Z.get(i)).repel( new particle( mouseX, mouseY, depth/2, 0, 0, 0, 1 ) );
    }
    
    else {
      ((particle) Z.get(i)).deteriorate();
    }
    */
    ((particle) Z.get(i)).deteriorate(); 
 /*
    ((particle) Z.get(i)).gravitate( new particle( 
      australiaLocation.x,
      australiaLocation.y,
      depth/2, 0, 0, 0, 0.05 )); */

    particle p =     ((particle) Z.get(i));
    p.update();
    r = float(i)/Z.size();
    colorMode(HSB,1);

    if(p.magnitude/100 < 0.1 ) {
      stroke( colour, pow(r,0.1), 0.9*sqrt(1-r), ((particle) Z.get(i)).magnitude/100+abs(((particle) Z.get(i)).z/depth)*0.05 );
    }
    else {
      stroke( colour, pow(r,0.1), 0.9*sqrt(1-r), 0.1+abs(((particle) Z.get(i)).z/depth)*0.05 );
    }
    p.display();/*
    if ( p.magnitude == 0) {
      Z.remove(i);
    }*/
  }
/*
  colour+=random(0.01);
  colour = colour%1;
*/
  //filter(INVERT);
  
  
}

class particle {
   
  float x;
  float y;
  float z;
  float px;
  float py;
  float magnitude;
  float theta;
  float phi;
  float mass;
  Location home;
  Location dest;
   
  particle( float dx, float dy, float dz, float V, float T, float P, float M ) {
    x = dx;
    y = dy;
    z = dz;
    px = dx;
    py = dy;
    magnitude = V;
    theta = T;
    phi = P;
    mass = M;
  }
   
  void reset ( float dx, float dy, float dz, float V, float T, float P, float M ) {
    x = dx;
    y = dy;
    z = dz;
    px = dx;
    py = dy;
    magnitude = V;
    theta = T;
    phi = P;
    mass = M;
  }
  
  void respawn() {
      float dx = dest.x - home.x;
      float dy = dest.y - home.y;
      float delta = random(1.0);
 
      x = home.x + delta * dx + 2 - random(4.0);
      y = home.y + delta * dy + 2 - random(4.0);
      px = x;
      py = y;
      // push it in the right direction
      gravitate( new particle( 
        dest.x + 2 - random(4),
        dest.y + 2 - random(4),
        depth/2, 0, 0, 0, 5.0 + random (5.0) ));
   
    
  }
   
  void gravitate( particle C ) {
    float dx, dy, dz;
    float F, t, p;
    if( sq( x - C.x ) + sq( y - C.y ) + sq( z - C.z ) != 0 ) {
      F = mass * C.mass;
      // magnitude
 
      dx = ( mass * x + C.mass * C.x ) / ( mass + C.mass );
      dy = ( mass * y + C.mass * C.y ) / ( mass + C.mass );
      dz = ( mass * z + C.mass * C.z ) / ( mass + C.mass );
      // find point to which particle is being attracted (dx,dy,dz)
       
      t = atan2( dy-y, dx-x );                          // find yaw angle
      p = atan2( dz-z, sqrt( sq(dy-y) + sq(dx-x) ) ) ;  // find depth angle
       
      dx = F * cos(p) * cos(t);
      dy = F * cos(p) * sin(t);
      dz = F * sin(p);
 
      dx += magnitude * cos(phi) * cos(theta);
      dy += magnitude * cos(phi) * sin(theta);
      dz += magnitude * sin(phi);
       
      magnitude = sqrt( sq(dx) + sq(dy) + sq(dz) );
      theta = atan2( dy, dx );
      phi = atan2( dz, sqrt( sq(dx) + sq(dy) ) );
 
    }
  }
 
  void repel( particle C ) {
    float dx, dy, dz;
    float F, t, p;
    if( sq( x - C.x ) + sq( y - C.y ) + sq( z - C.z ) != 0 ) {
      F = mass * C.mass;
      // magnitude
 
      dx = ( mass * x + C.mass * C.x ) / ( mass + C.mass );
      dy = ( mass * y + C.mass * C.y ) / ( mass + C.mass );
      dz = ( mass * z + C.mass * C.z ) / ( mass + C.mass );
      // find point to which particle is being attracted (dx,dy,dz)
       
      t = atan2( y-dy, x-dx );                          // find yaw angle
      p = atan2( z-dz, sqrt( sq(dy-y) + sq(dx-x) ) ) ;  // find depth angle
       
      dx = F * cos(p) * cos(t);
      dy = F * cos(p) * sin(t);
      dz = F * sin(p);
 
      dx += magnitude * cos(phi) * cos(theta);
      dy += magnitude * cos(phi) * sin(theta);
      dz += magnitude * sin(phi);
       
      magnitude = sqrt( sq(dx) + sq(dy) + sq(dz) );
      theta = atan2( dy, dx );
      phi = atan2( dz, sqrt( sq(dx) + sq(dy) ) );
 
    }
  }
   
  void deteriorate() {
//    magnitude *= 0.925;
//    magnitude *= 0.90;
    float d = (x - dest.x) * (x - dest.x) + (y - dest.y) * (y - dest.y);
    if (d < 20) {
        //magnitude = 0;
        x = home.x;
        y = home.y;
        px = home.x;
        py = home.y;
        
    } 
  }
   
  void update() {
    magnitude = min (magnitude, 1);     
    if (random(10)<2) { phi += (1 - random(2)) * 0.5; }
    x += magnitude * cos(phi) * cos(theta) + (2 - random(4))*0.1;
    y += magnitude * cos(phi) * sin(theta) + (2 - random(4))*0.1;
    z += magnitude * sin(phi);
      gravitate( 
      new particle( 
        dest.x,
        dest.y,
        depth/2, 0, 0, 0, (5.0 + random (5.0) )/0.1));
    

 
  }
   
  void display() {
    Location pl = new Location (px, py);
    Location l = new Location(x,y);
    line(map.getScreenPosition(pl).x, map.getScreenPosition(pl).y,
         map.getScreenPosition(l).x, map.getScreenPosition(l).y);
    px = x;
    py = y;
  }
   
   
}
