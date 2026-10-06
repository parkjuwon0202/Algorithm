class Array {
  int i0, j0, len, max, w;
  int[] arr;

  Array(int len, int i0, int j0) {
    max = 100;

    this.i0 = i0;
    this.j0 = j0;
    this.len = len;

    arr = new int[len];

    w = (width - 4) / len;

    shuffle();
  }

  Array(int len, int[] arr, int i0, int j0) {
    this.i0 = i0;
    this.j0 = j0;
    this.len = len;

    this.arr = new int[len];

    w = (width - 4) / len;

    for (int i = 0; i < len; i++) {
      this.arr[i] = arr[i];
    }
  }

  void draw() {

    textAlign(CENTER, CENTER);
    textSize(16);

    for (int i = 0; i < len; i++) {

      // 현재 비교하는 막대
      if (i == i0 || i == j0) {
        fill(60);
      } 
      else {
        fill(130);
      }

      int x = i * w + 2;
      int h = arr[i];

      int y = height - 5 * h - 80;

      // 막대
      rect(
        x,
        y,
        w - 2,
        5 * h
      );

      // 숫자
      fill(0);

      text(
        arr[i],
        x + w / 2,
        y - 12
      );
    }

    textAlign(LEFT, BASELINE);
  }

  void shuffle() {

    int[] numbers = {
      72, 35, 91, 18,
      64, 27, 83, 46,
      10, 58, 39, 95,
      21, 76, 43, 67
    };

    for (int i = 0; i < len; i++) {
      arr[i] = numbers[i];
    }
  }
}
