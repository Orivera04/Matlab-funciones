function [PEV,X,Xg,Y]= pevgrid(TS,x,Natural,varargin)
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

%  $Revision: 1.2.2.3 $  $Date: 2004/02/09 08:00:08 $

if nargin<=2
    Natural=1;
end

xtemp=x;
if Natural
    for i=1:length(x);
        % do the coding on each entry individually as this is
        % computationally much cheaper
        x{i}= code(TS,x{i}(:),i);
    end
end

nl= nlfactors(TS);
cs= cellfun('prodofsize',x);

if any(cs(1:nl)>1)
    % Local factor grid

    len= cellfun('prodofsize',x);
    IT2= nl>1 & ~all(InputFactorTypes(TS.Local)==1);
    if IT2
        len(2:nl)= 1;
    end
    [PEV,Y,Xg,Xl]= i_LocalGrid(TS,x,Natural,varargin{:});
    if nargout>1
        % make sure local covariates have dimension of 1
        if IT2
            [xtemp{2:nl}]=deal(0);
        end
        if length(x)>1
            % Generate N-D grid for evaluation
            [X{1:length(x)}]=ndgrid(xtemp{:});
        else
            X=x;
        end
        % Change into NxNg table
        Xcol= zeros(prod(size(X{1})),length(X));
        for i=1:length(X)
            Xcol(:,i)= X{i}(:);
        end

        if IT2
            % fills out other local (cpfactors
            Xcol(:,2:nl)= repmat(Xl(:,2:nl),size(Xg,1),1);
            for i=2:nl
                X{i}= reshape(Xcol(:,i),size(X{i}));
            end
        end
        Xg= Xcol;
    end
else
    if length(x)>1
        % Generate N-D grid for evaluation
        [X{1:length(x)}]=ndgrid(x{:});
    else
        X=x;
    end

    % Change into NxNg table
    Xg= zeros(prod(size(X{1})),length(X));
    len= zeros(1,length(x));
    for i=1:length(X)
        Xg(:,i)= X{i}(:);
        len(i)= length(x{i});
    end

    [PEV,Y]= pev(TS,Xg,0,varargin{:});


    if nargout>1 && Natural
        if length(x)>1
            % Generate N-D grid for evaluation
            [X{1:length(x)}]=ndgrid(xtemp{:});
        else
            X=xtemp;
        end
    end

end

% reshape table
if length(len)>1
    PEV= reshape(full(PEV),len);
    if nargout>3
        Y= reshape(Y,len);
    end
end



function [P,Y,Xg,Xl] = i_LocalGrid(TS,x,Natural,varargin)

nl= nlfactors(TS);
nf= nfactors(TS);

if length(x)>nl+1
    % Generate N-D grid for evaluation
    [XG{1:nf-nl}]=ndgrid(x{nl+1:end});
else
    XG= x(nl+1);
end
Xg= zeros(prod(size(XG{1})),length(XG));
for i=1:length(XG)
    Xg(:,i)= XG{i}(:);
end

IT2= nl>1 & ~all(InputFactorTypes(TS.Local)==1);

if nl==1 || IT2
    Xl= zeros(length(x{1}),nl);
    for i= 1:nl
        Xl(:,i)= x{i}(:);
    end
else
    [XL{1:nl}] = ndgrid(x{1:nl});
    Xl= zeros(prod(size(XL{1})),nl);
    for i= 1:nl
        Xl(:,i)= XL{i}(:);
    end
end

[P,Y]= pev(TS,{Xl,Xg},0,varargin{:});
