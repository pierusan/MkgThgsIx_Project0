
//Number of circles evolving on the screen
int n = 10;
//Positions of our circles
float x[], y[];
//Delta positions of our circles
float sx[], sy[];
//Radiuses of the circles
float r[];
//Hue of the circles
float h[];
//Booleans storing if the circles are growing
boolean grow[];
//Boolean storing if the circles are bursting
boolean burst[];
//Maximum horizontal (and vertical) speed
float maxSpeed = 10;
//Default radius of our circles
float defaultRadius = 30;
//Maximum radius when grown
float maxRadius = 90;
//Radius easing when growing
float radiusEasingGrow = 0.12;
//Radius easing when bursting
float radiusEasingBurst = 0.2;
//Radius threshold
float radiusThreshold = 2;
//Saturation of our circles
float defaultSaturation = 150;
//Value of our circles
float defaultValue = 255;
//Transparency of our circles
float defaultA = 255;
//Value when bursting or growing
float burstA = 150;

//Current level
int currentLevel = 0;
//Are we starting the level
boolean startingLevel = true;


void setup() {
  size(3000,2000);
  
  colorMode(HSB);
  
  resetCircles();
}

//Initialize all our arrays
void resetCircles() {
  x = new float[n];
  y = new float[n];
  sx = new float[n];
  sy = new float[n];
  h = new float[n];
  r = new float[n];
  grow = new boolean[n];
  burst = new boolean[n];
  for (int i=1; i < n; i++) {
    x[i] = random(0,width);
    y[i] = random(0,height);
    sx[i] = random(-maxSpeed, maxSpeed);
    sy[i] = random(-maxSpeed, maxSpeed);
    h[i] = random(0,256);
    r[i] = defaultRadius;
    grow[i] = false;
    burst[i] = false;
  }
  x[0] = y[0] = sx[0] = sy[0] = r[0] = 0;
  h[0] = random(0, 256);
  grow[0] = false;
}

//Have a circle grow at the cursor position if the mouse is pressed
void mousePressed() {
  x[0] = mouseX;
  y[0] = mouseY;
  sx[0] = 0;
  sy[0] = 0;
  grow[0] = true;
}


void draw() {
  //Clear the screen and set background color to a dark grey
  background(20, 20, 20);
  
  if (startingLevel){
    startLevel();
    return;
  }
  
  for (int i=0; i < n; i++) {
    //Draw all our circles
    float a = defaultA;
    if (grow[i] || burst[i])
      a = burstA;
    
    fill(h[i], defaultSaturation, defaultValue, a);
    ellipse(x[i],y[i],2*r[i],2*r[i]);
    
    //Update their new position
    x[i] += sx[i];
    y[i] += sy[i];
    
    //Have the circles bounce if they reach the extents of the screen
    if (x[i] < 0 || x[i] > width) sx[i] = -sx[i];
    if (y[i] < 0 || y[i] > height) sy[i] = -sy[i];
    
    //Increase the radius of the growing circles
    if (grow[i]) r[i] += (maxRadius - r[i]) * radiusEasingGrow;
    
    //If they reached the maximum radius
    if (r[i] > maxRadius - radiusThreshold) { sx[i] = sy[i]; grow[i] = false; burst[i] = true;}
    
    //If they are bursting
    if (burst[i]) r[i] += (- r[i]) * radiusEasingBurst;
    
    //If they are bursting and get to small
    if (burst[i] && r[i] < radiusThreshold) {r[i] = 0; x[i] = y[i] = -100; burst[i] = false;}
  }
  
  //Handle Collision between 2 circles when at least one of them is growing
  for (int i=0; i < n; i++) {
    for (int j=i+1; j < n; j++) {
      if (grow[i] == false && grow[j] == false) continue;
      if (burst[i] || burst[j]) continue;
      if (dist(x[i],y[i],x[j],y[j]) < r[i]+r[j]) { grow[i] = grow[j] = true;  sx[i] = sx[j] = sy[i] = sy[j] = 0; }
    }
  }
  
}

void startLevel(){
  
  switch(currentLevel){
    case 0: 
      
      break;
    default: 
      
  }
  startingLevel = false;
  delay(1000);
}