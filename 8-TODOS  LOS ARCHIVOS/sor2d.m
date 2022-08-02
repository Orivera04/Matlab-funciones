function [w,soriter,u] = sor2d(n,w)
		h = 1./n;
		tol =.01*h*h;
        maxit = 500;
        c = 1.;
        usur = 70.;
		u = 200.*ones(n+1);     %initial guess and one hot boundary 
        u(n+1,:) = 70;      % cool boundaries
        u(:,1) = 70; 
        u(:,n+1) = 70;
		f = h*h*c*usur*ones(n+1);
        x =h*(0:1:n);
        y = x;
		for iter =1:maxit   % begin SOR iterations
			numi = 0;
			for j = 2:n     % loop over all unknowns
				for i = 2:n
					utemp = (f(i,j) + u(i,j-1) + ...
                             u(i-1,j)+u(i+1,j)+u(i,j+1))/(4.+h*h*c);
					utemp = (1. - w)*u(i,j) + w*utemp;
					error = abs(utemp - u(i,j));
					u(i,j) = utemp;
					if error<tol    % test each node for convergence
						numi = numi + 1;
					end
				end
			end
			if numi==(n-1)*(n-1)    % global convergence test
				break;
			end
		end
		w
        soriter = iter
        meshc(x,y,u')
