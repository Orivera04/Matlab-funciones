%Smallest positive floating point number.
%
%    Leutenegger Marcel © 17.2.2005
%
function o=realmin(s)
o=pow2(ones(s),-126);
