
import java.util.ArrayList;

// ===============================
// BFS & DFS Graph Visualization
// Processing - Java Mode
// ===============================

final int NODE_COUNT = 7;

ArrayList<Integer>[] graph;

float[] nodeX = new float[NODE_COUNT];
float[] nodeY = new float[NODE_COUNT];

boolean[] visited = new boolean[NODE_COUNT];

ArrayList<Integer> result = new ArrayList<Integer>();
ArrayList<Integer> frontier = new ArrayList<Integer>();

int startNode = 0;
int currentNode = -1;

String mode = "READY";

int animationSpeed = 35;
int frameCounter = 0;

boolean paused = false;
boolean finished = false;

// BFS Queue
ArrayList<Integer> queue = new ArrayList<Integer>();

// DFS Stack (Frame을 이용한 재귀 방식)
ArrayList<DFSFrame> stack = new ArrayList<DFSFrame>();

// DFS 진행 프레임
class DFSFrame {
  int node;
  int nextIndex;

  DFSFrame(int node) {
    this.node = node;
    this.nextIndex = 0;
  }
}

void setup() {
  size(1000, 700);
  smooth();

  textAlign(CENTER, CENTER);

  createGraph();
  setNodePosition();

  resetSearch();
}

void draw() {
  background(245);

  drawTitle();
  drawEdges();
  drawNodes();
  drawInformation();
  drawControls();

  if (!paused && !finished && !mode.equals("READY")) {
    frameCounter++;

    if (frameCounter >= animationSpeed) {
      frameCounter = 0;
      nextStep();
    }
  }
}

// ===============================
// Graph 생성
// ===============================

void createGraph() {
  graph = (ArrayList<Integer>[]) new ArrayList[NODE_COUNT];

  for (int i = 0; i < NODE_COUNT; i++) {
    graph[i] = new ArrayList<Integer>();
  }

  addEdge(0, 1);
  addEdge(0, 2);

  addEdge(1, 3);
  addEdge(1, 4);

  addEdge(2, 5);
  addEdge(2, 6);

  addEdge(3, 4);
}

void addEdge(int a, int b) {
  graph[a].add(b);
  graph[b].add(a);
}

// ===============================
// 노드 위치
// ===============================

void setNodePosition() {
  nodeX[0] = 500;
  nodeY[0] = 150;

  nodeX[1] = 300;
  nodeY[1] = 290;

  nodeX[2] = 700;
  nodeY[2] = 290;

  nodeX[3] = 180;
  nodeY[3] = 460;

  nodeX[4] = 420;
  nodeY[4] = 460;

  nodeX[5] = 580;
  nodeY[5] = 460;

  nodeX[6] = 820;
  nodeY[6] = 460;
}

// ===============================
// 제목
// ===============================

void drawTitle() {
  fill(30);
  textSize(30);
  text("BFS and DFS for a Graph", width/2, 40);

  textSize(14);
  fill(100);
  text("Breadth First Search / Depth First Search",
       width/2, 75);
}

// ===============================
// 간선 그리기
// ===============================

void drawEdges() {
  stroke(150);
  strokeWeight(3);

  for (int i = 0; i < NODE_COUNT; i++) {
    for (int j : graph[i]) {
      if (i < j) {
        line(nodeX[i], nodeY[i],
             nodeX[j], nodeY[j]);
      }
    }
  }
}

// ===============================
// 노드 그리기
// ===============================

void drawNodes() {
  for (int i = 0; i < NODE_COUNT; i++) {

    if (i == currentNode) {
      fill(255, 150, 40);
    }
    else if (visited[i]) {
      fill(80, 190, 120);
    }
    else if (frontier.contains(i)) {
      fill(100, 170, 240);
    }
    else {
      fill(220);
    }

    stroke(40);
    strokeWeight(2);

    ellipse(nodeX[i], nodeY[i], 65, 65);

    fill(20);
    textSize(23);
    text(i, nodeX[i], nodeY[i]);

    // 시작 노드 표시
    if (i == startNode) {
      fill(30);
      textSize(12);
      text("START", nodeX[i], nodeY[i] + 48);
    }
  }
}

// ===============================
// 정보 화면
// ===============================

void drawInformation() {
  fill(30);
  textAlign(LEFT, CENTER);
  textSize(17);

  text("MODE : " + mode, 40, 540);

  String current = currentNode == -1
    ? "None"
    : str(currentNode);

  text("Current Node : " + current, 40, 570);

  text("Visited Order : " + result, 40, 600);

  text("Frontier : " + frontier, 40, 630);

  if (finished) {
    fill(30, 150, 80);
    text("SEARCH COMPLETED!", 40, 660);
  }

  textAlign(CENTER, CENTER);
}

