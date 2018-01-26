class Tile {

  float a_curr_gen;
  float b_curr_gen;

  float a_next_gen;
  float b_next_gen;

  float a_prev_gen;
  float b_prev_gen;

  float feed;
  float kill;

  int x;
  int y;

  color colStart;
  color colEnd;

  float fillVal;

  PVector Laplacian_Result;
  int generation;

  Tile(float a_val, float b_val, int x_val, int y_val, float feed_val, float kill_val)
  {
    Laplacian_Result = new PVector();
    a_curr_gen = a_val;
    b_curr_gen = b_val;
    x = x_val;
    y = y_val;
    colStart = color(0, 0, 255);
    colEnd = color(255, 0, 0);
    feed = feed_val;
    kill = kill_val;
   
  }
  Tile(float a_val, float b_val, int x_val, int y_val)
  {
    Laplacian_Result = new PVector();
    a_curr_gen = a_val;
    b_curr_gen = b_val;
    x = x_val;
    y = y_val;
    colStart = color(0, 0, 255);
    colEnd = color(255, 0, 0);
    feed = 0;
    kill = 0;
  
  }

  void CalcNextState()
  {

    a_next_gen = a_curr_gen + (Diffusion_Rate_a  * Laplacian_Result.x  -(a_curr_gen * pow(b_curr_gen, 2)) + feed * (1 - a_curr_gen)) * Delta_Time;
    b_next_gen = b_curr_gen + (Diffusion_Rate_b  * Laplacian_Result.y +(a_curr_gen * pow(b_curr_gen, 2)) - (kill + feed) * b_curr_gen) * Delta_Time;

  if(a_next_gen > 1)
  {
    a_next_gen = norm(a_next_gen, 0, a_next_gen + 0.1);
  }
  if(b_next_gen > 1)
  {
      b_next_gen = norm(b_next_gen, 0, b_next_gen + 0.1);
  }
   a_prev_gen = a_curr_gen;
   b_prev_gen = b_curr_gen;;
 
    a_curr_gen = a_next_gen;
    b_curr_gen = b_next_gen;
    generation++;
    Display();
  }

  void CalcNeighbors(Tile[][] tiles, int  x, int  y)

  {
    PVector a_b = new PVector(0, 0);
    PVector lapVec = new PVector(0, 0);

    for (int i = x - 1; i <= x+1; i++)
    {
      for (int j = y -1; j <= y+ 1; j++)
      {    
         int tileOffsetX = abs(i % scaled_width);
        int tileOffsetY = abs(j % scaled_height);

        lapVec = Laplacian(x, y, i, j, tiles[tileOffsetX][tileOffsetY].a_curr_gen, tiles[tileOffsetX][tileOffsetY].b_curr_gen);
        a_b.x += lapVec.x;
        a_b.y += lapVec.y;

    
        lapVec.x = 0;
        lapVec.y = 0;
      }
    }

    Laplacian_Result.x = a_b.x;
    Laplacian_Result.y = a_b.y;

    CalcNextState();
  }


  PVector Laplacian(int x, int y, int i, int j, float a_val, float b_val)
  {
    PVector lapVec = new PVector(a_val, b_val);
    if (i == x && j == y)
    {
      lapVec.x *= -1;
      lapVec.y *= -1;
    } else if ((i == x + 1 || i == x - 1) && j == y)
    {
      lapVec.x *= 0.2;
      lapVec.y *= 0.2;
    } else if ((j == y + 1 || j == y - 1) && i == x)
    {
      lapVec.x *= 0.2;
      lapVec.y *= 0.2;
    } else if (((i == x + 1) || (i == x - 1)) && j == y + 1)
    {
      lapVec.x *= 0.05;
      lapVec.y *= 0.05;
    } else if (((i == x + 1) || (i == x - 1)) && j == y - 1)
    {
      lapVec.x *= 0.05;
      lapVec.y *= 0.05;
    } else 
    {
      return lapVec;
    }

    return lapVec;
  }

  void Display()
  {
    
    if(a_curr_gen == a_prev_gen)
    {
      return;
    }      
    colorMode(HSB, 1.0);
    colStart =  color(a_curr_gen, b_next_gen, (a_next_gen + b_next_gen) / 1);  
    fill(colStart);
   // colStart = color(a_curr_gen, b_next_gen / 1, a_curr_gen);
   // colEnd = color(b_curr_gen, a_curr_gen, b_curr_gen);
    //fill(colStart);
    noStroke();
    rect(x * Row_Col_Mult, y * Row_Col_Mult, Row_Col_Mult, Row_Col_Mult);
   
  }

}