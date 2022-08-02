/* 	program gathmpi.c */
/* Illustrates mpi_gather.*/
#include <stdio.h>
/* Includes the mpi C library. */
#include "mpi.h"
      main(int argc, char* argv[]) {
      float a,b,h,loc_a,loc_b;
      float a_list[31];
      int  my_rank,p,n,dest,tag,loc_n,i;
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
      h = (b-a)/n;
/* Each processor has a unique loc_n, loc_a and loc_b. */
      loc_n = n/p;
      loc_a = a+my_rank*loc_n*h;
      loc_b = loc_a + loc_n*h;
      printf("my_rank = %d loc_a = %f\n", my_rank,loc_a);
      printf("my_rank = %d loc_b = %f\n", my_rank,loc_b);
      printf("my_rank = %d loc_n = %d\n", my_rank,loc_n);    
/* The loc_a are sent and recieved to an array, a_list, on */
/* processor 0. */
      MPI_Gather(&loc_a,1,MPI_FLOAT,&a_list,1,MPI_FLOAT,0,
                        MPI_COMM_WORLD);
      MPI_Barrier(MPI_COMM_WORLD);
      if (my_rank==0) {
        for (i = 0;i<p;i++) {
          printf( "a_list(%d) = %f\n",i,a_list[i]);
        }
      }
/* mpi is terminated. */ 
      MPI_Finalize();
} /*  end program gathmpi */

