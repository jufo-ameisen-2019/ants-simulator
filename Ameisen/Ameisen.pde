ArrayList<Ant> ants = new ArrayList<Ant>();
ArrayList<Bau> bauten = new ArrayList<Bau>();
ArrayList<Futter> stellen = new ArrayList<Futter>();
boolean play = true;

int anzahl_stellen = 1000;
int anzahl_ameisen = 10000;

public void setup() {
  //size(1000, 1000);
  fullScreen(FX2D);
  frameRate(1000);
  starte();
}
void starte() {
  for (int i = 0; i < anzahl_stellen; i++) {
    stellen.add(new Futter(int(random(9)), int(random(3000, 4000)), int(random(200, width-200)), int(random(200, height-200))));
  }
  neuerStaat(width/2,height/2,anzahl_ameisen);
}
void neuerStaat(int x, int y, int ameisen) {
  bauten.add(new Bau(x, y, bauten.size()));
  //wasser = new Futter(10, random(width), random(height));

  //100 Ameisen mit Heimatbau
  for (int i = 0; i < ameisen; i++) {
    ants.add(new Ant(ants.size(), bauten.get(bauten.size()-1)));
  }
}

void draw() {
  background(255);
  //Bau, Ameisen und Wasser anzeigen
  for (Bau i : bauten) {
    i.show();
  }
  for (Futter i : stellen) {
    i.show();
  }
  for (Ant i : ants) {
    i.show();
    if (play) {
      i.wasTun();
      i.move();
      i.torus();
    }
  }
  info();
  for (int i = 0; i < stellen.size(); i++) {
    stellen.get(i).update();
  }
  for (Bau i : bauten) {
    i.showLabel();
  }
}

void info() {
  textAlign(LEFT);
  textSize(30);
  fill(0);
  text("Futterstellen:", 30, 30);
  for (int i = 0; i < stellen.size(); i++) {
    fill(stellen.get(i).c);
    text(stellen.get(i).q+" : "+stellen.get(i).m, 30, 60+30*i);
  }

  textAlign(RIGHT);
  textSize(30);
  fill(0);
  text("Staaten:", width-30, 30);
  for (int i = 0; i < bauten.size(); i++) {
    fill(0);
    text("Staat "+i+" : "+bauten.get(i).m, width-30, 60+30*i);
  }
  textSize(20);
  textAlign(RIGHT,BOTTOM);
  text("0-9 neuer Futterpunkt, R = Reset, S = neuer Staat",width-10,height);
}

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
    fill(#FF408A);
    noStroke();
    ellipse(x, y, 50, 50);
  }
  void showLabel(){
    fill(#0EC95A);
    textSize(30);
    textAlign(CENTER,CENTER);
    text(id,x,y);
  }
  void increaseM() {
    m++;
  }
}

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

class Ant {
  int id;
  //x, y Position abh\u00e4ngig vom Heimatbau home
  PVector pos;
  Bau home;

  PVector dir;
  //ob Ameise Futter gefunden hat und welches
  boolean gefunden = false;
  Futter fund;
  //ob Ameise auf Suche nach Begleiter zu Futterstelle ist
  boolean sucheB = false;
  //ob Ameise nach Hause soll
  boolean goHome = false;
  //ID der zu folgenden Ameise
  boolean folge = false;
  int guide;

  Ant(int id, Bau home) {
    this.id = id;
    this.home = home;
    pos=new PVector(home.x, home.y);
    dir = PVector.random2D().normalize();
  }

  void show() {
    strokeWeight(3);
    stroke(0);
    if (gefunden) {
      stroke(fund.c);
    }
    point(pos.x, pos.y);
  }

