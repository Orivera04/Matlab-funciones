/*      program scatmpi.c */
/* Illustrates mpi_scatter. */
#include <stdio.h>
/* Includes the mpi C library. */
#include "mpi.h"
      main(int argc, char* argv[]) {
      float a_list[7],a_loc[7];
      int my_rank,p,n,dest,tag,i;
      n    = 1024;
      dest = 0;
      tag  = 50;
/* Initializes mpi, gets the rank of the processor, my_rank, */
/* and number of processors, p. */
      MPI_Init(&argc, &argv);
      MPI_Comm_rank(MPI_COMM_WORLD,&my_rank);
      MPI_Comm_size(MPI_COMM_WORLD,&p);
      if (my_rank==0) {
        for (i = 0;i<8;i++) {
          a_list[i] = i; 
        }
      }
/* The array, a_list, is sent and recieved in groups of */
/* two to the other processors and stored in the arrays a_loc. */
      MPI_Scatter(&a_list,2,MPI_FLOAT,&a_loc,2,MPI_FLOAT,0,
                        MPI_COMM_WORLD);
      for (i = 0; i<2; i++) {
        printf("my_rank = %d i = %d a_loc = %f\n",my_rank,i,a_loc[i]);
      }
/* mpi is terminated. */ 
      MPI_Finalize();
}  /* end program scatmpi */

