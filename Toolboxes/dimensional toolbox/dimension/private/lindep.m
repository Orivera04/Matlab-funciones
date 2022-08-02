function ind = lindep(M,dim)
% LINDEP find linear dependant rows or columns
%  ind = LINDEP(M,DIM) finds lineare dependent
%  rows (DIM = 1) or columns (DIM = 2)

% Dimensional Analysis Toolbox for Matlab
% Steffen Brueckner, 2002-02-09

% check number of input arguments
msg = nargchk(1,2,nargin);
if msg
    error(msg);
end
if nargin < 2
    dim = 1;
end

if dim == 2
    M = M';
end

% create index vector
ind = zeros(size(M,1),1);

% find linear dependent rows
kk = 1;
for ii=1:size(M,1)-1
    for jj = ii+1:size(M,1)
        D = [M(ii,:) ; M(jj,:)];
        if rank(D) == 1
            ind(ii) = kk;
            ind(jj) = kk;
            kk = kk + 1;
        end
    end
end