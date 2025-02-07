int numCircles = 5;
float[] angles;
float[] speeds;
float[] radii;
float[] vx;
float[] vy;
float[] xPos;
float[] yPos;
float[] colorProgress;
float circleSize = 50;
float resetRadius = 0;
boolean isMousePressed = false;

void setup() {
  size(800, 800);
  noStroke();

  angles = new float[numCircles];
  speeds = new float[numCircles];
  radii = new float[numCircles];
  vx = new float[numCircles];
  vy = new float[numCircles];
  xPos = new float[numCircles];
  yPos = new float[numCircles];
  colorProgress = new float[numCircles];

  for (int i = 0; i < numCircles; i++) {
    angles[i] = random(TWO_PI);
    speeds[i] = random(0.01, 0.05);
    radii[i] = random(50, 200);
    vx[i] = cos(angles[i]) * speeds[i];
    vy[i] = sin(angles[i]) * speeds[i];
    colorProgress[i] = 0;
  }
}

void draw() {
  background(35);
  for (int i = 0; i < numCircles; i++) {
    colorProgress[i] = min(colorProgress[i] + 0.002, 1);

    float adjustedSpeed = map(colorProgress[i], 0, 1, 0.05, 0.01);

    vx[i] = cos(angles[i]) * adjustedSpeed;
    vy[i] = sin(angles[i]) * adjustedSpeed;

    xPos[i] += vx[i];
    yPos[i] += vy[i];

    float x = width / 2 + cos(angles[i]) * radii[i];
    float y = height / 2 + sin(angles[i]) * radii[i];

    color c = lerpColor(color(255), color(255, 0, 0), colorProgress[i]);

    fill(c);
    ellipse(x, y, circleSize, circleSize);

    for (int j = i + 1; j < numCircles; j++) {
      float dx = xPos[i] - xPos[j];
      float dy = yPos[i] - yPos[j];
      float distance = sqrt(dx * dx + dy * dy);

      if (distance < circleSize) {
        float angleOfCollision = atan2(dy, dx);

        float vx1New = cos(angleOfCollision) * vx[i] + sin(angleOfCollision) * vy[i];
        float vy1New = cos(angleOfCollision) * vy[i] - sin(angleOfCollision) * vx[i];

        float vx2New = cos(angleOfCollision) * vx[j] + sin(angleOfCollision) * vy[j];
        float vy2New = cos(angleOfCollision) * vy[j] - sin(angleOfCollision) * vx[j];

        vx[i] = vx2New;
        vy[i] = vy2New;
        vx[j] = vx1New;
        vy[j] = vy1New;
      }
    }

    angles[i] += speeds[i];
  }

  fill(255, 0, 0, 50);
  ellipse(mouseX, mouseY, resetRadius * 2, resetRadius * 2);
}

void mousePressed() {
  isMousePressed = true;
  resetRadius = 20;

  for (int i = 0; i < numCircles; i++) {
    float x = width / 2 + cos(angles[i]) * radii[i];
    float y = height / 2 + sin(angles[i]) * radii[i];

    float distance = dist(mouseX, mouseY, x, y);
    if (distance < resetRadius) {
      colorProgress[i] = 0;
    }
  }
}

void mouseReleased() {
  isMousePressed = false;
  resetRadius = 0;
}

void mouseDragged() {
  if (isMousePressed) {
    resetRadius += 1;
  }
}
//so i wanted the colors of the circles to reset only when the mouse is released.
//aswell as like I wanted the red to start at one circle and to spread it to the other circles as they pass each other.
//also meant to include a timer which like theoretically wouldve been easy but i left it for last and passed out :3
