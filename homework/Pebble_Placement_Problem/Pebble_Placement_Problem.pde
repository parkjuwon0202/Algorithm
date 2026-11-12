
int rows = 3;
int cols = 6;

int cellSize = 90;
int startX = 100;
int startY = 170;

// 3 x 6 숫자 행렬
int[][] values = {
  { 5,  1,  7,  3,  8,  2},
  { 4,  9,  2,  6,  1,  7},
  { 3,  5,  8,  4,  6,  9}
};

// 사용자가 직접 놓은 돌
boolean[][] selected = new boolean[rows][cols];

// 4가지 가능한 패턴
// 1: 위쪽, 2: 가운데, 4: 아래쪽, 5: 위+아래
int[] patterns = {1, 2, 4, 5};

int[] optimalPattern;
int optimalScore;

int cursorRow = 0;
int cursorCol = 0;

boolean showOptimal = false;

void setup() {
  size(850, 650);
  textAlign(CENTER, CENTER);
  calculateOptimal();
}

void draw() {
  background(245);

  fill(30);
  textSize(28);
  text("Pebble Placement Problem", width/2, 45);

  textSize(15);
  fill(80);
  text("Arrow Keys: Move    SPACE: Place / Remove",
       width/2, 90);
  text("O: Show Optimal    R: Reset",
       width/2, 115);

  drawGrid();
  drawInfo();
}

void drawGrid() {

  for (int r = 0; r < rows; r++) {
    for (int c = 0; c < cols; c++) {

      int x = startX + c * cellSize;
      int y = startY + r * cellSize;

      // 기본 칸
      fill(255);
      stroke(170);
      strokeWeight(2);

      // 최적 배치 표시
      if (showOptimal && isOptimalCell(r, c)) {
        fill(190, 230, 190);
      }

      // 사용자가 선택한 칸
      if (selected[r][c]) {
        fill(255, 210, 120);
      }

      // 현재 커서
      if (r == cursorRow && c == cursorCol) {
        stroke(30, 100, 230);
        strokeWeight(4);
      }

      rect(x, y, cellSize, cellSize, 8);

      // 숫자 표시
      fill(30);
      textSize(24);
      text(values[r][c],
           x + cellSize/2,
           y + cellSize/2);

      // 돌 표시
      if (selected[r][c]) {
        fill(220, 60, 50);
        noStroke();
        ellipse(x + cellSize/2,
                y + cellSize/2,
                22, 22);
      }
    }
  }
}

// 최적 배치에 포함된 칸인지 확인
boolean isOptimalCell(int r, int c) {

  int pattern = optimalPattern[c];

  return (pattern & (1 << r)) != 0;
}

// 현재 점수 계산
int getCurrentScore() {

  int score = 0;

  for (int r = 0; r < rows; r++) {
    for (int c = 0; c < cols; c++) {

      if (selected[r][c]) {
        score += values[r][c];
      }
    }
  }

  return score;
}

// 각 열에 돌이 있는지 확인
boolean allColumnsFilled() {

  for (int c = 0; c < cols; c++) {

    boolean found = false;

    for (int r = 0; r < rows; r++) {
      if (selected[r][c]) {
        found = true;
      }
    }

    if (!found) {
      return false;
    }
  }

  return true;
}

// 현재 배치가 규칙에 맞는지 검사
boolean isValid() {

  for (int r = 0; r < rows; r++) {
    for (int c = 0; c < cols; c++) {

      if (!selected[r][c]) {
        continue;
      }

      // 아래쪽 인접 검사
      if (r + 1 < rows && selected[r+1][c]) {
        return false;
      }

      // 오른쪽 인접 검사
      if (c + 1 < cols && selected[r][c+1]) {
        return false;
      }
    }
  }

  return true;
}

