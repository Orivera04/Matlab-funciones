  function Ku = integral_op(u,k_hat,nux,nuy)
%
%  Ku = integral_op(u,k_hat)
%
%  Use 2-D FFT's to evaluate discrete approximation to the 
%  2-D convolution integral
%
%    Ku(x,y) = \int \int k(x-x',y-y') u(x',y') dx' dy'.
%
%  k_hat is the shifted 2-D discrete Fourier transform of the 2_D 
%  kernel evaluated at node points (x_i,y_j), and then extended.
%  u is also assumed to be evaluated at node points (x_i,y_j).
%  The size of k_hat may be different that of u, due to extension.

  [nkx,nky] = size(k_hat);
  Ku = real(ifft2( ((fft2(u,nkx,nky)) .* k_hat)));
  if nargin == 4
    Ku = Ku(1:nux,1:nuy);
  end