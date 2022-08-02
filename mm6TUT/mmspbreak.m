function ppo=mmspbreak(pp,xi,op)
%MMSPBREAK Modify Spline Breakpoints. (MM)
% MMSPBREAK(PP,X,'op') modifies the breakpoints in the piecewise
% polynomial PP using the breakpoints in X and performing the
% operation specified by the string 'op'.
% 'op' must be one of the following:
% 'new' - X becomes the new breakpoints in PP, the original
%         breakpoints are discarded,
% 'add' - X specifies breakpoints to add to PP, breakpoints
%         cannot be added outside the original breakpoints.
% 'remove' or 'delete' - X specifies breakpoints to remove from PP,
%         elements in X that are not breakpoints are ignored.
%
% See also: MMSPHELP

% D.C. Hanselman, University of Maine, Orono, ME  04469
% 8/20/99, 9/27/99
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin<3
   error('Three Input Arguments are Required.')
end
error(mmspchk(pp));
if ~ischar(op)|isempty(op)
   error('Third Argument Must be a String.')
end
xi=xi(:);
op=lower(op(isletter(op)));
switch op(1)
case 'n'
   if length(xi)<2
      error('At Least Two Breakpoints are Required.')
   end
   yi=mmppval(pp,xi);
   dyi=mmspder(pp,xi);
   ppo=mmhermite(xi,yi,dyi);
case 'a'
   [x,y,dy,coef,nord]=mmspget(pp,'x','y','dy','coef','order');
   xmin=min(x);
   xmax=max(x);
   xi=mmunique(xi);
   nx=x;
   if isempty(xi)
      ppo=pp;
      return
   end
   yi=mmppval(pp,xi);
   dyi=mmspder(pp,xi);
   tol=eps*max(max(abs(xi)),1);
   for i=1:length(xi)
      if all(abs(xi(i)-x)>tol)& (xi(i)>xmin) & (xi(i)<xmax)
         k=max(find(x<xi(i))); % break before xi(i)                   
         xx=[x(k); xi(i)];
         yy=[y(k); yi(i)];
         dyy=[dy(k); dyi(i)];
         c1=[zeros(1,nord-4) local_chic(xx,yy,dyy)];
         kk=k+1; % break after xi(i)
         xx=[xi(i); x(kk)];
         yy=[yi(i); y(kk)];
         dyy=[dyi(i); dy(kk)];
         c2=[zeros(1,nord-4) local_chic(xx,yy,dyy)];
         k=max(find(nx<xi(i)));
         coef=[coef(1:k-1,:); c1;c2 ;coef(k+1:end,:)];
         nx=[nx(1:k); xi(i); nx(k+1:end)];
      end
   end
   ppo=mkpp(nx,coef);
case {'r' 'd'}
   [x,y,dy,coef,nord]=mmspget(pp,'x','y','dy','coef','order');
   tol=eps*max(max(abs(xi)),1);
   for i=1:length(xi)
      k=find(abs(xi(i)-x)<tol);
      if ~isempty(k)
         k=k(1);
         if k==1 % first breakpoint
            x(1)=[];
            y(1)=[];
            dy(1)=[];
            coef(1,:)=[];
         elseif k==length(x)
            x(k)=[];
            y(k)=[];
            dy(k)=[];
            coef(k-1,:)=[];
         else % interior breakpoint
            idx=k+[-1 1];
            c=local_chic(x(idx),y(idx),dy(idx));
            coef(k-1,:)=[zeros(1,nord-4) c];
            coef(k,:)=[];
            x(k)=[];
            y(k)=[];
            dy(k)=[];
         end
      end
   end
   ppo=mkpp(x,coef);
otherwise
   error('Unknown Operation Requested.')
end
%-------------------------------
function p=local_chic(x,y,yp)
%cubic hermite polynomial computation

dx=diff(x);
dx2=dx*dx;
dy=diff(y);
p=[(-2*dy/dx+yp(1)+yp(2))/dx2 (3*dy/dx-2*yp(1)-yp(2))/dx yp(1) y(1)];
