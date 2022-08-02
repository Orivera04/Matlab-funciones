%Largest positive floating point number.
%
%    Leutenegger Marcel © 17.2.2005
%
function o=realmax(s)
o=pow2(2-eps(s),127);
