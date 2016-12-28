/**
 * Load and Display
 *
 * Images can be loaded and displayed to the screen at their actual size
 * or any other size.
 */

//Start drawing upwards when the pixel color is 7, 84, 19.
final color COLOR_START_UP = color(7, 84, 19);
//Start drawing left when the pixel color is 139, 57, 137.
final color COLOR_START_LEFT = color(139, 57, 137);
//Stop drawing when the pixel color is 51, 69, 169.
final color COLOR_STOP = color(51, 69, 169);
//Turn right when the pixel color is 182, 149, 72.
final color COLOR_TURN_CLOCKWISE = color(182, 149, 72);
//Turn left when the pixel color is 123, 131, 154.
final color COLOR_TURN_COUNTER_CLOCKWISE = color(123, 131, 154);

final int w = 180;
final int h = 60;


final PVector[] directions = {
  new PVector(  0, -1 ), // up
  new PVector(  1,  0 ), // right
  new PVector(  0,  1 ), // down
  new PVector( -1,  0 )  // left
};

final int DIRECTION_INDEX_UP = 0;
final int DIRECTION_INDEX_LEFT = 3;

void setup() {
  size(720, 240); // Processing doesn't allow variables here.

  // The image file must be in the data folder of the current sketch
  // to load successfully
  PImage originalImage = loadImage("image.png");  // Load the image into the program

  ArrayList<PVector> inkedPixels = findPixelsToPaint(originalImage);
  // find painted pixels

  noStroke();
  fill(#cc0000);
  rect(0, 0, width, height);
  fill(#ffffff);
  drawPoints(inkedPixels, 4);
}

ArrayList<PVector> findPixelsToPaint(PImage originalImage) {
  ArrayList<PVector> pixelsToPaint = new ArrayList();

  for (int x = 0; x < w; x++) {
    for (int y = 0; y < h; y++) {
      color currentColor = originalImage.get(x, y);
      if (currentColor == COLOR_START_UP) {
        startDrawing(originalImage, pixelsToPaint, x, y, DIRECTION_INDEX_UP);
      } else if (currentColor == COLOR_START_LEFT) {
        startDrawing(originalImage, pixelsToPaint, x, y, DIRECTION_INDEX_LEFT);
      }
    }
  }

  return pixelsToPaint;
}

void startDrawing(PImage originalImage, ArrayList<PVector> pixelsToPaint, int x, int y, int directionIndex) {
  int currentDirIndex = directionIndex;
  pixelsToPaint.add(new PVector(x, y));

  int x2 = x;
  int y2 = y;
  color currentColor = originalImage.get(x, y);

  do {
    x2 = x2 + (int)directions[currentDirIndex].x;
    y2 = y2 + (int)directions[currentDirIndex].y;

    if (x2 < 0 || x2 >= w || y2 < 0 || y2 >= h ) {
      break;
    }

    currentColor = originalImage.get(x2, y2);
    pixelsToPaint.add(new PVector(x2, y2));

    if (currentColor == COLOR_TURN_CLOCKWISE) {
      currentDirIndex = Math.floorMod(currentDirIndex + 1, 4);
    } else if (currentColor == COLOR_TURN_COUNTER_CLOCKWISE) {
      currentDirIndex = Math.floorMod(currentDirIndex - 1, 4);
    }
  } while (currentColor != COLOR_STOP);

}

void drawPoints(ArrayList<PVector> inkedPixels, float scale) {
  for (int i = 0; i < inkedPixels.size(); i++) {
    PVector currentPoint = inkedPixels.get(i);
    float x = currentPoint.x * scale;
    float y = currentPoint.y * scale;
    rect(x, y, scale, scale);
  }
}
