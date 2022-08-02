%Matrix or vector norm.
%
%    Leutenegger Marcel © 17.2.2005
%
function o=norm(s,t)
if nargin < 2
   t=2;
end
if ndims(s) ~= 2 | ndims(t) ~= 2
   error('Input arguments must be 2-D.');
end
if isempty(s)
   o=reshape(s,[0 0]);
   return
end
if isequal(t,'fro')
   s=s(:);
   o=sqrt(real(s'*s));
   return
end
if any(size(s) == 1)    % vector
   if isequal(t,'inf') | t == inf
      o=max(abs(s));
   elseif isequal(t,'-inf') | t == -inf
      o=min(abs(s));
   elseif ischar(t)
      error('String argument is an unknown option.');
   elseif t == 0
      o=feval(class(s),inf);
   else
      o=sum(abs(s).^t).^(1./t);
   end
else                    % matrix
   if isequal(t,'inf') | t == inf
      o=max(sum(abs(s),2));
   elseif t == 1
      o=max(sum(abs(s)));
   elseif t == 2
      o=max(svd(s));
   else
      error('The only matrix norms available are 1, 2, inf, and fro.');
   end
end
