function m = xregmodswitch(varargin)
%XREGMODSWITCH Model that switches between a number of different models
%
%  M = XREGMODSWITCH(ModelList,OpPoints,OpPtsXinfo);
%  M = XREGMODSWITCH('nfactors',nf);
%  M = XREGMODSWITCH(struct);
%  M = XREGMODSWITCH;

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.2 $  $Date: 2004/02/09 07:53:54 $

if nargin==1 && isstruct(varargin{1})
    % Convert loaded structure into class
    m = varargin{1};
    xm = m.xregmodel;
    m = rmfield(m, 'xregmodel');
else
    if nargin==0;
        % Default setup
        nf = 3;
        ModelList = {};
        OpPoints = [];
        xi = [];
        yi = [];
    elseif ischar(varargin{1}) && strcmp(varargin{1},'nfactors');
        % Set up model with given number of inputs
        % Models will be set later
        nf = varargin{2};
        ModelList = {};
        OpPoints = [];
        xi = [];
        yi = [];
    else
        % Input arguments ModelList,OpPoints,OpPtsXinfo
        ModelList = varargin{1};
        OpPoints = varargin{2};
        xiGlobal  = varargin{3};
        if isa(xiGlobal,'xregmodel')
            % Global model supplied
            [BndsG,gG] = getcode(xiGlobal);
            xiGlobal = xinfo(xiGlobal);
        else
            % xinfo structire supplied for operating points
            % Determine ranges from operating points
            ng = length(xiGlobal.Names);
            BndsG = [min(OpPoints,[],1) ;  max(OpPoints,[],1)]';
            Same = BndsG(:,1)==BndsG(:,2);
            BndsG(Same,2) = BndsG(Same,2)*1.1;
            BndsG(Same + BndsG(:,2)==0,2) = 1e-8;
            gG(1:ng) = {''};
        end

        if isa(ModelList{1},'xregstatsmodel')
            % this is a xregstatsmodel
            L = model(ModelList{1});
        else
            L = ModelList{1};
        end
        xi = xinfo(L);

        ng = size(OpPoints,2);
        nf = nfactors(L) + ng;

        % Combined input information
        xi.Names = [xi.Names;xiGlobal.Names];
        xi.Symbols = [xi.Symbols;xiGlobal.Symbols];
        xi.Units  = [xi.Units;xiGlobal.Units];

        % Output information
        yi = yinfo(L);
        if length(yi.Name)>1 && strcmp(yi.Name(end-1:end),'_1')
            % AllLocalModels has added a _1 to the end of the model name
            yi.Name = yi.Name(1:end-2);
        end

        % Get model ranges
        [BndsL,gL,TgtL] = getcode(L);
        Bnds = [BndsL; BndsG];
        g = [gL(:); gG(:)];
    end

    m.ModelList = ModelList;
    m.OpPoints = OpPoints;
    m.Version = 2;
    m.Tolerance = repmat(1e-3, 1, size(m.OpPoints, 2));

    xm = xregmodel('nfactors',nf);
    if ~isempty(xi)
        % Set up model info and ranges
        xm = xinfo(xm,xi);
        xm = yinfo(xm,yi);
        xm = setcode(xm,Bnds,g,Bnds);
    end
end

% Define class
m = class(m,'xregmodswitch',xm);
