function delsqshow(n,Rlist)
%DELSQSHOW	Show discrete Laplacian on various grids.
%	delsqshow(n,Rlist)
%	Rectangular grid is n-by-n.
%	Rlist is a string of letters denoting regions, taken
%	from the list 'SNLCDAHB'.  See numgrid.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

clf reset

% Grid size
if nargin < 1, n = 32; end
if nargin < 2, Rlist = 'SNLCDAHB'; end
   
% Loop over regions known to "numgrid"
for R = Rlist

    % Generate and display the grid.
    G = numgrid(R,n);
    spy(G)
    title('A finite difference grid')
    g = numgrid(R,12)
    disp('pause'), disp(' '), pause

    % Generate and display the discrete Laplacian.
    D = delsq(G);
    spy(D)
    title('The 5-point Laplacian')
    disp('pause'), disp(' '), pause

    % Number of interior points
    N = sum(G(:)>0);

    % Solve the Dirichlet boundary value problem:
    %    delsq(u) = 1 in the interior,
    %    u = 0 on the boundary.
    disp('Solving the sparse linear system ...')
    rhs = ones(N,1);
    tic
    if R == 'N'
        % For nested dissection, turn off minimum degree ordering.
        spparms('autommd',0)
        u = D\rhs;
        spparms('autommd',1)
    else
        u = D\rhs;
    end
    toc

    % Map the solution onto the grid and display it.
    U = G;
    U(G>0) = full(u(G(G>0)));
    clabel(contour(U));
    prism
    axis('square'), axis('ij')
    disp('pause'), disp(' '), pause

    colormap((cool+1)/2);
    mesh(U)
    axis([0 n 0 n 0 max(max(U))])
    axis('square'), axis('ij')
    disp('pause'), disp(' '), pause
end
