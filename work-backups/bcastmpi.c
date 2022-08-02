/*  	program bcastmpi.c */
/* Illustrates mpi_bcast. */
#include <stdio.h>
/* Includes the mpi C library. */
#include "mpi.h"
      main(int argc, char* argv[]) {
      float a,b,new_b;
      int  my_rank,p,n,dest,tag;
      n    = 1024;
      dest = 0;
      tag  = 50;
/* Initializes mpi, gets the rank of the processor, my_rank, */
/* and number of processors, p. */
      MPI_Init(&argc, &argv);
      MPI_Comm_rank(MPI_COMM_WORLD,&my_rank);
      MPI_Comm_size(MPI_COMM_WORLD,&p);
      if (my_rank==0) {
        a = .0;
        b = 100.;
      }
/* Each processor attempts to print a and b. */     
      printf("my_rank = %d a = %f\n",my_rank,a);
      printf("my_rank = %d b = %f\n",my_rank,b);
/* Processor 0 broadcasts a and b to the other processors. */
/* The mpi_bcast is issued by all processors. */
      MPI_Bcast(&a,1,MPI_FLOAT,0,
                        MPI_COMM_WORLD);
      MPI_Bcast(&b,1,MPI_FLOAT,0,
                        MPI_COMM_WORLD);
      MPI_Barrier(MPI_COMM_WORLD);
/* Each processor prints a and b. */ 
      printf("my_rank = %d a = %f\n",my_rank,a);
      printf("my_rank = %d b = %f\n",my_rank,b);
/* Processor 0 broadcasts b to the other processors and */
/* stores it in new_b. */
      if (my_rank == 0)  
        {MPI_Bcast(&b,1,MPI_FLOAT,0,
                        MPI_COMM_WORLD);
        }
      else
        {MPI_Bcast(&new_b,1,MPI_FLOAT,0,
                        MPI_COMM_WORLD);
      }
      printf("my_rank = %d new_b = %f\n",my_rank,new_b);
/* mpi is terminated. */                  
      MPI_Finalize();
 }    /* end program bcastmpi */

