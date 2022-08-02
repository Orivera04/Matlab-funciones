function sszero(A,B,C,D,zmag)
%SSZERO Zeros of a state-space model.
%       sszero(A,B,C,D,maxz) computes the (transmission) zeros of the
%       state-space model (A,B,C,D).  Zeros whose magnitude is greater
%       than maxz are not returned.  If maxz is omitted, it is set to 1,000.

%  R.J. Vaccaro  1/95

if nargin==4
  maxz=1000.;
end
AA=([A B;C D]);
BB=[eye(length(A)) B*0;0*[C D]];
if length(B(1,:)) ~= length(C(:,1))
 fprintf('\nSSZERO only works for systems with equal numbers\n')
 fprintf('of inputs and outputs.\n\n')
 return
end
[AA,BB,Q,V,Z]=qz(AA,BB);
BB=diag(BB);
AA=diag(AA);
I=find(maxz*abs(BB) > abs(AA));
AA(I)./BB(I)
return
