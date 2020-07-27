class Futter {
  //x, y Position f\u00fcr Futter
  int x, y;
  //Qualit\u00e4t q des Futters (1-10);
  int q;
  //Menge m
  int m;

  int c;

  Futter(int q, int m, int x, int y) {
    this.q = q;
    this.m = m;
    this.x = x;
    this.y = y;
    this.c = color(random(255), random(255), random(255));
  }

  void show() {
    fill(c);
    noStroke();
    ellipse(x, y, 20, 20);
  }

  void update() {
    if (m < 1) {
      for (int i = 0; i < ants.size(); i++) {
        ants.get(i).weg(x, y);
      }
      stellen.remove(this);
    }
  }
}