// ===============================
// BFS 시작
// ===============================

void startBFS() {
  resetSearch();

  mode = "BFS";

  visited[startNode] = true;
  queue.add(startNode);

  updateFrontier();
}

// ===============================
// DFS 시작
// ===============================

void startDFS() {
  resetSearch();

  mode = "DFS";

  visited[startNode] = true;
  result.add(startNode);

  stack.add(new DFSFrame(startNode));

  updateFrontier();
}

// ===============================
// 다음 탐색 단계
// ===============================

void nextStep() {

  if (mode.equals("BFS")) {
    bfsStep();
  }
  else if (mode.equals("DFS")) {
    dfsStep();
  }
}

// ===============================
// BFS 알고리즘
// ===============================

void bfsStep() {

  if (queue.isEmpty()) {
    finished = true;
    currentNode = -1;
    updateFrontier();
    return;
  }

  // Queue에서 가장 먼저 들어간 노드 제거
  currentNode = queue.remove(0);

  // 방문 순서 기록
  result.add(currentNode);

  // 인접 노드 확인
  for (int next : graph[currentNode]) {

    if (!visited[next]) {

      visited[next] = true;

      // Queue에 추가
      queue.add(next);
    }
  }

  updateFrontier();

  if (queue.isEmpty()) {
    finished = true;
  }
}

// ===============================
// DFS 알고리즘
// ===============================

void dfsStep() {

  if (stack.isEmpty()) {
    finished = true;
    currentNode = -1;
    updateFrontier();
    return;
  }

  DFSFrame top = stack.get(stack.size() - 1);

  currentNode = top.node;

  // 아직 확인할 인접 노드가 남아 있는 경우
  if (top.nextIndex < graph[currentNode].size()) {

    int next = graph[currentNode].get(top.nextIndex);

    top.nextIndex++;

    if (!visited[next]) {

      visited[next] = true;

      // 방문 순서 기록
      result.add(next);

      // Stack에 새로운 탐색 프레임 추가
      stack.add(new DFSFrame(next));
    }
  }
  else {

    // 더 이상 탐색할 인접 노드가 없으면 돌아가기
    stack.remove(stack.size() - 1);

    if (!stack.isEmpty()) {
      currentNode = stack.get(stack.size() - 1).node;
    }
    else {
      currentNode = -1;
      finished = true;
    }
  }

  updateFrontier();
}

// ===============================
// 탐색 대기 목록 업데이트
// ===============================

void updateFrontier() {

  frontier.clear();

  if (mode.equals("BFS")) {
    frontier.addAll(queue);
  }
  else if (mode.equals("DFS")) {

    for (int i = stack.size() - 1; i >= 0; i--) {
      frontier.add(stack.get(i).node);
    }
  }
}

// ===============================
// 초기화
// ===============================

void resetSearch() {

  for (int i = 0; i < NODE_COUNT; i++) {
    visited[i] = false;
  }

  result.clear();
  frontier.clear();
  queue.clear();
  stack.clear();

  currentNode = -1;

  mode = "READY";
  finished = false;
  paused = false;
  frameCounter = 0;
}

// ===============================
// 조작 방법 안내
// ===============================

void drawControls() {
  fill(30);
  textSize(15);

  text("LEFT / RIGHT : Change Start Node",
       770, 550);

  text("UP : BFS",
       770, 575);

  text("DOWN : DFS",
       770, 600);

  text("SPACE : Pause / Resume",
       770, 625);

  text("N : Next Step",
       770, 650);

  text("R : Reset",
       770, 675);
}

// ===============================
// 키보드 조작
// ===============================

void keyPressed() {

  if (keyCode == LEFT) {
    startNode = (startNode - 1 + NODE_COUNT)
                % NODE_COUNT;
    resetSearch();
  }

  else if (keyCode == RIGHT) {
    startNode = (startNode + 1)
                % NODE_COUNT;
    resetSearch();
  }

  else if (keyCode == UP) {
    startBFS();
  }

  else if (keyCode == DOWN) {
    startDFS();
  }

  else if (key == ' ') {
    if (!finished && !mode.equals("READY")) {
      paused = !paused;
    }
  }

  else if (key == 'n' || key == 'N') {
    if (!finished && !mode.equals("READY")) {
      nextStep();
    }
  }

  else if (key == 'r' || key == 'R') {
    resetSearch();
  }
}
