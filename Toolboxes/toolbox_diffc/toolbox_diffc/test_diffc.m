% test for the differential calculus toolbox
%
%   Copyright (c) 2004 Gabriel Peyr�

n = 128;
x = -1:2/(n-1):1;
[Y,X] = meshgrid(x,x);
M = Y.*X.^4 + X.*Y.^4;

M = ReadImage('Lenna');
M = M(1:n, 1:n);
% smooth a bit the image
h = build_gaussian_filter([11 11],0.1, [n n]);
M = perform_convolution(M,h);

grad = compute_grad(M);

clf;
plot_vf(grad, M);
colormap gray(256);

clf;
imagesc( compute_operator_1(M, [1,1]) );

H = compute_hessian(M);
plot_tf(H,M);

[e1,e2,l1,l2] = perform_tensor_decomp(H);