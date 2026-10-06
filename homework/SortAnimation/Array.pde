// Array.pde - 막대 하나하나를 그리는 클래스 (원본 기반, 무지개 색/강조 표시 추가)
class Array {
  int i0, j0, len, max, w;
  int[] arr;

  int a = -1, b = -1;     // 지금 비교/교환 중인 두 칸 (하얀색 강조)
  int lo = -1, hi = -1;   // 지금 작업 중인 구간 (구간 밖은 흐리게)
  int sLo = 0, sHi = -1;  // 정렬이 끝난 구간 (초록 표시)

  Array(int len, int i0, int j0) {
    max = 100;
    this.i0 = i0;
    this.j0 = j0;
    this.len = len;
    arr = new int[len];
    w = (int) (width-4)/len;
    shuffle();
  }

  Array(int len, int[] arr, int i0, int j0) {
    max = 100;   // 원본에는 빠져 있던 초기화 (색 계산에 필요)
    this.i0 = i0;
    this.j0 = j0;
    this.len = len;
    this.arr = new int[len];
    w = (int) (width-4)/len;
    for (int i=0; i<len; i++)
      this.arr[i] = arr[i];
  }

  void draw() {
    int x, y, h;
    colorMode(HSB, 255);
    textAlign(CENTER);
    textSize(12);
    for (int i=0; i<len; i++) {
      float hue = map(arr[i], 0, max, 0, 210);   // 값이 클수록 빨강→보라
      boolean active = (lo < 0) || (i >= lo && i <= hi);

      if (i == a || i == b) {
        fill(0, 0, 255);          // 하얀색 강조
        stroke(0);
        strokeWeight(3);
      } else {
        if (active) fill(hue, 210, 255);
        else        fill(hue, 70, 170);   // 작업 구간 밖은 흐리게
        noStroke();
      }

      x = i*w+2;
      h = 4*arr[i];
      y = height-h-60;
      rect(x, y, w-2, h, 4, 4, 0, 0);

      // 정렬 끝난 칸은 아래에 초록 표시
      if (i >= sLo && i <= sHi) {
        noStroke();
        fill(90, 220, 220);
        rect(x, height-54, w-2, 6, 3);
      }

      // 막대 위 숫자
      fill(0, 0, 60);
      noStroke();
      text(arr[i], x + (w-2)/2.0, y-4);
    }
    colorMode(RGB, 255);
    textAlign(LEFT);
    strokeWeight(1);
    noStroke();
  }

  void shuffle() {
    for (int i=0; i<len; i++)
      arr[i] = 5 + (int)random(max-5);
  }

  void printArray() {
    print("("+nf(i0,2)+","+nf(j0,2)+")- ");
    for (int i=0; i<len; i++)
      print(nf(arr[i],2)+" ");
    println();
  }
}
