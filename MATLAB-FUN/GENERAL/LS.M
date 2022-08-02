function l=ls(arg)
%LS	Directory listing.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

if isunix
   if nargin == 0
      [s,l] = unix('ls');
   else
      [s,l] = unix(['ls ', arg]);
   end
else
   c = computer;
   if strcmp(c(1:2),'PC') | strcmp(c(1:3),'MAC') | strcmp(c,'VAX_VMSG') | strcmp(c,'VAX_VMSD')
      if nargin == 0
         eval('dir');
      else
         eval(['dir ' arg]);
      end
   end
end
