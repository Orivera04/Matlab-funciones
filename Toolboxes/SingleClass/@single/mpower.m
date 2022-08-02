%Matrix power.
%
%  Leutenegger Marcel © 17.2.2005
%
function o=mpower(s,t)
if isempty(s) | isempty(t)
   o=[];
else
   o=single(double(s)^double(t));
end
