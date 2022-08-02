function Inu = cbesseli(nu,x)
%  -----   Calculate gamma function with a complex order   ----

if isreal(nu)
    Inu = besseli(nu,x);
else    
    Inu = (i)^(-nu)*cbesselj(nu,i*x);
end
Inu =Inu(:);