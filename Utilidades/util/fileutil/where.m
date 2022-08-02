function locations = where(varargin)
%WHERE  List all locations of one or more MATLAB functions.
%
%   Usage
%
%      WHERE FUN1 FUN2 ...
%      WHERE(FUN1, FUN2, ...)
%      LOCATIONS = WHERE(FUN1, FUN2, ...)
%
%   See also WHICH.

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-10-13 13:06:45 +0200
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   % Check number of input arguments.
   error(nargchk(1, Inf, nargin));

   % Are there any output arguments?
   display = 1;
   if nargout                   % If there are output arguments...
      locations = {};           % ...initialize output argument...
      display = 0;              % ...don't display results.
   end

   for i = 1:nargin
      if display
         which( varargin{i}, '-all' )
      else
         loc = which( varargin{i}, '-all' );
         if ~isempty(loc)
            locations = [ locations ; loc ];
         end
      end
   end
