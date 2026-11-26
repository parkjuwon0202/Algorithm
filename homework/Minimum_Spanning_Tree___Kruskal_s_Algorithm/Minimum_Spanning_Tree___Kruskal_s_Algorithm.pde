
PFont koreanFont;

// 그래프 데이터
ArrayList<Edge> edges = new ArrayList<Edge>();
ArrayList<Edge> mst = new ArrayList<Edge>();
ArrayList<Edge> rejected = new ArrayList<Edge>();

Node[] nodes;

// 알고리즘 변수
int mode = 1;
int step = 0;
int totalWeight = 0;
int currentEdge = -1;

boolean autoRun = false;
int speed = 40;

int[] parent;
int[] rank;
boolean[] visited;

// 현재 진행 상황
String status = "";

// 정점 클래스
class Node {
  float x, y;
  String name;

  Node(float x, float y, String name) {
    this.x = x;
    this.y = y;
    this.name = name;
  }
}

// 간선 클래스
class Edge {
  int u, v, weight;

  Edge(int u, int v, int weight) {
    this.u = u;
    this.v = v;
    this.weight = weight;
  }
}

// 초기 설정
void setup() {
  size(900, 650);
  frameRate(60);

  // Windows 한글 폰트
  koreanFont = createFont("Malgun Gothic", 20, true);
  textFont(koreanFont);

  // 정점 생성
  nodes = new Node[6];

  nodes[0] = new Node(180, 180, "A");
  nodes[1] = new Node(430, 110, "B");
  nodes[2] = new Node(700, 190, "C");
  nodes[3] = new Node(200, 430, "D");
  nodes[4] = new Node(470, 490, "E");
  nodes[5] = new Node(730, 420, "F");

  createGraph();
  resetAlgorithm();
}

// 그래프 생성
void createGraph() {
  edges.clear();

  edges.add(new Edge(0, 1, 4));  // A-B
  edges.add(new Edge(0, 3, 2));  // A-D
  edges.add(new Edge(0, 4, 7));  // A-E
  edges.add(new Edge(1, 2, 6));  // B-C
  edges.add(new Edge(1, 3, 5));  // B-D
  edges.add(new Edge(1, 4, 3));  // B-E
  edges.add(new Edge(2, 4, 8));  // C-E
  edges.add(new Edge(2, 5, 1));  // C-F
  edges.add(new Edge(4, 5, 9));  // E-F
}

// 화면 출력
void draw() {
  background(245);

  textFont(koreanFont);

  drawTitle();
  drawGraph();
  drawInformation();
  drawControls();

  // 자동 실행
  if (autoRun && frameCount % speed == 0) {
    nextStep();
  }
}

// 제목 출력
void drawTitle() {
  fill(30);
  textAlign(CENTER);
  textSize(27);

  text("Minimum Spanning Tree (MST)", width/2, 40);

  textSize(16);

  if (mode == 1) {
    fill(30, 100, 220);
    text("Kruskal 알고리즘", width/2, 70);
  } else {
    fill(30, 150, 90);
    text("Prim 알고리즘", width/2, 70);
  }
}

// 그래프 출력
void drawGraph() {

  // 기본 간선 출력
  for (int i = 0; i < edges.size(); i++) {
    Edge e = edges.get(i);

    stroke(190);
    strokeWeight(3);

    line(
      nodes[e.u].x, nodes[e.u].y,
      nodes[e.v].x, nodes[e.v].y
    );

    // 간선 가중치 표시
    float mx = (nodes[e.u].x + nodes[e.v].x) / 2;
    float my = (nodes[e.u].y + nodes[e.v].y) / 2;

    noStroke();
    fill(255);
    ellipse(mx, my, 32, 25);

    fill(20);
    textAlign(CENTER, CENTER);
    textSize(15);

    text(e.weight, mx, my);
  }

  // 선택된 MST 간선
  for (Edge e : mst) {
    stroke(20, 170, 80);
    strokeWeight(6);

    line(
      nodes[e.u].x, nodes[e.u].y,
      nodes[e.v].x, nodes[e.v].y
    );
  }

  // 제외된 간선
  for (Edge e : rejected) {
    stroke(220, 60, 60);
    strokeWeight(3);

    line(
      nodes[e.u].x, nodes[e.u].y,
      nodes[e.v].x, nodes[e.v].y
    );
  }

  // 현재 검사 중인 간선
  if (currentEdge >= 0 && currentEdge < edges.size()) {
    Edge e = edges.get(currentEdge);

    stroke(255, 160, 0);
    strokeWeight(7);

    line(
      nodes[e.u].x, nodes[e.u].y,
      nodes[e.v].x, nodes[e.v].y
    );
  }

  // 정점 출력
  for (int i = 0; i < nodes.length; i++) {

    if (mode == 2 && visited[i]) {
      fill(50, 180, 110);
    } else {
      fill(50, 120, 220);
    }

    stroke(255);
    strokeWeight(3);

    ellipse(nodes[i].x, nodes[i].y, 48, 48);

    fill(255);
    textAlign(CENTER, CENTER);
    textSize(18);

    text(nodes[i].name, nodes[i].x, nodes[i].y);
  }
}

