/* 	program dot3mpi.c */
/* Illustrates dot product via mpi_gather.*/
#include <stdio.h>
/* Includes the mpi C library. */
#include "mpi.h"
      main(int argc, char* argv[]) {
      float loc_dot,dot;
      float a[31],b[31],loc_dots[31];
      int  my_rank,p,n,source,dest,tag,loc_n;
      int  i,en,bn;
      MPI_Status  status;
      n    = 8;
      dest = 0;
      tag  = 50;
      for (i = 1;i<n+1;i++) {
          a[i] = i;
          b[i] = i+1;
      }
/* Initializes mpi, gets the rank of the processor, my_rank, */
/* and number of processors, p. */
      MPI_Init(&argc, &argv);
      MPI_Comm_rank(MPI_COMM_WORLD,&my_rank);
      MPI_Comm_size(MPI_COMM_WORLD,&p);
/* Each processor computes a local dot product */
      loc_n = n/p;
      bn = 1+(my_rank)*loc_n;
      en = bn + loc_n-1;
      printf("my_rank = %d loc_n = %d\n",my_rank,loc_n);
      printf("my_rank = %d bn = %d\n",my_rank,bn);
      printf("my_rank = %d en = %d\n",my_rank,en);
      loc_dot = 0.0;
      for (i = bn;i <= en; i++) {
        loc_dot = loc_dot + a[i]*b[i];
      }
      printf("my_rank = %d loc_dot = %f\n",my_rank,loc_dot);
/* mpi_gather sends and recieves all local dot products */
/* to the array loc_dots in processor 0. */
      MPI_Gather(&loc_dot,1,MPI_FLOAT,&loc_dots,1,MPI_FLOAT,0,
                        MPI_COMM_WORLD);
/* Processor 0 sums the local dot products. */
      if (my_rank == 0) {
        dot = loc_dot;
      	for (source = 1;source <= p-1; source++) {
        	dot = dot + loc_dots[source];
        }
      	printf( "dot product = %f",dot);
      }
/* mpi is terminated. */ 
      MPI_Finalize();
}  /* end program dot3mpi */

