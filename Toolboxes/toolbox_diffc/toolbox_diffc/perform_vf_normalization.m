function vf = perform_vf_normalization(vf)

% perform_vf_normalization - renormalize a vf.
%
%   vf = perform_vf_normalization(vf);
%
%   Copyright (c) 2004 Gabriel Peyr?


d = sqrt( sum(vf.^2,3) );
d(d<1e-6) = 1;
vf = prod_vf_sf(vf,1./d);