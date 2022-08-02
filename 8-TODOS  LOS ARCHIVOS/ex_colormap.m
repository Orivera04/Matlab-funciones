a = 1:64; b = a(ones(1, 10), :);
c = b(:)'; d = c(ones(1, 10), :);
image(d); colormap(gray); axis off


