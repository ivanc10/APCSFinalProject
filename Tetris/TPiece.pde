public class TPiece extends Tetromino {
  TPiece(TetrisBoard t) {
    board = t;
    row = 4;
    col = 1;
    comx = 2;
    comy = 1;
    state = 0;
    type = 0;
    COLOR = #B316ED;
  }
  public int[][] arrayData() {
    if (state == 0) {
      return new int[][] {{0, 0, 0},
                          {0, 1, 0},
                          {1, 1, 1}};
    }
    else if (state == 1) {
      return new int[][] {{1, 0, 0},
                          {1, 1, 0},
                          {1, 0, 0}};
    }
    else if (state == 2) {
      return new int[][] {{1, 1, 1},
                          {0, 1, 0},
                          {0, 0, 0}};
    }
    else {
      return new int[][] {{0, 0, 1},
                          {0, 1, 1},
                          {0, 0, 1}};
    }
  }
}