function mvp= xregcubic(order,labels)
%XREGCUBIC Multivariate cubic model object constructor
%
%  M = XREGCUBIC(ORDER, LABELS) where ORDER is the order of each factor and
%  LABELS is a cell array containing the desired term labels.
%
%  M = XREGCUBIC(SWEEPSET) creates an xregcubic model based on the given
%  sweepset.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.4.4.4 $  $Date: 2004/04/04 03:29:57 $

if nargin<1
    order=[3 3 3 3];
end

if isa(order,'sweepset')
    % Takes a guess at initial base model given a sweepset to work on.
    % This is assumed to be an xregcubic of order [3 3 3 2] if there are enough
    % independents defined.
    XNames= get(order,'Name');
    Xch= char(XNames);
    if Xch(1,2)=='_'
        % New name style (ignore 'D_','K_'
        Symbol= Xch(:,3);
    else
        % Old Name Style (use first letter)
        Symbol= Xch(:,1);
    end
    Symbol=cellstr(Symbol);
    % Default Coding
    X=double(order);
    % Defaults are for the min and max coding to be defined by the data
    MinX= num2cell(min(X));
    MaxX= num2cell(max(X));
    [g{1:size(order,2)}]=deal(inline('x'));
    code= struct('min',MinX,'max',MaxX,'g',g);
    % Redefine Order
    if size(order,2) >= 4
        order= [3 3 3 2 zeros(1,size(order,2)-4)];
    else
        order= 3*ones(1,size(order,2));
    end
    % Now recursively call xregcubic
    mvp = xregcubic(order,Symbol);
    set(mvp,'code',code);
    return
end

NewSettings= 0;
if isa(order,'struct');
    % Old structure from xreg3xspline/LOADOBJ
    [mvp,mlin]= i_Update(order);

elseif ischar(order)
    if strcmp(order,'nfactors')
        order=repmat(3,1,labels);
        mvp=xregcubic(order);
        return
    end
else

    if nargin<2
        % add extra labels: XN
        labels= cell(1,length(order));
        for n=1:length(order)
            labels{n}=sprintf('X%1d',n);
        end
        labels=labels(1:length(order));
    end

    if ~isa(labels,'cell')
        labels=cellstr(labels);
    end
    if length(order)~=length(labels)
        error('length(order) ~= length(labels)')
    end

    order=order(:)';

    mvp.reorder= [];
    mvp.N = [];

    % construct xreglinear (coeffs set to 1:len)
    mlin = xreglinear('nfactors',length(order));
    xi= xinfo(mlin);
    if isempty(xi)
        % dependent factor info
        xi= struct('Names',{labels},...
            'Units','',...
            'Symbols',{labels});
    else
        xi.Names= labels;
        xi.Symbols= labels;
    end
    mlin= xinfo(mlin,xi);


    % xregcubic Version Number
    mvp.version    = 3;
    mvp.MaxInteract= 3;

    NewSettings= 1;
end


% xregcubic Version Number
mvp.version    = 3;

mvp= class(mvp,'xregcubic',mlin);
if NewSettings
    mvp= termCount(mvp,order,mvp.MaxInteract);
end

mvp= setstatus(mvp,1,1);



% update old class structure
function [mvp,mlin]= i_Update(mvp)

mlin=xreglinear(mvp.xreglinear);
if mvp.version  < 2
    % Set up parent xreglinear
    [s,i] = sort(mvp.reorder);
    labels= mvp.labels(i);

    xi= xinfo(mlin);
    if isempty(xi)
        % dependent factor info
        xi= struct('Names',{labels},...
            'Units','',...
            'Symbols',{labels});
    else
        xi.Names= labels;
        xi.Symbols= labels;
    end
    mlin= xinfo(mlin,xi);

    mvp=mv_rmfield(mvp,'labels');
end
mvp=mv_rmfield(mvp,'xreglinear');
mvp.MaxInteract=3;
