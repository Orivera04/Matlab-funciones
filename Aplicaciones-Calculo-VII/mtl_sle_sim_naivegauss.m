clc
%Click the run bottom and refer to the comaand window
%These are the inputs that can be modified by the user
%n = number of equations
n=6;
%[A] = nxn coefficient matrix
A=[12.,0.0000000000007,3.,6.0007,5,6;1.,5.,1.,9.,7,8;13.,12.,4.0000001,8,4,6;5.6,3.,7.,1.003,7,4;1,2,3,4,5,6;6,7,5,6,7,5];
%[RHS] = nx1 right hand side array
RHS=[22;7e-7;29.001;5.301;9;90];

disp(sprintf('Naïve Gaussian Elimination Method \nUniversity of South Florida \nUnited States of America \nkaw@eng.usf.edu'))
disp(sprintf('\nNOTE: This worksheet demonstrates the use of Matlab to illustrate Naïve Gaussian\nElimination, a numerical technique used in solving a system of simultaneous linear\nequations.')) 


disp(sprintf('\n**************************************Introduction**************************************** \n\nOne of the most popular numerical techniques for solving simultaneous linear equations is\nNaïve Gaussian Elimination method.'))
disp(sprintf('The approach is designed to solve a set of n equations with n unknowns, \n[A][X]=[C], where [A]nxn is a square coefficient matrix, [X]nx1 is the solution vector,\nand [C]nx1 is the right hand side array.')) 
disp(sprintf('\nNaïve Gauss consists of two steps:')) 

disp(sprintf('1) Forward Elimination: In this step, the coefficient matrix [A] is reduced to an\nupper triangular matrix. This way, the equations are "reduced" to one equation and\none unknown\nin each equation.')) 
disp(sprintf('2) Back Substitution: In this step, starting from the last equation, each of the unknowns\nis found.'))
 
disp(sprintf('\nA simulation of Naïve Gauss Elimination Method follows.\n \n'))

disp(sprintf('***************************************Input Data*****************************************'))
disp(sprintf('Below are the input parameters to begin the simulation. \nInput Parameters: \nn = number of equations \n[A] = nxn coefficient matrix \n[RHS] = nx1 right hand side array')) 
format short g
disp(sprintf('-----------------------------------------------------------------'))
disp(sprintf('These are the default parameters used in the simulation. \nThey can be changed in the top part of the M-file'))
disp(sprintf('\nn= %d',n))
A1=A;
A=num2str(A,'%10.5g')
A=A1;
RHS1=RHS;
RHS=num2str(RHS1,'%10.5g')
RHS=RHS1;
disp(sprintf('--------------------------------------------------- \nWith these inputs,to conduct Naïve Gauss Elimination, Matlab will combine the [A] and\n[RHS] matrices into one augmented matrix, [C](n*(n+1)), that will facilitate the process\nof forward elimination.'))
C1=horzcat(A,RHS);
C=num2str(C1,'%10.5g')
C=C1;

disp(sprintf('*************************************Forward Elimination**********************************'))
disp(sprintf('Forward elimination consists of (n-1) steps. In each step k of forward elimination,\nthe coefficient element of the kth unknown will be zeroed from every\nsubsequent equation that follows the kth row. For example, in step 2 (i.e. k=2),\nthe coefficient of x2 will be zeroed from rows 3..n.')) 
disp(sprintf('With each step that is conducted, a new matrix is generated until the coefficient matrix is\ntransformed to an upper triangular matrix. Now, Matlab calculates the upper triangular\nmatrix while demonstrating the intermediate coefficient matrices that are produced for\neach step k.\n')) 

 %Conducting k, or (n-1) steps of forward elimination.
 for k=1:(n-1)
    %Defining the proper row elements to transform [C] into [U].
         for i=k+1:n
       %Generating the value that is multiplied to each equation.
                multiplier=(C(i,k)/C(k,k));
          for j=k:n+1
          %Subtracting the product of the multiplier and pivot equation from the ith row to generate new rows of [U] matrix.
                             C(i,j)=(C(i,j)-multiplier*C(k,j));
          end 
          end 
 disp(sprintf('================== Step %d',k)) 
 disp(sprintf('\b ======================='))
 C1=C;
 C=num2str(C1,'%10.5g')
 C=C1;
 disp(sprintf('The elements in column #%d',k))
 disp(sprintf('\b below C[%d',k))
 disp(sprintf('\b,%d',k))
 disp(sprintf('\b] are zeroed\n',k))
end 
disp(sprintf('This is the end of the forward elimination steps. The coefficient matrix\nhas been reduced to an upper triangular matrix'))

%--------------------------------------------------------------------------
%Creating the upper new coefficient matrix [A1]
A1=zeros(n,n);
for i=1:n
    for j=1:n
        A1(i,j)=C(i,j);
    end
end
%Now the new right hand side array, [RHS1]
RHS1=zeros(n,1);
for i=1:n
    RHS1(i,1)=C(i,(n+1));
end
%Only to enhance display:
A2=A1;
A=num2str(A2,'%10.5g')
A=A1;
RHS2=RHS1;
RHS=num2str(RHS2,'%10.5g')
RHS=RHS1;

%--------------------------------------------------------------------------
disp('*************************************Back substitution************************************') 
disp(sprintf('\nBack substitution begins with solving the last equation as it has only one unknown.\nThe remaining equations can be solved for using the following formula:\n'))

 disp('               x[i]=(C[i]-(sum{A[i,j]*X[j]}))/(A[i,i]')
            
 %Defining [X] as a vector.
 X=zeros(1,n);
 %Solving for the nth equation as it has only one unknown.
 X(n)=RHS1(n)/A1(n,n);
 %Solving for the remaining (n-1) unknowns working backwards from the (n-1)th equation to the first equation.
 for i=(n-1):-1:1
    %Setting the series sum equal to zero.
    summ=0;
    for j=i+1:n
       summ=summ+A1(i,j)*X(j);
   end 
    %Generating the summation term, at which time the unknowns that have been solved for are used to calculate Xi.
    X(i)=(RHS1(i)-summ)/A1(i,i);
end 
X;
disp(sprintf('\n\nUsing back substitution, we get the unknowns as:'))
X=rot90(X)
