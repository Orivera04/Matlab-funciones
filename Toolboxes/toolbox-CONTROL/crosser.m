 function [x,z] = crosser(funname,range,value,tol,P1,P2,P3,P4,P5,P6,P7,P8,P9);
% CROSSER = Interpolation of a function for a specified value 
%
%function [x,z] = crosser(funname,range,value);
%
%OPTIONAL additional parameters:
%function [x,z] = crosser(funname,range,value,tol,P1,P2,P3,P4,P5,P6,P7,P8,P9);
%
%  SEE ALSO : fsolve, fzero, fmin and fmins  (MATLAB supplied functions)
%
 if ( nargin < 2 )
   disp('crosser requires a minimum of 2 arguements');
   x = NaN; z = NaN; return;
 end;
 if nargin < 3, value = []; end; 
 if isempty(value), value = 0; end;
 if nargin < 4, tol =[]; end;
 if isempty(tol), tol = 1e-4; end;
 evalstr = ['z = ' funname '(x'];
 for n = 5:nargin, evalstr = [evalstr ',P' num2str(n-4)]; end;
 evalstr = [evalstr ');'];
% disp(range); disp(value);
 x = range(1); eval(evalstr); y(1) = z;
 x = range(2); eval(evalstr); y(2) = z;
 if ( y(1) > y(2) ), range = fliplr(range); y = fliplr(y); end;
 if ( ( y(1) > value ) | ( value > y(2) ) )
   disp('Input range to crosser does not intersect with the value!');
   disp([range;y]); disp(value);
   x = NaN; z = NaN; return;
 end;
% disp(abs(value-z)); disp(tol);
 while ( abs(value-z) > tol );
   x = (range(1)+range(2))/2;
   if ( (x == range(1)) | (x == range(2)) )  % Numeric accuracy limit reached
     disp('Crosser could not find the point within the specified tolerance');
     return;
   end;
   eval(evalstr);
%   disp([range(1) x range(2);y(1) z y(2)]);
   b = 1+( z > value );
   range(b) = x;
   y(b) = z;
 end;
   
