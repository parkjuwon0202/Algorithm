int n=8; //<>//
int xstep=400;
int ystep=50;
int radius=30;
int mode=0;
int traversal=0;
int textcolor=0;
PFont font;

BTree tree = new BTree();

void setup() {
  size(1200, 600);

  font = loadFont("AgencyFB-Reg-16.vlw");
  textFont(font, 16);
  textAlign(LEFT, CENTER);
  stroke(192, 0, 0);

  newTree();
}

void mousePressed() {
  if(mouseButton == LEFT) {
    int x=(int)(100.*mouseX/width);

    if(tree.value == -1) {
      tree.insert(x);
    }
    else {
      tree.remove(tree.value);
    }
  }
}

void mouseReleased() {
  drawTree();
}

void mouseMoved() {
  tree.findNode();

  if(tree.value != -1) {
    fill(92);
    ellipse(tree.x, tree.y, radius, radius);
    fill(0);
    text(tree.value, tree.x, tree.y);
  }
  else {
    drawTree();
  }
}

void keyPressed() {
  if(key=='c' || key=='C') {
    background(200);
    tree.clear();
  }
  else if(key=='v' || key=='V' || key==' ') {
    drawTree();
    tree.printTree();
  }
  else if(key=='b' || key=='B') {
    newTree();
  }
  else if(key=='t' || key=='T') {
    traversal++;
    if(traversal==3) traversal=0;
    drawMode();
  }
  else if(key=='d' || key=='D') {
    if(textcolor==0) textcolor=1;
    else textcolor=0;
    drawTree();
  }
  else if(key=='s' || key=='S') {
    int x=(int)(100.*mouseX/width);

    if(tree.contains(x)) {
      println("Search " + x + " : Found");
    }
    else {
      println("Search " + x + " : Not Found");
    }
  }
  else if(key=='i' || key=='I') {
    int x=(int)(100.*mouseX/width);

    if(tree.insert(x)) {
      println("Insert : " + x);
    }
    else {
      println("Insert failed : " + x);
    }

    drawTree();
  }
}

void newTree() {
  tree.clear();

  for(int i=0; i<n; i++) {
    tree.insert((int)random(99));
  }

  drawTree();
}

void draw() {
}

void drawMode() {
  int x=20;
  int y=50;

  textFont(font, 24);
  textAlign(LEFT, CENTER);

  noStroke();
  fill(132);
  rect(10, height-y-12, 150, 26);

  fill(0);

  if(traversal==0) {
    text("inorder(t)", x, height-y);
  }
  else if(traversal==1) {
    text("preorder(t)", x, height-y);
  }
  else if(traversal==2) {
    text("postorder(t)", x, height-y);
  }

  text((int)(100.*mouseX/width)+" insert", x+150, height-y);

  text("I:insert S:search D:delete", x, height-50);
  text("T:traversal C:clear B:new V:print", x, height-24);

  stroke(192, 0, 0);
  textFont(font, 16);
  textAlign(CENTER, CENTER);
}

void drawTree() {
  background(200);
  tree.assignPosition();
  tree.drawTree();
  drawMode();
}

class BTree {
  Node root;
  int x, y, value, index;

  void clear() {
    root=null;
  }

  boolean contains(int in) {
    return contains(in, root);
  }

  boolean contains(int in, Node curr) {
    if(curr==null) return false;

    if(in<curr.val) {
      return contains(in, curr.left);
    }
    else if(in>curr.val) {
      return contains(in, curr.right);
    }
    else {
      return true;
    }
  }

  int findMax() {
    if(isEmpty()) {
      println("The tree was empty! Returning 0 to avoid an error");
      return 0;
    }
    else {
      return findMax(root).val;
    }
  }

  Node findMax(Node curr) {
    if(curr==null) return null;
    else if(curr.right==null) return curr;

    return findMax(curr.right);
  }

  int findMin() {
    if(isEmpty()) {
      println("The tree was empty! Returning 0 to avoid an error");
      return 0;
    }
    else {
      return findMin(root).val;
    }
  }

  Node findMin(Node curr) {
    if(curr==null) return null;
    else if(curr.left==null) return curr;

    return findMin(curr.left);
  }

  int treeHeight() {
    return treeHeight(root);
  }

  int treeHeight(Node curr) {
    if(curr==null) return -1;

    return 1+max(
      treeHeight(curr.left),
      treeHeight(curr.right)
    );
  }

  boolean isEmpty() {
    return root==null;
  }

  boolean insert(int in) {
    Node r=insert(in, root);

    if(r==null) return false;

    root=r;
    return true;
  }

  Node insert(int in, Node curr) {
    if(curr==null) {
      return new Node(in);
    }

    Node res=null;

    if(in<curr.val) {
      res=insert(in, curr.left);

      if(res!=null) {
        curr.left=res;
      }
    }
    else if(in>curr.val) {
      res=insert(in, curr.right);

      if(res!=null) {
        curr.right=res;
      }
    }

    return res==null ? null : curr;
  }

