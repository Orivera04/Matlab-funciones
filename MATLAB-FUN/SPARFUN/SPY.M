function spy(S,arg2,arg3);
%SPY   	Visualize the sparsity structure.
% 	SPY(S) plots the sparsity pattern of any matrix S.
%	SPY(S,color) uses the specified marker color instead of yellow.
%	SPY(S,marksize) uses the specified marker size instead of
%	a size which depends upon the figure size and the matrix order.
%	SPY(S,color,marksize) and SPY(S,marksize,color) are allowed.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

color = 'y';
marksize = 0;
if nargin >= 2
   if isstr(arg2), color = arg2; else, marksize = arg2; end
end
if nargin >= 3
   if isstr(arg3), color = arg3; else, marksize = arg3; end
end

[m,n] = size(S);
[i,j] = find(S);
nz = length(i);
if nz > 0
    h = plot(j,i,[color '.']);
    if marksize == 0
       units = get(gca,'units');
       set(gca,'units','points');
       pos = get(gca,'position');
       marksize = max(1,min(15,round(3*min(pos(3:4))/max(m,n))));
       set(gca,'units',units);
    end
    set(h,'markersize',marksize);
else
    if ~ishold, plot([],[],'.'), end
    if m > 0
        text((n+1)/2,(m+1)/2,'0');
    else
        m = eps; n = eps;
        text((n+1)/2,(m+1)/2,'Empty');
    end
end
xlabel(['nz = ' int2str(nz)]);
if ~ishold
    axis('ij')
    axis([0 n+1 0 m+1]);
    set(gca,'aspect',[n/m,1])
end
