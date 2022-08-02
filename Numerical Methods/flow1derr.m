% Pollutant in a stream
%           u_t =  - vell u_x - dec u.
% u(x,t) represents the concentration of pollutant.
% Theupwind finite difference and Lax-Wendroff methods are used
% This code illustrates discretization error for these two methods.
% Vary the number of time and space steps and record the downstream errors.
% 
% Input Data
%
clear; clf(figure(1)); clf(figure(2));
flag = 0;           % flag = 0 uses upwind finite difference method.
                    % flag = 1 uses Lax-Wendroff method.
if flag == 0
    disp('Upwind Finite Difference Method')
else
    disp('Lax-Wendroff method')
end 
T     = 20.;        % time duration
maxk  = 1600;       % number of time steps
dt    = T/maxk;     % length of time step
L     = 1.0;        % length of steam
n     = 160.;       % number of space steps
dx    = L/n;        % length of space step
vel   = 0.1;        % velocity of stream
dec   = 0.1;        % decay rate of pollutant
p = vel*dt/dx;
u = zeros(n+1,maxk+1);
%  Initial concentration
for i = 1:n+1
	x(i)   = (i-1)*dx;
	u(i,1) = sin(pi*x(i)*2);
end
%  Upstream concentration
for k = 1:maxk+1
	time(k) = (k-1)*dt;
	u(1,k)  = sin(-pi*vel*time(k)*2)*exp(-dec*time(k));
end
%
%  Execute the methods and compute errors
%
%  Time Loop
for k = 1:maxk
    %  Space Loop
    if flag == 0    
        for i = 2:n+1;      % uses upwind finite difference
            u(i,k+1) = (1 - vel*dt/dx - dec*dt)*u(i,k) ...
                            + vel*dt/dx*u(i-1,k);
            error(i,k+1) = abs(sin(pi*(x(i) - vel*time(k))*2)*...
                                      exp(-dec*time(k)) - u(i,k));
        end
    else
        for i = 2:n+1;      % uses  Lax-Wendroff
            if i < n+1
                u(i,k+1) = u(i,k)*(1 - p^2) + u(i-1,k)*(p/2 + (p^2)/2)...
                          + u(i+1,k)*(-p/2 + (p^2)/2)...
                          - dt*dec*u(i,k) - .5*u(i-1,k)*dt^2*vel*dec/dx...
                          + .5*u(i+1,k)*dt^2*dec*vel/dx...
                          + u(i,k)*dt^2*dec^2/2;
            end  
            if i == n+1
                u(i,k+1) = (1 - vel*dt/dx - dec*dt)*u(i,k)... 
                          + vel*dt/dx*u(i-1,k);    
            end
            error(i,k+1) = abs(sin(pi*(x(i) - vel*time(k))*2)*...
                                      exp(-dec*time(k)) - u(i,k));
        end   
    end
end
%
%  Output
%
max(error(n,1:maxk))  % observe error for FDM = O(dt + dx)
                      % Observe error for L-W = O(dt^2 + dx^2)
figure(1)
mesh(x,time,u')
figure(2)
for k = 1:1:maxk
    plot(x,u(:,k))
    axis([0 L -1.0 1.0]);
    title(['Concentration at Time = ' num2str(time(k))])
    pause
end   