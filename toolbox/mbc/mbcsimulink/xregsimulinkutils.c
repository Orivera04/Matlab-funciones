/*  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc. */

/*  $Revision: 1.3.6.1 $ */

// This include is for the qsort function used in SetKnot
#include <search.h>

// *************** SETINIT routine ********************
void SetInit(double *B0,double x,int poly_order, int num_knots, double *K, double* LIMITS)
{
	int i;

	// get the limits of the range e.g. [-1 1]
	double k0 = LIMITS[0];
	double kn = LIMITS[1];
	
	for (i = 0; i < poly_order ; i++)
		*B0++ = 0.0;


	K += poly_order;

	for (i = poly_order; i <= poly_order+num_knots; i++){
		if (x < k0)
			*B0 = (*K > k0) ? 0:1;
		else if(x >= kn)
			*B0 = (*(K+1) == kn) ? 1:0;
		else if ( (*K <= x) && (x < *(K+1)) )
			*B0 = 1.0;
		else
			*B0 = 0.0;
		K++;
		B0++;
	}
}

// *************** compare routine ********************
int compare( const void *arg1, const void *arg2 )
{
	double d1 = * (double*) arg1;
	double d2 = * (double*) arg2;

	if (d1 < d2)
		return -1;
	if (d1 == d2)
		return 0;
	
	return 1;
}

// *************** SETKNOT routine ********************
void SetKnot(double *K, int poly_order, double *knots, int num_knots, double* limits)
{
	// This routine will set the Knot position vector to be:
	// K = [k0*ones(sizes+1);knots(:);kn*ones(s+1,1)]
	// 3 FOR loops seem like a good idea?? FOR loops are quick mate!

	int i;
	double *pKnotStart;
	
	for ( i = 0; i < poly_order+1; i++ )
		*K++ = limits[0];

	pKnotStart = K;

	for ( i = 0; i < num_knots; i++ )
		*K++ = *knots++;
	for ( i = 0; i < poly_order+1; i++ )
		*K++ = limits[1];

	// Make sure the knots are in assending order - this is essential 
	// for the correct evaluation of splines
	qsort(pKnotStart, num_knots, sizeof(double), compare);
}


// *************** PHI_CALC routine ********************
double* phi_calc(int poly_order, double x, int num_knots, double* K, double* B0, double* B1, double* LIMITS)
{

	// Loop variables
	int i,j; 
	double delK, Ki, Kj;
	// tempory pointers for loops
	double *tB0, *tB1 , *tK;

	int sfinal = 2*poly_order + num_knots + 1;
	
	// Set up the initial B0
	SetInit(B0, x, poly_order, num_knots, K, LIMITS);
	
	// recursive section...
	for (j = 1; j < poly_order+1; j++){
		// initialise tK to start of K
		tK = K;
		// swap B0 and B1 for next iteration
		tB0 = B0;
		tB1 = B1;
		B0  = tB1;
		B1  = tB0;
		for (i = 0 ;i < sfinal-j; i++) {			
		/*
		* Note that pointer increments mean that:
		*   tB0= B0 + Nx*i;  // at the start of each i iteration;
		*   tB1= B1 + Nx*i;  // at the start of each i iteration;
			*/			
			delK = *(tK+j) - *tK;
			if (delK != 0.0){
			/* 
			* The following loop does a vectorised version of 
			* B1[i] = (x - K[i])/(K[i+j]-K[i]) * B0[i]
				*/
				// Ki is a temporary static for K[i]
				Ki = *tK;
				// set tx to the top of X
				//tx = xget;
				*tB1 = (x - Ki)/delK * (*tB0);
			}
			else {
				// need to set B1[i] = 0
				*tB1 = 0.0;
				// also increment tB0 here so it is B0[i+1]
			}
			tB0++;
			
			// increment tK here as we need K[i+j+1] and K[i+1]
			tK++;
			delK = *(tK+j) - *tK;
			if (delK != 0.0){
				/* 
				* The following loop does a vectorised version of 
				* B1[i] =  B1[i] + (K[i+j+1]-x)/(K[i+j+1]-K[i+1]) * B0[i+1]
				*/
				// Kj is a temporary static for K[i+j+1]
				Kj  = *(tK+j);
				// set tx to the top of X
				*tB1 += (Kj - x)/delK * (*tB0);
			}
			tB1++;
			
		}  // for i		
	} // for j


	return B0;
}

