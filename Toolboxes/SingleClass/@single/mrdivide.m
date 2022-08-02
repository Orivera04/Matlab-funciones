%Right matrix divide.
%
%    Leutenegger Marcel © 17.2.2005
%
function o=mrdivide(s,t)
if isempty(s)
   o=[];
else
   if prod(size(t)) == 1
      o=s./t;
   else
      o=single(double(s)/double(t));
   end
end
