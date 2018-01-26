static final int Row_Col_Mult = 2;
static final float Diffusion_Rate_a = 1;
static final float Diffusion_Rate_b = 0.5;
//float Feed_Rate = 0.0460;
//float Kill_Rate = 0.0594;
static final float Delta_Time = 1;
boolean recordFrames = false;
Tile[][] tiles;

int scaled_width;
int scaled_height;
int arr_size;
int total_x = 0;
int total_y = 0;

void setup()
{

  size(800, 800, P2D);
  noSmooth();
  background(80, 50);
  scaled_width = width/Row_Col_Mult;
  scaled_height = height/Row_Col_Mult;

  arr_size = scaled_width * scaled_height;
  tiles = new Tile[scaled_width][scaled_height];
       
   //    feed = 0.062; // good results!
   //    kill = 0.061;// good results!    
   //    feed = 0.06;  
    //   kill = 0.0590;
  GenerateGrid();
}
void draw()
{
  surface.setTitle((int)frameRate + "fps");

  CalcNextState();
  if(recordFrames && (frameCount % 2 == 0))
  {
   // print(" a" + tiles[scaled_width/2][scaled_height/2].a_curr_gen + " b" + tiles[scaled_width/2][scaled_height/2].b_curr_gen + " ");
   saveFrame("Movie/images-######.png");
  }
}

void GenerateGrid()
{
  float feed = 0.062;
  float kill = 0.061;
  GenerateGrid(feed, kill);
}
void GenerateGrid(float feed, float kill)
{
  for (int y = 0; y < scaled_height; y++)
  {
    for (int x = 0; x < scaled_width; x++)
    {
       feed = map(x, 0, scaled_width, 0.1, 0.01);
       kill = map(y, 0, scaled_height, 0.01, 0.1);
  
      // feed = map(x, 0, scaled_width, 0.08, 0.04);
      // kill = map(y, 0, scaled_height, 0.07, 0.05);
    
      tiles[x][y] = new Tile(1.0, 0.0, x, y, feed, kill);

      if (random(-5, 5) > 4)
      {
         tiles[x][y].b_curr_gen = 1.0; 
      }    
    }
  }
}

void CalcNextState()
{
  for (int y = 0; y < scaled_height; y++)
  {
    for (int x = 0; x < scaled_width; x++)
    {
      tiles[x][y].CalcNeighbors(tiles, x, y);
    }
  }
}