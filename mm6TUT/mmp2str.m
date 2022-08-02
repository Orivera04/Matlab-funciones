function s=mmp2str(p,v,ff)
%MMP2STR Polynomial Vector to String Conversion. (MM)
% MMP2STR(P) converts the polynomial vector P into string representation.
% For example: P = [2 3 4] becomes the string '2x^2 + 3x + 4'
%
% MMP2STR(P,V) generates the string using the variable V as the parameter
% instead of x. MMP2STR([2 3 4],'z') becomes '2z^2 + 3z + 4'
%
% MMP2STR(P,1) or MMP2STR(P,V,1) factors the polynomial into the product
% of a constant and a monic polynomial.
% MMP2STR([2 3 4],1) becomes '2*(x^2 + 1.5x + 2)'
%
% See also MMPOLY, MMPADD, MMPSCALE, MMPSHIFT, MMPSIM.

% Calls: mmpsim

% D.C. Hanselman, University of Maine, Orono, ME, 04469
% 3/4/95, revised 11/12/96, v5: 1/14/97, 3/27/98
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin<3,   ff=0;  end
if nargin<2,   v='x'; end
if isempty(v), v='x'; end
if ~ischar(v), ff=v; v='x'; end
v=v(1);
p=mmpsim(p);
n=length(p);
if ff		% put in factored form
   K=p(1); Ka=abs(K); p=p/K;
   if abs(K-1)<1e-8
      pp='';pe='';
   elseif abs(K+1)<1e-4
      pp='-(';pe=')';
   elseif abs(Ka-round(Ka))<=1e-5*Ka
      pp=sprintf('%d*(',K); pe=')';
   else
      pp=sprintf('%.4g*(',K); pe=')';
   end
else		% not factored form
   K=p(1);
   pe='';
   if abs(K-1)<1e-8, pp='';
   else              pp=sprintf('%.4g',K);
   end
end
if n==1  % zero order polynomial case
   s=sprintf('%.4g',K);
   return
end
s=[pp v sprintf('^%.0f ',n-1)];
for i=2:n-1
   if p(i)<0,           pm='- ';  else, pm='+ ';                      end
   if abs(p(i)-1)<1e-8, pp='';    else, pp=sprintf('%.4g',abs(p(i))); end
   
   s=[s pm pp v sprintf('^%d ',n-i)];
end
if p(n)~=0,  pp=sprintf('%.4g',abs(p(n)));    else, pp=''; end
if p(n)<0,   pm='- '; elseif p(n)>0, pm='+ '; else, pm=''; end
s=[s pm pp pe];
