function [xn,Pn]=mmrwls(y,A,w,x,P)
%MMRWLS Recursive Weighted Least Squares. (MM)
% [x,P]=MMRWLS(y,A,W) computes the weighted least squares solution x
% that minimizes (y-Ax)'*diag(W)*(y-Ax). The weighting vector W must
% have a length equal to y, or be a scalar in which case all equations
% are given the scalar weight. If not given, W=ones(size(y)). W(i) is
% the weight given to the i(th) row of Ax=y. If requested, the matrix P
% contains information for optional future recursive calls.
%
% [x,P]=MMRWLS(x0,W) initializes a recursive solution by returning the
% initial solution x=x0 having a scalar weight 0<W<=1. If W is not given,
% W=1e-6 is used.
%
% [xn,Pn]=MMRWLS(yn,An,Wn,x,P) computes the recursive weighted least squares
% solution xn, given new equations yn=An*x, where Wn is the weighting vector
% associated with the new data, and x and P are the output from the previous
% function call. If not given, Wn=ones(size(yn)). Pn is the updated P matrix.
%
% See also MMRWPFIT, OPS.

% Reference: "Modern Control Theory", W.L. Brogan,
% Quantum Publishers, Inc., 1974

% Duane Hanselman and J.J. Miranda, University of Maine, Orono, ME,  04469
% 5/18/96, revised 8/1/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

if nargin==1                     % initialize recursive solution
   xn=y(:);
   Pn=diag(1e6+zeros(size(xn)));
elseif nargin==2 & length(A)==1  % initialize recursive solution
   A=abs(A);
   if A<=eps | A>1, error('W Must be Between 0 and 1.'), end
   xn=y(:);
   Pn=diag((1/A)+zeros(size(xn)));
elseif nargin<4                  % nonrecursive call
   y=y(:); % make sure y is a column
   if length(y)~=size(A,1), error('y not the right size for A.'), end
   if nargin==2, w=ones(size(y)); end  % default weight
   w=w(:); % make sure w is a column
   if any(w<eps), error('Weights Must be Positive.'), end
   if length(w)==1, w=repmat(w,size(y)); end  % expand scalar weight
   if size(A,1)<size(A,2), error('Not Enough Equations to Find Solution.'), end
   if length(w)~=length(y), error('y and W Not The Same Length.'), end
   wA=w(:,ones(1,size(A,2))).*A;  % weight rows according to w
   xn=wA\(w.*y);  % compute initial solution
   
   if nargout>1  % compute P
      Pn=inv(A'*wA);
   end
else         % recursive call
   y=y(:); % make sure y is a column
   if length(y)~=size(A,1), error('y Not The Right Size For A.'), end	
   if nargin==4, P=x; x=w; w=ones(size(y)); end  % default weight
   if size(P,1)~=size(P,2), error('P Not Square.'), end
   if length(x)~=size(P,2), error('x and P Not Conformable.'), end
   x=x(:); % make sure x is a column
   w=w(:); % make sure w is a column
   if any(w<eps), error('Weights Must be Positive.'), end
   if length(w)==1, w=repmat(w,size(y)); end  % expand scalar weight
   if length(w)~=length(y), error('yn and Wn Not The Same Length.'), end
   
   K=P*A'/(A*P*A'+diag(1./w));
   xn=x+K*(y-A*x);
   if nargout>1  % compute new P
      Pn=P-K*A*P;
   end
end
