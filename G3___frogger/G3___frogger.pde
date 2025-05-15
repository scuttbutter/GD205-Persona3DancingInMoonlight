interface Command {
  void execute();
}

class MoveUp implements Command {
  Player player;
  MoveUp(Player p) { player = p; }
  public void execute() { player.move(0, -1); }
}

class MoveDown implements Command {
  Player player;
  MoveDown(Player p) { player = p; }
  public void execute() { player.move(0, 1); }
}

class MoveLeft implements Command {
  Player player;
  MoveLeft(Player p) { player = p; }
  public void execute() { player.move(-1, 0); }
}

class MoveRight implements Command {
  Player player;
  MoveRight(Player p) { player = p; }
  public void execute() { player.move(1, 0); }
}

// === PLAYER CLASS ===
class Player {
  int gridX, gridY;
  int size;

  Player(int gridX, int gridY, int size) {
    this.gridX = gridX;
    this.gridY = gridY;
    this.size = size;
  }

  void move(int dx, int dy) {
    int newX = gridX + dx;
    int newY = gridY + dy;

    if (newX >= 0 && newX < cols && newY >= 0 && newY < rows) {
      gridX = newX;
      gridY = newY;
    }
  }

  void display() {
    fill(0, 255, 0);
    rect(gridX * size, gridY * size, size, size);
  }

  boolean checkCollision(Car car) {
    float px = gridX * size;
    float py = gridY * size;
    return (px < car.x + car.w && px + size > car.x &&
            py < car.y + car.h && py + size > car.y);
  }
}

// === CAR CLASS ===
class Car {
  float x, y, speed;
  float w, h;
  color col;

  Car(float x, float y, float speed, int tileSize) {
    this.x = x;
    this.y = y;
    this.speed = speed;
    this.w = tileSize * 2;
    this.h = tileSize;
    col = color(random(255), random(255), random(255));
  }

  void update() {
    x += speed;
    if (x > width) {
      x = -w;
    }
  }

  void display() {
    fill(col);
    rect(x, y, w, h);
  }
}

// === GAME CONTROLLER ===
class GameController {
  Player player;
  ArrayList<Car> cars;
  int goalX;

  GameController() {
    resetLevel();
  }

  void resetLevel() {
    // Reset player position
    player = new Player(cols / 2, rows - 1, tileSize);

    // Reset goal position
    goalX = int(random(cols));

    // Reset cars
    cars = new ArrayList<Car>();
    for (int i = 1; i <= 5; i++) {
      float y = i * tileSize;
      cars.add(new Car(random(width), y, random(3.5, 8), tileSize));
    }

    // Reapply key bindings after reset
    setupKeyBindings();
  }

  void setupKeyBindings() {
    // Command setup
    keyCommands = new HashMap<Integer, Command>();
    keyCommands.put((int)'w', new MoveUp(player));
    keyCommands.put((int)'s', new MoveDown(player));
    keyCommands.put((int)'a', new MoveLeft(player));
    keyCommands.put((int)'d', new MoveRight(player));
    keyCommands.put(UP, new MoveUp(player));
    keyCommands.put(DOWN, new MoveDown(player));
    keyCommands.put(LEFT, new MoveLeft(player));
    keyCommands.put(RIGHT, new MoveRight(player));
  }

  void draw() {
    background(51);

    // Draw grid (optional)
    stroke(80);
    for (int i = 0; i < cols; i++) {
      line(i * tileSize, 0, i * tileSize, height);
    }
    for (int j = 0; j < rows; j++) {
      line(0, j * tileSize, width, j * tileSize);
    }

    // Draw goal tile
    noStroke();
    fill(255, 255, 0); // Yellow
    rect(goalX * tileSize, 0, tileSize, tileSize);

    // Update and draw cars
    for (int i = 0; i < cars.size(); i++) {
      Car car = cars.get(i);
      car.update();
      car.display();

      if (player.checkCollision(car)) {
        println("💥 Game Over!");
        noLoop();
      }
    }

    // Check if player reached the goal
    if (player.gridX == goalX && player.gridY == 0) {
      println("🎉 You Win!");
      resetLevel();  // Reset the level when player hits the goal
    }

    // Draw player
    player.display();
  }
}

// === GLOBALS ===
GameController controller;
HashMap<Integer, Command> keyCommands;

int tileSize = 40;
int cols, rows;

void setup() {
  size(600, 600);
  cols = width / tileSize;
  rows = height / tileSize;

  controller = new GameController();

  // Initially set up key bindings
  controller.setupKeyBindings();
}

void draw() {
  controller.draw();
}

void keyPressed() {
  int k = key;
  if (keyCommands.containsKey(k)) {
    Command cmd = keyCommands.get(k);
    cmd.execute();
  } else if (keyCommands.containsKey(keyCode)) {
    Command cmd = keyCommands.get(keyCode);
    cmd.execute();
  }
}