// *************** EVAL_LOOP routine ********************
void eval_loop(double *x, double *phi, double *c, double *n, int interact, int phiC, double *y)
{
	// create some intermediate variables
	double yi = 0;
	double yj = 0; 
	double *tc=c, *xiplus1, *xjplus1, *xkplus1, *tphi;
	int i,j,k;

	*y=0;
	tphi= phi;
	for (i=0;i<phiC;i++)
		*y += (*tphi++)*(*tc++);	// y(:)=phi*c(i3:i3+Ns-1)
	// At this point, tc=c+1*Ns
	// reset the counter.
	tphi=phi;
	
	// I have expanded the original code, so that logical tests are only done
	// once. It is also easier to increment the pointer tc this way.
	
	if (interact == 0){
		xiplus1=x+1;// i starts at zero
		for (i=0;i<(int)n[0];i++){
			// Yi(:) = c(i3)+x(:,1).*(c(i3+1) + x(:,1)*c(i3+2));
			yi = *tc + *x *(*(tc+1) + *(tc+2)*(*x));
			tc +=3;			
			
			xjplus1= x+ (i+1);// j starts at i
			for (j=i;j<(int)n[1];j++){ // J loop.
				// Yj = c(i3) + x(:,1).*c(i3+1);
				yj = *tc + (*x)*(*(tc+1));
				tc+=2;				
				xkplus1= x + (j+1);//this sets up x(:,k+1); k starts at j

				for (k=j;k<(int)n[2];k++) // K loop
					// Yj(:)= Yj + c(i3)*x(:,k+1);
					yj += (*tc++)*(*(xkplus1++));
				// yi(:)=yi+x(:,j+1).*yj
				yi += (*xjplus1++)*(yj); 
				// Clean up temporary yj;
				yj = 0;
			}
			*y += *(xiplus1++)*(yi); // y(:) = y + x(:,i+1).*yi
			// Clean up temporary yi;
			yi = 0;
		}
	}// END OF 'IF' statement for case interact == 0
	
	else if(interact == 1){
		xiplus1=x+1;// i starts at zero
		for (i=0;i<(int)n[0];i++){	// I Loop

			// yi(:)=phi*c(i3:i3+Ns-1);
			for (j=0;j<phiC;j++)
				yi += *(tphi++)*(*tc++); 
			
			// reset the counter.
			tphi=phi;
			xjplus1=x+(i+1);//j starts at i

			for (j=i;j<(int)n[1];j++){	// J LOOP
				yj = *tc + *x*(*(tc+1));
				tc+=2;
				xkplus1= x + (j+1);//this sets up x(:,k+1); k starts at j

				for (k=j;k<(int)n[2];k++) // K loop
					// Yj(:)= Yj + c(i3)*x(:,k+1);
					yj += (*tc++)*(*(xkplus1++));
				// yi(:)=yi+x(:,j+1).*yj
				yi += *(xjplus1++)*(yj); 
				// Clean up temporary yj;
				yj = 0;
			}
			// y(:) = y + x(:,i+1).*yi
			*y += *(xiplus1++)*(yi); 
			// Clean up temporary yi;
			yi = 0;
		}
	}// END OF 'IF' statement for case interact == 1
	
	else if(interact >1){
		xiplus1=x+1;
		for (i=0;i<(int)n[0];i++){	// I Loop
			for (j=0;j<phiC;j++)
				// y(:)=phi*c(i3:i3+Ns-1);
				yi += (*tphi++)*(*tc++);	
			tphi=phi;
			xjplus1= x + (i+1);

			for (j=i;j<(int)n[1];j++){	// J LOOP
				for (k=0;k<phiC;k++)
					// y(:)=phi*c(i3:i3+Ns-1)
					yj += (*tphi++)*(*tc++);	
				tphi=phi;
				xkplus1= x + (j+1);

				for (k=j;k<(int)n[2];k++) // K loop
					yj += (*tc++)*(*(xkplus1++));
				
				yi += *(xjplus1++)*(yj); // yi(:)=yi+x(:,j+1).*yj

				// Clean up temporary yj;
				yj = 0;
			}
			// y(:) = y + x(:,i+1).*yi
			*y += *(xiplus1++)*(yi); 
			// Clean up temporary yi;
			yi = 0;
		}
	}// END OF 'IF' statement for case interact >1
	
}// End of routine.
