float triangleSize = 20;  // Size of the bullet
ArrayList<Bullet> bullets = new ArrayList<Bullet>();  // Array to store bullets

void setup() {
  size(600, 600);
}

void draw() {
  background(35);
  
  // Draw the shooter (center triangle)
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

  // Update and draw bullets
  for (int i = bullets.size() - 1; i >= 0; i--) {
    Bullet b = bullets.get(i);
    b.update();
    b.display();
    if (b.isOffScreen()) {
      bullets.remove(i);
    }
  }
}

void mousePressed() {
  // Create a new bullet when the mouse is pressed
  float angle = atan2(mouseY - height / 2, mouseX - width / 2);
  bullets.add(new Bullet(width / 2, height / 2, angle));
}

// Bullet class to handle each individual bullet
class Bullet {
  float x, y;
  float speed = 5;
  float angle;
  
  Bullet(float startX, float startY, float a) {
    x = startX;
    y = startY;
    angle = a;
  }
  
  void update() {
    // Move the bullet in the direction of the angle
    x += cos(angle) * speed;
    y += sin(angle) * speed;
  }
  
  void display() {
    pushMatrix();
    translate(x, y);
    rotate(angle);
    
    fill(255, 0, 0);
    noStroke();
    beginShape();
    vertex(0, -triangleSize / 2); 
    vertex(triangleSize / 2, triangleSize / 2); 
    vertex(-triangleSize / 2, triangleSize / 2); 
    endShape(CLOSE);
    
    popMatrix();
  }
  
  boolean isOffScreen() {
    return x < 0 || x > width || y < 0 || y > height;
  }
}
