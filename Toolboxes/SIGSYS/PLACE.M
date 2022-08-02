function K = place(A,B,P)
%PLACE	K = place(A,B,P)  computes the state feedback matrix K such that
%	the eigenvalues of  A-B*K  are those specified in vector P.
%	The complex eigenvalues in the vector P must appear in consecu-
%	tive complex conjugate pairs. No eigenvalue may be placed with
%	multiplicity greater than the number of inputs.  
%
%	The  displayed "ndigits" is an  estimate of how well the
%	eigenvalues were placed.   The value seems to give an estimate
%	of how many decimal digits in the eigenvalues of A-B*K match
%	the specified numbers given in the array P.
%
%	A warning message is printed if the nonzero closed loop poles
%	are greater than 10% from the desired locations specified in P.
%
%	See also: LQR and RLOCUS.

%	M. Wette 10-1-86
%	UCSB ECE, Santa Barbara, CA 93106, (805) 961-4691
%  	    E-mail: riccati@hub.ucsb.edu
%	Revised 9-25-87 JNL
%       Revised 8-4-92 Wes Wang
%
%  Ref::    Kautsky, Nichols, Van Dooren, "Robust Pole Assignment in Linear 
%           State Feedback," Intl. J. Control, 41(1985)5, pp 1129-1155
%

%	Copyright (c) 1986-93 by the MathWorks, Inc.

NTRY=5;         % - number of iterations for "optimization" -
%
[nx,na] = size(A);

P = P(:);
if length(P)~=nx, error('P must have the same number of states as A.'); end

[n,m] = size(B);
if (nx == 0 | n == 0), 
	error('A and B matrices cannot be empty.')
end
nx=0; i=1; while (i<=n),
    if imag(P(i))~=0.0,
        pr = [pr real(P(i))]; pi = [pi imag(P(i))];
        cmplx = [cmplx 1]; i = i+2;
    else,
        pr = [pr real(P(i))]; pi = [pi 0.0];
        cmplx = [cmplx 0]; i = i+1;
    end;
    nx = nx+1;
end;
%
m = rank(B);
% Make sure there are more inputs than repeated poles:
ps = sort(P);
for i=1:n-m
	imax = min(n,i+m);
	if all(ps(i:imax) == ps(i))
error('Can''t place poles with multiplicity greater than the number of inputs.');
	end
end
nmmp1 = n-m+1; mp1 = m+1; jj = sqrt(-1);
[Qb,Rb] = qr(B); q0 = Qb(:,1:m); q1 = Qb(:,mp1:n); Rb = Rb(1:m,:);
%
% - special case: (#inputs)==(#states) - efficient, but not clean
if (m==n),
    A = A - diag(real(P));
    i=0; for j=1:nx,
	i = i+1;
	if cmplx(j),
	    A(i,i+1) = A(i,i+1) + pi(j);
	    A(i+1,i) = A(i+1,i) - pi(j);
	    i = i+1;
	end;
    end;
    disp(sprintf('place: ndigits= %g', fix(log10(1.0/eps))))
    K = Rb\q0'*A;
    return;		% escape here!
end
%
% - compute bases for eigenvectors -
I = eye(n);
for i=1:nx,
    [Q,R] = qr(((pr(i)+jj*pi(i))*I-A)'*q1);
    Bx = [ Bx Q(:,nmmp1:n) ];
end;
%
% - choose basis set -
% at each iteration of i pick the eigenvector Xj, j~=i, 
% which is "most orthogonal" to the current eigenvector Xi
%Wes changed the following
nn=1; 
for i=1:nx, 
  X(:,i) = Bx(:,(i-1)*m+1); 
  if m>1 %check if X is a full rank matrix. If it is not, make it up
    for ii = 2:m
      nnx = nn + cmplx(i);
      Y(:,nnx) = imag(X(:,i)); %if cmplx(i)==1 take imag part, else empty action
      Y(:,nn) = real(X(:,i));
      if rank(Y) < nnx, 
        X(:,i) = Bx(:,(i-1)*m+ii); 
      else
        ii = m;
      end; % if rank(Y) < nnx, 
    end; %for ii = 2:m
    nn = nn + 1 + cmplx(i); 
  end; %if m>1
end; %for i=1:nx, 
% Wes changed the above
if (m>1),
    for k = 1:NTRY,
	for i = 1:nx,
	    S = [ X(:,1:i-1) X(:,i+1:nx) ]; S = [ S conj(S) ];
	    [Us,Ss,Vs] = svd(S);
	    Pr = Bx(:,(i-1)*m+1:i*m); Pr = Pr*Pr';
	    X(:,i) = Pr*Us(:,n); X(:,i) = X(:,i)/norm(X(:,i));
	end
    end
end
for i = 1:nx,
    if cmplx(i),
        Xf = [ Xf X(:,i) conj(X(:,i)) ];
    else,
        Xf = [ Xf X(:,i) ];
    end;
end;
cnd = cond(Xf);
if (cnd*eps >= 1.0),
    disp('place: can''t place eigenvalues there');
    return;
end
disp(sprintf('place: ndigits= %g', fix(log10(cnd/eps))))
%
% - compute feedback -
K = Rb\q0'*(A-real(Xf*diag(P,0)/Xf));

% Check results. Start by removing 0.0 pole locations
P = sort(P);
i = find(P ~= 0);
P = P(i);
Pc = sort(eig(A-B*K));
Pc = Pc(i);
if max(abs(P-Pc)./abs(P)) > .1
	disp('Warning: Pole locations are more than 10% in error.')
end
% --- last line of place ---
