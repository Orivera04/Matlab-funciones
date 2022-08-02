/*    program basicmpi.c */
/* Illustrates the basic eight mpi commands. */
#include <stdio.h>
/* Includes the mpi C library. */
#include "mpi.h"
      main(int argc, char* argv[]) {
      float a,b,h,loc_a,loc_b;
      float a_list[31];
      int  my_rank,p,n,source,dest,tag,loc_n;
      int i;
      MPI_Status  status;
/* Every processor gets values for a,b and n. */ 
      a = 0.0;
      b = 100.0;
      n = 1024;
      dest = 0;
      tag  = 50;    
/* Initializes mpi, gets the rank of the processor, my_rank, */
/* and number of processors, p. */    
      MPI_Init(&argc, &argv);
      MPI_Comm_rank(MPI_COMM_WORLD,&my_rank);
      MPI_Comm_size(MPI_COMM_WORLD,&p);
      printf("my_rank = %d a = %f\n", my_rank,a);
      printf("my_rank = %d b = %f\n", my_rank,b);
      printf("my_rank = %d n = %d\n", my_rank,n);
      h = (b-a)/n;
/* Each processor has unique value of loc_n, loc_a and loc_b. */     
      loc_n = n/p;
      loc_a = a + my_rank*loc_n*h;
      loc_b = loc_a + loc_n*h;
/* Each processor prints its loc_n, loc_a and loc_b. */ 
      printf("my_rank = %d loc_a = %f\n", my_rank,loc_a);
      printf("my_rank = %d loc_b = %f\n", my_rank,loc_b);
      printf("my_rank = %d loc_n = %d\n", my_rank,loc_n);     
/* Processors p not equal 0 sends a_loc to an array, a_list, */
/* in processor 0, and processor 0 recieves these. */     
      if (my_rank == 0) {
        a_list[0] = loc_a;
        for (source = 1; source < p; source++) { 
          MPI_Recv(&a_list[source],1,MPI_FLOAT,source 
                          ,50,MPI_COMM_WORLD,&status);
        }    
      } else {
          MPI_Send(&loc_a,1,MPI_FLOAT,0,50,
                            MPI_COMM_WORLD);
      } 
      MPI_Barrier(MPI_COMM_WORLD);
/* Processor 0 prints the list of all loc_a. */    
      if (my_rank == 0) {
        for (i = 0;i < p; i++) {
          printf( "a_list(%d) = %f\n",i,a_list[i]);
        }
      }
/* mpi is terminated. */     
      MPI_Finalize();
}  /*  end program basicmpi */
    
