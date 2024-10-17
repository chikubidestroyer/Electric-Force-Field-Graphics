import java.util.*;
class Board{
  Pixel[][] board;
  List<TestCharge> charges;
  Board(){
    board = new Pixel[height][width];
    charges = new ArrayList<TestCharge>();
  }
  class TestCharge{
    boolean isNegative;
    int x;
    int y;
    TestCharge(boolean isNeg, int x, int y){
      isNegative = isNeg;
      this.x = x;
      this.y = y;
    }
  }
  class Pixel{
    TestCharge p;
    PVector forceDir;
    int x;
    int y;
    Pixel(TestCharge p, int x, int y){
      this.p = p;
      this.x = x;
      this.y = y;
      if(p == null) forceDir = calculateDirection(x,y);
      else{ 
        forceDir = null;
        charges.add(p);
      }
    }
    
    
  }
  PVector calculateDirection(int x, int y){
    PVector result = new PVector(0,0);
    for(TestCharge c : charges){
      float magnitude = 100/pow(dist(x,y, c.x, c.y)/50, 2);
      //float magnitude = 5;
      float yDiff = c.y - y;
      float xDiff = c.x - x;
      if(!c.isNegative){
        yDiff = -yDiff;
        xDiff = -xDiff;
      }
      float angle;
      angle = atan(yDiff/xDiff);
      //else angle = PI/2;
      float yDir = magnitude*sin(angle);
      float xDir = magnitude*cos(angle);
      if(yDir * yDiff < 0) yDir = -yDir;
      if(xDir * xDiff < 0) xDir = -xDir;
      result.add(new PVector(xDir, yDir));
    }
    float div = sqrt(pow(result.x,2)+pow(result.y,2));
    result = new PVector(20*result.x/div, 20*result.y/div);
    return result;
  }
  
  
  void drawBoard(){
    for(int row = 0; row < height; row+=40){
      for(int col = 0; col < width; col+=40){
        System.out.println(row +" " + col);
        Pixel px = board[row][col];
        if(px.p == null){
          fill(0);
          stroke(255);
          circle(px.x,px.y,3);
          line(px.x, px.y, px.x+px.forceDir.x, px.y+px.forceDir.y);
          //fill(0);
        }
        
      }
    }
    for(TestCharge c : charges){
      if(c.isNegative) fill(0,0,255);
      else fill(255,0,0);
      circle(c.x,c.y, 10);
    }
  }
  void setCharges(int num, boolean isNeg){
    for(int i = 0; i < num; i++){
      
      int x = (int)random((int)width/40)*40;
      int y = (int)random((int)height/40)*40;
      //System.out.println(board[y][x]);
      if(board[y][x] == null){
        board[y][x] = new Pixel(new TestCharge(isNeg, x, y), x, y);
        charges.add(board[y][x].p);
      } else i--;
    }
  }
  
  void setAll(){
    for(int row = 0; row < height; row+=40){
      for(int col = 0; col < width; col+=40){
        if(board[row][col] == null){
          board[row][col] = new Pixel(null, col, row);
        }
      }
    }
  }
}

void setup(){
  
  size(800,800);
  //strokeWeight(1);
  background(0);
  int numPos = 2;
  int numNeg = 3;
  Board invoker = new Board();
  //Board.Pixel[][] board = invoker.board;
  
  invoker.setCharges(numPos, false);
  invoker.setCharges(numNeg, true);
  
  invoker.setAll();
  invoker.drawBoard();
  saveFrame("pic.jpeg");
}
