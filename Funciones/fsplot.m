function a=fsplot(varargin)
%FSPLOT Fourier Series Function Plot. (MM)
% FSPLOT(Kn) plots the FS Kn over the range [0 T] where
% T=1 is the period.
% FSPLOT(Kn1,Kn2,...) plots multiple FS over the range [0 T]
% where T=1 is the period.
%
% FSPLOT(TK,Kn) plots the FS Kn over the range specified in TK.
% TK must be either [Tmin/T Tmax/T] or [Tmin Tmax T], where the
% range plotted is [Tmin Tmax]. TK=[] defaults to TK=[0 1].
%
% FSPLOT(TK,Kn,S) uses the line type/plot symbol/color information
% contained in the string S. See PLOT for information about S.
%
% FSPLOT(TK1,Kn1,S1,TK2,Kn2,S2,...) plots multiple FS defined by
% the triples (TKi,Kni,Si) on the same axes.
%
% H=FSPLOT(...) returns handles to the created lines.
%
% See also FSHELP

% Calls: fssize, fseval

% D. Hanselman, University of Maine, Orono, ME  04469
% 8/3/99, 11/10/99, 5/4/00, 4/10/01
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

True=logical(1);
False=logical(0);
gottk=False;
gotkn=False;

if nargin==1 % FSPLOT(Kn)
   kn=varargin{1};
   [N,msg]=fssize(kn);
   error(msg)
   Npts=max(5*N,100);
   t=linspace(0,1,Npts);
   y=fseval(kn,t,1);
   h=plot(t,y);
   if nargout==1
      a=h;
   end
   
elseif ~any(cellfun('isclass',varargin,'char')) &...
       all(cellfun('size',varargin,1)==1) & ...
       all(cellfun('size',varargin,2)>3)  % FSPLOT(Kn1,Kn2,...)
   pargs=cell(2,nargin);
   for k=1:nargin
      Kn=varargin{k};
      [N,msg]=fssize(Kn);
      error(msg)
      Npts=max(5*N,100);
      t=linspace(0,1,Npts);
      pargs{1,k}=t;
      pargs{2,k}=fseval(Kn,t,1);
   end
   h=plot(pargs{:});
   if nargout==1
      a=h;
   end

else  % FSPLOT(TK1,Kn1,S1,TK2,Kn2,S2,...)
   pargs=cell(1,nargin);
   np=1;
   while np<=nargin
      arg=varargin{np};
      if ~gottk % argument must be time span
         if isempty(arg)
            tmin=0;
            tmax=1;
            T=1;
         elseif length(arg)==2
            tmin=arg(1);
            tmax=arg(2);
            T=1;
         else
            tmin=arg(1);
            tmax=arg(2);
            T=arg(3);
         end
         gottk=True;
         np=np+1;
      elseif gottk & ~gotkn % argument must be FS vector
         [N,msg]=fssize(arg);
         error(msg)
         Npts=max(5*N*max(abs(tmax-tmin)/T,1),100);
         pargs{np-1}=linspace(tmin,tmax,Npts);
         pargs{np}=fseval(arg,pargs{np-1},T);
         np=np+1;
         gotkn=True;
      elseif gotkn & ischar(arg) % argument must be S string
         pargs{np}=arg;
         np=np+1;
      else % triplet complete
         gottk=False;
         gotkn=False;
      end
   end
   h=plot(pargs{:});
   if nargout==1
      a=h;
   end
end