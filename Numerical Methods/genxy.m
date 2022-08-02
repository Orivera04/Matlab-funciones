
function [x,y] = genxy(n,nx,ny)
% A = 1.;
% B = 2.;
% dtheta = pi/(4*ny-4);
% ii = 0;
% for j = 1:ny
    % theta = (j-1)*dtheta;
    % dr = (B/cos(theta)-A)/(nx-1);
    % for i=1:nx
        % r = A + (i-1)*dr;
        % ii = ii+1;
        % x(ii) = r*cos(theta);
        % y(ii) = r*sin(theta);
    % end
% end
% 
 L = 4;
 H = 2;
 dtau = 1/(ny-1);
 dx =  L/(nx-1);
ii = 0;
for j = 1:ny
    tau = (j-1)*dtau;
    for i=1:nx
        ii = ii+1;
        x(ii) = (i-1)*dx;
        y(ii) = exp(-(x(ii)-L)^2) + tau*(H - exp(-(x(ii)-L)^2));;
    end
end
