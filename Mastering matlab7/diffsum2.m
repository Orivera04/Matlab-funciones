% diffsum2.m
% compute differential sum along a given dimension

x = cat(3,hankel([3 1 6 -1]),pascal(4)) % data to test
dim = 3  % dimension to work along

xsiz = size(x);
n = xsiz(dim);                 % size along desired dim
xdim = ndims(x);               % # of dimensions

perm = [dim:xdim 1:dim-1]      % put dim first
x = permute(x,perm)            % permute so dim is row dimension
x = reshape(x,n,[])  % reshape into a 2D array

y = x(1:n-1,:)+x(2:n,:)        % Differential sum along row dimension

xsiz(dim) = n-1                % new size of dim dimension
y = reshape(y,xsiz(perm))      % put result back in original form
y = ipermute(y,perm)           % inverse permute dimensions
