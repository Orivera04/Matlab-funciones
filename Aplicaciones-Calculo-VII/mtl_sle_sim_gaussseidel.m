clc
%Click the run bottom and refer to the comaand window
%These are the inputs that can be modified by the user
%n = number of equations'))
n=4;
%[A] = nxn coefficient matrix
A=[10,3,4,5;2,24,7,4;2,2,34,3;2,5,2,12];
%[RHS] = nx1 right hand side array
RHS=[22,32,41,18];
%[X] = nx1 initial guess of the solution vector
X=[1,23,4,50];
%maxit = maximum number of iterations
maxit=5;
disp('Simulation of Gauss-Seidel Method ')
disp('© 2007 Fabian Farelo, Autar Kaw ') 
disp('University of South Florida ') 
disp(' United States of America ')
disp(' http://numericalmethods.eng.usf.edu ')

disp(sprintf('\nNOTE: This worksheet demonstrates the use of Matlab to illustrate the Gauss-Seidel Method,\nan iterative technique used in solving a system of simultaneous linear equations.')) 

%--------------------------------------------------------------------------
disp(sprintf('\n**************************** Introduction ******************************'))
disp(sprintf('\nGauss-Seidel method is used to solve a set of simultaneous linear equations,\n[A] [X] = [RHS],where [A]nxn is the square coefficient matrix, [X]nx1 is the solution\nvector, and [RHS]nx1 is the right hand side array.\nThe equations can be rewritten as:'))
disp(sprintf('\n        x[i] = [rhs[i]-sum(A[i,j]*X*[j])[i<>j]/A[i,j]]                               (1.1)'))
disp(sprintf('\nIn certain cases, such as when a system of equations is large, iterative methods of\nsolving equations such as Gauss-Seidel method are more advantageous.'))
disp(sprintf('Elimination methods, such as Gaussian Elimination, are prone to round-off errors for a\nlarge set of equations whereas iterative methods,'))
disp(sprintf('such as Gauss-Seidel method, allow the user to control round-off error.'))
disp(sprintf('Also if the physics of the problem are well known, initial guesses needed in iterative\nmethods can be made more judiciously for faster convergence.'))

disp(sprintf('Steps to apply Gauss-Seidel Method:'))

disp(sprintf('1) Make an initial guess for the solution vector [X]. This can be based on the physics of\nthe problem.\n(Note: To begin, the initial guess will be considered Xold).'))

disp(sprintf('\n               X[old] = [x1, x2, x3 .. xn]                                           (1.2)'))
disp(sprintf('\n2) Substitute the initial guess solution vector [X] in Equation (1.1).'))
disp(sprintf('\n        xi = [RHS[i]-sum(A[i,j]*X[j])[i<>j]/A[i,j]]                                  (1.3)'))            
disp(sprintf('\n3) The new xi guess that is obtained will replace the previous guess in the [X] vector.'))

disp(sprintf('\n               Xold = [xnew, x2, x3 .. xn]                                           (1.4)'))
disp(sprintf('[X] will then be used to calculate the next xi value by repeating Step 2.\nThis will be repeated n times until the new solution vector [X] is complete.'))
disp(sprintf('\n               Xnew = [xnew, x2new, x3new .. xnnew]                                  (1.5)'))
disp(sprintf('4) At this point, the first iteration is completed and the absolute relative\napproximate error (abs_ea) is calculated by comparing the new guess [X] with the\nprevious guess [Xold].'))
disp(sprintf('\n               abs_ea_i = 100*|xi new - xi old] /[xi new]|                           (1.6)'))
disp(sprintf('\nThe maximum of these errors is the absolute relative approximate error at the end of\nthe iteration.'))
disp(sprintf('\n5) Repeat Steps 1-4, replacing the new solution vector with the old solution vector in\nStep 1. Repeat until you have conducted either the maximum number of iterations or met\nthe pre-specified tolerance.'))
disp(sprintf('\n               Xold = Xnew                                                           (1.7)'))
disp(sprintf('\nA simulation of Gauss-Seidel method follows.')) 





%--------------------------------------------------------------------------
disp(sprintf('********************************** Input Data ******************************************'))

disp(sprintf('n = number of equations'))
disp(sprintf('[A] = nxn coefficient matrix'))
disp(sprintf('[RHS] = nx1 right hand side array'))
disp(sprintf('[Xold] = nx1 initial guess of the solution vector'))
disp(sprintf('maxit = maximum number of iterations'))
disp(sprintf('\nNOTE: These are the default values. Input data can be changed at the beginning of\nthe M-file\n'))
disp(sprintf('n= %d',n))
A
RHS
X
maxit
disp(sprintf('*********************************** Iterations *******************************************\n'))
disp(sprintf('Below, "maxit" iterations are conducted and values of the previous approximations, present\napproximations,absolute relative percentage approximate error, and maximum absolute\nrelative percentage approximate error are calculated at the end of each iteration.\n'))


%Initializing the absolute relative approximate error array
abs_ea=zeros(n); 

%Iterations
%--------------------------------------------------------------------------

%Defining the number of iterations to be conducted.
 for k=1:maxit 
  disp('=========================================================================================')
  disp('=========================================================================================')
  disp(' ')
  disp(sprintf('Iteration number%d',k))  
  disp(sprintf('Previous iteration values of the solution vector')) 
  Xold=X;
  Xold


 %The following i loop generates the new solution vector:
  for i=1:n
    %Initializing the series sum to zero.
    summ=0;
    for j=1:n
       %Only adding i<> terms.      
       if (i<j) 
          %Generating the summation term.       
          summ=summ+A(i,j)*X(j);
       end 
       if (i>j) 
          %Generating the summation term.       
          summ=summ+A(i,j)*X(j);
       end 
    end 
    %Using Gauss-Seidel method to calculate new [X] term. 
    X(i)=(RHS(i)-summ)/A(i,i); 
  end 
  %Initializing the maximum absolute relative percentage approximate error to zero.
  Max_abs_ea=0.0;
  %The following i loop generates the maximum absolute relative percentage approximate error for the kth step:
  for i=1:n
   %Calculating absolute relative percentage approximate error for each Xi.  
    abs_ea(i)=abs((X(i)-Xold(i))/X(i))*100.0;
       %Defining the maximum value of the relative approximate errors.   
       if abs_ea(i)>Max_abs_ea 
          Max_abs_ea=abs_ea(i);
       end 
  end
  disp(sprintf('----------------------New iterative values of the solution vector-----------------------'))
  X
  disp(sprintf('---------------------Absolute relative percentage approximate error---------------------'))
  Y=rot90(abs_ea);
  abs_e=Y(n,1:n)
  disp(sprintf('-----------------Maximum absolute relative percentage approximate error-----------------'))
  Max_abs_ea
end 
