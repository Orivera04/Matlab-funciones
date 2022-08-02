function Ynu = cbessely(nu,x)
%  -----   Calculate gamma function with a complex order   ----

if isreal(nu)
    Ynu = bessely(nu,x);
else    
    Ynu = (cbesselj(nu,x)*cos(nu*pi)-cbesselj(-nu, x))/sin(nu*pi);
end
Ynu = Ynu(:);