ArrayList<Array> lists;

Array list;

int type = 0;
int len = 16;

int index = 0;
int loop = 0;

boolean autoFlag = true;

int speed = 120;
int lastTime = 0;

int finishTime = 0;

String[] titles = {
  "Selection Sort",
  "Bubble Sort",
  "Insertion Sort",
  "Merge Sort"
};


void setup() {

  size(900, 600);

  textSize(24);

  run(type);
}


void draw() {

  background(200);

  if (lists == null || lists.size() == 0) {
    return;
  }

  list = lists.get(index);

  list.draw();

  fill(0);

  textSize(24);

  text(
    titles[type],
    20,
    35
  );

  textSize(18);

  text(
    "Step : " + index + " / " + loop,
    20,
    height - 45
  );

  text(
    "SPACE : Play / Pause     A : Faster     S : Slower",
    20,
    height - 15
  );


  // 자동 재생
  if (autoFlag) {

    // 정렬 진행 중
    if (index < loop) {

      if (millis() - lastTime > speed) {

        index++;

        lastTime = millis();
      }
    }

    // 정렬 완료
    else {

      if (finishTime == 0) {

        finishTime = millis();
      }

      // 1.5초 후 다음 정렬
      if (millis() - finishTime > 1500) {

        type++;

        if (type >= titles.length) {
          type = 0;
        }

        run(type);
      }
    }
  }
}


// =========================================
// 정렬 시작
// =========================================

void run(int newType) {

  type = newType;

  index = 0;
  loop = 0;

  finishTime = 0;

  lists = new ArrayList<Array>();


  // 처음 배열
  Array first = new Array(
    len,
    -1,
    -1
  );

  lists.add(first);


  // 정렬 실행
  if (type == 0) {

    selectionSort();

  } 
  else if (type == 1) {

    bubbleSort();

  } 
  else if (type == 2) {

    insertionSort();

  } 
  else if (type == 3) {

    mergeSort(
      0,
      len - 1
    );
  }

  lastTime = millis();
}


// =========================================
// Selection Sort
// =========================================

void selectionSort() {

  for (int i = 0; i < len - 1; i++) {

    int minIndex = i;

    for (int j = i + 1; j < len; j++) {

      addState(
        minIndex,
        j
      );

      int[] arr = getCurrentArray();

      if (arr[j] < arr[minIndex]) {

        minIndex = j;
      }
    }

    if (minIndex != i) {

      int[] arr = getCurrentArray();

      swap(
        arr,
        i,
        minIndex
      );

      addState(
        i,
        minIndex
      );
    }
  }
}


// =========================================
// Bubble Sort
// =========================================

void bubbleSort() {

  for (int i = 0; i < len - 1; i++) {

    for (int j = 0; j < len - i - 1; j++) {

      addState(
        j,
        j + 1
      );

      int[] arr = getCurrentArray();

      if (arr[j] > arr[j + 1]) {

        swap(
          arr,
          j,
          j + 1
        );

        addState(
          j,
          j + 1
        );
      }
    }
  }
}


// =========================================
// Insertion Sort
// =========================================

void insertionSort() {

  for (int i = 1; i < len; i++) {

    int[] arr = getCurrentArray();

    int key = arr[i];

    int j = i - 1;

    addState(
      i,
      i
    );

    while (
      j >= 0 &&
      arr[j] > key
    ) {

      arr[j + 1] = arr[j];

      addState(
        j,
        j + 1
      );

      j--;
    }

    arr[j + 1] = key;

    addState(
      j + 1,
      i
    );
  }
}


// =========================================
// Merge Sort
// =========================================

void mergeSort(
  int left,
  int right
) {

  if (left >= right) {
    return;
  }

  int middle =
    (left + right) / 2;

  mergeSort(
    left,
    middle
  );

  mergeSort(
    middle + 1,
    right
  );

  merge(
    left,
    middle,
    right
  );
}


// =========================================
// Merge
// =========================================

void merge(
  int left,
  int middle,
  int right
) {

  int[] arr =
    getCurrentArray();

  int[] temp =
    new int[right - left + 1];

  int i = left;

  int j = middle + 1;

  int k = 0;


  while (
    i <= middle &&
    j <= right
  ) {

    addState(
      i,
      j
    );

    if (arr[i] <= arr[j]) {

      temp[k] = arr[i];

      i++;

    } 
    else {

      temp[k] = arr[j];

      j++;
    }

    k++;
  }


  while (i <= middle) {

    temp[k] = arr[i];

    i++;
    k++;
  }


  while (j <= right) {

    temp[k] = arr[j];

    j++;
    k++;
  }


  // 실제 배열에 복사
  for (
    int x = 0;
    x < temp.length;
    x++
  ) {

    arr[left + x] =
      temp[x];

    addState(
      left + x,
      left + x
    );
  }
}


// =========================================
// 현재 배열
// =========================================

int[] getCurrentArray() {

  return lists
    .get(
      lists.size() - 1
    )
    .arr;
}


// =========================================
// 상태 저장
// =========================================

void addState(
  int i,
  int j
) {

  int[] current =
    getCurrentArray();

  Array newState =
    new Array(
      len,
      current,
      i,
      j
    );

  lists.add(
    newState
  );

  loop++;
}


// =========================================
// Swap
// =========================================

void swap(
  int[] arr,
  int i,
  int j
) {

  int temp =
    arr[i];

  arr[i] =
    arr[j];

  arr[j] =
    temp;
}


// =========================================
// 키보드
// =========================================

void keyPressed() {

  // SPACE
  if (key == ' ') {

    autoFlag =
      !autoFlag;

    lastTime =
      millis();

    if (autoFlag) {
      finishTime = 0;
    }
  }

  // A - 빠르게
  else if (
    key == 'a' ||
    key == 'A'
  ) {

    if (speed > 30) {
      speed -= 20;
    }
  }

  // S - 느리게
  else if (
    key == 's' ||
    key == 'S'
  ) {

    speed += 20;
  }
}
