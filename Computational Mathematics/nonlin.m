    clear;
    % This code is for a nonlinear ODE.
    % Stefan radiative heat lose is modeled.
    % Newton's method is used.
    % The linear steps are solved by A\d.
    uo = 900.;
		n = 19;
		h = 1./(n+1);
		FP = zeros(n);
		F  = zeros(n,1);
		u  = ones(n,1)*uo;
        % begin Newton iteration
		for m =1:20
			for i = 1:n %compute Jacobian matrix 
				if i==1
					F(i) = fnonl(u(i))*h*h + u(i+1) - 2*u(i) + uo;
					FP(i,i) = fnonlp(u(i))*h*h - 2;
					FP(i,i+1) = 1;
				  elseif i<n
					F(i) = fnonl(u(i))*h*h + u(i+1) - 2*u(i) + u(i-1);
					FP(i,i) = fnonlp(u(i))*h*h - 2;
					FP(i,i-1) = 1;
					FP(i,i+1) = 1;
				  else
					F(i) = fnonl(u(i))*h*h - 2*u(i) + u(i-1) + uo;
					FP(i,i) = fnonlp(u(i))*h*h - 2;
					FP(i,i-1) = 1;
				end
			end
			du = FP\F;% solve linear system
			u  = u - du;
			error = norm(F)
			if error<.0001
				break;
			end
      end
      m
      error
      uu = [900 u' 900];
      x = 0:h:1;
      plot(x,uu)