// 돌 놓기
void togglePebble() {

  boolean next = !selected[cursorRow][cursorCol];

  if (next) {

    // 위쪽 또는 아래쪽에 돌이 있는지
    if (cursorRow > 0 &&
        selected[cursorRow-1][cursorCol]) {
      return;
    }

    if (cursorRow < rows-1 &&
        selected[cursorRow+1][cursorCol]) {
      return;
    }

    // 왼쪽 또는 오른쪽에 돌이 있는지
    if (cursorCol > 0 &&
        selected[cursorRow][cursorCol-1]) {
      return;
    }

    if (cursorCol < cols-1 &&
        selected[cursorRow][cursorCol+1]) {
      return;
    }
  }

  selected[cursorRow][cursorCol] = next;
}

// DP 최적해 계산
void calculateOptimal() {

  int[][] dp = new int[cols][4];
  int[][] prev = new int[cols][4];

  for (int c = 0; c < cols; c++) {
    for (int p = 0; p < 4; p++) {

      dp[c][p] = -1000000000;
      prev[c][p] = -1;

      int weight = getPatternWeight(c, patterns[p]);

      if (c == 0) {
        dp[c][p] = weight;
      } else {

        for (int q = 0; q < 4; q++) {

          // 이전 열과 같은 행에 돌이 있으면 불가능
          if ((patterns[p] & patterns[q]) == 0) {

            int candidate = dp[c-1][q] + weight;

            if (candidate > dp[c][p]) {
              dp[c][p] = candidate;
              prev[c][p] = q;
            }
          }
        }
      }
    }
  }

  // 마지막 열에서 최고 점수 찾기
  int best = 0;

  for (int p = 1; p < 4; p++) {
    if (dp[cols-1][p] > dp[cols-1][best]) {
      best = p;
    }
  }

  optimalScore = dp[cols-1][best];

  // 역추적하여 최적 패턴 복원
  optimalPattern = new int[cols];

  int current = best;

  for (int c = cols-1; c >= 0; c--) {

    optimalPattern[c] = patterns[current];

    if (c > 0) {
      current = prev[c][current];
    }
  }
}

// 해당 열에서 패턴의 점수 계산
int getPatternWeight(int c, int pattern) {

  int sum = 0;

  for (int r = 0; r < rows; r++) {

    if ((pattern & (1 << r)) != 0) {
      sum += values[r][c];
    }
  }

  return sum;
}

// 점수 및 상태 출력
void drawInfo() {

  int currentScore = getCurrentScore();

  fill(30);
  textSize(19);

  text("Current Score: " + currentScore,
       width/2, 485);

  text("Optimal Score: " + optimalScore,
       width/2, 525);

  textSize(16);

  if (!isValid()) {
    fill(220, 40, 40);
    text("Invalid Placement!", width/2, 565);

  } else if (!allColumnsFilled()) {
    fill(180, 110, 0);
    text("Place at least one pebble in every column.",
         width/2, 565);

  } else if (currentScore == optimalScore) {
    fill(0, 140, 50);
    text("Congratulations! Optimal Solution!",
         width/2, 565);

  } else {
    fill(60);
    text("Valid Placement! Try to get a higher score.",
         width/2, 565);
  }
}

// 키보드 조작
void keyPressed() {

  if (keyCode == UP) {
    cursorRow = max(0, cursorRow - 1);
  }

  if (keyCode == DOWN) {
    cursorRow = min(rows-1, cursorRow + 1);
  }

  if (keyCode == LEFT) {
    cursorCol = max(0, cursorCol - 1);
  }

  if (keyCode == RIGHT) {
    cursorCol = min(cols-1, cursorCol + 1);
  }

  if (key == ' ') {
    togglePebble();
  }

  if (key == 'o' || key == 'O') {
    showOptimal = !showOptimal;
  }

  if (key == 'r' || key == 'R') {

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        selected[r][c] = false;
      }
    }

    cursorRow = 0;
    cursorCol = 0;
    showOptimal = false;
  }
}
