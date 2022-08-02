function a=cell2num(c)
%CELL2NUM Convert cell array into numeric array.
%   A = CELL2NUM(C) converts the cell array C into a array by
%   placing each element of C into a separate element.  A will
%   be the same size as C.
%
%   CELL2NUM does not work for cell arrays within cell arrays.

%   B. Rasmus Anthin 2001-04-12
%   Originated from NUM2CELL by Clay M. Thompson

error(nargchk(1,1,nargin))

if isempty(c), a = []; return, end
dims = ndims(c)+1;

% Size of input array
siz = [size(c),ones(1,max(dims)-ndims(c))];

% Create remaining dimensions vector
rdims = 1:max(ndims(c),max(dims));
rdims(dims) = []; % Remaining dims

% Size of extracted subarray
bsize = siz;
bsize(rdims) = 1; % Set remaining dimensions to 1

% Size of output matrix
asize = siz;
asize(dims) = 1; % Set selected dimensions to 1
a = ones(asize);

% Permute C so that requested dims are the first few dimensions
c = permute(c,[dims rdims]); 

% Make offset and index into c
offset = prod(bsize);
ndx = 1:prod(bsize);
for i=0:prod(asize)-1,
  a(i+1) = reshape(c{ndx+i*offset},bsize);
end