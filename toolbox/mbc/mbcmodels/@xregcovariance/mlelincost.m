function [f,Beta,G,W,Li,T2] = mlelincost(cparams,c,y,X,W0,isNested)
%MLELINCOST MLE cost function for global covariance matrix with linear models
%
% [f,Beta,G,W,Li,T2] = MLELINCOST(cparams,c,y,X,W0,0)
% [f,Beta,G,W,Li,T2] = MLELINCOST(cparams,c,y,yhat,W0,1)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.4.3 $  $Date: 2004/02/09 07:46:25 $

N = size(X,1);

% covariance model for Gamma
c = update(c,cparams);

% eval covariance function Wci*Wci'= inv(cov);
Wci = choltinv(c,W0);

if nargin<6 || isNested
    % Calculate weighted residuals Wc\(y-Zb);
    X = (Wci*X);
    y = Wci*y;
    if nargout==1 && N>1000 && issparse(X)
        % use q-less sparse qr decomp for speed
        [qy,R] = qr(X,y,0);
        % scalar result so divide by N
        r = sqrt((sum(y.*y)- sum(qy.*qy))/N);
    else
        Beta = X\y;
        r = y-X*Beta;
    end
else
    r = Wci*(y-X);
    Beta = [];
end

% log likelihood function
% log(det(W)) + (y-Zb)'/W*(y-Zb)
% e= 2*log(diag(Wc)) + r.^2;
if isempty(Wci)
    wd = zeros(0,1);
else
    wd = diag(Wci);
end

f = sum( -2*log(wd) + r.^2);
% Note det(W)  = det(Wc)^2
%      det(Wc) = prod(diag(Wc)) as Wc is triangular
%      use log(prod(x)) = sum(log(x)) to avoid overflow

if nargout>1
    % don't calculate in optimisation

    % single unstructured covariance
    G = unstruct(c);

    Ng = size(G,1);

    W = cov(c,W0);

    % individual T^2 contributions
    T2 = reshape(r,Ng,length(r)/Ng);
    T2 = sum(T2.*T2,2);

    % individual likelihood contributions
    Li = reshape(-2*log(diag(Wci)) + r.^2,Ng,length(r)/Ng);
    % sum over response features
    Li = sum(Li)';
end

drawnow

