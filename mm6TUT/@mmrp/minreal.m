function r=minreal(r,tol)
%MINREAL Pole-Zero Cancelation for Rational Polynomial Objects. (MM)
% MINREAL(R) returns the minimal realization of the rational polynomial
% object R.
% MINREAL(R,TOL) specifies a relative tolerance for cancelation.
% The default value for TOL is 10^-5.

% D.C. Hanselman, University of Maine, Orono ME,  04469
% 3/27/98
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==1
	tol=1e-5;
else
	tol=max(abs(tol),10*eps);
end
tol0=sqrt(eps);

[z,p]=roots(r);
nz=length(z);
zm=ones(nz,1);
for i=1:nz
	if abs(z(i)>tol0)
		TOL=tol*abs(z(i));
	else
		TOL=tol;
	end
	match=find(abs(p-z(i))<=TOL);
	if ~isempty(match)
		p(match(1))=[]; % throw out matching pole
		zm(i)=0; % flag zero for elimination
	end
end
z=z(logical(zm));
r.n=r.n(1)*poly(z);
r.d=r.d(1)*poly(p);
	
