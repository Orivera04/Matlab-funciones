function out = corrsort(s,f)
%CORRSORT Sort elements in a variance matrix by correlation.
%
%   X = CORRSORT(S) returns an N*(N-1)/2-by-3 matrix with the correlations
%   in the first column and variable numbers in the two last columns.  The
%   elements are sorted by absolute correlation, so, for instance, -0.5 and
%   0.5 are considered equal.
%
%   X = CORRSORT(S,FLAG) will sort correlations rather than absolute
%   correlations, so, for instance, -0.5 and 0.5 are considered different.
%
%   The correleations are sorted in descending order.
%
%   If no output argument is given, the results are pretty-printed.

%   Author:      Peter J. Acklam
%   Time-stamp:  2002-03-03 13:45:58 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   error(nargchk(1, 2, nargin));        % check number of input args
   [m, n] = size( s );
   if m ~= n
      error('Input matrix must be square.');
   end

   r = var2corr(s);                     % variance to correlation matrix
   n = size(r, 1);                      % dimension

   tmp = tril(ones(n), -1);             % temporary matrix
   rho = r(find(tmp));                  % correlation coefficients
   [i j] = find(tmp);                   % indices of corresponding elements

   % Get the sort keys and do the sorting.
   if nargin == 1
      keys = -abs(rho);
   else
      keys = -rho;
   end
   [dummy order] = sort(keys);

   xu = [j i rho];                      % build unsorted matrix
   xs = xu(order,:);                    % sort the matrix

   if nargout
      % return results
      out = x;
   else
      % pretty-print results
      fprintf('\n');
      fprintf('     Sorted by variable     Sorted by correlation\n');
      fprintf('\n');
      fprintf(' Variables  Correlation    Variables  Correlation\n');
      fprintf('\n');
      fprintf('%5d %4d %+12.6f %7d %4d %+12.6f\n', [ xu xs ].');
      fprintf('\n');
   else
      out = x;
   end