  void remove(int in) {
    root=remove(in, root);
  }

  Node remove(int in, Node curr) {
    if(curr==null) return curr;

    if(in<curr.val) {
      curr.left=remove(in, curr.left);
    }
    else if(in>curr.val) {
      curr.right=remove(in, curr.right);
    }
    else if(curr.left!=null && curr.right!=null) {
      curr.val=findMin(curr.right).val;
      curr.right=remove(curr.val, curr.right);
    }
    else {
      curr=(curr.left!=null) ? curr.left : curr.right;
    }

    return curr;
  }

  void assignPosition() {
    if(!isEmpty()) {
      assignPosition(root, 0, 0);
    }
  }

  void assignPosition(Node curr, float dx, float dy) {
    if(curr!=null) {
      assignPosition(
        curr.left,
        dx-1./pow(2.,dy+1.),
        dy+1
      );

      curr.x=dx;
      curr.y=dy;

      assignPosition(
        curr.right,
        dx+1./pow(2.,dy+1.),
        dy+1
      );
    }
  }

  void printTree() {
    fill(0,0,255);
    index=0;

    if(isEmpty()) {
      println("The tree is empty");
    }
    else {
      if(traversal==0) {
        println("INORDER");
      }
      else if(traversal==1) {
        println("PREORDER");
      }
      else if(traversal==2) {
        println("POSTORDER");
      }

      printTree(root);
      println();
    }
  }

  void printTree(Node curr) {
    if(curr==null) return;

    if(traversal==0) {
      printTree(curr.left);

      println(
        curr.val+" "+index+
        " ("+curr.x+","+curr.y+")"
      );

      text(
        index,
        (int)(curr.x*xstep+width/2-radius/2-2),
        (int)(curr.y*ystep+radius-radius/2-2)
      );

      index++;

      printTree(curr.right);
    }

    else if(traversal==1) {
      println(
        curr.val+" "+index+
        " ("+curr.x+","+curr.y+")"
      );

      text(
        index,
        (int)(curr.x*xstep+width/2-radius/2-2),
        (int)(curr.y*ystep+radius-radius/2-2)
      );

      index++;

      printTree(curr.left);
      printTree(curr.right);
    }

    else if(traversal==2) {
      printTree(curr.left);
      printTree(curr.right);

      println(
        curr.val+" "+index+
        " ("+curr.x+","+curr.y+")"
      );

      text(
        index,
        (int)(curr.x*xstep+width/2-radius/2-2),
        (int)(curr.y*ystep+radius-radius/2-2)
      );

      index++;
    }
  }

  void findNode() {
    x=y=value=-1;

    if(isEmpty()) return;

    findNode(root);
  }

  void findNode(Node curr) {
    if(curr!=null) {
      findNode(curr.left);

      int dx=mouseX-(int)(curr.x*xstep+width/2);
      int dy=mouseY-(int)(curr.y*ystep+radius);

      if((dx*dx+dy*dy)<radius*radius/4) {
        x=(int)(curr.x*xstep+width/2);
        y=(int)(curr.y*ystep+radius);
        value=curr.val;
        return;
      }

      findNode(curr.right);
    }
  }

  void drawTree() {
    if(isEmpty()) {
      println("The tree is empty");
    }
    else {
      drawTreeLine(root);
      drawTree(root);
    }
  }

  void drawTreeLine(Node curr) {
    if(curr!=null) {
      drawTreeLine(curr.left);

      if(curr.left!=null) {
        line(
          (int)(curr.x*xstep+width/2),
          (int)(curr.y*ystep+radius),
          (int)(curr.left.x*xstep+width/2),
          (int)(curr.left.y*ystep+radius)
        );
      }

      if(curr.right!=null) {
        line(
          (int)(curr.x*xstep+width/2),
          (int)(curr.y*ystep+radius),
          (int)(curr.right.x*xstep+width/2),
          (int)(curr.right.y*ystep+radius)
        );
      }

      drawTreeLine(curr.right);
    }
  }

  void drawTree(Node curr) {
    if(curr!=null) {
      drawTree(curr.left);

      fill(255);

      ellipse(
        curr.x*xstep+width/2,
        curr.y*ystep+radius,
        radius,
        radius
      );

      if(textcolor==0) {
        fill(0);
      }
      else {
        fill(255);
      }

      text(
        curr.val,
        (int)(curr.x*xstep+width/2),
        (int)(curr.y*ystep+radius)
      );

      drawTree(curr.right);
    }
  }
}

class Node {
  int val;
  float x, y;
  Node left;
  Node right;

  Node(int v) {
    val=v;
  }

  Node(int v, Node l, Node r) {
    val=v;
    left=l;
    right=r;
  }

  public String toString() {
    if(left==null && right==null) {
      return "N("+val+")";
    }

    return "N("+val+", "+left+", "+right+")";
  }
}
