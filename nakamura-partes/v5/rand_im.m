% rand_im plots an image of random matrix.
% See List D.2: L_d1
% Copyright S. Nakamura, 1995 
disp('Input matrix size:')
m=input('m=  ');
n=input('n=  ');
W = ceil(64*rand(m,n));
    % Generates a m-by-n random matrix.close
colormap(hot)
set(gcf, 'NumberTitle','off','Name',...
      'rand_im: image of a random matrix')
image(W);

