%  Setup.m
%
%  Generate atmospheric image data.

%  Generate object.

  %nfx = input(' Object size nx = ');
  nfx = 100;
  nfy = nfx;
  h = 2/(nfx-1);
  x = [-1:h:1]';
  [X,Y] = meshgrid(x);
  R = sqrt(X.^2 + Y.^2);
  f1 = (R<.25);
  f2 = (-.2<X-Y) & (X-Y<.2) & (-1.4<X+Y) & (X+Y<1.4);
  f3 = (-.2<X+Y) & (X+Y<.2) & (-1.4<X-Y) & (X-Y<1.4);
  panel = f2.*(1-f1) + f3.*(1-f1);
  f4 = (-.25<X) & (X<.25) & (0<Y) & (Y<.5);
  f5 = (sqrt(X.^2+(Y-.5).^2) < .25);
  body = .5*f1 + (f4.*(1-f1) + f5.*(1-f4));
  body_support = (body>0);
  f_true = .75*panel + body.*(1-panel);
  f_true = f_true';
  c_f = 1e4;
  f_true = c_f * f_true;
  
%  Generate pupil mask.

  nx = 128;
  ny = nx;
  icen = nx/2 + 1;  % Pupil is centered at icen. 
  ix = [1:nx]' - icen;
  iy = [1:ny]' - icen;
  [iX,iY] = meshgrid(ix,iy);
  R = nx/2;
  r = sqrt(iX.^2 + iY.^2) / R;
  pupil = (.1 < r & r < .5);

%  Generate phase screen.

  L0m2 = 1e-4 / R;
  c_phi = 3e2;
  indx = [0:nx/2, ceil(nx/2)-1:-1:1]';
  [indx1,indx2] = meshgrid(indx,indx');
  randn('state',0);   %  Reset random number generator to initial state.
  phi = real(ifft2( (sqrt(indx1.^2+indx2.^2).^2 + L0m2).^(-11/12) .* ...
      fft2(randn(nx,ny)) ));
  phi = phi - mean(phi(:));
  phi = c_phi * phi .* pupil;
  
%  Generate point spread function.

  fprintf(' ... generating image data ...\n');
  imath = sqrt(-1);
  H = fftshift( pupil.*exp(imath*phi));
  psf = abs(ifft2(H)).^2;
  k_hat = fft2(psf);
  
%  Generate simulated data. Convolve object with PSF's and add error.

  dat = integral_op( f_true, k_hat);
  %error_percnt = input(' Percent data error = ');
  error_percnt = .1
  stdev = .01 * error_percnt * norm(dat(:)) / sqrt(nx*ny);
  dat = dat + stdev*randn(nx,ny);
  
%  Display data.

  figure(1)
    subplot(221)
      imagesc(f_true), colorbar
      title('Object')
    subplot(222)
      imagesc(dat(1:nfx,1:nfy)), colorbar
      title('Image')
    