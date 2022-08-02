function  [mask,ind,ne,lr] = vicinity(b,m)

% VICINITY  Finding vicinity of specified points.
%	[MASK,IND,NE,LR] = VICINITY(B,M)  Accepts "binary"
%	vector B which is zeros except for the elements
%	whose vicinities need to be found.
%	Returns vectors MASK and IND of the same size as
%	B and vectors NE with indices of beginnings and
%	ends of vicinity ranges and LR with -1 for left
%	vicinities and 1 for right ones

%  Kirill K. Pankratov,  kirill@plume.mit.edu
%  01/30/95

ind = [0 b(:)' 0];

l = length(ind);
n = find(ind);
ln = length(n);

 % Left wing ...............
al = ones(1,l);
nd = [1 -diff(n)+1];
al(1:n(1)) = zeros(1,n(1));
al(n) = nd;
al = cumsum(al);

 % Right wing ...............
ar = ones(1,l);
nd = [1 diff(fliplr(n))+1];
ar(n(ln):l) = zeros(size(n(ln):l));
ar(fliplr(n)) = nd;
ar = fliplr(cumsum(fliplr(ar)));

 % Combine the left and right wing ...........
mask = al.*(al<=ar)+ar.*(al>ar)+ar.*(~al)+al.*(~ar);

ind = [1 0 abs(diff(diff(mask)))/2];
ind = ceil(cumsum(ind));

 % Find and zero-pad points outside the range m
nn = find(mask>m+1);
mask(nn) = zeros(size(nn));

ind = ind.*(mask>1);

mask = mask(2:l-1);
ind = ind(2:l-1);
l = l-2;

 % Now calculate indices for beginnings and ends
al = sparse(1:l,ind+1,1:l);
ne = full(max(al));
al = sparse(1:l,ind+1,l-(1:l));
ne = [l-full(max(al)); ne];
ne = ne(:,2:size(ne,2));

nn = find(ind);
if min(ind(nn))==2
  ind(nn) = ind(nn)-1;
  ne = ne(:,2:length(ne));
end

a = any(ne<1) | any(ne>=length(b));
na = find(a);
if na~=[], ne(:,na) = ne(:,na-1); end

 % Left or right
lr = -ones(1,size(ne,2));
lr = cumprod(lr)*(1-(mask(1)==1)*2);
nn = find(lr<0);
ne(:,nn) = flipud(ne(:,nn));

