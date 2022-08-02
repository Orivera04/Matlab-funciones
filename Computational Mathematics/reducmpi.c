/*    program reducmpi.c */
/* Illustrates mpi_reduce. */
#include <stdio.h>
/* Includes the mpi C library. */
#include "mpi.h"
      main(int argc, char* argv[]) {
      float a,b,h,loc_a,loc_b,sum,prod;
      int  my_rank,p,n,dest,tag,loc_n;
      MPI_Status  status;
      a    = 0.0;
      b    = 100.0;
      n    = 1024;
      dest = 0;
      tag  = 50;
/* Initializes mpi, gets the rank of the processor, my_rank, */
/* and number of processors, p. */
      MPI_Init(&argc, &argv);
      MPI_Comm_rank(MPI_COMM_WORLD,&my_rank);
      MPI_Comm_size(MPI_COMM_WORLD,&p);
/* Each processor has a unique loc_n, loc_a and loc_b. */
      h = (b-a)/n;
      loc_n = n/p;
      loc_a = a + my_rank*loc_n*h;
      loc_b = loc_a + loc_n*h;
      printf ("my_rank = %d loc_a = %f\n",my_rank,loc_a);
      printf ("my_rank = %d loc_b = %f\n",my_rank,loc_b);
      printf ("my_rank = %d loc_n = %d\n",my_rank,loc_n);
/* mpi_reduce is used to compute the sum of all loc_b */
/* to sum on processor 0. */     
      MPI_Reduce(&loc_b,&sum,1,MPI_FLOAT,MPI_SUM,0,
                        MPI_COMM_WORLD);
/* mpi_reduce is used to compute the product of all loc_b */ 
/* to prod on processor 0. */                       
      MPI_Reduce(&loc_b,&prod,1,MPI_FLOAT,MPI_PROD,0,
                        MPI_COMM_WORLD);
      if (my_rank==0) {
        printf( "sum = %f\n",sum);
        printf( "product = %f\n",prod);
      }
/* mpi is terminated. */
      MPI_Finalize();
} /* end program reducmpi */

