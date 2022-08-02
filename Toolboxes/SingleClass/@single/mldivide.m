%Right matrix divide.
%
%    Leutenegger Marcel © 17.2.2005
%
function o=mldivide(s,t)
if isempty(t)
   o=[];
else
   if prod(size(s)) == 1
      o=s.\t;
   else
      o=single(double(s)\double(t));
   end
end
