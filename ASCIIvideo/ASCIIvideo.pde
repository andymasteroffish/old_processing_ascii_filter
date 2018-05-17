/*
 * ASCII video converter
 * (c) Andy Wallace
 * 2011
 *
 * Based on code by Ben Fry found in the example files bundled with Processing under library/Video (Capture).
 *
 * Pixels are evaluated in square groups of four, which are compared to a list of letters.
 * Each character was preprocessed by a seperate application for it's weight in the four quadrants.
 * The program selects ASCII character that best fits each pixel group.
 */

import processing.video.*;

Capture video;  //gets the image from the camera

//size of video
int vidW=int(160*1.2);
int vidH=int(120*1.2);

//letters
char[] letters;
float[][] letterWeight;

//font info
PFont font;
float fontSize = 12;

//sizing
float scaleW;
float scaleH;

void setup(){
  size(640*2,480*2);
  scaleW=width/vidW;
  scaleH=height/vidH;
  
  //font size needs to scale with the size of the window and the resolution of the incoming video
  fontSize=12*(width/640)*(160/float(vidW));
  
  //set the font
  font = loadFont("UniversLTStd-Light-48.vlw");
  
  //width, height, and fps set by Capture()
  video= new Capture (this,vidW,vidH,15);
  video.start();
  
  //setting up letters
  setLetters();
  
}

//get the new frame when it is available
public void captureEvent(Capture c){
  c.read();
}

void draw(){
  background(255);
  fill(0);
  textFont(font, fontSize);
  
  //set(0, 0, video);    //show the video
  
  //checking each group of 4 pixels
  for (int x=0; x<vidW-1; x+=2){
    
    for (int y=0; y<vidH-1; y+=2){
      
      int[] vals=new int[4];  //stores the four values
      
      for (int i=0; i<4; i++){
        //figure out which of the four x,y values we're checking
        int checkX=x;
        int checkY=y;
        if (i%2==1)  checkX=x+1;
        if (i>1)     checkY=y+1;
        
        //get the pixel color at this point
        int pixColor=video.pixels[getPixel(checkX,checkY)];
        
        //bitshifting to get the different color values
        int r = (pixColor>>16) & 0xff;  //I think & is the union operator, but I should check.
        int g = (pixColor>>8) & 0xff;
        int b = (pixColor) & 0xff;
        
        //find the strongest value
        vals[i]=max(r,g,b);
      }
      
      //if it was different enough, find a good fit for the group
      //go through all of the letetrs and see which one is the best fit
      int bestFit=0;           //array location of the best Fit
      int bestFitDif=10000;  //difference in pixels from bestFit to the current pixel group
      for (int i=0; i<94; i++){
        //find out how closely this letter[i] fits the current group of 4 pixels 
        int dif=0;
        for (int k=0; k<4; k++)
          dif+=abs(letterWeight[i][k]-vals[k]);
         
        //is this a clsoer fit than the current bestFit?
        if (dif<bestFitDif){
          bestFit=i;
          bestFitDif=dif;
        }
      }
      //draw the letter
      text(letters[bestFit],map(x,0,vidW,0,width),map(y,0,vidH,0,height));
      
    }
  }
 
}


int getPixel(int x, int y){
  return x+y*vidW;
}

