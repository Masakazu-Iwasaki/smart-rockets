class Rocket {

  PVector pos; //position vector
  PVector vel; //velocity vector
  PVector acc; //acceleration vector
  DNA dna; //the Rocket's DNA
  float mutationRate; //mutation rate
  int timer; //how much time is left for the current booster
  int boostersFired; //how many boosters have been fired
  int numBoosters; //total number of boosters
  float fitness; //fitness of the Rocket
  float age; //age of the rocket
  float dir; //direction the Rocket is firing
  float mag; //magnitude of the force
  boolean done; //is the rocket done?
  boolean dead; //is the rocket dead?
  boolean collided; //has the rocket hit anything?

  Rocket (float mutationRate_, int numBoosters_) { //initialisation function for the Rocket object
    pos = new PVector(width/2, height - 20); //set the initial position of the rocket
    vel = new PVector(0, 0); //the initial velocity is 0
    acc = new PVector(0, 0); //the initial acceleration is 0
    mutationRate = mutationRate_; //the mutation rate is the value specified
    timer = 0; //the timer starts at 0
    fitness = 0; //fitness starts at 0
    numBoosters = numBoosters_; //the number of boosters is the value specified
    boostersFired = -1; //the boosters fired starts at -1
    dna = new DNA(mutationRate, numBoosters); //initialise the DNA of the Rocket
    age = 0; //the rocket starts at age 0
    dead = false; //the rocket is not dead
    done = false; //it is not done
    collided = false; //and it is not collided
  }

  void show() { //shows the rocket on the screen
    stroke(0); //black outline
    strokeWeight(1); //one pixel outlin
    fill(250); //light gray fill
    ellipse(pos.x, pos.y, 16, 16 ); //draws a circle at the Rocket's location
  }


  void mutate() { //mutates the DNA of the Rocket
    ArrayList<ArrayList> newGenes = new ArrayList<ArrayList>(); //new ArrayList to store the new genes
    for (ArrayList<Float> i : dna.genes) { //for each ArrayList in the genes ArrayList
      ArrayList<Float> temp = new ArrayList(); //temporary ArrayList to store float values
      for (int j = 0; j < i.size(); j++) { //looping through the ArrayList i
        float t = i.get(j) + random(-.05 * i.get(j), .05 * i.get(j)); //temp float that is the value of the sub - gene
        if (j == 0) { //if the sub-gene is the direction
          t = constrain(t, 0, TWO_PI); //make sure it stays between 0 and 2 pi
        }
        temp.add(t); //add the temporary float to the temporary ArrayList
      }
      newGenes.add(temp);//add the temporary ArrayList to the newGenes arrayList
    }
    dna.genes = newGenes; //the rocket's genes are now the new genes.
  }


  Rocket crossover() { //performs a crossover operation on the Rocket
  //(well, it used to before I realised that was kinda silly for Rockets
  
    Rocket newRocket = new Rocket(mutationRate, numBoosters); //create a new Rocket
    ArrayList<ArrayList> a = new ArrayList<ArrayList>(dna.genes); //copy the genes of this Rocket
    newRocket.dna.genes = a; //the new Rocket's genes are now this rocket's genes
    return newRocket; //return the new Rocket
  }


  void fire() { //fires the thrusters of the Rocket
    if (timer == 0) { //if the timer is 0

      boostersFired += 1; //One more booster has finished firing

      if (boostersFired == numBoosters) { //if all the boosters have been fired
        done = true; //the rocket is done
      }

      if (!done) { //if the rocket is not done
        ArrayList<Float> gene = new ArrayList<Float>(dna.genes.get(boostersFired)); //grabs the genes for the booster the rocket should fire
        dir = gene.get(0); //direction is the first value of the ArrayList
        timer = int(gene.get(1)); //the duration is the second value of the ArrayList
        mag = gene.get(2); //the magnitude is the third value of the ArrayList
      }
    } else {
      applyForce(dir, mag); //Apply a force with the given direction and magnitude
      timer -= 1; //reduce the timer by one
    }
  }


  void applyForce(float dir_, float mag_) { //applys a force to the rocket
    PVector force = PVector.fromAngle(dir_); //create a new PVector pointing in the direction specified
    force.setMag(mag_); //set the magnitude of the force
    acc.add(force); //add the force to the acceleration
  }

  void update(PVector target, PVector o) { //updates the position, velocity and acceleration of the rocket and checks collisions

    vel.add(acc); //add the acceleration to the velocity
    vel.limit(4); //limit the velocity to 4
    pos.add(vel); //add the velocity to the position
    acc.mult(0); //set the acceleration to 0

    if (dist(pos.x, pos.y, target.x, target.y) < 25) { //if the Rocket is touching the target
      dead = true; //it is dead
    }

    PVector o2 = new PVector(o.x + 500, o.y + 50); //o is the obstacle's top left corner, o2 is the obstacle's bottom right corner

    if (pos.x > o.x && pos.x < o2.x && pos.y > o.y && pos.y < o2.y) { //if the rocket is touching the obstacle
      dead = true; //the particle is dead
      collided = true; //the particle has collided
    }
  }
}