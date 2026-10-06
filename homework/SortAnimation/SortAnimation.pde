// SortAnimation.pde - 5가지 정렬을 무지개 막대로 자동 재생하는 쇼
// 조작: 스페이스=일시정지  a/s=속도  z/x=알고리즘  r=다시 섞기  m=자동 다음곡 on/off
//       ←/→ 또는 마우스 좌/우클릭 = 한 단계씩 (누르면 일시정지)

ArrayList<Array> lists;
Array list;
int[] work, tmp;
int type = 0, napTime = 40, len = 24, index = 0, loop = 0, lastStep = 0;
boolean autoFlag = true, showMode = true;
String[] titles = {"Selection Sort", "Bubble Sort", "Insertion Sort", "Merge Sort", "Quick Sort"};
String[] notes  = {
  "O(n^2) - 가장 큰 값을 골라 맨 뒤로 보냅니다",
  "O(n^2) - 이웃한 두 막대를 비교하며 큰 값이 거품처럼 오른쪽으로",
  "O(n^2) - 카드를 꽂아 넣듯 한 칸씩 제자리를 찾아갑니다",
  "O(n log n) - 반으로 쪼갠 뒤 정렬된 두 묶음을 합칩니다",
  "O(n log n) - 기준값(pivot)을 중심으로 작은 쪽/큰 쪽으로 나눕니다"
};
PFont f;

void setup() {
  size(900, 600);
  f = createFont("Arial", 24, true);
  textFont(f);
  run(type);
  lastStep = millis();
}

void draw() {
  background(235);
  list = lists.get(index);
  list.draw();

  fill(30);
  textAlign(LEFT);
  textSize(28);
  text(titles[type], 20, 40);
  textSize(16);
  fill(90);
  text(notes[type], 20, 66);

  fill(0);
  textSize(15);
  text("step " + index + "/" + loop + "    speed " + napTime + "ms (a/s)    algorithm " + (type+1) + "/5 (z/x)", 20, height-32);
  text("pause: space    reshuffle: r    auto-next: " + (showMode ? "ON" : "OFF") + " (m)    step: arrows / mouse", 20, height-12);

  if (autoFlag && millis() - lastStep >= waitTime()) {
    lastStep = millis();
    nextStep();
  }
}

int waitTime() {
  if (index == loop) return napTime * 30;  // 완성 후 잠깐 감상
  if (index == 0) return napTime * 10;
  return napTime;
}

void nextStep() {
  if (index < loop) index++;
  else {
    if (showMode) type = (type + 1) % 5;   // 다음 알고리즘으로
    run(type);                             // 새로 섞어서 다시 시작
  }
}

void keyPressed() {
  if (key == ' ') autoFlag = !autoFlag;
  else if (key == 'a') napTime = max(5, napTime - 10);
  else if (key == 's') napTime += 10;
  else if (key == 'z') { if (type > 0) { type--; run(type); } }
  else if (key == 'x') { if (type < 4) { type++; run(type); } }
  else if (key == 'r') run(type);
  else if (key == 'm') showMode = !showMode;
  else if (key == CODED) {
    if (keyCode == LEFT)  { if (index > 0) index--; }
    else if (keyCode == RIGHT) { if (index < loop) index++; }
  }
}

void mousePressed() {
  if (autoFlag) autoFlag = false;
  if (mouseButton == LEFT) { if (index > 0) index--; }
  else if (mouseButton == RIGHT) { if (index < loop) index++; }
}

// ---------- 정렬 과정을 한 장면씩 저장 ----------

void snap(int a, int b, int lo, int hi, int sLo, int sHi) {
  Array s = new Array(len, work, a, b);
  s.a = a; s.b = b; s.lo = lo; s.hi = hi; s.sLo = sLo; s.sHi = sHi;
  lists.add(s);
}

void run(int t) {
  index = 0;
  lists = new ArrayList<Array>();
  Array base = new Array(len, 0, -1);
  work = new int[len];
  tmp = new int[len];
  for (int i = 0; i < len; i++) work[i] = base.arr[i];

  snap(-1, -1, -1, -1, 0, -1);
  if (t == 0) selectionSort();
  else if (t == 1) bubbleSort();
  else if (t == 2) insertSort();
  else if (t == 3) mergeSort(0, len-1);
  else if (t == 4) quickSort(0, len-1);
  snap(-1, -1, -1, -1, 0, len-1);   // 완성!
  loop = lists.size() - 1;
  lists.get(loop).printArray();
}

void selectionSort() {
  for (int end = len-1; end > 0; end--) {
    int m = 0;
    for (int j = 1; j <= end; j++) {
      snap(j, m, 0, end, end+1, len-1);
      if (work[j] > work[m]) m = j;
    }
    if (m != end) {
      swap(work, m, end);
      snap(m, end, 0, end, end+1, len-1);
    }
  }
}

void bubbleSort() {
  for (int p = 0; p < len-1; p++) {
    for (int i = 0; i < len-p-1; i++) {
      snap(i, i+1, 0, len-p-1, len-p, len-1);
      if (work[i] > work[i+1]) {
        swap(work, i, i+1);
        snap(i, i+1, 0, len-p-1, len-p, len-1);
      }
    }
  }
}

void insertSort() {
  for (int i = 1; i < len; i++) {
    int j = i;
    snap(j, j-1, 0, i, 0, -1);
    while (j > 0 && work[j-1] > work[j]) {
      swap(work, j-1, j);
      j--;
      snap(j, j+1, 0, i, 0, -1);
    }
  }
}

void mergeSort(int low, int high) {
  if (low >= high) return;
  int mid = low + (high - low) / 2;
  mergeSort(low, mid);
  mergeSort(mid + 1, high);
  merge(low, mid, high);
}

void merge(int low, int mid, int high) {
  for (int i = low; i <= high; i++) tmp[i] = work[i];
  int i = low, j = mid + 1, k = low;
  while (i <= mid && j <= high) {
    if (tmp[i] <= tmp[j]) work[k] = tmp[i++];
    else work[k] = tmp[j++];
    snap(k, -1, low, high, 0, -1);
    k++;
  }
  while (i <= mid) {
    work[k] = tmp[i++];
    snap(k, -1, low, high, 0, -1);
    k++;
  }
}

void quickSort(int low, int high) {
  int i = low, j = high;
  int pivot = work[low + (high - low) / 2];
  while (i <= j) {
    while (work[i] < pivot) { i++; snap(i, j, low, high, 0, -1); }
    while (work[j] > pivot) { j--; snap(i, j, low, high, 0, -1); }
    if (i <= j) {
      swap(work, i, j);
      snap(i, j, low, high, 0, -1);
      i++;
      j--;
    }
  }
  if (low < j) quickSort(low, j);
  if (i < high) quickSort(i, high);
}

void swap(int[] arr, int i, int j) {
  int tmp = arr[j];
  arr[j] = arr[i];
  arr[i] = tmp;
}
