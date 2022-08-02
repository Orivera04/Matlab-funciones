function M = perform_vf_integration(vf, dt,T_list, posx, posy )

% perform_vf_integration - perform a time integration of the vf
%
%   M = perform_vf_integration(vf, dt, T_list, posx, posy );
%
%   real(M(i,j,t)) is the X location of the point (posx(i),posy(j))
%       at timestep T_list(t).
%
%   The vf is assumed to be sampled at locations [1,...,n]^2 unless posx and posy are given.
%
%   The integrator is a simple explicit euler, but it is very 
%   fast thanks to vectorization.
%
%   Copyright (c) 2005 Gabriel Peyré

n = size(vf,1);
p = size(vf,2);
m = length(T_list);

if nargin<4
    posx = 1:n;
end
if nargin<5
    posy = 1:p;
end

[Y,X] = meshgrid(posy,posx);

M = zeros( length(posx),length(posy),m);

T_list = [0; sort(T_list(:))];

for i=1:m
    % compute the number of time steps
    delta = T_list(i+1)-T_list(i);
    nt = ceil(delta/dt);
    if nt>0
        DT = delta / nt;
        % perform each time step
        for k=1:nt
            dx = interp2(1:p,1:n,vf(:,:,1), Y,X );
            dy = interp2(1:p,1:n,vf(:,:,2), Y,X );
            X = clamp( X + DT*dx, 1,n );
            Y = clamp( Y + DT*dy, 1,p );
        end
    end
    % record value
    M(:,:,i) = X + 1i * Y;
end
