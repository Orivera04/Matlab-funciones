/*     program dertypempi.c */
/* Illustrates a derived type. */    
#include <stdio.h>
/* Includes the mpi C library. */
#include "mpi.h"
      main(int argc, char* argv[]) {
      float a,b;
      int c,d;
      int blocks[4];
      int my_rank,p,n,dest,tag;
      MPI_Aint addresses[4];
      MPI_Aint displacements[4];
      MPI_Datatype  typelist[4];
      MPI_Datatype  data_mpi_type;
      n    = 4;
      dest = 0;
      tag  = 50;
/* Initializes mpi, gets the rank of the processor, my_rank, */
/* and number of processors, p. */
      MPI_Init(&argc, &argv);
      MPI_Comm_rank(MPI_COMM_WORLD,&my_rank);
      MPI_Comm_size(MPI_COMM_WORLD,&p);
      if (my_rank==0) {
        a = 2.718;
        b = 3.141;
        c = 1;
        d = 186000;
      }    
/* Define the new derived type, data_mpi_type. */       
        typelist[0] = MPI_FLOAT;
        typelist[1] = MPI_FLOAT;
        typelist[2] = MPI_INT;
        typelist[3] = MPI_INT;
        blocks[0] = 1;
        blocks[1] = 1;
        blocks[2] = 1;
        blocks[3] = 1;
        MPI_Address(&a,&addresses[0]);
        MPI_Address(&b,&addresses[1]);
        MPI_Address(&c,&addresses[2]);
        MPI_Address(&d,&addresses[3]);
        displacements[0] = addresses[0] - addresses[0];
        displacements[1] = addresses[1] - addresses[0];
        displacements[2] = addresses[2] - addresses[0];
        displacements[3] = addresses[3] - addresses[0];
        MPI_Type_struct(4,blocks,displacements,
                          typelist,&data_mpi_type);
        MPI_Type_commit(&data_mpi_type);
/* Before the broadcast of the new type data_mpi_type */
/* try to print the data. */      
      printf("my_rank = %d a = %f\n",my_rank,a);
      printf("my_rank = %d b = %f\n",my_rank,b);
      printf("my_rank = %d c = %d\n",my_rank,c);
      printf("my_rank = %d d = %d\n",my_rank,d);
      MPI_Barrier(MPI_COMM_WORLD);
/* Broadcast data_mpi_type. */     
      MPI_Bcast(&a,1,data_mpi_type,0,
                        MPI_COMM_WORLD);
/* Each processor prints the data.  */                      
      printf("my_rank = %d a = %f\n",my_rank,a);
      printf("my_rank = %d b = %f\n",my_rank,b);
      printf("my_rank = %d c = %d\n",my_rank,c);
      printf("my_rank = %d d = %d\n",my_rank,d);
/* mpi is terminated. */          
      MPI_Finalize();
} /* end program dertypempi */