  void move() {
    if (folge == false) {
      if ((goHome==false && gefunden == false )|| (sucheB == true && goHome ==false)) {
        //Wenn Ameise auf Suche nach Futter -> zuf\u00e4llige Bewegung entweder nach links, rechts, oben oder unten
        /*switch(int(random(4))) {
         case 0:
         pos.x++;
         break;
         case 1:
         pos.x--;
         break;
         case 2:
         pos.y++;
         break;
         case 3:
         pos.y--;
         break;
         }*/
        dir.rotate(radians(random(-90, 90)));
        pos.add(dir);
      } else if (goHome) {
        //Wenn Ameise Futter gefunden hat, kehrt sie zum Bau zur\u00fcck
        /*switch(int(random(2))) {
         case 0:
         if (pos.x<home.x) {
         pos.x++;
         } else {
         pos.x--;
         }
         break;
         case 1:
         if (pos.y<home.y) {
         pos.y++;
         } else {
         pos.y--;
         }
         break;
         }*/
        dir = new PVector(home.x-pos.x, home.y-pos.y).normalize();
      dir.rotate(radians(random(-90, 90)));
        pos.add(dir);
      } else if (gefunden && sucheB == false) {
        /*switch(PApplet.parseInt(random(2))) {
        case 0:
          if (pos.x<fund.x) {
            pos.x++;
          } else {
            pos.x--;
          }
          break;
        case 1:
          if (pos.y<fund.y) {
            pos.y++;
          } else {
            pos.y--;
          }
          break;
        }*/
      dir = new PVector(fund.x-pos.x, fund.y-pos.y).normalize();
      dir.rotate(radians(random(-90, 90)));
      pos.add(dir);
      }

    } else {
      /*if (pos.x<ants.get(guide).pos.x) {
       pos.x++;
       } else {
       pos.x--;
       }
       if (pos.y<ants.get(guide).pos.y) {
       pos.y++;
       } else {
       pos.y--;
       }*/
      dir = new PVector(ants.get(guide).pos.x-pos.x, ants.get(guide).pos.y-pos.y).normalize();
      pos.add(dir);
    }
  }

  //das "Gehirn" der Ameise
  void wasTun() {
    for (Futter i : stellen) {
      if (dist(pos.x, pos.y, i.x, i.y)<10 && (gefunden == false || fund.q <= i.q)) {
        i.m--;
        home.increaseM();
        gefunden = true;
        goHome = true;
        folge = false;
        fund = i;
        break;
      }
    }
    if (goHome) {
      if (dist(pos.x, pos.y, home.x, home.y)<2) {
        goHome=false;
        sucheB = true;
      }
    }
    if (sucheB) {
      for (int i = 0; i < ants.size(); i++) {
        if (i != id && dist(pos.x, pos.y, ants.get(i).pos.x, ants.get(i).pos.y)<6) {
          if (ants.get(i).fund != this.fund && (ants.get(i).gefunden == false) || ants.get(i).fund.q < this.fund.q) {
            ants.get(i).folgen(id, fund.q);
          }
          sucheB = false;
          break;
        }
      }
    }
  }

  void weg(int fx, int fy) {
    if (gefunden && fund.x == fx && fund.y == fy) {
      gefunden=false;
      folge=false;
      goHome=true;
    }
  }

  void folgen(int wer, int s) {
    int d = PApplet.parseInt(random(0, 9));
    if (s>d) {
      println("JA"+ants.get(wer).fund);
      folge=true;
      guide=wer;
    } else {
      println("NEIN"+ants.get(wer).fund);
    }
  }


  //Ameise kann das Feld nicht verlassen und wird so auf einem "Donut" gehalten
  void torus() {
    pos.x=(pos.x+width)%width;
    pos.y=(pos.y+height)%height;
  }
}

void reset() {
  bauten = new ArrayList<Bau>();
  stellen = new ArrayList<Futter>();
  ants = new ArrayList<Ant>();
  starte();
}

void keyPressed() {
  println(keyCode);
  if (int(key) >= 48 && int(key) <= 57) {
    stellen.add(new Futter(int(key-48), 3000, mouseX, mouseY));
  } else if (keyCode == 32) {
    play = !play;
  } else if (keyCode == 82) {
    reset();
  }else if(keyCode == 83){
    neuerStaat(mouseX,mouseY,anzahl_ameisen);
  }
}
