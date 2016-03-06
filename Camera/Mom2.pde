class Mom2{
  float adapt;
  float avg;
  Mom2(float adapt) {
    this.adapt = adapt;
    reset();
  }
  void note(float x) {
    if(x == Float.POSITIVE_INFINITY)
      return;
    else
      avg = (avg * (1 - adapt)) + (x * adapt);
      println(avg);
  }
  void reset() {
    avg = 0;
  }
}