/* Metodo de biseccion */

#include <stdio.h>
#include <math.h>

double funcion(double x);

main()
{
	double a,b,m,error,cota;
	int N,i;

	printf("METODO DE BISECCION\n");
	printf("-------------------\n\n");

	/* Se mantiene pidiendo datos hasta que sean validos */
	do
	{
		printf ("Extremo inferior del intervalo: ");
		scanf("%lf",&a);
		printf ("Extremo superior del intervalo: ");
		scanf ("%lf",&b);
	} while (a>=b || funcion(a)*funcion(b)>=0);

	printf("Numero de iteraciones: ");
	scanf ("%d",&N);
	printf ("Cota de error: ");
	scanf ("%lf",&cota);

	i = 1;	/* Contador de iteraciones */
	error = cota*10;	/* Error */

	while (error>cota && i < N)
	{
		m = (a+b)/2;
		if (funcion(a)*funcion(m)<0)
			b = m;
		else
			a = m;
		i++;
		error = fabs(funcion(m));
	}

	printf ("La solucion alcanzada es: %lf\n",m);
	printf ("El valor de la funcion es: %g\n",funcion(m));

	printf("Numero de iteraciones: %d de %d\n",i,N);
}