void setLetters(){
  
  //fill letters with 94 chars
  letters=new char[94];
  String lettersString =
  " .`-_':,;^=+/\"|)\\<>)%*&{}][$@?!#1234567890qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM";
  for (int i=0; i<94; i++)
    letters[i]=lettersString.charAt(i);
  
  
  letterWeight=new float[94][4];

  //copy pasted from ASCIIvideoCharacterWeights output
  letterWeight[0][0]=255.0;
  letterWeight[0][1]=249.58127;
  letterWeight[0][2]=249.58127;
  letterWeight[0][3]=244.19861;
  letterWeight[1][0]=255.0;
  letterWeight[1][1]=249.58127;
  letterWeight[1][2]=208.46277;
  letterWeight[1][3]=244.19861;
  letterWeight[2][0]=203.42131;
  letterWeight[2][1]=249.58127;
  letterWeight[2][2]=249.58127;
  letterWeight[2][3]=244.19861;
  letterWeight[3][0]=255.0;
  letterWeight[3][1]=249.58127;
  letterWeight[3][2]=162.6059;
  letterWeight[3][3]=244.19861;
  letterWeight[4][0]=255.0;
  letterWeight[4][1]=249.58127;
  letterWeight[4][2]=249.58127;
  letterWeight[4][3]=244.19861;
  letterWeight[5][0]=186.5455;
  letterWeight[5][1]=249.58127;
  letterWeight[5][2]=249.58127;
  letterWeight[5][3]=244.19861;
  letterWeight[6][0]=213.93822;
  letterWeight[6][1]=249.58127;
  letterWeight[6][2]=209.49612;
  letterWeight[6][3]=244.19861;
  letterWeight[7][0]=255.0;
  letterWeight[7][1]=249.58127;
  letterWeight[7][2]=210.03853;
  letterWeight[7][3]=244.19861;
  letterWeight[8][0]=215.12138;
  letterWeight[8][1]=249.58127;
  letterWeight[8][2]=211.42337;
  letterWeight[8][3]=244.19861;
  letterWeight[9][0]=166.54803;
  letterWeight[9][1]=136.90443;
  letterWeight[9][2]=208.01595;
  letterWeight[9][3]=202.96582;
  letterWeight[10][0]=238.44655;
  letterWeight[10][1]=229.61192;
  letterWeight[10][2]=113.49992;
  letterWeight[10][3]=80.211525;
  letterWeight[11][0]=249.11235;
  letterWeight[11][1]=210.84901;
  letterWeight[11][2]=158.5454;
  letterWeight[11][3]=63.920185;
  letterWeight[12][0]=124.19985;
  letterWeight[12][1]=249.49216;
  letterWeight[12][2]=113.61626;
  letterWeight[12][3]=244.19861;
  letterWeight[13][0]=118.30865;
  letterWeight[13][1]=249.58127;
  letterWeight[13][2]=249.58127;
  letterWeight[13][3]=244.19861;
  letterWeight[14][0]=125.50251;
  letterWeight[14][1]=249.58127;
  letterWeight[14][2]=120.94708;
  letterWeight[14][3]=244.19861;
  letterWeight[15][0]=133.23085;
  letterWeight[15][1]=249.58127;
  letterWeight[15][2]=112.16954;
  letterWeight[15][3]=244.19861;
  letterWeight[16][0]=122.55756;
  letterWeight[16][1]=249.58127;
  letterWeight[16][2]=116.336945;
  letterWeight[16][3]=242.07928;
  letterWeight[17][0]=253.49832;
  letterWeight[17][1]=167.79312;
  letterWeight[17][2]=105.509476;
  letterWeight[17][3]=129.18309;
  letterWeight[18][0]=175.92451;
  letterWeight[18][1]=240.0489;
  letterWeight[18][2]=163.01141;
  letterWeight[18][3]=75.02624;
  letterWeight[19][0]=133.23085;
  letterWeight[19][1]=249.58127;
  letterWeight[19][2]=112.16954;
  letterWeight[19][3]=244.19861;
  letterWeight[20][0]=123.85321;
  letterWeight[20][1]=31.175058;
  letterWeight[20][2]=220.74445;
  letterWeight[20][3]=16.44722;
  letterWeight[21][0]=101.11018;
  letterWeight[21][1]=142.32828;
  letterWeight[21][2]=249.58127;
  letterWeight[21][3]=244.19861;
  letterWeight[22][0]=69.440186;
  letterWeight[22][1]=65.16126;
  letterWeight[22][2]=51.648434;
  letterWeight[22][3]=-89.24801;
  letterWeight[23][0]=108.1928;
  letterWeight[23][1]=249.58127;
  letterWeight[23][2]=96.87294;
  letterWeight[23][3]=244.19861;
  letterWeight[24][0]=107.42569;
  letterWeight[24][1]=249.58127;
  letterWeight[24][2]=96.64687;
  letterWeight[24][3]=244.19861;
  letterWeight[25][0]=100.72925;
  letterWeight[25][1]=249.58127;
  letterWeight[25][2]=110.477356;
  letterWeight[25][3]=244.19861;
  letterWeight[26][0]=101.407845;
  letterWeight[26][1]=249.58127;
  letterWeight[26][2]=110.477356;
  letterWeight[26][3]=244.19861;
  letterWeight[27][0]=-20.04906;
  letterWeight[27][1]=160.36298;
  letterWeight[27][2]=29.859222;
  letterWeight[27][3]=45.70874;
  letterWeight[28][0]=59.41646;
  letterWeight[28][1]=-48.200092;
  letterWeight[28][2]=13.483257;
  letterWeight[28][3]=-74.375565;
  letterWeight[29][0]=168.04073;
  letterWeight[29][1]=124.1465;
  letterWeight[29][2]=134.0746;
  letterWeight[29][3]=243.77672;
  letterWeight[30][0]=105.48186;
  letterWeight[30][1]=249.58127;
  letterWeight[30][2]=143.18857;
  letterWeight[30][3]=244.19861;
  letterWeight[31][0]=77.83748;
  letterWeight[31][1]=84.34351;
  letterWeight[31][2]=50.478363;
  letterWeight[31][3]=77.15432;
  letterWeight[32][0]=132.43782;
  letterWeight[32][1]=196.04541;
  letterWeight[32][2]=178.34781;
  letterWeight[32][3]=184.38245;
  letterWeight[33][0]=139.8695;
  letterWeight[33][1]=95.28547;
  letterWeight[33][2]=50.299473;
  letterWeight[33][3]=143.44046;
  letterWeight[34][0]=125.750854;
  letterWeight[34][1]=93.29142;
  letterWeight[34][2]=114.69392;
  letterWeight[34][3]=73.929565;
  letterWeight[35][0]=167.92502;
  letterWeight[35][1]=108.68667;
  letterWeight[35][2]=108.05044;
  letterWeight[35][3]=60.666046;
  letterWeight[36][0]=34.39028;
  letterWeight[36][1]=145.13747;
  letterWeight[36][2]=109.108986;
  letterWeight[36][3]=78.341415;
  letterWeight[37][0]=41.485504;
  letterWeight[37][1]=113.163055;
  letterWeight[37][2]=43.320496;
  letterWeight[37][3]=74.7276;
  letterWeight[38][0]=166.42465;
  letterWeight[38][1]=79.4804;
  letterWeight[38][2]=130.43973;
  letterWeight[38][3]=211.43874;
  letterWeight[39][0]=70.2141;
  letterWeight[39][1]=94.004745;
  letterWeight[39][2]=39.898712;
  letterWeight[39][3]=63.229923;
  letterWeight[40][0]=80.73199;
  letterWeight[40][1]=84.864174;
  letterWeight[40][2]=71.2102;
  letterWeight[40][3]=48.05841;
  letterWeight[41][0]=86.43521;
  letterWeight[41][1]=101.53566;
  letterWeight[41][2]=69.75084;
  letterWeight[41][3]=82.25113;
  letterWeight[42][0]=163.17708;
  letterWeight[42][1]=158.38931;
  letterWeight[42][2]=78.41349;
  letterWeight[42][3]=60.922028;
  letterWeight[43][0]=203.70633;
  letterWeight[43][1]=166.75883;
  letterWeight[43][2]=67.0997;
  letterWeight[43][3]=9.981803;
  letterWeight[44][0]=168.99625;
  letterWeight[44][1]=182.50491;
  letterWeight[44][2]=20.847347;
  letterWeight[44][3]=84.4118;
  letterWeight[45][0]=148.0424;
  letterWeight[45][1]=247.18028;
  letterWeight[45][2]=121.825134;
  letterWeight[45][3]=244.19861;
  letterWeight[46][0]=98.29884;
  letterWeight[46][1]=249.18459;
  letterWeight[46][2]=94.25668;
  letterWeight[46][3]=243.3778;
  letterWeight[47][0]=198.1908;
  letterWeight[47][1]=198.44484;
  letterWeight[47][2]=64.70368;
  letterWeight[47][3]=161.82243;
  letterWeight[48][0]=207.7746;
  letterWeight[48][1]=202.52727;
  letterWeight[48][2]=88.12988;
  letterWeight[48][3]=78.01354;
  letterWeight[49][0]=178.7353;
  letterWeight[49][1]=249.58127;
  letterWeight[49][2]=123.537025;
  letterWeight[49][3]=244.19861;
  letterWeight[50][0]=166.81546;
  letterWeight[50][1]=180.29166;
  letterWeight[50][2]=78.86115;
  letterWeight[50][3]=89.54299;
  letterWeight[51][0]=146.91512;
  letterWeight[51][1]=176.39838;
  letterWeight[51][2]=51.281075;
  letterWeight[51][3]=89.346596;
  letterWeight[52][0]=166.50917;
  letterWeight[52][1]=197.0498;
  letterWeight[52][2]=43.213005;
  letterWeight[52][3]=74.78724;
  letterWeight[53][0]=160.09566;
  letterWeight[53][1]=198.12125;
  letterWeight[53][2]=64.27844;
  letterWeight[53][3]=125.960335;
  letterWeight[54][0]=164.6957;
  letterWeight[54][1]=83.1623;
  letterWeight[54][2]=80.02553;
  letterWeight[54][3]=59.10829;
  letterWeight[55][0]=34.039413;
  letterWeight[55][1]=248.56183;
  letterWeight[55][2]=123.06131;
  letterWeight[55][3]=244.19861;
  letterWeight[56][0]=161.40959;
  letterWeight[56][1]=156.68588;
  letterWeight[56][2]=73.30992;
  letterWeight[56][3]=61.278347;
  letterWeight[57][0]=77.16993;
  letterWeight[57][1]=181.7229;
  letterWeight[57][2]=121.13886;
  letterWeight[57][3]=117.8393;
  letterWeight[58][0]=178.7353;
  letterWeight[58][1]=249.58127;
  letterWeight[58][2]=120.95385;
  letterWeight[58][3]=244.19861;
  letterWeight[59][0]=117.483475;
  letterWeight[59][1]=204.66132;
  letterWeight[59][2]=26.112734;
  letterWeight[59][3]=179.82065;
  letterWeight[60][0]=132.21268;
  letterWeight[60][1]=249.58127;
  letterWeight[60][2]=123.537025;
  letterWeight[60][3]=244.19861;
  letterWeight[61][0]=165.49602;
  letterWeight[61][1]=191.31717;
  letterWeight[61][2]=42.091576;
  letterWeight[61][3]=209.23416;
  letterWeight[62][0]=193.31645;
  letterWeight[62][1]=200.08775;
  letterWeight[62][2]=66.450836;
  letterWeight[62][3]=149.9339;
  letterWeight[63][0]=168.94177;
  letterWeight[63][1]=189.25304;
  letterWeight[63][2]=79.06995;
  letterWeight[63][3]=169.64883;
  letterWeight[64][0]=202.85974;
  letterWeight[64][1]=197.54834;
  letterWeight[64][2]=73.59611;
  letterWeight[64][3]=156.7032;
  letterWeight[65][0]=72.1633;
  letterWeight[65][1]=176.70917;
  letterWeight[65][2]=53.521263;
  letterWeight[65][3]=89.636475;
  letterWeight[66][0]=151.37764;
  letterWeight[66][1]=181.24509;
  letterWeight[66][2]=121.17743;
  letterWeight[66][3]=117.85409;
  letterWeight[67][0]=151.17137;
  letterWeight[67][1]=111.88949;
  letterWeight[67][2]=121.04027;
  letterWeight[67][3]=115.51925;
  letterWeight[68][0]=91.37161;
  letterWeight[68][1]=49.368702;
  letterWeight[68][2]=82.14286;
  letterWeight[68][3]=13.770704;
  letterWeight[69][0]=115.499695;
  letterWeight[69][1]=6.190956;
  letterWeight[69][2]=65.32332;
  letterWeight[69][3]=107.40192;
  letterWeight[70][0]=44.575974;
  letterWeight[70][1]=128.14104;
  letterWeight[70][2]=47.426025;
  letterWeight[70][3]=134.92883;
  letterWeight[71][0]=44.15891;
  letterWeight[71][1]=34.20045;
  letterWeight[71][2]=96.60164;
  letterWeight[71][3]=81.2794;
  letterWeight[72][0]=56.38275;
  letterWeight[72][1]=159.58836;
  letterWeight[72][2]=129.81189;
  letterWeight[72][3]=233.7813;
  letterWeight[73][0]=92.607635;
  letterWeight[73][1]=111.64368;
  letterWeight[73][2]=177.0366;
  letterWeight[73][3]=175.36906;
  letterWeight[74][0]=122.223526;
  letterWeight[74][1]=116.95999;
  letterWeight[74][2]=89.23117;
  letterWeight[74][3]=49.54015;
  letterWeight[75][0]=116.66053;
  letterWeight[75][1]=249.58127;
  letterWeight[75][2]=108.72777;
  letterWeight[75][3]=244.19861;
  letterWeight[76][0]=91.394516;
  letterWeight[76][1]=48.46434;
  letterWeight[76][2]=82.20376;
  letterWeight[76][3]=45.610443;
  letterWeight[77][0]=67.621735;
  letterWeight[77][1]=50.63094;
  letterWeight[77][2]=72.14486;
  letterWeight[77][3]=205.64458;
  letterWeight[78][0]=149.0646;
  letterWeight[78][1]=107.87112;
  letterWeight[78][2]=64.25928;
  letterWeight[78][3]=32.3907;
  letterWeight[79][0]=50.076763;
  letterWeight[79][1]=145.4989;
  letterWeight[79][2]=129.94374;
  letterWeight[79][3]=29.123972;
  letterWeight[80][0]=70.33268;
  letterWeight[80][1]=53.11801;
  letterWeight[80][2]=61.470024;
  letterWeight[80][3]=52.087048;
  letterWeight[81][0]=37.369663;
  letterWeight[81][1]=139.32748;
  letterWeight[81][2]=98.35322;
  letterWeight[81][3]=225.57161;
  letterWeight[82][0]=95.70432;
  letterWeight[82][1]=110.22074;
  letterWeight[82][2]=79.28814;
  letterWeight[82][3]=-24.099098;
  letterWeight[83][0]=90.435776;
  letterWeight[83][1]=60.872467;
  letterWeight[83][2]=97.004555;
  letterWeight[83][3]=79.25813;
  letterWeight[84][0]=255.0;
  letterWeight[84][1]=116.80473;
  letterWeight[84][2]=123.19972;
  letterWeight[84][3]=119.69885;
  letterWeight[85][0]=62.086796;
  letterWeight[85][1]=145.84184;
  letterWeight[85][2]=69.63172;
  letterWeight[85][3]=103.10018;
  letterWeight[86][0]=122.223526;
  letterWeight[86][1]=249.58127;
  letterWeight[86][2]=64.25684;
  letterWeight[86][3]=168.25877;
  letterWeight[87][0]=145.1253;
  letterWeight[87][1]=65.80882;
  letterWeight[87][2]=24.619518;
  letterWeight[87][3]=170.87108;
  letterWeight[88][0]=97.931046;
  letterWeight[88][1]=111.31075;
  letterWeight[88][2]=101.926605;
  letterWeight[88][3]=82.31353;
  letterWeight[89][0]=90.96461;
  letterWeight[89][1]=122.868065;
  letterWeight[89][2]=80.93671;
  letterWeight[89][3]=123.81722;
  letterWeight[90][0]=115.276306;
  letterWeight[90][1]=122.30198;
  letterWeight[90][2]=121.229866;
  letterWeight[90][3]=125.1819;
  letterWeight[91][0]=42.918507;
  letterWeight[91][1]=44.025204;
  letterWeight[91][2]=47.12739;
  letterWeight[91][3]=24.352352;
  letterWeight[92][0]=28.573591;
  letterWeight[92][1]=87.801476;
  letterWeight[92][2]=113.27808;
  letterWeight[92][3]=-24.99451;
  letterWeight[93][0]=11.423707;
  letterWeight[93][1]=187.36931;
  letterWeight[93][2]=110.22828;
  letterWeight[93][3]=-20.92726;



}
  
