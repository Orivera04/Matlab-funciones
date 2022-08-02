function [N,n,m]=mmisver(a)
%MMISVER Test for Given MATLAB Version. (MM)
% MMISVER(N) for integer N returns True if running any MATLAB version N.n.m
% For example MMISVER(4) returns True if running any version 4.n.m
%
% MMISVER(X) for noninteger X returns True if running MATLAB version X
% For example MMISVER(5.3) returns True if running version 5.3 or 5.3.1
%
% MMISVER(RXX) for string RXX denoting the release number, e.g. 'R12'
% returns TRUE if running the designated release number.
%
% X=MMISVER returns the N.n version of MATLAB ignoring any third digit
% For example version 6.0.1 returns X=6.0
%
% [N,n,m]=MMISVER returns the N.n.m version of MATLAB as separate integers.
% For example [N,n,m]=MMISVER returns N=5, n=2, m=1 for version 5.2.1
%
% MMISVER('R') returns the numerical release number of MATLAB.

% See also VERSION

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 3/30/99, 6/14/00
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==0 & nargout<=1              % X=MMISVER
   N=sscanf(version,'%f',1);
elseif nargin==0                       % [N,n,m]=MMISVER
   v=strrep(version,'.',' ');
   Nnm=sscanf(v,'%d',3);
   N=Nnm(1); n=Nnm(2); m=Nnm(3);
elseif isnumeric(a)
   if a==fix(a)                       	% MMISVER(N)
      N=(sscanf(version,'%d',1)==a);
   else                               	% MMISVER(X)
      N=(sscanf(version,'%f',1)==a);
   end
elseif ischar(a)&(length(a)==1)			% MMISVER R
   v=version;
   idx=findstr(v,'(R');
   if ~isempty(idx)
      N=sscanf(v(idx(1)+2:end),'%d',1);
   else
      error('Unable to Determine Release Number.')
   end
elseif ischar(a)&(length(a)==3)			% MMISVER(RXX)
   N=~isempty(findstr(lower(version),a));
else
   error('Unknown Calling Syntax.')
end
