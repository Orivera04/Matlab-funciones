 clc
 %Click the run bottom and refer to the comaand window
 %These are the inputs that can be modified by the user
 %n = number of equations
 n=4;
 %[A] = nxn coefficient matrix
 A=[12,7,3,1;1,5,1,2;2,7,-11,1;9,2,1,13];
 %[RHS] = nx1 right hand side array
 RHS=[22;7;-2;3];
 %[X] = nx1 initial guess of the solution vector
 X=[1;2;1;1];
 %maxit = maximum number of iterations
 maxit=8;
disp('Convergence of Gauss-Seidel Method')
disp('©2007 Fabian Farelo, Autar Kaw')
disp('University of South Florida')
disp('United States of America') 
disp(sprintf('\nkaw@eng.usf.edu'))

disp(sprintf('\nNOTE: This worksheet demonstrates the convergence of Gauss-Seidel method,\nan iterative technique used in solving a system of simultaneous\nlinear equations.\n'))

%------------------------------ Introduction----------------------------
disp(sprintf('****************************** Introduction ****************************\n\n '))
disp(sprintf('Gauss-Seidel method is an advantageous approach to solving a system of ')) 
disp(sprintf('simultaneous linear equations because it allows the user to control ')) 
disp(sprintf('round-off error that is inherent in elimination methods such as ')) 
disp(sprintf('Gaussian Elimination. However, this method is not without its pitfalls.')) 
disp(sprintf('Gauss-Seidel method is an iterative technique whose solution may or ')) 
disp(sprintf('may not converge.Convergence is ensured only if the coefficient matrix,')) 
disp(sprintf('[A]nxn, is diagonally dominant, otherwise the method may or may not '))
disp(sprintf('converge.'))
disp(sprintf('\nA diagonally dominant square matrix [A] is defined by the following:'))
disp(sprintf('\n      (Sum(|A(i, j)|, j = 1 .. n),[i <> j] <= |(a(i, i))|      (1.1)'))
disp(sprintf('\n for all i, and'))
disp(sprintf('\n      (Sum(|A(i, j)|, j = 1 .. n),[i <> j] < |(a(i, i))|       (1.2)'))
disp(sprintf('\nfor at least one i.'))
disp(sprintf('\nFortunately, many physical systems that result in simultaneous linear')) 
disp(sprintf('equations have diagonally dominant coefficient matrices, or with the')) 
disp(sprintf('exchange of a few equations, the coefficient matrix can become'))
disp(sprintf('diagonally dominant.'))
disp(sprintf('The following simulation illustrates the convergence of the\nGauss-Seidel method.'))

%-------------------------------Input Data --------------------------------
disp(sprintf('\n********************************** Input Data ***************************\n\n'))
disp(sprintf('n = number of equations'))
disp(sprintf('[A] = nxn coefficient matrix'))
disp(sprintf('[RHS] = nx1 right hand side array'))
disp(sprintf('[Xold] = nx1 initial guess of the solution vector'))
disp(sprintf('maxit = maximum number of iterations'))
disp(sprintf('\nNOTE: These are the default values. Input data can be changed at the\nbeginning of the M-file\n'))
disp(sprintf('n= %d',n))
A
RHS
X
maxit

%-------------------------Gauss-Siedel Procedure---------------------------
disp(sprintf('\n*********************** Gauss-Seidel Procedure ************************\n\n'))
disp(sprintf('Gauss-Seidel method utilizes the equation\n'))
disp(sprintf('\n      x[i] = [rhs[i]-sum(A[i,j]*X*[j])[i<>j]/A[i,j]]          (3.1)'))
disp(sprintf('\nto compute an approximate value for a solution vector [X].'))
disp(sprintf('The following procedure uses Gauss-Seidel method to calculate the value'))
disp(sprintf('of the solution for the above system of equations using maxit iterations.')) 
disp(sprintf('It will then store each approximate solution, Xi, from each iteration '))
disp(sprintf('in a matrix with maxit columns. Thereafter, Matlab will plot the solutions')) 
disp(sprintf(' as a function of the iteration number.'))


%--------------------------------------------------------------------------
 
 %epsa is the array that stores the absolute relative approximate error at the end of each iteration.
 epsa=zeros(n);
 %Xnew is the solution vector after each iteration is conducted.
 Xnew=zeros(n);
 %epsmax is the greatest relative approximate error of all values in the solution vector that are generated in the given iteration.
 epsmax=zeros(maxit);
 %Xstore is a matrix that stores the solution vector after each iteration.
 Xstore=zeros(n,maxit);
 %Defining the initial guess values of the solution vector.
 Xprev=X;
 %conducting maxit iterations. 
 for k=1:maxit
    epsmax(k)=0.0;
           for i=1:n
            %Initializing the series sum to zero.
            summ=0.0;
               for j=1:n
                  %Only adding i<>j terms.
                  if (i>j) 
                     %Generating the summation term in Equation (3.1).
                     summ=summ+A(i,j)*Xprev(j);
                  end 
                  if (i<j) 
                     %Generating the summation term in Equation (3.1).
                     summ=summ+A(i,j)*Xprev(j);
                  end 
               end 
                %Using Equation (3.1) to calculate the new [X] solution vector.
                Xnew(i)=(RHS(i)-summ)/A(i,i);
                %Calculating the absolute relative approximate error. 
                epsa(i)=abs((Xnew(i)-Xprev(i))/Xnew(i))*100.0;
                %Finding the maximum epsa value.
                if epsmax(k)<=epsa(i)
                    epsmax(k)=epsa(i);
                end 
                %Updating the previous guess.           
                Xprev(i)=Xnew(i);
                %Storing each value of X for each iteration.
                Xstore(i,k)=Xnew(i);
            end 
end 
    
%------------------------------Results-----------------------------------
disp(sprintf('\n*********************************** Results ****************************\n\n'))
disp(sprintf('The following matrix stores the value of the solution for Xi\nin the ith row after each given iteration'))
Xstore1=Xstore;
Xstore=num2str(Xstore1,'%10.5g')
Xstore=Xstore1;
disp(sprintf('\nThe following matrix stores the maximum absolute relative approximate error\npercentage after each given iteration.'))
Z=(1:maxit);
%Only to enhance display
epsmax1=epsmax;
epsmax=num2str(epsmax1(1:maxit,1)','%10.5g')
epsmax=epsmax1;
%----Plots----
for i=1:n
figure
plot(Z,Xstore(i,1:maxit),'LineWidth',3)
xlabel('Iteration Number')
ylabel(['X',num2str(i)])
title(['Value of X',num2str(i),' as a function of the iteration Number'])
end

ex=epsmax1(1:maxit,1);
figure
plot(Z,ex,'g','LineWidth',3)
xlabel('Iteration Number')
ylabel('Maximum absolute relative approximate error')
axis([(0) (maxit+1) (-10) (max(ex))])
title('Maximum absolute relative approximate error as a function of iteration number')