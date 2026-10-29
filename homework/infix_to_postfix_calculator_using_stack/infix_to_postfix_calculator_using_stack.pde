
import java.util.Stack;

String inputExp = "";
String resultExp = "";
String message = "수식을 입력하세요. 예: 112+34 또는 a*(b+c)/d";

int prec(char c) {
  if (c == '^')
    return 3;
  else if (c == '*' || c == '/')
    return 2;
  else if (c == '+' || c == '-')
    return 1;
  else
    return -1;
}


boolean isRightAssociative(char c) {
  return c == '^';
}


String infixToPostfix(String s) {
  Stack<Character> st = new Stack<Character>();
  StringBuilder res = new StringBuilder();

  int i = 0;

  while (i < s.length()) {
    char c = s.charAt(i);


    if (Character.isWhitespace(c)) {
      i++;
      continue;
    }

    if (Character.isDigit(c)) {
      StringBuilder number = new StringBuilder();

      while (i < s.length() &&
             Character.isDigit(s.charAt(i))) {
        number.append(s.charAt(i));
        i++;
      }

      if (res.length() > 0) {
        res.append(" ");
      }

      res.append(number);
      continue;
    }


    else if (Character.isLetter(c)) {
      if (res.length() > 0) {
        res.append(" ");
      }

      res.append(c);
    }


    else if (c == '(') {
      st.push(c);
    }


    else if (c == ')') {
      while (!st.isEmpty() && st.peek() != '(') {
        res.append(" ");
        res.append(st.pop());
      }

      if (st.isEmpty()) {
        return "오류: 괄호를 확인하세요.";
      }

      st.pop();
    }


    else if (prec(c) != -1) {
      while (!st.isEmpty() && st.peek() != '(' &&
        (prec(st.peek()) > prec(c) ||
        (prec(st.peek()) == prec(c) &&
        !isRightAssociative(c)))) {

        res.append(" ");
        res.append(st.pop());
      }

      st.push(c);
    }


    else {
      return "오류: 잘못된 문자가 있습니다.";
    }

    i++;
  }

  // 남은 연산자 처리
  while (!st.isEmpty()) {
    if (st.peek() == '(') {
      return "오류: 괄호를 확인하세요.";
    }

    res.append(" ");
    res.append(st.pop());
  }

  return res.toString().trim();
}

void setup() {
  size(700, 450);
  textFont(createFont("SansSerif", 20));
}

void draw() {
  background(245);


  fill(35, 45, 65);
  textAlign(CENTER, CENTER);
  textSize(28);
  text("Infix to Postfix Converter", width / 2, 45);


  textAlign(LEFT, CENTER);
  textSize(18);
  fill(50);
  text("중위 표기법 수식 입력:", 50, 105);


  fill(255);
  stroke(100, 130, 180);
  strokeWeight(2);
  rect(50, 130, 600, 55, 8);

  // 입력 텍스트
  fill(30);
  textSize(22);
  textAlign(LEFT, CENTER);

  String displayInput = inputExp;

  if (frameCount % 60 < 30) {
    displayInput += "|";
  }

  text(displayInput, 65, 157.5);

  drawButton(
    50, 215, 180, 50,
    "변환하기", color(55, 125, 220)
  );

  drawButton(
    250, 215, 180, 50,
    "초기화", color(100, 110, 125)
  );

  fill(50);
  textSize(18);
  textAlign(LEFT, CENTER);
  text("변환 결과:", 50, 310);


  fill(255);
  stroke(210);
  strokeWeight(1);
  rect(50, 335, 600, 65, 8);

  fill(20, 130, 85);
  textSize(22);
  textAlign(LEFT, CENTER);

  if (resultExp.length() > 0) {
    text(resultExp, 65, 367.5);
  } else {
    fill(150);
    text("결과가 여기에 표시됩니다.", 65, 367.5);
  }

  // 안내 메시지
  fill(80);
  textSize(14);
  textAlign(CENTER, CENTER);
  text(message, width / 2, 425);
}
void drawButton(
  int x, int y, int w, int h,
  String label, color buttonColor
) {
  stroke(255);
  strokeWeight(1);
  fill(buttonColor);
  rect(x, y, w, h, 10);

  fill(255);
  textAlign(CENTER, CENTER);
  textSize(18);
  text(label, x + w / 2, y + h / 2);
}
void convertInput() {
  if (inputExp.trim().length() == 0) {
    resultExp = "";
    message = "먼저 수식을 입력하세요.";
    return;
  }

  String converted = infixToPostfix(inputExp);

  if (converted.startsWith("오류:")) {
    resultExp = "";
    message = converted;
  } else {
    resultExp = converted;
    message = "변환이 완료되었습니다!";
  }
}
void mousePressed() {

  // 변환하기 버튼
  if (mouseX >= 50 && mouseX <= 230 &&
      mouseY >= 215 && mouseY <= 265) {
    convertInput();
  }

  else if (mouseX >= 250 && mouseX <= 430 &&
           mouseY >= 215 && mouseY <= 265) {
    inputExp = "";
    resultExp = "";
    message = "수식을 입력하세요. 예: 112+34 또는 a*(b+c)/d";
  }

  // 입력창 클릭 시 입력 가능
  else if (mouseX >= 50 && mouseX <= 650 &&
           mouseY >= 130 && mouseY <= 185) {
    message = "수식을 입력한 후 변환 버튼을 누르세요.";
  }
}

void keyPressed() {

  if (key == ENTER || key == RETURN) {
    convertInput();
  }

  else if (key == BACKSPACE) {
    if (inputExp.length() > 0) {
      inputExp = inputExp.substring(
        0, inputExp.length() - 1
      );
    }
  }

  // 입력 가능한 문자
  else if (key != CODED &&
           key != DELETE &&
           key != ESC &&
           key != TAB) {

    if ((key >= 32 && key <= 126) ||
        key == ' ') {
      inputExp += key;
    }
  }
}
