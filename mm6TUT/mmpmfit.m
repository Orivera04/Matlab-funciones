function P=mmpmfit(x,y,n)
%MMPMFIT Polynomial Matrix Curve Fitting. (MM)
% P=MMPMFIT(x,Y,N) where x is a vector and Y is a matrix
% having as many rows as x(:), returns a matrix P of
% polynomials of order N, with the (i)th row of P being
% the polynomial associated with the (i)th column of Y.
% Use MMPMVAL to evaluate the polynomials.
%
% MMPMFIT vectorizes the following:
%  for j=1:size(Y,2)
%    P(j,:)=polyfit(x,Y(:,j));
%  end
%
% See also MMP2PM, MMPM2P, MMPMDER, MMPMINT, MMPMSEL, MMPMEVAL.

% Duane Hanselman, University of Maine, Orono, ME,  04469
% 5/22/96, revised 7/7/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

x=x(:);
nx=length(x);
[ry,cy]=size(y);
if nx~=ry
   error('length(x) and Rows of Y not the Same.')
end

V(:,n+1)=ones(nx,1);  % Build Vandermonde matrix.
for j=n:-1:1
   V(:,j) = x.*V(:,j+1);
end
P=(V\y).';  % one equation does them all!
