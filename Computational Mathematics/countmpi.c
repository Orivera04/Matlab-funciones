/*      program countmpi.c */
/* Illustrates count for arrays. */      
#include <stdio.h>
/* Includes the mpi C library. */
#include "mpi.h"
      main(int argc, char* argv[]) {
      float a[4];
      int b[2][3];
      int my_rank,p,n,i,j,dest,tag;
      n    = 4;
      dest = 0;
      tag  = 50;
/* Initializes mpi, gets the rank of the processor, my_rank, */
/* and number of processors, p. */
      MPI_Init(&argc, &argv);
      MPI_Comm_rank(MPI_COMM_WORLD,&my_rank);
      MPI_Comm_size(MPI_COMM_WORLD,&p);
/* Define the arrays. */     
      if (my_rank==.0) {
        a[0] = 1.;
        a[1] = 2.78;
        a[2] = 3.14;
        a[3] = 186000.;
        for (j = 0;j<3;j++) {
          for (i = 0;i<2;i++) {
            b[i][j] = i+j;
          }
        }
      }
/* Each processor attempts to print the array. */    
      for (i =0;i<4;i++) {
         printf("my_rank = %d a(%d) = %f\n",my_rank,i,a[i]);
      } 
      MPI_Barrier(MPI_COMM_WORLD);
/* The arrays are broadcast via count equal to four. */     
      MPI_Bcast(&(a[0]),4,MPI_FLOAT,0,
                        MPI_COMM_WORLD);
      MPI_Bcast(&(b[0][0]),4,MPI_INT,0,
                        MPI_COMM_WORLD);                  
/* Each processor prints the arrays. */ 
      for (i =0;i<4;i++) {
         printf("my_rank = %d a(%d) = %f\n",my_rank,i,a[i]); 
      }                     
      for (j = 0;j<3;j++) {
         for (i = 0;i<2;i++) {
            printf("my_rank = %d b(%d,%d) = %d\n",my_rank,i,j,b[i][j]);
         }
      } 
/* mpi is terminated. */            
      MPI_Finalize();
}  /*   end program countmpi */

