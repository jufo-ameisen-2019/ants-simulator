ArrayList<Ant> ants = new ArrayList<Ant>();
ArrayList<Bau> bauten = new ArrayList<Bau>();
ArrayList<Futter> stellen = new ArrayList<Futter>();
boolean play = true;
boolean f3 = false;
boolean schau = true;

int last_update;

float speed;

JSONObject config;

int anzahl_stellen = 100;
int anzahl_ameisen = 1000;
int anzahl_futter = 3000;

float ant_speed = 1;

int schau_ameisen = 500;
int schau_stellen = 100;
int schau_futter = 2000;
int schau_bauten = 4;
float schau_speed = 0.5;
int schau_intervall = 5;
int schau_margin = 200;

boolean config_exception = false;

public void setup() {
  try {
    config = loadJSONObject("config.json");
  }
  catch(Exception e) {
  }
  println(config);
  try {
    anzahl_ameisen = config.getJSONObject("Standard").getInt("Ameisen");
    anzahl_stellen = config.getJSONObject("Standard").getInt("Futterstellen");
    ant_speed = config.getJSONObject("Standard").getFloat("Geschwindigkeit");

    schau_ameisen = config.getJSONObject("Schau").getInt("Ameisen");
    schau_stellen = config.getJSONObject("Schau").getInt("Futterstellen");
    schau_bauten = config.getJSONObject("Schau").getInt("Bauten");
    schau_speed = config.getJSONObject("Schau").getFloat("Geschwindigkeit");
    schau_intervall = config.getJSONObject("Schau").getInt("Minutenintervall");
    schau_margin = config.getJSONObject("Schau").getInt("Margin");
  }
  catch(Exception e) {
    println("Config file seems to be corrupted");
    config_exception = true;
  }
  speed = ant_speed;
  last_update = minute();
  //size(1000, 1000);
  fullScreen(FX2D);
  frameRate(1000);
  schau();
}

void starte() {
  speed = ant_speed;
  for (int i = 0; i < anzahl_stellen; i++) {
    stellen.add(new Futter(int(random(9)), int(random(anzahl_futter*0.8, anzahl_futter*1.2)), int(random(width)), int(random(height))));
  }
  neuerStaat(width/2, height/2, anzahl_ameisen);
}
void neuerStaat(int x, int y, int ameisen) {
  bauten.add(new Bau(x, y, bauten.size()));
  //wasser = new Futter(10, random(width), random(height));

  //100 Ameisen mit Heimatbau
  for (int i = 0; i < ameisen; i++) {
    ants.add(new Ant(ants.size(), bauten.get(bauten.size()-1)));
  }
}

void schau() {
  speed = schau_speed;
  for (int i = 0; i < 100; i++) {
    stellen.add(new Futter(int(random(9)), int(random(schau_futter*0.8, schau_futter*1.2)), int(random(width)), int(random(height))));
  }
  for (int i = 0; i < 4; i++) {
    neuerStaat((int)random(schau_margin, width-schau_margin), (int)random(schau_margin, height-schau_margin), anzahl_ameisen);
  }
}

void draw() {
  background(255);
  intervall();
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
  for (int i = 0; i < stellen.size(); i++) {
    stellen.get(i).update();
  }
  if (f3) {
    info();
    for (Bau i : bauten) {
      i.showLabel();
    }
  }
  if (config_exception) {
    config_error();
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
  textAlign(RIGHT, BOTTOM);
  text("0-9 neuer Futterpunkt, R/F5 = Reset, S = neuer Staat, TAB = Schaumodus ein/aus, H/F3 = GUI ein/aus", width-10, height);
  textSize(30);
  textAlign(CENTER, TOP);
  if (schau) {
    text("Schaumodus", width/2, 0);
  } else {
    text("Standardmodus", width/2, 0);
  }
}

void config_error() {
  if (config_exception) {
    fill(255, 0, 0);
    textSize(20);
    textAlign(RIGHT, BOTTOM);
    text("ERROR: config file missing or corrupt", width-10, height-25);
  }
}

void reset() {
  bauten = new ArrayList<Bau>();
  stellen = new ArrayList<Futter>();
  ants = new ArrayList<Ant>();
  if (schau) {
    schau();
  } else {
    starte();
  }
}

void intervall() {
  if (schau) {
    if (minute() - last_update >= schau_intervall) {
      schau();
    }
  }
}

void keyPressed() {
  println(keyCode);
  if (int(key) >= 48 && int(key) <= 57) {
    stellen.add(new Futter(int(key-48), 3000, mouseX, mouseY));
  } else if (keyCode == 32) {
    play = !play;
  } else if (keyCode == 82 || keyCode == 116) {
    reset();
  } else if (keyCode == 83) {
    neuerStaat(mouseX, mouseY, anzahl_ameisen);
  } else if (keyCode == 114 || keyCode == 72) {
    f3 = !f3;
  } else if (keyCode == 9) {
    schau = !schau;
  }
}
