class Bau {
  //x, y Position für Bau
  float x, y;
  int m = 0;
  int id;

  Bau(float x, float y, int id) {
    this.x = x;
    this.y = y;
    this.id = id;
  }

  void show() {
    fill(#894711);
    noStroke();
    ellipse(x, y, 50, 50);
  }
  void showLabel() {
    fill(255);
    textSize(30);
    textAlign(CENTER, CENTER);
    text(id, x, y);
  }
  void increaseM() {
    m++;
  }
}
