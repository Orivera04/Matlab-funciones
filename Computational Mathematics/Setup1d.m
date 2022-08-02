%  Variation on MATLAB code written by Curt Vogel, Dept of Mathematical Sciences,
%  Montana State University, for Chapter 1 of the SIAM Textbook,
%  "Computational Methods for Inverse Problems".
%
%  Set up a discretization of a convolution integral operator K with a 
%  Gaussian kernel. Generate a true solution and convolve it with the 
%  kernel. Then add random error to the resulting data. 
%  Set up parameters.
  clear;
  n = 100; %nunber of grid points ;
  sig = .05; % kernel width sigma 
  err_lev = 10; %inputPercent error in data
%  Set up grid.
  h = 1/n;
  x = [h/2:h:1-h/2]';
%Compute matrix K corresponding to convolution with Gaussian kernel.
C=1/sqrt(pi)/sig
for i = 1:n
    for j = 1:n
       K(i,j) = h*C* exp(-((i-j)*h)^2/(sig^2));
   end
end
%  Set up true solution f_true and data d = K*f_true + error.
  f_true = .75*(.1<x&x<=.25) +.5*(.25<x&x<=.35)...
              + .70*(.35<x&x<=.45) + .10*(.45<x&x<=.6)...
              +1.2*(.6<x&x<=.66)+1.6*(.66<x&x<=.70)+1.2*(.70<x&x<=.80)...
              +1.6*(.80<x&x<=.84)+1.2*(.84<x&x<=.90)...
              + 0.3*(.90<x&x<=1.0);
  Kf = K*f_true;
  % Define random error
  randn('state',0);
  eta = err_lev/100 * norm(Kf) * randn(n,1)/sqrt(n);
  d = Kf + eta;
%  Display the data.
  figure(1)
   subplot(1,2,1)
    %plot(x,f_true,'-', x,d,'o',x,Kf,'--')  
     plot(x,d,'o')
    xlabel('x axis')
    title('Noisy and Blurred Data')
     pause
  