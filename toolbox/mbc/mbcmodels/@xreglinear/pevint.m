function [int,s]= pevint(m,lowerlim,upperlim)
%PEVINT Calculate integral of PEV
%
%  [INT, S] = PEVINT(M, LOWER, UPPER) integrates the PEV of the model in the
%  hypercube specified by the limit vectors LOWER and UPPER.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:49:54 $

n= length(lowerlim);

% PEV integrand is a polynomial of order 2*n
% => need n+1 points for Gaussian quadrature (will be exact for polys up to degree 2n+1)
nquad= get(m,'order') +1;

X= cell(1,n);
W= X;
for i=1:n
    qx=(upperlim(i)-lowerlim(i))/2;
    px=(upperlim(i)+lowerlim(i))/2;
    if abs(qx)> 1e-12
        % calculate gaussian points
        [bp,wf]=gausspoints(nquad(i));

        xlevel=qx*bp(:)+px;

        X{i}= xlevel;
        W{i}= wf* (upperlim(i)-lowerlim(i))/2;
    else
        % only one point
        X{i}= px;
        W{i}= 1;
    end
end

[PEV,x,Xg] = pevgrid(m,X,0);

p= PEV(:);
if length(W)~=1
    [wg{1:length(W)}]= ndgrid(W{:});
    Wg= ones(size(p,1),1);
    for i=1:length(wg)
        Wg(:)= Wg.*wg{i}(:);
    end
else
    Wg= W{1}(:);
end
p(:)= p.*Wg;
int=sum(p);

if nargout > 1
    % Calculate s where s is a matrix such that int= trace( (X'*X)\s )
    % It is very useful in V-optimal designs
    
    % calculate X matrix
    FX= x2fx(m,Xg);
    FX= FX(:,Terms(m));
    
    % s= X'* diag(Wg) * X;
    if size(FX,1)==1 || length(Wg)==1
        % Sparsity is unnecessary, and leads to s being sparse which causes
        % later errors
        s = FX' * diag(Wg) * FX;
    else
        %    use sparse diagonal for efficiency
        s = FX' * spdiags(Wg,0,length(Wg),length(Wg)) * FX;
    end
end


% recursive routine to evaluate integral
% obsolete now, but left in for demonstration of how it used to work

%S.type='()';
%S.subs=repmat({':'},n,1);
%int = innerfun(m,PEV,W,lowerlim,upperlim,nquad,n,S)

function int = innerfun(m,PEV,W,lowerlim,upperlim,nquad,n,S)
%usage:  int = innerfun(fun,lowerlim,upperlim,nquad,n,level,x,quadrule);


% weights for current level
wf= W{n};

% reset all
S.subs(:)={':'};

if n==1,
    % univariate integral
    int = wf*PEV(:);
else
    int = 0;
    for i=1:nquad(n),
        % subsref call on Nth dimension
        S.subs{n}= i;
        Pn= subsref(PEV,S);
        % recursive call to do N-1 integral
        int = int + wf(i) *  ...
            innerfun(m,Pn,W,lowerlim,upperlim,nquad,n-1,S);
    end
end

% scale integral
%int = int * (upperlim(n)-lowerlim(n))/2;
