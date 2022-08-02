function y=mmpmeval(P,x,i)
%MMPMEVAL Polynomial Matrix Evaluation. (MM)
% Y=MMPMEVAL(P,x) evaluates polynomial matrix P at the values in x.
% The (j)th column of Y the evaluation of P(j,:) at x(:).
% Y(i,j) is the evaluation of the (j)th polynomial at x(i).
%
% Y=MMPMEVAL(P,x,I) evaluates the polynomials indexed by the vector I.
% The (j)th column of Y is the evaluation of P(I(j),:) and x(:).
%
% Use MMPMFIT for curve fitting.
%
% MMPMEVAL(P,x) vectorizes the following:
%  for j=1:size(P,1)
%    Y(:,j)=polyval(P(j,:),x(:));
%  end
%
% See also MMP2PM, MMPM2P, MMPMDER, MMPMFIT, MMPMINT, MMPMSEL.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 5/22/96, revised 8/16/96, 9/20/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

[rp,cp]=size(P);
if nargin==2, i=1:rp; end
ilen=length(i);
if any(i<1|i>rp)
	error('I Contains Indices Outside the Rows of P.')
end
P=P(i,:).';  % keep only selected polynomials and transpose
x=x(:);      % make x a column vector
nx=length(x);
y=zeros(nx,ilen);
xm=x(:,ones(1,ilen)); % Tony's trick to make x a matrix
t=ones(nx,1);
for i=1:cp  % Horner's method applied to all chosen polys at once
	p=P(i,:);
	y=xm.*y + p(t,:);
end
