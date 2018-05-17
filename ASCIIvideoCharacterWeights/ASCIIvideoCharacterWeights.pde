String letters =
  " .`-_':,;^=+/\"|)\\<>)%*&{}][$@?!#1234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM";

PFont font;

int cur=0;

float[] maxV={0,0,0,0};
float[] minV={255,255,255,255};

void setup(){
  println(letters.length());
  size(300,300);
  font = loadFont("UniversLTStd-Light-48.vlw");
   textFont(font, 400);
   fill(0);
}

void draw(){
  if (cur<94){
    background(255);
    line(width/2,0,width/2,height);
    line(0,height/2,width,height/2);
    text(letters.charAt(cur),28,297);
    
    float[] vals= {0,0,0,0};
    
    //process the image
    loadPixels();
     for (int x=0; x<width; x++){
      for (int y=0; y<height; y++){
          int pixColor=pixels[getPixel(x,y)];
          
          //bitshifting to get the different color values
          int r = (pixColor>>16) & 0xff; 
          int g = (pixColor>>8) & 0xff;
          int b = (pixColor) & 0xff;
          
          int grey=max(r,g,b);
          
          int section=0;
          if (x<width/2 && y<height/2) section=0;
          if (x>=width/2 && y<height/2) section=1;
          if (x<width/2 && y>=height/2) section=2;
          if (x>=width/2 && y>=height/2) section=3;
         
          vals[section]+=grey;
        
      }
     }
     
     //normalize
     for (int i=0; i<4; i++){
      vals[i]=map(vals[i],0,255*((width*height)/4), 0,255); 
      vals[i]=map(vals[i],175,255,0,255);
      println("letterWeight["+cur+"]["+i+"]="+vals[i]+";");
      
      if (vals[i]>maxV[i])  maxV[i]=vals[i];
      if (vals[i]<minV[i])  minV[i]=vals[i];
     }
     
     //print the values
     //println("letterWeights[0]"+vals[0]+","+vals[1]+","+vals[2]+","+vals[3]+"},");
     
     cur++;
     
     if (cur==94){
//       println("max: "+maxV[0]+" , "+maxV[1]+" , "+maxV[2]+" , "+maxV[3]);
//       println("min: "+minV[0]+" , "+minV[1]+" , "+minV[2]+" , "+minV[3]);
     }
  }
  
}

void keyPressed(){
  println(mouseX+","+mouseY);
  cur++;
  if (cur==94)  cur=0;
}

int getPixel(int x, int y){
  return x+y*width;
}
