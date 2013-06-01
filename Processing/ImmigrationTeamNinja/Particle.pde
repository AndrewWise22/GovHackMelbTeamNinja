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
    for(int i = int((Z.length-1000)*k/n); i < int((Z.length-1000)*(k+1)/n); i++) {
      v = sq(random(sqrt(m)));
      theta = random(TWO_PI);
      phi = random(TWO_PI);
      Z[i] = new particle( px+v*cos(phi)*cos(theta), py+v*cos(phi)*sin(theta), pz+v*sin(phi), 0, 0, 0, 1 );
    }
  }
  px = width/2;
  py = height/2;
  for(int i = Z.length-1000; i < Z.length; i++) {
    pz = random(depth);
    v = sq(random(sqrt(width/4)));
    theta = random(TWO_PI);
    Z[i] = new particle( px+v*cos(theta), py+v*sin(theta), pz, 0, 0, 0, 1 ); 
 
  }
}


void particleDraw() {

  float r;
  for(int i = 0; i < Z.length; i++) {
    if( mousePressed && mouseButton == LEFT ) {
      Z[i].gravitate( new particle( mouseX, mouseY, depth/2, 0, 0, 0, 0.75 ) );
    }
    else if( mousePressed && mouseButton == RIGHT ) {
      Z[i].repel( new particle( mouseX, mouseY, depth/2, 0, 0, 0, 1 ) );
    }
    else {
      Z[i].deteriorate();
    }

    Z[i].update();
    r = float(i)/Z.length;
    colorMode(HSB,1);
    if( Z[i].magnitude/100 < 0.1 ) {
      stroke( colour, pow(r,0.1), 0.9*sqrt(1-r), Z[i].magnitude/100+abs(Z[i].z/depth)*0.05 );
    }
    else {
      stroke( colour, pow(r,0.1), 0.9*sqrt(1-r), 0.1+abs(Z[i].z/depth)*0.05 );
    }
    Z[i].display();
  }

  colour+=random(0.01);
  colour = colour%1;

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
    magnitude *= 0.925;
  }
   
  void update() {
     
    x += magnitude * cos(phi) * cos(theta);
    y += magnitude * cos(phi) * sin(theta);
    z += magnitude * sin(phi);
 
  }
   
  void display() {
    line(px,py,x,y);
    px = x;
    py = y;
  }
   
   
}
