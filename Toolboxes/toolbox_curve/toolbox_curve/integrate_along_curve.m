function val = integrate_along_curve(c_list, M)

% integrate_along_curve - Integrate a 2D function along a 2D curve.
%
%   val = integrate_along_curve(c_list, M);
%
%   The curve is assumed to be in [0,1]²
%
%   Copyright (c) 2004 Gabriel Peyré

if ~iscell(c_list)
    c_list = {c_list};
end

n = size(M,1);
nb = length(c_list);
val = zeros(nb,1);
for i=1:nb
    c = c_list{i};   
    % compute the integral of the function allong the curve
    cs = c*(n-1) + 1;   % scale to [1,n]
    cs = round(cs);
    I = find( cs(1,:)>0 & cs(1,:)<n+1 & cs(2,:)>0 & cs(2,:)<n+1 );   % crop 
    cs = cs(:,I);
    J = sub2ind(size(M), cs(1,:),cs(2,:) );
    val(i) = sum(M(J));
end