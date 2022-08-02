//You can include any C libraries that you normally use
#include "math.h"
#include "float.h"
#include "mex.h"   //--This one is required


int round(double a)
{
/*	int f = floor(a);
	if (a - f > 0.5)	return (int)(f+1);
	else
		return (int)(f);
*/
return (int)a;
}

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
//---Inside mexFunction---

//Declarations
mxArray *xData,*yData,*noiseData, *kernelData;
double *xValues, *outArray,*yValues,*noiseValues, *intensityArray,x,y,sum,xPast,yPast,*normVX,*normVY,*kernelValues;
double kernelSum;
int i,j,k, sign, iteration;
int rowLen, colLen,LIClength, stepCount[3];


//Copy input pointer x
xData = prhs[1];
yData = prhs[0];
noiseData = prhs[2];
kernelData = prhs[3];

//Get matrix x
xValues = mxGetPr(xData);
yValues = mxGetPr(yData);
noiseValues = mxGetPr(noiseData);
kernelValues = mxGetPr(kernelData);

rowLen = mxGetN(xData);
colLen = mxGetM(xData);
LIClength = (int)(mxGetN(kernelData) / 2);

//Allocate memory and assign output pointer
plhs[0] = mxCreateDoubleMatrix(colLen, rowLen, mxREAL); //mxReal is our data-type
plhs[1] = mxCreateDoubleMatrix(colLen, rowLen, mxREAL); 
plhs[2] = mxCreateDoubleMatrix(colLen, rowLen, mxREAL); 
plhs[3] = mxCreateDoubleMatrix(colLen, rowLen, mxREAL); 

//Get a pointer to the data space in our newly allocated memory
outArray = mxGetPr(plhs[0]);
intensityArray = mxGetPr(plhs[1]);
normVX = mxGetPr(plhs[3]);
normVY = mxGetPr(plhs[2]);



//Normalizing the vector field
for(i=0;i<rowLen;i++)
{
    for(j=0;j<colLen;j++)
    {
        intensityArray[(i*colLen)+j] = sqrt( xValues[(i*colLen)+j] * xValues[(i*colLen)+j] + yValues[(i*colLen)+j] * yValues[(i*colLen)+j] );
		if (intensityArray[(i*colLen)+j] != 0)  
		{
            normVX[(i*colLen)+j] = xValues[(i*colLen)+j] / intensityArray[(i*colLen)+j];
            normVY[(i*colLen)+j] = yValues[(i*colLen)+j] / intensityArray[(i*colLen)+j];
		}
        else
        {
            normVX[(i*colLen)+j] = xValues[(i*colLen)+j] ;
            normVY[(i*colLen)+j] = yValues[(i*colLen)+j] ;
        }
		}
}
            
//if (colLen > rowLen) LIClength = colLen / 10; else LIClength = rowLen / 10;  // Define LIC length;

for(i=0;i<rowLen;i++)
{
    for(j=0;j<colLen;j++)
    {
   //     stepCount = 1;
        sum = 0;
        kernelSum = 0;
       
	for (sign=-1;sign<2;sign = sign + 2)
	if (sign != 0)
	{
        iteration = sign + 1;
        stepCount[iteration] = 0;
		x = i; y = j;	
		for (k=1;k<LIClength * 10;k++)
		{
			xPast = x;
            yPast = y;

			x = x + sign * normVX[((int)(xPast))*colLen+(int)(yPast)] ;
            if (x < 0)  break;
            if (x > rowLen - 1) break; 

            
            y = y + sign * normVY[((int)(x))*colLen+(int)(y)];
            if (y < 0)  break;
            if (y > colLen - 1) break; 
                           
			if ((((int)(x) != (int)(xPast)) || ((int)(y) != (int)(yPast)) ))
			{
               stepCount[iteration]++;
               if (stepCount[iteration] > LIClength) break;
               sum += kernelValues[(int)(sign * stepCount[iteration]+ LIClength)] * noiseValues[((int)(x)*colLen)+(int)(y)];
               kernelSum += kernelValues[(int)(sign * stepCount[iteration]+ LIClength)];
			}
          
          }
	}
		outArray[(i*colLen)+j] = sum / kernelSum; 
	}
    
    }
	
}
