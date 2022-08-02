function ppt=mmsptrim(pp,tol)
%MMSPTRIM Trim Spline Breakpoints. (MM)
% MMSPTRIM(PP,TOL) Trims the 1-D spline described by the piecewise
% polynomial PP returning a piecewise polynomial having fewer breaks.
%
% MMSPTRIM recursively eliminates interior breakpoints if a new
% piecewise polynomial connecting the two breakpoints on either
% side of a tested breakpoint exhibits an error less than that specified
% by TOL at the tested breakpoint.
% TOL=[RelTol AbsTol] is a two element vector containing a
% relative error and absolute error criteria respectively. For example,
% TOL=[1e-2 1e-6] eliminates X if there is less than 1% relative error
% and 1e-6 absolute error at X. If TOL is not given, TOL=[1e-3 1e-8].
% The error exhibited at breakpoints eliminated in previous passes are
% not checked. To compensate TOL is reduced by a factor of two at each
% pass and the error in the final piecewise polynomial may be less than
% or greater than the default TOL.
%
% MMSPTRIM returns an error if PP is discontinuous at any of its
% breakpoints.
% Breakpoints where the slope is discontinuous are retained in the
% output.
% Discontinuities in the curvature at the breakpoints are ignored.
%
% See also: MMSPHELP

% D.C. Hanselman, University of Maine, Orono, ME  04469
% 2/17/01
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==1
    tol=[1e-3 1e-8];
end
if length(tol)~=2 | tol(1)<1e-12 | tol(2)<0
   error('Improper TOL Specified.')
end
ppt=pp;

while 1
	[ix,idx]=mmspjump(ppt);
	if any(ix)
       error('Spline Must Not be Discontinuous at Breakpoints.')
	end
   [x,y,dyl,dyr,np]=mmspget(ppt,'x','y','dyl','dyr','pieces');

	keep=zeros(1,np+1);
	keep(1)=1;
	keep(end)=1;
	keep(idx)=1; % keep is one for breaks to be kept

	ia=find(~keep&[0 keep(1:end-1)]); % one after every keep run
	ib=find(~keep&[keep(2:end) 0]);   % one before every keep run
	idx=[];
	for i=1:length(ia)
       idx=[idx ia(i):2:ib(i)];
	end
	tmp=zeros(size(keep));
	tmp(idx)=1;          % breaks marked for deletion test
	tp=find(tmp);        % break indices to test for deletion
   keep=keep|~tmp;      % breakpoint keepers
	k=find(keep);        % breakpoint keeper indices
	
	xn=x(k);
	yn=y(k);
	dyln=dyl(k(1:end-1));
	dyrn=dyr(k(2:end)-1);
	ppr=mmhermite(xn,yn,dyln,dyrn);
	
   xtp=x(tp);
	yb=mmppval(pp,xtp);
	ya=mmppval(ppr,xtp);

	idx=find(abs(ya-yb)>=(abs(yb)*tol(1) + tol(2)));
   if length(idx)==length(xtp)
      break
   end
   keep(tp(idx))=1;
   k=find(keep);

   xn=x(k);
	yn=y(k);
	dyln=dyl(k(1:end-1));
	dyrn=dyr(k(2:end)-1);
	ppt=mmhermite(xn,yn,dyln,dyrn);
   tol=max(tol/2,eps);
end
