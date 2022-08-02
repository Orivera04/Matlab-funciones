%  Variation on MATLAB code written by Curt Vogel, Dept of Mathematical Sciences,
%  Montana State University, for Chapter 8 of the SIAM Textbook,
%  "Computational Methods for Inverse Problems".
%
%  Use Picard fixed point iteration to solve
%    grad(T(u)) = K'*(K*u-d) + alpha*L(u)*u  = 0.
%  At each iteration solve for newu = u+du
%    (K'*K + alpha*L(u)) * newu = K'*d,
%  where 
%    L(u) = grad(J(u)) =( D'* diag(psi'(|[D*u]_i|^2,beta) * D * dx
  Setup1d % Defines true image and distorts it
  alpha = .030 % Regularization parameter alpha 
  beta = .01 %TV smoothing parameter beta 
  fp_iter = 30; % Number of fixed point iterations 
  %  Set up discretization of first derivative operator.
  D = zeros(n-1,n);
   for i =1:n-1
       D(i,i) = -1./h;
       D(i,i+1) = 1./h;
   end;
  %  Initialization.
  dx = 1 / n;
  u_fp = zeros(n,1);
  for k = 1:fp_iter
    Du_sq = (D*u_fp).^2;
    L = D' * diag(psi_prime(Du_sq,beta)) * D * dx;
    H = K'*K + alpha*L;
    g = -H*u_fp + K'*d;
    du = H \ g;
    u_fp = u_fp + du;
    du_norm = norm(du)
   % Plot solution at each Picard step
    figure(1)
     subplot(1,2,2) 
      plot( x,u_fp,'-')
      xlabel('x axis')
      title('TV Regularized Solution (-)')
      pause;
      drawnow  
  end  %  for fp_iter  
  plot(x,f_true,'--', x,u_fp,'-')
  xlabel('x axis')
  title('TV Regularized Solution (-)')