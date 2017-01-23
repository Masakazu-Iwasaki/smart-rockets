
Population population; //Create a Population object, which contains the rockets
float mutationRate = 100; //Percent chance of a mutation to occur
int numBoosters = 6; //Number of boosters each Rocket should have
PVector target; //The target the rockets are aiming for
PVector obstacle; //the obstacle the rockets should go around
int timer = 300; //The amount of time left
int time = 300; //The maximum amount of time

void setup() {
  size(800, 800);
  target = new PVector(width/2, 200); //Set location of the target
  obstacle = new PVector(150, 500); //set location of the obstacle
  population = new Population(mutationRate, numBoosters, 50); //initialize the population
}

void draw() {
  background(127); //set background colour
  strokeWeight(3); //Three pixel outline
  stroke(0); //Black outline
  fill(150); //grayish fill colour
  ellipse(target.x, target.y, 45, 45); //draw the target
  rect(obstacle.x, obstacle.y, 500, 50); //draw the obstacle

  fill(255); //White fill colour
  textSize(24); 
  text("Timer:", 15, 30);
  text(timer, 213, 30);
  text("Average Fitness:", 15, 60);
  text(population.avgFitness, 205, 60);
  text("Max Fitness:", 15, 90);
  text(population.maxFitness, 205, 90);

  if (timer == 0) {
    timer = time; //set timer to the max time
    population.calculateFitness(target); //calculate the fitness of each rocket in the population
    population.buildGenepool(); //build a genepool (this also builds the next population)
  } else {
    for (Rocket r : population.popu) { //for each rocket in the population
      if (!r.dead) { //If that rocket is not dead
        r.fire(); //fire the booster
        r.update(target, obstacle); //update position, velocity, acceleration, check collisions
        r.age++; //The rocket gets older
      }
      r.show(); //display the rocket
    }
  }
  timer --; //the timer goes down
}