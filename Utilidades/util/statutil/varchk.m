function msg = varchk(S)
%VARCHK Perform extensive checking on a variance matrix.
%
%   VARCHK(S) checks the variance matrix S and display an error message if
%   it does not satisfy the conditions for being a variance matrix.
%
%   MSG = VARCHK(S) returns the error message rather than displays it.

%   Author:      Peter J. Acklam
%   Time-stamp:  2002-03-03 13:45:29 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   if isempty(S)
      msg = 'Variance matrix is empty.';

   elseif ~isa(S, 'double')
      msg = 'Variance matrix must be of class ''double''.' ;

   elseif ndims(S) > 2
      msg = 'Variance matrix can not have more than two dimensions.' ;

   elseif size(S, 1) ~= size(S, 2);
      msg = 'Variance matrix must be square.';

   elseif ~isreal(S)
      msg = 'Variance matrix must be real.';

   elseif any(any(S ~= S.'))
      msg = 'Variance matrix must be symmetric.';

   elseif any(eig(S) < 0)
      msg = 'Variance matrix can not be negative definite.';

   else
      msg = '';
   end

   if ~nargout
      error(msg);
   end
