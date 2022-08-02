clc
%Click the run bottom and refer to the comaand window
%These are the inputs that can be modified by the user
%n = number of equations
n=6;
%[A] = nxn coefficient matrix
A=[12.,0.1234567890987654,3.,6.7,5,6;1.,5.053e9,1.,9.,7,8;13.,12.,4.0000001,8,4,6;5.6,3.,7.,1.003,7,4;1,2,3,4,5,6;6,7,5,6,7,5];
%[RHS] = nx1 right hand side array
RHS=[22;7e-7;29.001;5.301;9;90];
%--------------------------------------------------------------------------

disp('LU Decomposition Method')
disp('University of South Florida') 
disp('United States of America')
disp('kaw@eng.usf.edu')

disp(sprintf('NOTE: This worksheet demonstrates the use of Matlab to illustrate LU Decomposition method,\na technique used in solving a system of simultaneous linear equations.'))
%--------------------------------------------------------------------------
disp('  ')
disp('**************************************Introduction***************************************')
disp(' ')
disp(sprintf('When solving multiple sets of simultaneous linear equations with the same coefficient\nmatrix but different right hand sides,'))
disp(sprintf('\bLU Decomposition is advantageous over other\nnumerical methods in that it proves to be numerically more efficient in computational\ntime '))
disp(sprintf('\bthan other techniques.\nIn this worksheet, the reader can choose a system of equations and see how each\nstep of LU decomposition method is conducted.'))


disp(sprintf('\n\nLU Decomposition method is used to solve a set of simultaneous linear equations,\n[A] [X] = [C],')) 
disp(sprintf('\b where [A]nxn is a non-singular square coefficient matrix, [X]nx1 is the\nsolution vector,')) 
disp(sprintf('\band [C]nx1 is the right hand side array.\nWhen conducting LU decomposition method,'))
disp(sprintf('\bone must first decompose the coefficient matrix\n[A]nxn into a lower triangular matrix [L]nxn,')) 
disp(sprintf('\b and upper triangular matrix [U]nxn.\nThese two matrices can then be used to solve for the solution vector [X]nx1\nin the following sequence:'))
disp('Recall that') 
disp('[A] [X] = [C].')
disp('Knowing that') 
disp('[A] = [L] [U]')
disp('then first solving with forward substitution')
disp('[L] [Z] = [C]')
disp('and then solving with back substitution')
disp('[U] [X] = [Z]')
disp('gives the solution vector [X].')
%-------------------------------------------------------------------------

disp('**************************************Input Data***********************************')
disp('Below are the input parameters to begin the simulation.') 
disp('Input Parameters:')
disp('n = number of equations')
disp('[A] = nxn coefficient matrix')
disp('[RHS] = nx1 right hand side array')
format short g
disp(sprintf('n=%d',n))
%Only to enhance display:
format short g
A1=A;
A=num2str(A,'%10.5g')
A=A1;
disp(sprintf('\n\n\n  '))
RHS1=RHS;
RHS=num2str(RHS1,'%10.5g')
RHS=RHS1;
disp('***********************************************************************************')
disp('************************** LU Decomposition Method ********************************')
disp('***********************************************************************************')
disp(sprintf('\nThe following sections divide LU Decomposition method into 3 steps:\n')) 
disp('1.) Finding the LU decomposition of the coefficient matrix [A]nxn') 
disp('2.) Forward substitution')
disp('3.) Back substitution')
disp(' ')


%--------------------------------------------------------------------------
%LU Decomposition
disp('-------------------------------Finding the LU Decomposition-------------------------')
disp(' ')
disp('How does one decompose a non-singular matrix [A], that is how do you find [L] and [U]?')
disp(sprintf('This worksheet decomposes the coefficient matrix [A] into a lower triangular matrix [L]\nand upper triangular matrix [U], given [A] = [L][U].'))
disp(sprintf('\f For [U], the elements of the matrix are exactly the same as the coefficient matrix one\nobtains at the end of forward elimination steps in Naïve Gauss Elimination.'))
disp(sprintf('\f For [L], the matrix has 1 in its diagonal entries. The non-zero elements are\nmultipliers that made the corresponding elements zero in the upper triangular matrix\nduring forward elimination.'))

