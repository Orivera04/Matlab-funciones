function [R,Q]= xregrdel(R,j,Q)
%XREGRDEL delete column from triangular factorisation using Given's rotation
% 
% [R1,Q1]= xregrdel(R,j,Q)
% uses 
%  [R1,Q1]= xregrdel(R,j,Q) is equivalent to qrdelete(Q,R,j,'col') and works for economy qr
%  [R1,Rinv1]= xregrdel(R,j,inv(R)) need to remove jth row of Rinv1 manually


%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
% $Revision: 1.2.6.1 $  $Date: 2004/02/09 08:02:29 $


[m,n]= size(R);
if nargin<3
    Q=zeros(0,m);
end

[mq,nq]= size(Q);
if m~=n
    error('R must be square.')
elseif (nq ~= m)
    error('Inner matrix dimensions of QR factors must agree.')
elseif j <= 0
    error('Deletion index must be positive.')
elseif (j > n)
    error('Deletion index exceeds matrix dimensions.')
end
% Remove the j-th column.  n = number of columns in modified R.
% R(:,j) = [];
% [m,n] = size(R);

% R now has nonzeros below the diagonal in columns j through n.
%    R = [x | x x x         [x x x x
%         0 | x x x          0 * * x
%         0 | + x x    G     0 0 * *
%         0 | 0 + x   --->   0 0 0 *
%         0 | 0 0 +          0 0 0 0
%         0 | 0 0 0]         0 0 0 0]
% Use Givens rotations to zero the +'s, one at a time, from left to right.

[Q,R]= mx_planerot(Q,R,j);
% R= R(1:end-1,:);