// 정보 출력
void drawInformation() {
  fill(30);
  textAlign(LEFT);
  textSize(16);

  text("선택된 간선: " + mst.size() + " / 5", 40, 555);
  text("전체 가중치 합: " + totalWeight, 40, 585);
  text("현재 진행 단계: " + step, 40, 615);

  fill(30, 120, 220);
  textSize(14);
  text(status, 390, 555);

  fill(30, 150, 80);
  text("초록색: 선택된 간선", 390, 585);

  fill(220, 50, 50);
  text("빨간색: 제외된 간선", 390, 610);
}

// 조작 안내
void drawControls() {
  fill(30);
  textAlign(CENTER);
  textSize(13);

  text(
    "1: Kruskal   2: Prim   SPACE: 다음 단계   A: 자동 실행   R: 초기화   UP/DOWN: 속도",
    width/2, 635
  );
}

// 알고리즘 초기화
void resetAlgorithm() {

  mst.clear();
  rejected.clear();

  step = 0;
  totalWeight = 0;
  currentEdge = -1;

  autoRun = false;

  parent = new int[nodes.length];
  rank = new int[nodes.length];

  visited = new boolean[nodes.length];

  for (int i = 0; i < nodes.length; i++) {
    parent[i] = i;
    rank[i] = 0;
  }

  if (mode == 1) {

    // Kruskal: 가중치 오름차순 정렬
    edges.sort((a, b) -> a.weight - b.weight);

    status = "Kruskal: 간선을 가중치 순서로 검사합니다.";

  } else {

    // Prim: A 정점에서 시작
    visited[0] = true;

    status = "Prim: A 정점에서 시작합니다.";
  }
}

// Union-Find: 부모 노드 찾기
int find(int x) {

  if (parent[x] != x) {
    parent[x] = find(parent[x]);
  }

  return parent[x];
}

// 두 집합 합치기
boolean union(int a, int b) {

  int rootA = find(a);
  int rootB = find(b);

  if (rootA == rootB) {
    return false;
  }

  if (rank[rootA] < rank[rootB]) {
    parent[rootA] = rootB;

  } else if (rank[rootA] > rank[rootB]) {
    parent[rootB] = rootA;

  } else {
    parent[rootB] = rootA;
    rank[rootA]++;
  }

  return true;
}

// 다음 단계 실행
void nextStep() {

  if (mst.size() == nodes.length - 1) {
    status = "MST 완성!";
    autoRun = false;
    currentEdge = -1;
    return;
  }

  if (mode == 1) {
    kruskalStep();
  } else {
    primStep();
  }
}

// Kruskal 알고리즘
void kruskalStep() {

  if (step >= edges.size()) {
    status = "더 이상 검사할 간선이 없습니다.";
    autoRun = false;
    currentEdge = -1;
    return;
  }

  Edge e = edges.get(step);

  currentEdge = step;
  step++;

  // 사이클 검사 후 간선 선택
  if (union(e.u, e.v)) {

    mst.add(e);
    totalWeight += e.weight;

    status = nodes[e.u].name + " - " +
      nodes[e.v].name + " 선택! 가중치: " + e.weight;

  } else {

    rejected.add(e);

    status = nodes[e.u].name + " - " +
      nodes[e.v].name + " 제외! 사이클 발생";
  }

  // MST 완성 확인
  if (mst.size() == nodes.length - 1) {
    status += " / MST 완성!";
    autoRun = false;
    currentEdge = -1;
  }
}

// Prim 알고리즘
void primStep() {

  Edge best = null;
  int bestIndex = -1;

  // 방문한 정점과 방문하지 않은 정점을
  // 연결하는 최소 가중치 간선 찾기
  for (int i = 0; i < edges.size(); i++) {

    Edge e = edges.get(i);

    boolean uVisited = visited[e.u];
    boolean vVisited = visited[e.v];

    if (uVisited != vVisited) {

      if (best == null || e.weight < best.weight) {
        best = e;
        bestIndex = i;
      }
    }
  }

  if (best == null) {
    status = "연결할 수 있는 간선이 없습니다.";
    autoRun = false;
    return;
  }

  currentEdge = bestIndex;

  mst.add(best);
  totalWeight += best.weight;

  visited[best.u] = true;
  visited[best.v] = true;

  step++;

  status = nodes[best.u].name + " - " +
    nodes[best.v].name + " 선택! 가중치: " + best.weight;

  // MST 완성 확인
  if (mst.size() == nodes.length - 1) {
    status += " / MST 완성!";
    autoRun = false;
    currentEdge = -1;
  }
}

// 키보드 입력
void keyPressed() {

  // Kruskal 실행
  if (key == '1') {
    mode = 1;
    resetAlgorithm();
  }

  // Prim 실행
  if (key == '2') {
    mode = 2;
    resetAlgorithm();
  }

  // 다음 단계
  if (key == ' ') {
    autoRun = false;
    nextStep();
  }

  // 자동 실행
  if (key == 'a' || key == 'A') {
    autoRun = !autoRun;
  }

  // 초기화
  if (key == 'r' || key == 'R') {
    resetAlgorithm();
  }

  // 속도 빠르게
  if (keyCode == UP) {
    speed = max(5, speed - 5);
  }

  // 속도 느리게
  if (keyCode == DOWN) {
    speed = min(120, speed + 5);
  }
}
