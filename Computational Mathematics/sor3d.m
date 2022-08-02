clear;
% This is the SOR solution of a 3D problem.
% Assume steady state heat diffusion.
% Given temperature on the boundary.
w = 1.8;
eps = .001;
maxit = 200;
nx = 30;
ny = 30;
nz = 30;
nunk = (nx-1)*(ny-1)*(nz-1);
u = 70.*ones(nx+1,ny+1,nz+1);   % initial guess
u(1,:,:) = 200.; % hot boundary at x = 0
for iter = 1:maxit; % begin SOR
  numi = 0;
  for l = 2:nz
    for j = 2:ny
       for i = 2:nx
        temp = u(i-1,j,l) + u(i,j-1,l) + u(i,j,l-1);
        temp = (temp + u(i+1,j,l) + u(i,j+1,l) + u(i,j,l+1))/6.;
        temp = (1. - w)*u(i,j,l) + w*temp;
        error = abs(temp - u(i,j,l));
        u(i,j,l) = temp;
        if error<eps
          numi = numi + 1;
        end
      end
    end
  end
  if numi==nunk
    break
  end
end
iter   % iterations for convergence
slice(u,  [5 10 15 20],10,10)    % creates color coded 3D plot
colorbar