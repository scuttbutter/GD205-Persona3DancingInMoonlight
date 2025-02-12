float triangleSize = 100;

void setup() {
  size(600, 600);
}

void draw() {
  background(35);
  
  float angle = atan2(mouseY - height / 2, mouseX - width / 2);
  
  pushMatrix();
  translate(width / 2, height / 2);  
  rotate(angle);  
  
  fill(100, 150, 255);
  noStroke();
  beginShape();
  vertex(0, -triangleSize / 2); 
  vertex(triangleSize / 2, triangleSize / 2); 
  vertex(-triangleSize / 2, triangleSize / 2); 
  endShape(CLOSE);
  
  popMatrix();
}
