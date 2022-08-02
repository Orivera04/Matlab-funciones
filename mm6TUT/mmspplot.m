function a=mmspplot(varargin)
%MMSPPLOT Plot Spline Piecewise Polynomials. (MM)
% MMSPPLOT(PP) plots the spline having piecewise polynomial PP
% over its range of definition.
%
% MMSPPLOT(XR,PP) plots PP over the range specified by the two
% element vector XR=[Xmin Xmax].
%
% MMSPPLOT(XR,PP,S) uses the line type/plot symbol/color information
% contained in the string S. See PLOT for information about S.
%
% MMSPPLOT(XR1,PP1,S1,XR2,PP2,S2,...) plots multiple PPs defined by
% the triples (XRi,PPi,Si) on the same axes.
%
% H=MMSPPLOT(...) returns handles to the created lines.
%
% See also MMSPHELP

% D.C. Hanselman, University of Maine, Orono, ME  04469
% 8/19/99, 11/10/99
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

tol=sqrt(eps);
True=logical(1);
False=logical(0);
gotxr=False;
gotpp=False;

if nargin==1 % simplest input
   pp=varargin{1};
   error(mmspchk(pp))
   br=mmspget(pp,'x');
   bp=br(2:end-1);
   x=sort(unique([mmsubdiv(br,10); (1+tol)*bp; (1-tol)*bp]));
   x(x<min(br))=[];
   x(x>max(br))=[];
   y=mmppval(pp,x);
   h=plot(x,y);
   if nargout==1
      a=h;
   end
else
   pargs=cell(1,nargin);
   np=1;
   while np<=nargin
      arg=varargin{np};
      if ~gotxr % argument must be time span
         xmin=min(arg(1:2));
         xmax=max(arg(1:2));
         gotxr=True;
         np=np+1;
      elseif gotxr & ~gotpp % argument must be PP vector
         error(mmspchk(arg))
         br=mmspget(arg,'x');
         bp=br(2:end-1);
         x=sort(unique([mmsubdiv(br,10); (1+tol)*bp; (1-tol)*bp]));
         x(x<xmin)=[];
         x(x>xmax)=[];
         pargs{np-1}=x;
         pargs{np}=mmppval(arg,x);
         np=np+1;
         gotpp=True;
      elseif gotpp & ischar(arg) % argument must be S string
         pargs{np}=arg;
         np=np+1;
      else % triplet complete
         gotxr=False;
         gotpp=False;
      end
   end
   h=plot(pargs{:});
   if nargout==1
      a=h;
   end
end