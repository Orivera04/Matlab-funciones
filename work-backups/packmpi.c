/*      program packmpi.c */
/* Illustrates mpi_pack and mpi_unpack. */    
#include <stdio.h>
/* Includes the mpi C library. */
#include "mpi.h"
      main(int argc, char* argv[]) {
      float a,b;
      int c,d,location;
      int ierr;
      char numbers[100];
      int  my_rank,p,n,source,dest,tag,loc_n;
      int  i;
      MPI_Status status;
      n    = 4;
      dest = 0;
      tag  = 50;
/* Initializes mpi, gets the rank of the processor, my_rank, */
/* and number of processors, p. */
      MPI_Init(&argc, &argv);
      MPI_Comm_rank(MPI_COMM_WORLD,&my_rank);
      MPI_Comm_size(MPI_COMM_WORLD,&p);
/* Processor 0 packs and broadcasts the four number. */   
      if(my_rank==0) {
        a = 2.718;
        b = 3.141;
        c = 1;
        d = 186000;
        location = 0;
        MPI_Pack(&a,1,MPI_FLOAT,&numbers,100,&location,
                         MPI_COMM_WORLD);
        MPI_Pack(&b,1,MPI_FLOAT,&numbers,100,&location,
                         MPI_COMM_WORLD);
        MPI_Pack(&c,1,MPI_INT,&numbers,100,&location,
                         MPI_COMM_WORLD);
        MPI_Pack(&d,1,MPI_INT,&numbers,100,&location,
                         MPI_COMM_WORLD);
        MPI_Bcast(&(numbers[0]),100,MPI_PACKED,0,
                        MPI_COMM_WORLD);                
      }else{
        MPI_Bcast(&(numbers[0]),100,MPI_PACKED,0,
                        MPI_COMM_WORLD);
/* Each processor unpacks the numbers.  */                     
        location = 0;
        MPI_Unpack(&(numbers[0]),100,&location,&a,1,MPI_FLOAT,
                         MPI_COMM_WORLD);
        MPI_Unpack(&(numbers[0]),100,&location,&b,1,MPI_FLOAT,
                         MPI_COMM_WORLD);
        MPI_Unpack(&(numbers[0]),100,&location,&c,1,MPI_INT,
                         MPI_COMM_WORLD);
        MPI_Unpack(&(numbers[0]),100,&location,&d,1,MPI_INT,
                         MPI_COMM_WORLD);
        }
/* Each processor prints the numbers. */    
      printf("my_rank = %d a = %f\n",my_rank,a);
      printf("my_rank = %d b = %f\n",my_rank,b);
      printf("my_rank = %d c = %d\n",my_rank,c);
      printf("my_rank = %d d = %d\n",my_rank,d);
/* mpi is terminated. */          
      MPI_Finalize();
} /*     end program packmpi */
