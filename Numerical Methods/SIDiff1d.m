    clear;
    % This code is for susceptible/infected population.
    % The infected may disperse in 1D via Fick's law.
    % Newton's method is used.
    % The full Jacobian matrix is defined.
    % The linear steps are solved by A\d.
    sus0 = 50.;
    inf0  = 0.;
    a =20/50;
    b = 1;
    D = 10000;
		n = 20;
        nn = 2*n+2;
        maxk = 80;
        L = 900;
		dx = L./n;
        x = dx*(0:n);
        T = 3;
        dt = T/maxk;
        alpha = D*dt/(dx*dx);
		FP = zeros(nn);
		F  = zeros(nn,1);
		sus  = ones(n+1,1)*sus0; % define initial populations
        sus(1:3) = 2;
        susp = sus;
        inf   = ones(n+1,1)*inf0;
        inf(1:3) = 48;
        infp = inf;
        for k = 1:10  % begin time steps 
            u = [susp; infp]; % begin Newton iteration
		    for m =1:20
			    for i = 1:nn %compute Jacobian matrix 
				    if i>=1&i<=n+1
					    F(i) = sus(i) - susp(i) + dt*a*sus(i)*inf(i);
				    	FP(i,i) = 1 + dt*a*inf(i);
					    FP(i,i+n+1) = dt*a*sus(i);
                    end
				    if i==n+2
                       F(i) = inf(1) - infp(1) + b*dt*inf(1) -...
                           alpha*2*(-inf(1) + inf(2)) - a*dt*sus(1)*inf(1);
                       FP(i,i) = 1+b*dt + alpha*2 - a*dt*sus(1);
                       FP(i,i+1) = -2*alpha;
                       FP(i,1) = -a*dt*inf(1);
				    end
                    if i>n+2&i<nn
                        i_shift = i - (n+1);
                        F(i) = inf(i_shift) - infp(i_shift) + b*dt*inf(i_shift) - ...
                            alpha*(inf(i_shift-1) - 2*inf(i_shift) + inf(i_shift+1)) - ...
                            a*dt*sus(i_shift)*inf(i_shift);
                        FP(i,i) = 1+b*dt + alpha*2 - a*dt*sus(i_shift);
                        FP(i,i-1) = -alpha;
                        FP(i,i+1) = -alpha;
                        FP(i, i_shift) = - a*dt*inf(i_shift);
                    end
                    if i==nn
                        F(i) = inf(n+1) - infp(n+1) + b*dt*inf(n+1) - ...
                            alpha*2*(-inf(n+1) + inf(n)) - a*dt*sus(n+1)*inf(n+1);
                        FP(i,i) = 1+b*dt + alpha*2 - a*dt*sus(n+1);
                        FP(i,i-1) = -2*alpha;
                        FP(i,n+1) = -a*dt*inf(n+1);
                    end
			    end
			    du = FP\F;% solve linear system
			    u  = u - du;
                sus(1:n+1) = u(1:n+1);
                inf(1:n+1) = u(n+2:nn);
			    error = norm(F);
			    if error<.00001
				    break;
			    end
            end   % Newton iterations
       time(k) = k*dt;
       time(k)
       m
       error
       susp = sus;
       infp = inf;
       sustime(:,k) = sus(:);
       inftime(:,k)  = inf(:);
       axis([0 900 0 60]);
       hold on;
       plot(x,sus,x,inf)
       pause
  end  %time step
  hold off
  figure(2);
  plot(time,sustime(10,:),time,inftime(10,:)) 
     
     
