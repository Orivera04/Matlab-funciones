function B=commute(A)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% commute.m
%
% Commutation Calculator 
%
% A is a matrix of power series coefficients for a generalized linear 
% differential operator
%
% L=a_N(x)*D^N+ ... + a_1(x)*D + a_0(x)
%
% The coefficients of a_N(x) are in the first column and a_0(x) are in the last 
% column. The output matrix B contains the expansion coefficients of the
% functions b_0(x) though b_n(x) where
%
% L=D^N b_N(x)+ ... + D b_1(x) + b_0(x)
%
% The object being to move the derivative operators to the left for easy
% conversion to an integral operator
%
% Written by: Greg von Winckel - 07/01/04
% Contact: gregvw@chtm.unm.edu 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% rows = highest order coefficient term
% cols = order of differential operator
[rows,cols]=size(A);

% Monomial derivative operator
D=diag((1:rows-1),1);

B=zeros(rows,cols);

% Compute the weights
W=pascal(cols,2);

for k=2:cols
    W(k,:)=[zeros(1,k-1),W(k,1:cols-k+1)];
end

for j=1:cols
    for k=j:cols
        B(:,k)=B(:,k)+W(j,k)*D^(k-j)*A(:,j);
    end    
end






