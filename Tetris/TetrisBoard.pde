import java.util.*;
public class TetrisBoard {
  private int[][] grid = new int[20][10];
  private List<Tetromino> pieces;
  public Tetromino currentPiece;
  private int heldPiece;
  private int pieceNumber;
  public boolean canHoldPiece = true;
  private String MODE; //10 Lines, 20 Lines, 40 Lines, 100 Lines, Score
  public int score;
  public int startTime;
  public int time;
  private boolean shouldFall = true;
  private int numLines;
  public boolean LOST = false;
  TetrisBoard() {
    MODE = "Score";
    pieceNumber = 0;
    pieces = new ArrayList<Tetromino>();
    addPieces();
    addPieces();
    heldPiece = -1;
    time = 0;
    startTime = millis();
  }
  TetrisBoard(int l) {
    MODE = l + " lines";
    numLines = l;
    pieceNumber = 0;
    pieces = new ArrayList<Tetromino>();
    addPieces();
    addPieces();
    heldPiece = -1;
    time = 0;
    startTime = millis();
  }
  
  private void addPieces() {
    for(Tetromino t: generateBag() ) {
      pieces.add(t);
    }
  }
  
  private Tetromino numToPiece(int num) {
    Tetromino[] types = new Tetromino[] {new IPiece(this), new JPiece(this), new LPiece(this), new OPiece(this), new SPiece(this), new TPiece(this), new ZPiece(this)};
    return types[num];
  }
  
