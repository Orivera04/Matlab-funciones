function bathyscape(depth, limit)
%BATHYSCAPE See how deep we can recurse.
%
%   BATHYSCAPE will attempt to recurse down until the recursion limit it
%   reached, displaying messages along the way, telling how deep it has
%   reached.  The recursion limit is the 'RecursionLimit' root property.
%
%   BATHYSCAPE must be called with no input arguments.

%   Author:      Peter J. Acklam
%   Time-stamp:  2002-03-03 13:41:21 +0100
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   if ~nargin
      depth = 1;
      limit = get(0, 'RecursionLimit');
      fprintf('Diving...\n');
   end

   if depth < limit
      if ~rem(depth, 100) | limit - depth < 10
         fprintf('Now at depth %d\n', depth);
      end
      bathyscape(depth+1, limit);
   elseif depth == limit
      fprintf('Bottom was hit at recursion level %d!\n', depth);
      fprintf('Going up again.\n');
   end
