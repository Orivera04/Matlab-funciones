function D = ql(A,epsilon,show)
%---------------------------------------------------------------------------
%QL   The QL method for finding eigenvalues
%     of a symmetric tridigonal matrix.
% Sample call
%   A = ql(A,epsilon,show)
% Inputs
%   A         symmetric tridigonal matrix
%   epsilon   convergence tolerance
% Return
%   D         solution: vector of eigenvalues
%
% NUMERICAL METHODS: MATLAB Programs, (c) John H. Mathews 1995
% To accompany the text:
% NUMERICAL METHODS for Mathematics, Science and Engineering, 2nd Ed, 1992
% Prentice Hall, Englewood Cliffs, New Jersey, 07632, U.S.A.
% Prentice Hall, Inc.; USA, Canada, Mexico ISBN 0-13-624990-6
% Prentice Hall, International Editions:   ISBN 0-13-625047-5
% This free software is compliments of the author.
% E-mail address:      in%"mathews@fullerton.edu"
%
% Algorithm 11.4 (Reduction to Tridiagonal Form).
% Algorithm 11.5 (The QL Method with Shifts).
% Section	11.4, Eigenvalues of Symmetric Matrices, Page 581-587
%---------------------------------------------------------------------------

if nargin==1, show = 0; end
if show==1,
  clc,disp('Currently  A = '),disp(A)
  pause(0.8);
end
[n,n] = size(A);
shift = 0;
m = 1;
cnt = 0;
for m=1:(n-2)  % Loop for eliminating super diagonal.
  cond = 0;
	 while cond==0                            % Start of inner iteration loop.
    rts =  eig(A(m:m+1,m:m+1));            % Start FindShift
    r1 = rts(1);                           % Use  eig  to find the
    r2 = rts(2);                           % eigenvalue of A(m:m+1,m:m+1) 
    sh = r1;                               % is closest to A(m,m).
    if (abs(A(m,m)-r2)<abs(A(m,m)-r1)), sh = rts(2); end
    cnt = cnt+1;
    home; if cnt==1, clc; end;
    disp(['The shift is  ',num2str(sh)])   % End of FindShift
	   if (abs(A(m,m+1))>epsilon),            % Start of form eigenvalue.
      shift = shift + sh;  
      if show==1,
        disp(''),disp(''),disp('');
      end
      A(m:n,m:n) = A(m:n,m:n) - sh*diag(ones(1,n-m+1));
	   else
	     A(m,m) = A(m,m) + shift;
      if show==1,
	       disp('The eigenvalue is '),disp(A(m,m));
      end
	     m = m+1;
	     cond = 1;
    end                                    % End of form eigenvalue.
    % Now use the Givens rotations to zero the elements.
    Q = eye(n);
      for j = n-1:-1:m,
        Xp = A(j,j+1);
        Xq = A(j+1,j+1);
        Yq = sqrt(A(j,j+1)^2 +A(j+1,j+1)^2);
        c = -Xq*Yq/(Xp^2+Xq^2);
        s = Xp*Yq/(Xp^2+Xq^2);
        R = [c s; -s c];
        A(j:j+1,:) = R*A(j:j+1,:);
        A(:,j:j+1) = A(:,j:j+1)*R';
      end                                  % End of inner iteration loop
    if show==1,
      Mx = 'QL iteration No. ';
      disp(''),disp([Mx,int2str(cnt)]),disp(''),...
	     disp('Currently  A = '),disp(A);
      pause(0.8);
    end
	 end
end
% Use  eig  to help find the last two eigenvalues.
A(m:m+1,m:m+1) = shift + diag(eig(A(m:m+1,m:m+1)));
A(n-1,n) = 0;
A(n,n-1) = 0;
if show==1,
  home;disp('');disp('');disp('');disp('');
  Mx = 'QL iteration No. ';
  disp(''),disp([Mx,int2str(cnt)]),disp(''),...
	 disp('Currently  A = '),disp(A);
  pause(0.8);
end
D = diag(A);
