%  Variation on MATLAB code written by Curt Vogel,
% Dept of Mathematical Sciences,
%  Montana State University, 
% for Chapter 8 of the SIAM Textbook,
%  "Computational Methods for Inverse Problems".
%
%  Use Picard fixed point iteration to solve
%    grad(T(u)) = K'*(K*u-d) + alpha*L(u)*u  = 0.
%  At each iteration solve for newu = u+du
%    (K'*K + alpha*L(u)) * newu = K'*d where 
%    L(u)  =( D'* diag(psi'(|[D*u]_i|^2,beta) * D * dx
  Setup2d % Defines true2d image and distorts it
  max_fp_iter = input(' Max. no. of fixed point iterations = ');
  max_cg_iter = input(' Max. no. of CG iterations = ');
  cg_steptol = 1e-5;
  cg_residtol = 1e-5;
  cg_out_flag = 0;  %  If flag = 1, output CG convergence info.
  reset_flag = input(' Enter 1 to reset; else enter 0: ');
  if exist('f_alpha','var')
    e_fp = [];
  end
  alpha = input(' Regularization parameter alpha = ');
  beta = input(' TV smoothing parameter beta = ');  
  %  Set up discretization of first derivative operators. 
  n = nfx;
  nsq = n^2;
  Delta_x = 1 / n;
  Delta_y = Delta_x;
  D = spdiags([-ones(n-1,1) ones(n-1,1)], [0 1], n-1,n) / Delta_x;
  I_trunc1 = spdiags(ones(n-1,1), 0, n-1,n);
  Dx1 = kron(D,I_trunc1);   %  Forward (upwind) differencing in x
  Dy1 = kron(I_trunc1,D);   %  Forward (upwind) differencing in y
  %  Initialization.
  k_hat_sq = abs(k_hat).^2;
  Kstar_d = integral_op(dat,conj(k_hat),n,n);   %  Compute K'*dat.
  f_fp = zeros(n,n);
  fp_gradnorm = [];
  snorm_vec = []; 
  for fp_iter = 1:max_fp_iter  
    %  Set up regularization operator L.
    fvec = f_fp(:);
    psi_prime1 = psi_prime((Dx1*fvec).^2 + (Dy1*fvec).^2, beta);
    Dpsi_prime1 = spdiags(psi_prime1, 0, (n-1)^2,(n-1)^2);
    L1 = Dx1' * Dpsi_prime1 * Dx1 + Dy1' * Dpsi_prime1 * Dy1;
    L = L1 * Delta_x * Delta_y;
    KstarKf = integral_op(f_fp,k_hat_sq,n,n);
   Matf_fp =KstarKf(:)+ alpha*(L*f_fp(:));
    G = Matf_fp - Kstar_d(:);
    gradnorm = norm(G);
    fp_gradnorm = [fp_gradnorm; gradnorm];  
    %  Use CG iteration to solve linear system
    % (K'*K + alpha*L)*Delta_f = r
    fprintf(' ... solving linear system using cg iteration ... \n');
    [Delf,residnormvec,stepnormvec,cgiter] = ...
      cgcrv(k_hat_sq,L,alpha,-G,max_cg_iter,cg_steptol,cg_residtol);
    Delta_f = reshape(Delf,n,n);  
    f_fp = f_fp + Delta_f;% Update Picard iteration
    snorm = norm(Delf);
    snorm_vec = [snorm_vec; snorm];
    if exist('f_alpha','var')
      e_fp = [e_fp; norm(f_fp - f_alpha,'fro')/norm(f_alpha,'fro')];
    end
    %   Output fixed point convergence information.
    fprintf(' FP iter=%3.0f, ||grad||=%6.4e, ||step||=%6.4e, nCG=%3.0f\n', ...
       fp_iter, gradnorm, snorm, cgiter);
    figure(2)
      subplot(221)
        semilogy(residnormvec/residnormvec(1),'o')
        xlabel('CG iteration')
        title('CG Relative Residual Norm')
      subplot(222)
        semilogy(stepnormvec,'o')
        xlabel('CG iteration')
        title('CG Relative Step Norm')
      subplot(223)
        semilogy([1:fp_iter],fp_gradnorm,'o-')
        xlabel('Fixed Point Iteration')
        title('Norm of FP Gradient')
      subplot(224)
        semilogy([1:fp_iter],snorm_vec,'o-')
        xlabel('Fixed Point Iteration')
        title('Norm of FP Step')
    figure(1)
    subplot(223)
      imagesc(f_fp), colorbar
      title('Restoration')
      subplot(224)
      mesh(f_fp), colorbar
      title('Restoration')
    figure(4)
      plot([1:nfx]',f_fp(ceil(nfx/2),:), [1:nfx]',f_true(ceil(nfx/2),:))
      title('Cross Section of Reconstruction')
    drawnow    
  end %for fp
  rel_soln_error = norm(f_fp(:)-f_true(:))/norm(f_true(:))








