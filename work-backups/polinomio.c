#include <stdio.h>
#include <math.h>

#define N 100

double polyval (double p[], int n, double x)
{
	double valor;
	int j;

	valor = 0;
	for (j=0;j<=n;j++)
		valor = valor + p[j]*pow(x,j);
	return (valor);
}

main()
{
	int n,j;
	double coef[N],x;

	printf("Grado del polinomio? ");
	scanf ("%d",&n);

	for (j=n;j>=0;j--)
	{
		printf("Coeficiente de x^%d ? ",j);
		scanf ("%lf",&coef[j]);
	}

	while (1) /* Condicion siempre verdadera: 1 */
	{
		printf("Punto a evaluar? ");
		scanf ("%lf",&x);
		if (x==-999)
			break; /* Para salir del while */
		printf("p(%lf)=%lf\n",x,polyval(coef,n,x));
	}
}
