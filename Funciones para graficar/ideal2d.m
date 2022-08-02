%   This code models flow around an obstacle.
%   SOR iterations are used to solve the system.
%   SOR parameters
    clear;
    maxm = 1000;
      eps = .01;
      ww = 1.6;
%     Flow data     
      nx = 50;
      ny = 20;
      ip = 40;
      jp = 4;
      W = 100.;
      L = 500.;
      dx = L/nx;
      rdx = 1./dx;
      rdx2 = 1./(dx*dx);
      dy = W/ny;
      rdy = 1./dy;
      rdy2 = 1./(dy*dy);
%     Define Boundary Conditions and Initial Guess           
      uo = 1.;
      for j=1:ny+1
          u(1,j) = uo*(j-1)*dy;
      end 
      for i = 2:nx+1
          u(i,ny+1) = uo*W;
      end    
      for j =1:ny
          for i = 2:nx+1
             u(i,j) = 0.;
          end
      end
      for i = 1:nx+1
          x(i) = dx*(i-1);
      end 
      for j = 1:ny+1
          y(j) = dy*(j-1);
      end
%
%     Execute SOR Algorithm
%
      unkno = (nx)*(ny-1) - (jp-1)*(nx+2-ip);
      m = 1;
      numi = 0;
     while ((numi<unkno)*(m<maxm))
         numi = 0;
%     Interior Bottom Nodes         
         for j = 2:jp   
            for i=2:ip-1
                utemp = rdx2*(u(i+1,j)+u(i-1,j));
                utemp = utemp + rdy2*(u(i,j+1)+u(i,j-1));
                utemp = utemp/(2.*rdx2 + 2.*rdy2);
                utemp = (1.-ww)*u(i,j) + ww*utemp;
                error = abs(utemp - u(i,j)); 
                u(i,j) = utemp;
                if (error<eps) 
                    numi = numi +1;
                end
            end 
         end   
%     Interior Top Nodes         
         for j = jp+1:ny   
            for i=2:nx
                utemp = rdx2*(u(i+1,j)+u(i-1,j));
                utemp = utemp + rdy2*(u(i,j+1)+u(i,j-1));
                utemp = utemp/(2.*rdx2 + 2.*rdy2);
                utemp = (1.-ww)*u(i,j) + ww*utemp;
                error = abs(utemp - u(i,j)) ;
                u(i,j) = utemp;
                if (error<eps) 
                    numi = numi +1;
                end
            end 
         end
%     Right Boundary Nodes
         i = nx+1;
         for j = jp+1:ny   
                utemp = 2*rdx2*u(i-1,j);
                utemp = utemp + rdy2*(u(i,j+1)+u(i,j-1));
                utemp = utemp/(2.*rdx2 + 2.*rdy2);
                utemp = (1.-ww)*u(i,j) + ww*utemp;
                error = abs(utemp - u(i,j)); 
                u(i,j) = utemp;
                if (error<eps) 
                    numi = numi +1;
                end
         end 
         m = m +1;
      end     
%     Output to Terminal   
      m
      ww
      figure(1)
      contour(x,y,u')
      figure(2)
      [X Y] = meshgrid(x(1:nx), y(1:ny));
      velx = diff(u,1,2)/dy;
      vely = -diff(u,1,1)/dx;
      quiver(X,Y,velx(1:nx,1:ny)',vely(1:nx,1:ny)')
      

          
