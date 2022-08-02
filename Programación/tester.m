function test_it = templatestester()
%
% function[ test_it ] = templatestester()
%
% templatestester loops over the various MatLab versions of the iterative
% templates. Test matrices are generated in matgen.m. Results are printed 
% to the screen.

%  INITIALIZATION

   no_soln_jac   = 0;                     % convergence check
   no_soln_sor   = 0;
   no_soln_cg    = 0;
   no_soln_cheby = 0;
   no_soln_gmres = 0;
   no_soln_bicg  = 0;
   no_soln_cgs   = 0;
   no_soln_bicgs = 0;
   no_soln_qmr   = 0;

   guess_err_jac   = 0;                   % initial guess = solution error
   guess_err_sor   = 0;                   
   guess_err_cg    = 0;                   
   guess_err_cheby = 0;                   
   guess_err_gmres = 0;                   
   guess_err_bicg  = 0;                   
   guess_err_cgs   = 0;                   
   guess_err_bicgs = 0;                   
   guess_err_qmr   = 0;                   

   allpassed = 0;

   num_tests = 6;
   ep = eps;
   tol = ep * 1000;

%  BEGIN TESTING: FORM SYSTEM AND APPLY ALGORITHMS

   for test = 1:num_tests
      test
      A = matgen( test*10 );             % form test matrix
      [sizeA,sizeA] = size(A);
      max_it = sizeA * 10;
      normA = norm( A,inf );
      if ( test == 1 | test == 2 | test == 3 | test == 6 ),
         for i = 1:sizeA,                % set rhs = row sums
            temp = 0.0;
            for j = 1:sizeA,
               temp = temp + A(i,j);
            end
            b(i,1) = temp;
         end
      else 
         b = ones(sizeA,1);              % set rhs = unit vector
      end
      if ( test < 4 ),
         M = eye(sizeA);                 % no preconditioning
      else
         M = diag(diag(A));              % diagonal preconditioning
      end

      if ( test < 6 ),
         xk = 0*b;                       % initial guess = zero vector
      else
         xk = ones(sizeA,1 );            % initial guess = solution
      end

%     TEST EACH METHOD; CHECK ACCURACY IF CONVERGENCE CLAIMED

%     Test Jacobi and Chebyshev

      if ( test == 1 | test == 6 ),
         jac_maxit = max_it * 3;
         [x, error, iter, flag_jac] = jacobi(A, xk, b, jac_maxit, tol);
         if ( flag_jac ~= 0 & test ~= 6 ),
            no_soln_jac = no_soln_jac + 1;
            'jacobi failed to converge for'
            test, error
            allpassed = allpassed + 1;
         end
         if ( test == 6 & iter ~= 0 & flag_jac ~= 0 )
            guess_err_jac = guess_err_jac + 1;
            'jacobi failed for initial guess = solution'
            test, iter, flag_jac
            allpassed = allpassed + 1;
         end

         [x, error, iter, flag_cheby] = cheby(A, xk, b, M, max_it, tol);
         if ( flag_cheby ~= 0 & test ~= 6 ),
            no_soln_cheby = no_soln_cheby + 1;
            'chebyshev failed to converge for'
            test, error
            allpassed = allpassed + 1;
         end
         if ( test == 6 & iter ~= 0 & flag_cheby ~= 0 )
            guess_err_cheby = guess_err_cheby + 1;
            'chebyshev failed for initial guess = solution'
            test, iter, flag_cheby
            allpassed = allpassed + 1;
         end

      end

%     SPD ROUTINES

      if ( test == 1 | test == 2 | test == 4 | test == 6 ), 

         if ( test == 1 ),                     % various relaxation parameters
            w = 1.0;
         elseif ( test == 2 ),
            w = 1.2;
         else
            w = 1.1;
         end

         sor_maxit = max_it * 3;
         [x, error, iter, flag_sor] = sor(A, xk, b, w, sor_maxit, tol);
         if ( flag_sor ~= 0 & test ~= 6 ),
            no_soln_sor = no_soln_sor + 1;
            'sor failed to converge for'
            test, error
            allpassed = allpassed + 1;
         end
         if ( test == 6 & iter ~= 0 & flag_sor ~= 0 ),
            guess_err_sor = guess_err_sor + 1;
            'sor failed for initial guess = solution'
            test, iter, flag_sor
            allpassed = allpassed + 1;
         end

         [x, error, iter, flag_cg] = cg(A, xk, b, M, max_it, tol);
         if ( flag_cg ~= 0 & test ~= 6 ),
            no_soln_cg = no_soln_cg + 1;
            'cg failed to converge for'
            test, error
            allpassed = allpassed + 1;
         end
         if ( test == 6 & iter ~= 0 & flag_cg ~= 0 ),
            guess_err_cg = guess_err_cg + 1;
            'cg failed for initial guess = solution'
            test, iter, flag_cg
            allpassed = allpassed + 1;
         end
      end

