% P6_4.M Compute exp(1/3) to at least 5 decimal places
%
clear
y=(exp(1))^(1/3);	% Exact result
%
% Compute the terms  x^(n)/n!
Exp(1)=1;
err(1)=Exp(1)-y;
for n=1:10
 Exp(n+1)=Exp(n) + 1./((3^(n))*prod(1:n));	% Taylor series
 err(n+1)=(Exp(n+1)-y);		% Error after n+1 terms
	if abs(err(n+1)) < 10^(-6);
  	break
	end
end
format long			% Display complete precision
Answer=[Exp' err']; 
disp(' exp(1/3)        error');
disp(Answer)
format short