L=zeros(n,n);
U=zeros(n,n);
%Initializing diagonal of [L] to be unity.
for i = 1:n
    L(i,i)=1.0;
end 
 
 %Dumping [A] matrix into a local matrix [AA] 
 for i=1:n
    for j=1:n
       AA(i,j)=A(i,j);
    end
 end 
 
 %Conducting forward elimination steps of Naïve Gaussian Elimination to obtain [L] and [U] matrices.
 for k=1:n-1
    for i=(k+1):n
    %Computing multiplier values.
    multiplier=AA(i,k)/AA(k,k);
    %Putting multiplier in proper row and column of [L] matrix.   
    L(i,k)=multiplier;
       for j=(k+1):n
          %Eliminating (i-1) unknowns from the ith row to generate an upper triangular matrix.
          AA(i,j)=AA(i,j)-multiplier*AA(k,j);
       end 
    end 
 end 
 
 %Dumping the end of forward elimination coefficient matrix into the [U] matrix.
 for i=1:n
    for j=i:n
       U(i,j)=AA(i,j);
    end 
 end 
%Only to enhance display:

L1=L;
L=num2str(L1,'%15.5g')
L=L1;
U1=U;
U=num2str(U1,'%15.5g')
U=U1;


%--------------------------------------------------------------------------
%Forward Substitution
disp(sprintf('\n\n------------------------------- Forward Substitution---------------------------------\n'))
disp(sprintf('Now that the [L] and [U] matrices have been formed, the forward substitution step,\n[L] [Z] = [C], can be conducted, beginning with the first equation as it has only one\nunknown,\n'))
disp('z[1] = c[1]/l[1, 1]')
disp(sprintf('\nSubsequent steps of forward substitution can be represented by the following formula:\n'))
disp('z[i] = (c[i]-(Sum(l[i, j]*z[j], j = 1 .. i-1))[i = 2 .. n])/l[i, i]')

%Defining the [Z] vector.
 Z=zeros(1,n);
%Solving for the first equation as it has only one unknown.
 Z(1)=RHS(1)/L(1,1);
 %Solving for the remaining (n-1) unknowns 
 for i=2:n
 sum=0;
    %Generating the summation term 
    for j=1:(i-1)
       sum=sum+L(i,j)*Z(j);
   end
 Z(i)=(RHS(i)-sum)/L(i,i);
end 
Z=transpose(Z)

%--------------------------------------------------------------------------
%Back Substitution
disp(sprintf('\n-----------------------------------Back Substitution------------------------------------\n'))
disp(sprintf('Now that [Z] has been calculated, it can be used in the back substitution step,\n[U] [X] = [Z], to solve for solution vector [X]nx1, where [U]nxn is the upper triangular\nmatrix calculated in Step 2.1, and [Z]nx1 is the right hand side array.'))
disp(sprintf('Back substitution begins with the nth equation as it has only one unknown:\n'))
disp('xn = zn/U(n, n)')
disp(sprintf('\nThe remaining unknowns are solved for using the following formula:\n'))
disp('xi = (zi-(Sum(U[i, j]*X[j], j = i+1 .. n))[i = n-1 .. 1])/U[i, i]')
%Defining the [X] vector.
 X=zeros(1,n);
 %Solving for the nth equation as it has only one unknown.
 X(n)=Z(n)/U(n,n);
 %Solving for the remaining (n-1) unknowns working backwards from the (n-1)th equation to the first equation.
 for i=(n-1):-1:1
    %Initializing series sum to zero.
    sum=0;
       %Calculating summation term 
       for j=(i+1):n
          sum=sum+U(i,j)*X(j);
       end 
    %Calculating solution vector [X].
    X(i)=(Z(i)-sum)/U(i,i);
  end
  X=transpose(X)

  %------------------------------------------------------------------------
 