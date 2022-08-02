function [y, l] = BDF2_NEWTON(fun, t, yvec, h, var)

l = 0;
TOL = 1e-12;

% Number of Discretiziation of the beam
[S,N] = size(yvec);
S = S/2;

% Initialization of y
y = yvec(:,2);
yold = y + ones(2*S,1);

while norm(y-yold)> TOL
	yold = y;

	% Compute the gradient of the function 
	help = ones(S,1);
	GINV = spdiags([-help,2*help,-help],[-1,0,1],S,S);
	clear help;
	GINV(S,S) = 3;
	
	GDISC = -GINV;
	GDISC(1,1) = -3;
	GDISC(S,S) = -1;
	
	F = FUNC(t);
	v = S^4 * (GDISC*yold(1:S,1)) ...
			+ S^2 * (F(2)*cos(yold(1:S,1)) - F(1)*sin(yold(1:S,1)));
	GRADv = S^4*GDISC + S^2*diag(-F(2)*sin(yold(1:S,1)) - F(1)*cos(yold(1:S,1)));
	
	clear i;
	MAT = diag(exp(i*yold(1:S,1))) * GINV * diag(exp(-i*yold(1:S,1)));
	clear GINV;
	C = real(MAT);
	CINV = inv(C);
	D = imag(MAT);
	
	DMATv = spdiags([i*diag(MAT,-1).*(v(2:S)-v(1:S-1)), zeros(S-1,1),...
									 i*diag(MAT,1).*(v(1:S-1)-v(2:S)); 0 0 0],[-1,0,1],S,S);
	GRADCv = real(DMATv);
	GRADDv = imag(DMATv);
	
	w = D*v + yold(S+1:2*S).^2;
	GRADw = GRADDv + D*GRADv;
	u = CINV*w;
	
	DMATu = spdiags([i*diag(MAT,-1).*(u(2:S)-u(1:S-1)), zeros(S-1,1),...
									 i*diag(MAT,1).*(u(1:S-1)-u(2:S)); 0 0 0],[-1,0,1],S,S);
	GRADCu = real(DMATu);
	GRADDu = imag(DMATu); 
	GRADu = CINV*(GRADw - GRADCu);
	GRAD2 = GRADCv + C*GRADv + GRADDu + D*GRADu;
	JACOBIAN = [zeros(S,S), eye(S); GRAD2, 2*D*CINV*diag(yold(S+1:2*S,1))];
	
	JACINV = inv([eye(2*S) - h*12/25*JACOBIAN]);
	
	fold = feval(fun, t+h, yold, '');
	Fold = yold - 2/3*(h*fold + 2*yvec(:,2) - 0.5*yvec(:,1));
	y = yold - JACINV*Fold;
	l = l+1;
	if (l == 500) break; end;
end

return

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function F = FUNC(t)

tmp = 1.5*(sin(t))^2*(t<=pi);
F(1) = -tmp;
F(2) = tmp;