  private int pieceToNum(Tetromino piece) {
    ArrayList<Integer> pieceColors = new ArrayList<Integer>(7);
    pieceColors.add(#1EF5F3); pieceColors.add(#1520E3);
    pieceColors.add(#FFAB0D); pieceColors.add(#FCFC19);
    pieceColors.add(#0DFF16); pieceColors.add(#B316ED);
    pieceColors.add(#FF0D2D);
    return pieceColors.indexOf(piece.COLOR);
  } 
  private List<Tetromino> generateBag() {
    List<Tetromino> bag = new ArrayList<Tetromino>(7);
    int[] numbers = {0,1,2,3,4,5,6};
    
    List<Integer> nums = new ArrayList<Integer>(numbers.length);
    for (int i : numbers) {
      nums.add(i);
    }
    Collections.shuffle(nums);
    for (Integer n: nums) {
      bag.add(numToPiece(n));
    }
    return bag;
  }
  
  public void nextPiece() {
    pieceNumber++;
    if (pieceNumber == 7) {
      pieceNumber = 0;
      addPieces();
    }
    currentPiece = pieces.remove(0);
  }
  private void displayBoard() {
    background(0);
    for (int r = 0; r < 20; r++) {
      for (int c = 0; c < grid[0].length; c++) {
        fillSquare(r, c, grid[r][c]);  
      }
    }
    stroke(255);
    noFill();
    rect(250, 0, 300, 600);
    displayNextPieces(4);
  }
  public void updateBoard() {
    int[][] pieceData = currentPiece.arrayData();
    for(int r = 0; r < pieceData.length; r++) {
      for(int c = 0; c < pieceData[0].length; c++) {
        if (pieceData[r][c] != 0) {
          int rowi = currentPiece.row - currentPiece.comx + r;
          int coli = currentPiece.col - currentPiece.comy + c;
          grid[rowi][coli] = currentPiece.COLOR;
        }
      }
    }
  }
  
  private void displayPiece(Tetromino piece, int row, int col) {
    int[][] pieceData = piece.arrayData();
    for(int r = 0; r < pieceData.length; r++) {
      for(int c = 0; c < pieceData[0].length; c++) {
        if (pieceData[r][c] != 0) {
          float rowi = row - piece.comx + r;
          float coli = col - piece.comy + c;
          fillSquare(rowi, coli, piece.COLOR);
        }
      }
    }
  }
  
  private void displayNextPieces(int n) {
    for (int i = 0; i < n; i++) {
      Tetromino piece = pieces.get(i);
      displayPiece(piece, 2+3*i, 13);
    }
  }
  
  private void displayCurrent() {
    int[][] pieceData = currentPiece.arrayData();
    for(int r = 0; r < pieceData.length; r++) {
      for(int c = 0; c < pieceData[0].length; c++) {
        if (pieceData[r][c] != 0) {
          float row = currentPiece.row - currentPiece.comx + r;
          float col = currentPiece.col - currentPiece.comy + c;
          fillSquare(row, col, currentPiece.COLOR);
        }
      }
    }
  }
  private void fillSquare(float row, float col, int c) { //helper method to color a square of the grid
    stroke(255, 255, 255, 40);
    fill(c);
    rect(250+30*col, 30*row, 30, 30);
  }
  private void clear(int row) {
    for (int r = row; r > 0; r--) {
      for (int c = 0; c < grid[0].length; c++) {
        grid[r][c] = grid[r-1][c];
      }
    }
    for (int c = 0; c < grid[0].length; c++) {
      grid[0][c] = 0;
    }
  }
  private void clear() {
    ArrayList<Integer> lines = new ArrayList(0);
    for (int r = 0; r < grid.length; r++) {
      boolean line = true;
      for (int c = 0; c < grid[0].length; c++) {
        if (grid[r][c] == 0) {
          line = false;
        }
      }
      if (line) {
        lines.add(r);
      }
    }
    numLines -= lines.size();
    while (lines.size() > 0) {
      score += 1000;
      clear(lines.remove(0));
    }
  }
  private void displayPreview() {
    color colour = currentPiece.COLOR;
    float red = red(colour);
    float green = green(colour);
    float blue = blue(colour);
    colour = color(red, green, blue, 70);
    int bottomRow = currentPiece.getBottomRow();
    int column = currentPiece.col;
    int[][] pieceData = currentPiece.arrayData();
    for(int r = 0; r < pieceData.length; r++) {
      for(int c = 0; c < pieceData[0].length; c++) {
        if (pieceData[r][c] != 0) {
          float row = bottomRow - currentPiece.comx + r;
          float col = currentPiece.col - currentPiece.comy + c;
          fillSquare(row, col, colour);
        }
      }
    }
  }
  public void holdPiece() {
    if (canHoldPiece) {
      if (heldPiece == -1) {
        heldPiece = pieceToNum(currentPiece);
        currentPiece = pieces.remove(0);
        canHoldPiece = false;
      }
      else {
        int temp = heldPiece;
        heldPiece = pieceToNum(currentPiece);
        currentPiece = numToPiece(temp);
        canHoldPiece = false;
      }
    }
  }
  private void displayHeldPiece() {
    if (heldPiece != -1) {
      displayPiece(numToPiece(heldPiece), 2, -4);
    }
  }
  private void updateTime() {
    time = millis() - startTime;
  }
  private void displayTime() {
    textSize(35);
    fill(255);
    text( "Time: " + (float) time / 1000.0, 300, 650);
    noFill();
  }
  private void naturallyFall() {
    if (second() % 2 == 1 && shouldFall) {
      currentPiece.fall();
      shouldFall = false;
    }
    else if (second() % 2 == 0) {
      shouldFall = true;
    }
  }
  private void displayLines() {
    textSize(35);
    fill(255);
    text( "Lines Left: " + numLines, 300, 700);
    noFill();
  }
  private void displayScore() {
    textSize(35);
    fill(255);
    text( "Score: " + score, 300, 700);
    noFill();
  }
  
  public void display() {
    background(0);
    if (LOST) {
      board = null;
      displayGameOver();
    }
    else {
      displayBoard();
      displayCurrent();
      displayPreview();
      displayHeldPiece();
      clear();
      naturallyFall();
      if (second() % 2 == 0) {
        naturallyFall();
      }
    }
    if (MODE.equals("Score") ) {
      displayScore();      
    }
    else if (numLines > 0) {
      displayLines();
      updateTime();
      displayTime();
    }
    else {
      displayVictoryScreen();
    }
  }
  private void displayVictoryScreen() {
    fill(0);
    rect(0, 0, 800, 800);
    fill(#12FF53);
    textSize(35);
    text("Congratulations! You cleared " + MODE + " in " + (float) (time) / 1000 + " seconds!", 200, 200, 400, 400);
    fill(255);
    text("Thanks for playing!", 200, 400);
    text("Press R to play again.", 200, 450);
  }
  private void displayGameOver() {
    fill(0);
    rect(0, 0, 800, 800);
    fill(#F70505);
    textSize(50);
    text("GAME OVER :<(", 100, 200);
    fill(#12FF53);
    if (MODE.equals("Score")) {
      text("You got a score of " + score + "!", 100, 275);
    }
    fill(255);
    text("Press R to play again.", 100, 350);
  }
  public int getNumLines() {
    return numLines;
  }
}
