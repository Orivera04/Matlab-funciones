function rel = release
%RELEASE Return the MATLAB release number.
%
%   RELEASE returns the release number of the running version of MATLAB.  An
%   empty string is returned if the release number can't be found.
%
%   See also VERSION, VER.

%   Author:      Peter J. Acklam
%   Time-stamp:  2003-10-13 11:37:28 +0200
%   E-mail:      pjacklam@online.no
%   URL:         http://home.online.no/~pjacklam

   ver = version;
   idx = strfind(ver, '(R');

   % quick exit if we can't find any release number
   if isempty(idx)
      rel = [];
      return;
   end

   rel = sscanf(ver(idx+2:end), '%g');
