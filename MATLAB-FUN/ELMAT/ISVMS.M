function yn = isvms()
%ISVMS	True for the VMS operating system.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

c = computer;
yn = 0;
if strcmp(c,'VAX_VMSD') | strcmp(c,'VAX_VMSG')
   yn = 1;
end
