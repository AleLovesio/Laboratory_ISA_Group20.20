#include<stdio.h>
#include<stdlib.h>

#define N 2 /// order of the filter
#define NB 10  /// number of bits
#define NB_LA 11  /// number of bits after the Look Ahead transformation


const int b0 = 26; /// coefficient b0
const int b[N]={52, 26}; /// b array
const int a[N]={48, -25}; /// a array


/// Perform fixed point filtering assuming direct form II
///\param x is the new input sample
///\return the new output sample
int myfilter_LA(int x)
{
  static int Coeff[6]; /// array of the coefficient after the Look Ahead transformation
  static int b0_LA, b_LA[N], a_LA[N];
  
  static int sw[N+1]; /// w shift register
  static int first_run = 0; /// for cleaning the shift register
  int i; /// index
  int w; /// intermediate value (w)
  int y; /// output sample
  int fb, ff; /// feed-back and feed-forward results

  /// clean the buffer
  if (first_run == 0)
  {
    first_run = 1;
	//coefficients caluclation
	/*
	Coeff[0]=b0;
	Coeff[1]=(b[0]+ ((a[0]*b0) >> (NB -1)) );
	Coeff[2]=(b[1]+ ((a[0]*b[0]) >> (NB -1)) );
	Coeff[3]=(a[0]*b[1]) >> (NB -1);
	Coeff[4]=(a[1]+ ((a[0]*a[0]) >> (NB -1)) );
	Coeff[5]=(a[0]*a[1]) >> (NB -1);
	*/
	b0_LA=b0 << (NB_LA-NB);
	b_LA[0]=b[0] << (NB_LA-NB);
	b_LA[1]=b[1] << (NB_LA-NB);
	a_LA[0]=a[0] << (NB_LA-NB);
	a_LA[1]=a[1] << (NB_LA-NB);
	Coeff[0]=b0_LA;
	Coeff[1]=(b_LA[0]+ ((a_LA[0]*b0_LA) >> (NB -1)) );
	Coeff[2]=(b_LA[1]+ ((a_LA[0]*b_LA[0]) >> (NB -1)) );
	Coeff[3]=(a_LA[0]*b_LA[1]) >> (NB -1);
	Coeff[4]=(a_LA[1]+ ((a_LA[0]*a_LA[0]) >> (NB -1)) );
	Coeff[5]=(a_LA[0]*a_LA[1]) >> (NB -1);
    //print of the Look Ahead coefficients
	for (i=0; i<6; i++){
	  	printf("\n%d\n",Coeff[i]);
	}
    for (i=0; i<N+1; i++)
      sw[i] = 0;
  }
	
  x = x << (NB_LA-NB);
  /// compute feed-back and feed-forward
  fb = 0;
  ff = 0;
  for (i=0; i<N+1; i++)
  {
    if (i == 0){
        ff += (sw[i]*Coeff[i+1] >> (NB_LA-1));
    }
    else{
        fb += (sw[i]*Coeff[i+3]) >> (NB_LA-1);
        ff += (sw[i]*Coeff[i+1]) >> (NB_LA-1);
    }

  }\

  /// compute intermediate value (w) and output sample
  w = x + fb;
  y = (w*Coeff[0]) >> (NB_LA-1);
  y += ff;

  /// update the shift register
  for (i=N; i>0; i--)
    sw[i] = sw[i-1];
  sw[0] = w;

  return y >> (NB_LA-NB);
}

/// Perform fixed point filtering assuming direct form II after 1 stage of Look Ahead transformation
///\param x is the new input sample
///\return the new output sample
int myfilter(int x)
{
  static int sw[N]; /// w shift register
  static int first_run = 0; /// for cleaning the shift register
  int i; /// index
  int w; /// intermediate value (w)
  int y; /// output sample
  int fb, ff; /// feed-back and feed-forward results

  /// clean the buffer
  if (first_run == 0)
  {
    first_run = 1;
    for (i=0; i<N; i++)
      sw[i] = 0;
  }

  /// compute feed-back and feed-forward
  fb = 0;
  ff = 0;
  for (i=0; i<N; i++)
  {
    fb += (sw[i]*a[i]) >> (NB-1);
    ff += (sw[i]*b[i]) >> (NB-1);
  }\

  /// compute intermediate value (w) and output sample
  w = x + fb;
  y = (w*b0) >> (NB-1);
  y += ff;

  /// update the shift register
  for (i=N-1; i>0; i--)
    sw[i] = sw[i-1];
  sw[0] = w;

  return y;
}

int main (int argc, char **argv)
{
  FILE *fp_in;
  FILE *fp_out;
  FILE *fp_out_LA;

  int x;
  int y, y_LA;

  /// check the command line
  if (argc != 4)
  {
    printf("Use: %s <input_file> <output_file>\n", argv[0]);
    exit(1);
  }

  /// open files
  fp_in = fopen(argv[1], "r");
  if (fp_in == NULL)
  {
    printf("Error: cannot open %s\n",argv[1]);
    exit(2);
  }
  fp_out = fopen(argv[2], "w");
  fp_out_LA = fopen(argv[3], "w");

  /// get samples and apply filter
  fscanf(fp_in, "%d", &x);
  do{
    y = myfilter(x);
    y_LA = myfilter_LA(x);
    fprintf(fp_out,"%d\n", y);
    fprintf(fp_out_LA,"%d\n", y_LA);
    fscanf(fp_in, "%d", &x);
  } while (!feof(fp_in));

  fclose(fp_in);
  fclose(fp_out);
  fclose(fp_out_LA);

  

  return 0;

}
