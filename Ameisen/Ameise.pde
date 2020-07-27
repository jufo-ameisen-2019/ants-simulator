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
    dir = PVector.random2D().setMag(speed);
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
        dir = new PVector(home.x-pos.x, home.y-pos.y).setMag(speed);
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
        dir = new PVector(fund.x-pos.x, fund.y-pos.y).setMag(speed);
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
      dir = new PVector(ants.get(guide).pos.x-pos.x, ants.get(guide).pos.y-pos.y).setMag(speed);
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