%     Nonsymmetric ROUTINES

      if ( test == 1 | test == 4 | test == 5 | test == 6 ) 

         restrt = test*10;
         if ( restrt == 0 ) restrt = 1, end;
         [x, error, iter, flag_gmres]=gmres( A, xk, b, M, restrt, max_it, tol );
         if ( flag_gmres ~= 0 & test ~= 6 ),
            no_soln_gmres = no_soln_gmres + 1;
            'gmres failed to converge for'
            test
            allpassed = allpassed + 1;
         end
         if ( test == 6 & iter ~= 0 & flag_gmres ~= 0 )
            guess_err_gmres = guess_err_gmres + 1;
            'gmres failed for initial guess = solution'
            test, iter, flag_gmres
            allpassed = allpassed + 1;
         end
         [x, error, iter, flag_bicg] = bicg(A, xk, b, M, max_it, tol);
         if ( flag_bicg ~= 0 & test ~= 6 ),
            no_soln_bicg = no_soln_bicg + 1;
            'bicg failed to converge for'
            test, error
            allpassed = allpassed + 1;
         end
         if ( test == 6 & iter ~= 0 & flag_bicg ~= 0 )
            guess_err_bicg = guess_err_bicg + 1;
            'bicg failed for initial guess = solution'
            test, iter, flag_bicg
            allpassed = allpassed + 1;
         end

         [x, error, iter, flag_cgs] = cgs(A, xk, b, M, max_it, tol);
         if ( flag_cgs ~= 0 & test ~= 6 ),
            no_soln_cgs = no_soln_cgs + 1;
            'cgs failed to converge for'
            test, error
            allpassed = allpassed + 1;
         end
         if ( test == 6 & iter ~= 0 & flag_cgs ~= 0 )
            guess_err_cgs = guess_err_cgs + 1;
            'cgs failed for initial guess = solution'
            test, iter, flag_cgs
            allpassed = allpassed + 1;
         end

         [x, error, iter, flag_bicgs] = bicgstab(A, xk, b, M, max_it, tol);
         if ( flag_bicgs ~= 0 & test ~= 6 ),
            no_soln_bicgs = no_soln_bicgs + 1;
            'bicgstab failed to converge for'
            test, error
            allpassed = allpassed + 1;
         end
         if ( test == 6 & iter ~= 0 & flag_bicgs ~= 0 ),
            guess_err_bicgs = guess_err_bicgs + 1;
            'bicgstab failed for initial guess = solution'
            test, iter, flag_bicgs
            allpassed = allpassed + 1;
         end

         [x, error, iter, flag_qmr] = qmr(A, xk, b, M, max_it, tol);
         if ( flag_qmr ~= 0 & test ~= 6 ),
            no_soln_qmr = no_soln_qmr + 1;
            'qmr failed to converge for'
            test, error
            allpassed = allpassed + 1;
         end
         if ( test == 6 & iter ~= 0 & flag_qmr ~= 0 ),
            guess_err_qmr = guess_err_qmr + 1;
            'qmr failed for initial guess = solution'
            test, iter, flag_qmr
            allpassed = allpassed + 1;
         end
      end
   end

%  REPORT RESULTS

   TESTING = '             COMPLETE'

   if ( allpassed == 0 ),
      RESULTS = '             ALL TESTS PASSED', end

   if ( no_soln_jac ~= 0 ),
      'jacobi failed test (failed to converge)',
   elseif ( guess_err_jac ~= 0 ),
      'jacobi failed test (initial guess = solution error)',
   else
      'jacobi passed test';
   end

   if ( no_soln_sor ~= 0 ),
      'sor failed test (failed to converge)',
   elseif ( guess_err_sor ~= 0 ),
      'sor failed test (initial guess = solution error)',
   else
      'sor passed test';
   end

   if ( no_soln_cg ~= 0 ),
      'cg failed test (failed to converge)',
   elseif ( guess_err_cg ~= 0 ),
      'cg failed test (initial guess = solution error)',
   else
      'cg passed test';
   end

   if ( no_soln_cheby ~= 0 ),
      'cheby failed test (failed to converge)',
   elseif ( guess_err_cheby ~= 0 ),
      'cheby failed test (initial guess = solution error)',
   else
      'cheby passed test';
   end

   if ( no_soln_gmres ~= 0 ),
      'gmres failed test (failed to converge)',
   elseif ( guess_err_gmres ~= 0 ),
      'gmres failed test (initial guess = solution error)',
   else
      'gmres passed test';
   end

   if ( no_soln_bicg ~= 0 ),
      'bicg failed test (failed to converge)',
   elseif ( guess_err_bicg ~= 0 ),
      'bicg failed test (initial guess = solution error)',
   else
      'bicg passed test';
   end

   if ( no_soln_cgs ~= 0 ),
      'cgs failed test (failed to converge)',
   elseif ( guess_err_cgs ~= 0 ),
      'cgs failed test (initial guess = solution error)',
   else
      'cgs passed test';
   end

   if ( no_soln_bicgs ~= 0 ),
      'bicgstab failed test (failed to converge)',
   elseif ( guess_err_bicgs ~= 0 ),
      'bicgstab failed test (initial guess = solution error)',
   else
      'bicgstab passed test';
   end

   if ( no_soln_qmr ~= 0 ),
      'qmr failed test (failed to converge)',
   elseif ( guess_err_qmr ~= 0 ),
      'qmr failed test (initial guess = solution error)',
   else
      'qmr passed test';
   end

%  END TEMPLATES TESTING
