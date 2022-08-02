   function cputim1  = cputime
%CPUTIME  Computation of the CPU time.
%cputim1  = cputime returns the  cputime in seconds that 
%has been used by the program since the program started.
%example :
% t1 = cputime
% your-operation
% t1 = cputime - t1 
%returns the cputime used to run your-operation.
%Since this PC version of MATLAB does not have a cputime 
%I have written a program called cputime
%that gives the time.

        t1 = clock;
        sum =  t1(6);
        sum = sum + t1(5) * 60;
        sum = sum + t1(4) * 3600;
        cputim1  = sum;     
        end;
     
