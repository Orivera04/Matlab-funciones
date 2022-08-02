function Knu = cbesselk(nu,x)
%  -----   Calculate gamma function with a complex order   ----


if isreal(nu)
    Knu = besselk(nu,x);
else 
%     Knu = 0.5*pi*i^(nu+1)*(cbesselj(nu,i*x)+i*cbessely(nu, i*x));
    Knu = 0.5*pi*(cbesseli(-nu, x)-cbesseli(nu,x))/sin(pi*nu);
end
Knu = Knu(:);