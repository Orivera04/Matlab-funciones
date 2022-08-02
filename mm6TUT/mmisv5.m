function tf=mmisv5(v)
%MMISV5 True for MATLAB Version 5. (MM)
% MMISV5 returns logical True if running ANY MATLAB version 5.x
%
% MMISV5(5.x) returns logical True ONLY if running MATLAB version 5.x
% e.g. MMISV5(5.2) returns True only for MATLAB version 5.2
%
% See also VERSION

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 8/15/96, 10/30/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8

if nargin==0
   tf=(sscanf(version,'%d',1)==5);
else
   tf=(sscanf(version,'%f',1)==v);
end
