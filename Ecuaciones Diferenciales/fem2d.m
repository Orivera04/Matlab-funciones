clear;
%   FEM2D
%   Uses ffem2d.m, gennod.m, genxy.m, genbc1.m and genbc2.m
%   Solves -(Kux)x - (Kuy)y + Cu = f,
%       u = g1 on bdry omega1,
%       du/dn = g2 - c2 u on bdry omega2 and
%       du/dn = 0 on bdry omega3.
%   Linear shape functions and
%   assembly by elements are used.
K = 1.0;
C = 0.0;
nx = 25;
ny = 20;
n = nx*ny;
ne = (nx-1)*(ny-1)*2;
npres = 2*nx+ny-2;  % npres = nx+ny;
sm = zeros(n);
rhs = zeros(n,1);
nod = gennod(ne,nx,ny); % Generates node numbering.
[x y] = genxy(n,nx,ny); % Generates node coordinates.
[npt g1] = genbc1(npres,nx,ny); % Identifies nodes with given values.
for elt =1:ne   % Assemble the system matrix.
    for j = 1:3
        jj = nod(elt,j);
        xx(j) = x(jj);
        yy(j) = y(jj);
    end
    for i=1:3
        j = mod(i+1,3);
        if (j==0)
            j = 3;
        end
        m = mod(i+2,3);
        if (m==0)
           m = 3;
        end
        a(i) = xx(j)*yy(m) - xx(m)*yy(j);
        b(i) = yy(j) - yy(m);
        c(i) = xx(m) - xx(j);
    end
    delta = (c(3)*b(2) - c(2)*b(3))/2;
    for ir = 1:3
        for ic = 1:3
            ak = (b(ir)*b(ic)+c(ir)*c(ic))/(4*delta);
            ii = nod(elt,ir);
            jj = nod(elt,ic);
            sm(ii,jj) = sm(ii,jj) + K*ak;
            sm(ii,jj) = sm(ii,jj) + C*delta/12;
            rhs(ii) = rhs(ii) + ffem2d(xx(ic),yy(ic))*delta/12;
            if (ii==jj)
                sm(ii,jj) = sm(ii,jj) + C*delta/12;
                rhs(ii) = rhs(ii) + ffem2d(xx(ic),yy(ic))*delta/12;
            end
        end
    end
end
for i=1:npres   % Insert the given boundary conditions.
    node = npt(i);
    for k = 1:n
        sm(node,k) = 0;
    end
    sm(node,node) = 1.;
    rhs(node) = g1(i);
end
%
sol = sm\rhs;   % Solve the algebraic system.
%
count = 0;  % Put sol into 2d grid array.
for j = 1:ny
    for i = 1:nx
        count = count+1;
        xcoord(i,j) = x(count);
        ycoord(i,j) = y(count);
        u(i,j) = sol(count);
    end
end
   surfc(xcoord,ycoord,u)
%   contour(xcoord,ycoord,u)

