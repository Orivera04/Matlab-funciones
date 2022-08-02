function ppi=mmppint(pp,c)
%MMPPINT Cubic Spline Integral Interpolation.
% PPI=MMPPINT(PP,C) returns the piecewise polynomial vector PPI
% describing the integral of the cubic spline described by
% the piecewise polynomial in PP and having integration constant C.

if prod(size(c))~=1
   error('C Must be a Scalar.')
end
[br,co,npy,nco]=unmkpp(pp);	            % take apart pp
sf=nco:-1:1;								      % scale factors for integration
ico=[co./sf(ones(npy,1),:) zeros(npy,1)];	% integral coefficients
nco=nco+1;									      % integral spline has higher order
ico(1,nco)=c;								      % integration constant
for k=2:npy									      % find constant terms in polynomials
	ico(k,nco)=polyval(ico(k-1,:),br(k)-br(k-1));
end
ppi=mkpp(br,ico);							      % build pp form for integral
