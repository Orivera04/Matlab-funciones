function varargout=mmspget(pp,varargin)
%MMSPGET Get Spline Data. (MM)
% [V1,V2,...]=MMSPGET(PP,'Prop1','Prop2',...) returns the piecewise
% polynomial property values contained in PP associated with properties
% 'Prop1', 'Prop2', etc.
%
% Valid property names:
% 'xmin'             minimum breakpoint
% 'xmax'             maximum breakpoint
% 'x' or 'breaks'    breakpoints
% 'y'                y data used to construct the spline
% 'dy'               slope at breakpoints
% 'ddy'              curvature at breakpoints
%
% 'yl'               y value at left edge of each polynomial
% 'yr'               y value at right edge of each polynomial
% 'dyl'              slope at left edge of each polynomial
% 'dyr'              slope at right edge of each polynomial
% 'ddyl'             curvature at left edge of each polynomial
% 'ddyr'             curvature at right edge of each polynomial
%
% 'coef'             piecewise polynomial coefficient array
% 'pieces'           number of piecewise polynomials
% 'order'            spline order (polynomial order + 1)
% 'dim'              dimension of the spline (number of curves)
% 'form'             form of the spline (i.e., 'pp')
%                    (other forms exist in the Spline Toolbox)
%
% All outputs are column vectors.
% See also MMSPHELP

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 10/20/98, 4/26/99, 8/20/99, 9/22/99, 11/10/99, 12/2/00
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

errmsg='1-D Spline Required.';
ni=nargin-1;
if (ni>1) & (ni~=nargout)
   error('# of Outputs Must Equal # of Properties.')
end
[x,c,np,nc,nd]=unmkpp(pp);  % tear apart pp form
x=x(:);

for k=1:ni
   p=lower(varargin{k});
   if ~ischar(p)
      error('Property Names Must be Strings.')
   end
   if strncmp(p,'xmi',3)
      varargout{k}=min(x);
      
   elseif strncmp(p,'xma',3)
      varargout{k}=max(x);
      
   elseif strncmp(p,'x',1)|strncmp(p,'b',1)
      varargout{k}=x;
      
   elseif length(p)==1 & strncmp(p,'y',1)
      if nd>1, error(errmsg), end
      varargout{k}=[c(:,nc); polyval(c(np,:),x(np+1)-x(np))];
      
   elseif length(p)==2 & strncmp(p,'dy',2)
      if nd>1, error(errmsg), end
      cc=(nc-1:-1:1).*c(np,1:nc-1);
      varargout{k}=[c(:,nc-1); polyval(cc,x(np+1)-x(np))];
      
   elseif length(p)==3 & strncmp(p,'ddy',3)
      if nd>1, error(errmsg), end
      if nc>=3
         cc=(nc-1:-1:1).*c(np,1:nc-1); % order is nc-1
         cc=(nc-2:-1:1).*cc(1,1:nc-2); % order is nc-2
         varargout{k}=[2*c(:,nc-2); polyval(cc,x(np+1)-x(np))];
      else
         varargout{k}=zeros(size(x));
      end
      
   elseif strncmp(p,'yl',2)
      if nd>1, error(errmsg), end
      varargout{k}=c(:,nc);
      
   elseif strncmp(p,'yr',2)
      if nd>1, error(errmsg), end
      dx=diff(x);
      yr=c(:,1);
      for i=2:nc
         yr=dx.*yr + c(:,i);
      end
      varargout{k}=yr;
      
   elseif strncmp(p,'dyl',3)
      if nd>1, error(errmsg), end
      varargout{k}=c(:,nc-1);
      
   elseif strncmp(p,'dyr',3)
      if nd>1, error(errmsg), end
      sf=nc-1:-1:1;
      cc=sf(ones(np,1),:).*c(:,1:nc-1);
      dx=diff(x);
      dyr=cc(:,1);
      for i=2:nc-1
         dyr=dx.*dyr + cc(:,i);
      end
      varargout{k}=dyr;
      
   elseif strncmp(p,'ddyl',4)
      if nd>1, error(errmsg), end
      if nc>=3
         varargout{k}=2*c(:,nc-2);
      else
         varargout{k}=zeros(np,1)
      end
      
   elseif strncmp(p,'ddyr',4)
      if nd>1, error(errmsg), end
      if nc>=3
         sf=(nc-1:-1:2).*(nc-2:-1:1);
         cc=sf(ones(np,1),:).*c(:,1:nc-2);
         dx=diff(x);
         ddyr=cc(:,1);
         for i=2:nc-2
            ddyr=dx.*ddyr + cc(:,i);
         end
      else
         ddyr=zeros(np,1);
      end
      varargout{k}=ddyr;
      
   elseif strncmp(p,'c',1)
      varargout{k}=c;
      
   elseif strncmp(p,'p',1)   
      varargout{k}=np;
      
   elseif strncmp(p,'o',1)
      varargout{k}=nc;
      
   elseif strncmp(p,'d',1)
      varargout{k}=nd;
      
   elseif strncmp(p,'f',1)
      if isstruct(pp)
         varargout{k}=pp.form;
      elseif pp(1)==10
         varargout{k}='pp';
      else
         varargout{k}='';
      end
      
   else
      warning(['Unknown Property Name: ' p])
   end
end
