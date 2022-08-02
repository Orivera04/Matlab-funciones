function s = compute_cuvilinear_abscice(c)

% compute_cuvilinear_abscice - compute the curvilinear abscice of a curve
%
%   s = compute_cuvilinear_abscice(c);
%
%   A curve is a 2 x npts matrix.
%
%   Copyright (c) 2004 Gabriel Peyré


npts = size(c,2);
D = c(:,2:end)-c(:,1:(end-1));
s = zeros(npts,1);
s(2:end) = sqrt( D(1,:).^2 + D(2,:).^2 );
s = cumsum(s);