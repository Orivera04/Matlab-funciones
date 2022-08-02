#include <stdio.h>
#include <math.h>

double funcion (double x);
double derivadaf (double x);

main()
{
	int Nit, i;
	double cota,xi,xsol,error;

	printf("Metodo de Newton-Raphson\n");
	printf("Cota de error maxima: ");
	scanf ("%lf",&cota);
	printf ("Numero maximo de iteraciones: ");
	scanf ("%d",&Nit);
	printf ("Punto inicial: ");
	scanf ("%lf",&xi);

	i = 1; /* Contador de iteraciones */
	error = cota + 1 ; /* Para asegurar que error > cota al ppio */

	while (i<= Nit && error > cota)
	{
		/* Aplicamos formula Newton-Raphson */
		xsol = xi - funcion (xi) / derivadaf(xi);
		error = fabs (xsol-xi);
		i++;
		/* En la siguiente iteracion xsol es xi */
		xi = xsol;
	}

	printf ("La solucion es %lf\n", xsol);
	printf ("El valor de la funcion es %g\n",funcion(xsol));
	printf ("El error alcanzado es %g\n", error);
	if (i>=Nit)
		printf ("Se ha alcanzado el maximo n. de iteraciones\n");
	else
		printf ("El n. de iteraciones ha sido %d\n",i);
}


