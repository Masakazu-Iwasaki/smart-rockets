class Population { //Create a new class Population

  ArrayList<Rocket> popu; //popu is an ArrayList that will store the Rockets
  ArrayList<Rocket> nextPopu; //nextPopu is an ArrayList that stores the next generation's Rockets
  float mutationRate; //stores the mutation rate
  int numBoosters; //stores the number of boosters
  float maxFitness; //stores the max fitness
  float avgFitness; //stores the avgFitness

  Population(float mutationRate_, int numBoosters_, int number) { //initialisation function for Populations, number is the number of Rockets
    popu = new ArrayList<Rocket>(); //Create a new ArrayList to store the Rockets
    nextPopu = new ArrayList<Rocket>(); //Create a new ArrayList to store the next generation's Rockets
    mutationRate = mutationRate_; //the mutation rate is the value specified
    numBoosters = numBoosters_; //the number of boosters is the value specified
    maxFitness = 0; //the maxFitness starts at zero
    for (int i = 0; i < number; i++) { 
      popu.add(new Rocket(mutationRate, numBoosters)); //adds 'number' of Rockets to the population
    }
  } 


  void calculateFitness(PVector target) { //calculates the fitnesses of each rocket
    maxFitness = 0; //maxFitness starts out as 0
    avgFitness = 0; //avgFitness starts out as 0
    float maxDist = dist(width/2, height - 20, target.x, target.y); //the '''''maximum distance''''' a rocket can be from target
    for (Rocket r : popu) { //for each Rocket r in the populations
      if (r.collided) { //if r bumped into something
        r.fitness = 5; //its fitness is 5
      } else { 

        float a = maxDist - dist(r.pos.x, r.pos.y, target.x, target.y); //a is the maxdistance - the actual distance
        a = constrain(a, 1, maxDist); //make sure a is between 1 and maxDist
        a = map(a, 1, maxDist, 1, 75); //map a between 1 and 75

        float b = 300 - r.age; //b is 300 - age
        b = map(b, 0, 300, 0, 50); //map b to between 0 and 50

        r.fitness = a + b; //the fitness is a + b
      }
      avgFitness += r.fitness; //add the fitness to avgFitness

      if (r.fitness > maxFitness) { //if this particles fitness is greater than the current maxFitness
        maxFitness = r.fitness; //the maxFitness is now this particle's fitness
      }
    }
    avgFitness /= popu.size(); //divide the avgFitness by the number of Rockets
  }



  void buildGenepool() { //builds a genepool and creates the next generation

    ArrayList<Rocket> genepool = new ArrayList<Rocket>(); //create the genepool
    float rand = random(maxFitness); //rand is a random number between 0 and maxFitness

    for (Rocket r : popu) { //for each Rocket r in the population
      if (r.fitness > rand) { //if the fitness is greater than rand
        genepool.add(r); //add r to the genepool
      }
    }

    while (nextPopu.size() < 0.75 * popu.size()) { //while the next population size is less than 75% the current population size

      Rocket a = genepool.get(floor(random(genepool.size()))); //rocket a is a random rocket from the genepool
      Rocket c = a.crossover(); //perform the crossover operation on a, to return a new rocket, c

      c.mutate(); //mutate c's DNA
      nextPopu.add(c); //add c to the population
    }

    while (nextPopu.size() < popu.size()) { //while the next generation size is less than the current generation
      Rocket a = new Rocket(mutationRate, numBoosters); //a is a new rocket
      nextPopu.add(a); //add a to the population
    }

    popu = nextPopu; //the current population is the next population
    nextPopu = new ArrayList<Rocket>(); //the next population becomes a new ArrayList
  }
}