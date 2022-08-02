 % Black-Scholes Equation
 % One underlying asset
 % Explicit time with projection
 sig =.4
 r = .08;
 n = 100 ;
 maxk = 1000; 
 f = 0.0;
 T = .5;
 dt = T/maxk; 
 L = 2.;
 dx = L/n;
 alpha =.5*sig*sig*dt/(dx*dx);
 sur = zeros(maxk+1,1);
 % Define the payoff obstacle
for i = 1:n+1
	x(i) = dx*(i-1);
	u(i,1) = max(1.0 - x(i),0.0);
	suro(i) = u(i,1);
end
u(1,1:maxk+1)   = 1.0;% left BC
u(n+1,1:maxk+1) = 0.0;% right BC
% Use the explicit discretization
for k = 1:maxk
	for i = 2:n
		u(i,k+1) = dt*f+...
				x(i)*x(i)*alpha*(u(i-1,k)+ u(i+1,k)-2.*u(i,k))+ ...
				u(i,k)*(1 -r*dt) - ...
				r*x(i)*dt/dx*(u(i,k)-u(i+1,k));
                if (u(i,k+1)<suro(i)) % projection step
			         u(i,k+1) = suro(i);
		        end
		if ((u(i,k+1)>suro(i)) & (u(i,k)==suro(i))) 
			sur(i) = (k+.5)*dt;
		end
	end 
end 
figure(1)
 plot(20*dx:dx:60*dx,sur(20:60))
 figure(2)
 %mesh(u)
 %plot(x,u(:,201),x,u(:,401),x,u(:,601),x,u(:,maxk+1))
 plot(x,u(:,maxk+1))
 xlabel('underlying asset')
 ylabel('value of option')
 title('American Put Option')
 

