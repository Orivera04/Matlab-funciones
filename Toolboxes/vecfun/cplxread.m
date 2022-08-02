function str=cplxread(c)
%CPLXREAD  Translate complex number to string.

% Copyright (c) 2001-04-23, B. Rasmus Anthin

str='';sgn='';
if real(c)
   str=num2str(real(c));
   sgn='+';
end
if imag(c)==1
   str=[str sgn 'i'];
elseif imag(c)==-1
   str=[str '-i'];
elseif imag(c)>0
   str=[str sgn num2str(imag(c)) 'i'];
elseif imag(c)
   str=[str num2str(imag(c)) 'i'];
else
   str=num2str(c);
end