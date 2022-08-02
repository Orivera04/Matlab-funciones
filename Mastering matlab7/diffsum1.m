% diffsum1.m
% compute differential sum along a given dimension

x = cat(3,hankel([3 1 6 -1]),pascal(4)) % data to test
dim = 1  % dimension to work along

xsiz = size(x)
xdim = ndims(x)

tmp = repmat({':'},1,xdim) % cells of ':'
c1 = tmp;
c1{dim} = 1:xsiz(dim)-1    % poke in 1:end-1
c2 = tmp;
c2(dim) = {2:xsiz(dim)}    % poke in 2:end

y = x(c1{:})+x(c2{:})