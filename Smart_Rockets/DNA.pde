class DNA { //Create a DNA class

  ArrayList<ArrayList> genes; //create an ArrayList to contain the genes
  float mutationRate; //A float that stores the mutation rate
  int numBoosters; //An int that stores the number of boosters

  DNA(float mutationRate_, int numBoosters_) { //initialisation function for DNA object
    genes = new ArrayList<ArrayList>(); //genes is a new ArrayList
    mutationRate = mutationRate_; //mutation rate gets the value specified when a DNA object is created
    numBoosters = numBoosters_; //numBoosters gets the value specified when a DNA object is created

    for (int i = 0; i < numBoosters; i++) { //for i less than the number of boosters
      ArrayList<Float> boosterGenes = new ArrayList<Float>(); //A new ArrayList that stores the boosters' genes
      boosterGenes.add(random(TWO_PI)); //First element is direction, between 0 and 2 pi
      boosterGenes.add(random(100)); //second element is duration, between 0 and 100 frames
      boosterGenes.add(random(0.5)); //third element is magnitude, between 0 and 0.5
      genes.add(boosterGenes); //add that booster's genes to the genes ArrayList
    }
  }
}