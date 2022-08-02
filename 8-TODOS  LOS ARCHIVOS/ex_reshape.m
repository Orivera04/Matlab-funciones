x = rand(3,4);
y=reshape(x, 2,3,2)
y = shiftdim(y,1)
det(y(:, 2, 1:2))
det(squeeze(y(2:3, 2, 1:2)))