#include <math.h>

double funcion(double x)
{
	double f;
	f = x*x + 0.5 - exp(-x);
	return (f);
}

double derivadaf(double x)
{
	double fp;
	fp = 2*x + exp(-x);
	return (fp);
}

