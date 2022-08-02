    clear;
    % This code is for susceptible/infected population.
    % The infected may disperse  in 2D via Fick's law.
    % Newton's method is used.
    % The Schur complement is used on the Jacobian matrix.
    % The linear solve steps use a sparse pcg.
    % Uses m-files coeff_in_laplace.m, update_bc.m and pcgssor.m
    sus0 = 50;
    inf0  = 0;
    a = 20/50;
    b = 1;
    D = 10000;
		n = 21;
        maxk = 80;
		dx = 900./(n-1);
        x =dx*(0:n);
        dy = dx;
        y = x;
        T = 3;
        dt = T/maxk;
        alpha = D*dt/(dx*dx);
        coeff_in_laplace;  % define the coefficient in laplace
		G = zeros(n+1); % equation for sus (susceptible)
		H  = zeros(n+1); % equation for inf (infected)
		sus  = ones(n+1)*sus0; % define initial populations
        sus(1:3,1:3) = 2;
        susp = sus;
        inf   = ones(n+1)*inf0;
        inf(1:3,1:3) = 48;
        infp = inf;
        for k = 1:maxk  % begin time steps 
		    for m =1:20  % begin Newton iteration
			    for j = 2:n %compute sparse Jacobian matrix  
                    for i = 2:n
                        G(i,j) = sus(i,j) - susp(i,j) + dt*a*sus(i,j)*inf(i,j);
                        H(i,j) = inf(i,j) - infp(i,j) + b*dt*inf(i,j) - ...
                            alpha*(cw(i,j)*inf(i-1,j) +ce(i,j)* inf(i+1,j)+  ...
                            cs(i,j)*inf(i,j-1)+ cn(i,j)* inf(i,j+1)-cc(i,j)*inf(i,j))- ...
                            a*dt*sus(i,j)*inf(i,j);
                        ac(i,j) = 1 + dt*b+alpha*cc(i,j)-dt*a*sus(i,j);
                        ae(i,j) = -alpha*ce(i,j);
                        aw(i,j) = -alpha*cw(i,j);
                        an(i,j) = -alpha*cn(i,j);
					    as(i,j) = -alpha*cs(i,j);
                        ac(i,j) = ac(i,j)-(dt*a*sus(i,j))*(-dt*a*inf(i,j))/(1+dt*a*inf(i,j));
                        rhs(i,j) = H(i,j) - (-dt*a*inf(i,j))*G(i,j)/(1+dt*a*inf(i,j));
                    end
                end
			    [dinf , mpcg]= pcgssor(an,as,aw,ae,ac,inf,rhs,n); % solve linear system
                dsus(2:n,2:n) = G(2:n,2:n)-(dt*a*sus(2:n,2:n)).*dinf(2:n,2:n);
                update_bc;  % update the boundary values
                sus = sus - dsus;
                inf = inf - dinf;
			    error = norm(H(2:n,2:n));
			    if error<.0001
				    break;
			    end
            end   % Newton iterations
        susp = sus;
        infp = inf;
       time(k) = k*dt;
       current_time = time(k)
       mpcg
       error
       subplot(1,2,1) 
       mesh(x,y,inf)
       title('infected')
       subplot(1,2,2)
       mesh(x,y,sus)
       title('susceptible')
       pause
  end  %time step

     
     
