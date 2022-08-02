function [PEV,Xout,Xg,Y] = pevgrid(m,Values,Natural,varargin)
%PEVGRID Evaluate Prediction Error Variance for model over grid
%
%  PEV = evalpev(m,Values,Natural)
%    m is the model. InitStore must be called on m before this function
%    Values cell array defining grid e.g. Values = {-1:.1:1,0,-1:.1:1}
%    Natural==1 if Values is in natural units
%
%  If y data is available, PEV = x'* s*inv(X'*X) * x, otherwise PEV = x'*
%  inv(X'*X) * x.  NDGRID is used to define the grid. The shape of PEV is
%  the same as the grid shape returned by NDGRID.
%
%  See also XREGLINEAR/EVALPEV, NDGRID

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:52:51 $

if nargin<=2
    Natural=1;
end
xc= Values;
s= cellfun('prodofsize',xc);
MaxSize= min(10000,prod(s));
dimGrid = sum(s>1);

if Natural
    for i=1:length(xc);
        % do the coding on each entry individually as this is
        % computationally much cheaper
        xc{i}= code(m,xc{i}(:),i);
    end
end
n= length(xc);
IT2=  ~all(InputFactorTypes(m)==1);
if n>1

    X=Values;
    if IT2
        Xout= Values;
        % transient data dependent with time dependent outputs
        X= xc;
        MaxSize= length(X{1});
    else
        if dimGrid>1

            % Generate N-D grid for evaluation
            [X{s>1}] = ndgrid(xc{s>1});

            if nargout>1
                [Xout{s>1}] = ndgrid(Values{s>1});
            end
        else
            X= xc;
            Xout= Values;
        end
    end
else
    X= xc;
    Xout= Values;
end





Xg =zeros(MaxSize,n);
for i= find(s==1)
    % setup scalar inputs
    Xg(:,i)= xc{i};
end


if IT2
    Nevals= 1;
    PEV= zeros(numel(X{1}),1);
    if nargout>3
        Y= PEV;
    end
else
    Y = zeros(prod(s),1);
    Nevals = floor(prod(s)/MaxSize);
    PEV = zeros(prod(s),1);
    if nargout>3
        Y = PEV;
    end
end

for i= 1:Nevals
    % do evaluations in blocks of MaxSize
    ind= (MaxSize*(i-1)+1:MaxSize*i)';
    for j=find(s>1)
        % non scalar inputs
        Xg(:,j)= X{j}(ind);
    end
    if nargout>3
        [PEV(ind),Y(ind)]= pev(m,Xg,0,varargin{:});
    else
        PEV(ind)= pev(m,Xg,0,varargin{:});
    end
end
if ~IT2 && MaxSize*i<prod(s)
    % last block
    ind= (floor(prod(s)/MaxSize)*MaxSize+1:prod(s))';
    Xg= Xg(1:length(ind),:);
    for j=find(s>1)
        % non scalar inputs
        Xg(:,j)= X{j}(ind);
    end
    if nargout>3
        [PEV(ind),Y(ind)]= pev(m,Xg,0,varargin{:});
    else
        PEV(ind)= pev(m,Xg,0,varargin{:});
    end
end

% reshape table
if length(s)>1 && ~IT2
    PEV = reshape(PEV,s);
    if nargout>3
        Y = reshape(Y,s);
    end
end

if nargout>2
    [dum,d] = max(s);
    Xg = zeros(numel(X{d}),n);
    for i=1:n
        Xg(:,i) = X{i}(:);
    end
end
