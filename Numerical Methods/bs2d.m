     % program bs2d
     % Black-Scholes Equation
 % Two underlying assets
 % Explicit time with projection
     clear;
      n = 40;
      maxk = 1000;
      f = .00;
      T=.5;
      dt = T/maxk;
      L=4;
      dx = L/n;
      dy = L/n;
    sig1 = .4;
    sig2 = .4;
    rho12 = .3;
    E1 = 1;
    E2 = 1.5;
    total = E1 + E2;
    alpha1 = .5*sig1^2*dt/(dx*dx);
    alpha2 = .5*sig2^2*dt/(dy*dy);
    alpha12 = .5*sig1*sig2*rho12*dt/(2*dx*2*dy);
    r = .12;
    sur = zeros(n+1);
% Insert Initial Condition
      for j = 1:n+1
        y(j) = dy*(j-1);  
        for i = 1:n+1
          x(i) = dx*(i-1);
          %Define the payoff fucntion
          u(i,j,1) = max(E1-x(i),0.0) + max(E2-y(j),0.0);
   %      u(i,j,1) = max(total -(x(i) + y(j)),0.0);
          suro(i,j) = u(i,j,1);
        end;
      end;   
% Begin Time Steps      
      for k = 1:maxk
% Insert Boundary Conditions
       u(n+1,1,k+1) = E2;
       u(n+1,n+1,k+1) = 0.0;
       u(1,n+1,k+1) = E1 ;
       u(1,1,k+1) = total;
% Do y = 0.
       j=1;
        for i = 2:n
          u(i,j,k+1) = dt*f+x(i)*x(i)*alpha1*...
              (u(i-1,j,k) + u(i+1,j,k)-2.*u(i,j,k)) ...
                  +u(i,j,k)*(1 -r*dt)- ...
                  r*x(i)*dt/dx*(u(i,j,k)-u(i+1,j,k));                 
          if (u(i,j,k+1)<suro(i,j)) 
              u(i,j,k+1) = suro(i,j);
          end 
          if ((u(i,j,k+1)>suro(i,j))&...
              (u(i,j,k)==suro(i,j))) 
              sur(i,j)= k+.5;
          end 
        end 
% Do y = L.
       j=n+1;
        for i = 2:n
           u(i,j,k+1) = dt*f+x(i)*x(i)*alpha1*...
              (u(i-1,j,k) + u(i+1,j,k)-2.*u(i,j,k)) ...
                  +u(i,j,k)*(1 -r*dt)- ...
                  r*x(i)*dt/dx*(u(i,j,k)-u(i+1,j,k));     
          if (u(i,j,k+1)<suro(i,j)) 
              u(i,j,k+1) = suro(i,j);
          end 
          if ((u(i,j,k+1)>suro(i,j))&...
              (u(i,j,k)==suro(i,j))) 
              sur(i,j)= k+.5;
          end 
        end 
% Do x = 0.
       i=1;
        for j = 2:n
          u(i,j,k+1) = dt*f+y(j)*y(j)*alpha2*...
              (u(i,j-1,k) + u(i,j+1,k)-2.*u(i,j,k))...
                  +u(i,j,k)*(1 -r*dt)-...
                  r*y(j)*dt/dy*(u(i,j,k)-u(i,j+1,k));         
          if (u(i,j,k+1)<suro(i,j)) 
              u(i,j,k+1) = suro(i,j);
          end 
          if ((u(i,j,k+1)>suro(i,j)) &...
              (u(i,j,k)==suro(i,j))) 
              sur(i,j)= k+.5;
          end 
        end  
%Do x = L.
       i=n+1;
        for j = 2:n
          u(i,j,k+1) = dt*f+y(j)*y(j)*alpha2*...
              (u(i,j-1,k) + u(i,j+1,k)-2.*u(i,j,k))...
                  +u(i,j,k)*(1 -r*dt)-...
                  r*y(j)*dt/dy*(u(i,j,k)-u(i,j+1,k));   
          if (u(i,j,k+1)<suro(i,j)) 
              u(i,j,k+1) = suro(i,j);
          end 
          if ((u(i,j,k+1)>suro(i,j))&...
              (u(i,j,k)==suro(i,j))) 
              sur(i,j)= k+.5;
          end 
        end                
%Solve for Interior Nodes 
       for j= 2:n
        for i = 2:n
          u(i,j,k+1) = dt*f+x(i)*x(i)*alpha1*...
                  (u(i-1,j,k) + u(i+1,j,k)-2.*u(i,j,k))...
                  +u(i,j,k)*(1 -r*dt)...
                  -r*x(i)*dt/dx*(u(i,j,k)-u(i+1,j,k))...
                  +y(j)*y(j)*alpha2*...
                  (u(i,j-1,k) + u(i,j+1,k)-2.*u(i,j,k)) ...
                  - r*y(j)*dt/dy*(u(i,j,k)-u(i,j+1,k)) ...
                  +2.0*x(i)*y(j)*alpha12*...
                  (u(i+1,j+1,k)-u(i-1,j+1,k)-u(i+1,j-1,k)+u(i-1,j-1,k));
          if (u(i,j,k+1)<suro(i,j)) 
              u(i,j,k+1) = suro(i,j);
          end
          if ((u(i,j,k+1)>suro(i,j)) &...
              (u(i,j,k)==suro(i,j)))
              sur(i,j)= k+.5;
          end 
        end 
       end 
      end 
      figure(1)
      subplot(2,2,1)
      mesh(x,y,suro')
      title('Payoff Value')
      subplot(2,2,2)
      mesh(x,y,u(:,:,maxk+1)')
      title('Put Value')
      subplot(2,2,3)
      mesh(x,y,u(:,:,maxk+1)'-suro')
      title('Put Minus Payoff')
      subplot(2,2,4)
      mesh(x,y,sur'*dt)
      title('Optimal Exercise Times')
      