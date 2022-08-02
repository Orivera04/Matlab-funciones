function [Q,R,OK,df,varargout]= qrdecomp(m,J)
%QRDECOMP QR decompostion for least squares
%
%  [Q,R,OK,df, Ri] = QRDECOMP(X)
%  Inputs
%    m  model
%    J  jacobian
%  Outputs
%    Q,R economised qr decomposition of QR=J , R square upper triangular
%        note this is adjusted for lambda and type of least squares (e.g.
%        ridge, rols)
%    OK rank check on R (J)
%    df degrees of freedom
%    Ri is defined as factorisation of  Ri*Ri'= (R'*R)\J'*J/(R'*R)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:49:57 $

if isempty(J)
    df= size(J,1);
    Q=zeros(df,0);
    R= [];
    OK=df>0;
    varargout= cell(1,nargout-4);
else
    switch m.qr
        case 'ols'
            [Q,R,OK,df,varargout{1:nargout-4}]= qr_ols(m,J);
        case 'ridge'
            [Q,R,OK,df,varargout{1:nargout-4}]= qr_ridge(m,J);
        case 'rols'
            [Q,R,OK,df,varargout{1:nargout-4}]= qr_rols(m,J);
        otherwise
            [Q,R,OK,df,varargout{1:nargout-4}]= feval(['qr_',m.qr],m,J);
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% QR decomposition for Ordinary Least Squares
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Q,R,OK,df, Ri]= qr_ols(m,X)

[Q,R,OK]= xregqr(X);

df = size(Q,1)-size(R,1);

if nargout > 4
    if OK
        Ri = inv(R);
    else
        Ri = [];
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% QR decomposition for ROLS
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Q,R,OK,df,Ri]= qr_rols(m,J)

if numel(m.lambda)==1
    lam= m.lambda;
else% local rols
    termsin = Terms(m);
    if any(termsin)
        lam= m.lambda(termsin);
        lam= lam(:);
    else
        lam = 0;
    end
end


n = size(J,2);

% use normalised qr decomposition
[Q,R,OK]= xregqr(J);
dB= diag(R);
W= Q*sparse(1:n,1:n,dB,n,n);
B= sparse(1:n,1:n,1./dB,n,n)*R;

% W is not orthonormal
dw= (sum(W.*W,1))';
dwlam= sqrt(lam+dw);
%OK=  rstats(1)==n && ~any(dwlam < max(dwlam)*n*eps);


% normalise to get Q,R equivalents so b= R\(Q'*y) and H= sum(Q.*Q,2)
% note Q'*Q ~= I
Q= W*sparse(1:n,1:n,1./dwlam,n,n);
R= sparse(1:n,1:n,dwlam,n,n)*B;
if ~OK
    df=0;
    Ri=[];
    return
end


df = size(J,1) - sum(dw./(dw+lam));% N - gamma

if nargout > 4
    if OK
        % inverse calculation for PEV and std(b) = Ri*Ri'
        Ri = B\sparse(1:n,1:n,sqrt(dw)./(lam+dw),n,n);
    else
        Ri = [];
    end
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% QR decomposition for RIDGE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [Q,R,OK,df,Ri]= qr_ridge(m,J)

if numel(m.lambda)==1
    sqrtlam= sqrt(m.lambda)*eye(size(J,2));
else % local ridge
    termsin = Terms(m);
    if any(termsin)
        sqrtlam= diag(sqrt(m.lambda(termsin)));
    else
        sqrtlam = eye(size(J,2));
    end
end

OK=size(J,1)>=size(J,2);
if OK

    % augmented J
    Ja = [J; sqrtlam];

    % apply Q, R to the augmented matrix
    [Q,R,OK]= xregqr(Ja);
    Q= Q(1:size(J,1),:);

    dq = sum(Q.*Q,2);
    df = size(J,1) - sum(dq);

    if nargout > 4
        if OK
            Ri = R\Q';
        else
            Ri = [];
        end
    end
else
    Q=[];
    R=[];
    df=0;
    Ri=[];
end
