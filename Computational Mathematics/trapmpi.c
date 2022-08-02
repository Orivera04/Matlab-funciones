/* program trapmpi.c */
/* This illustrates how the basic mpi commands */
/* can be used to do parallel numerical integration */ 
/* by partitioning the summation. */ 

#include <stdio.h>
/* Includes the mpi C library. */
#include "mpi.h"

/* Every processor gets values for a,b and n. */
main(int argc, char* argv[]) {
    int         my_rank;   
    int         p;         
    float       a = 0.0;   
    float       b = 100.0;   
    int         n = 1024000;  
    float       h;         
    float       local_a;   
    float       local_b;   
    int         local_n;                        
    float       integral;  
    float       total = 0.0;     
    int         dest = 0;  
    int         tag = 50;
    int         i;
    float       x;
    double      overhead;
    double      start, finish;
    float       f(float x);
    
/* Initializes mpi, gets the rank of the processor, my_rank, */
/* and number of processors, p. */
    MPI_Init(&argc, &argv);
    MPI_Comm_rank(MPI_COMM_WORLD, &my_rank);
    MPI_Comm_size(MPI_COMM_WORLD, &p);
    
    overhead = 0.0;
    for (i = 0; i < 100; i++) {
        MPI_Barrier(MPI_COMM_WORLD); 
        start = MPI_Wtime();
        MPI_Barrier(MPI_COMM_WORLD);
        finish = MPI_Wtime();
        overhead = overhead + (finish - start);
    }
    overhead = overhead/100.0;
    MPI_Barrier(MPI_COMM_WORLD);
    start = MPI_Wtime();

/* h is the same for all processes. */
    h = (b-a)/n;    
/* Each processor has unique value of loc_n, loc_a and loc_b. */ 
    local_n = n/p;  
    local_a = a + my_rank*local_n*h;
    local_b = local_a + local_n*h;
/* Each processor does part of the integration. */ 
/* The trapezoid rule is used. */ 
    integral = (f(local_a) + f(local_b))*.5;
    x = local_a;
    for (i = 1; i <= local_n-1; i++) {
        x = x + h;
        integral = integral + f(x);
    }
    integral = integral*h;

/* The mpi subroutine mpi_reduce() is used to communicate */ 
/* the partial integrations, integral, and then sum */ 
/* these to get the total numerical approximation, total. */
    MPI_Reduce(&integral, &total, 1, MPI_FLOAT,
        MPI_SUM, 0, MPI_COMM_WORLD);

    MPI_Barrier(MPI_COMM_WORLD); 
    finish = MPI_Wtime(); 
/* Processor 0 prints the n,a,b,total */ 
/* and time for computation and communication. */  
    if (my_rank == 0) {
        printf("With n = %d trapezoids, our estimate\n",
            n);
        printf("of the integral from %f to %f = %f\n",
            a, b, total);
        printf("time is %e", (finish-start)-overhead);
    }

/* mpi is terminated. */ 
    MPI_Finalize();
} /* end main  */


/* This is the function to be integrated. */ 
float f(float x) {
    float return_val;
    return_val = x*x;
    return return_val;
} /* end function  */



