% bisec_n(f_name, a,c): bisection method without graphics
%      f_name: definition of the equation to solve
%       a, c : end points of initial interval
% Copyright S. Nakamura, 1995
function bisec_n(f_name, a,c)
f_name
%       tolerance : tolerance
%       it_limit : limit of iteration number
%       Y_a, Y_c : y values of the current end points
fprintf( 'Bisection Scheme\n\n' );
tolerance = 0.000001;  it_limit = 30;
fprintf( ' It.  a           b           c            f(a)   ');
fprintf( '     f(b)        f(c)\n' );
it = 0;
Y_a = feval(f_name, a ); Y_c = feval(f_name, c );
if ( Y_a*Y_c > 0 )  
     fprintf( '\n\n Stopped because   f(a)f(c) > 0 \n' );
     fprintf( '\n Change a or b and run again.\n' );
else   
   while 1 
      it = it + 1;
      b = (a + c)/2;  Y_b = feval(f_name, b );
      fprintf('%3.0f %10.6f, %10.6f', it, a, b );
      fprintf('%10.6f,  %10.6f, %10.6f, %10.6f\n', c, Y_a, Y_b, Y_c );
      if ( abs(c-a)<=tolerance )
         fprintf( '  Tolerance is satisfied. \n' );break
      end
      if ( it>it_limit )
        fprintf( 'Iteration limit exceeded.\n' ); break
      end  
      if( Y_a*Y_b <= 0 )     c = b;    Y_c = Y_b;
      else                   a = b;    Y_a = Y_b;
      end
   end
   fprintf('Final result: Root = %12.6f \n', b );
end

