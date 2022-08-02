function pResponses = AddResponse(T,VarName,varargin)
%ADDRESPONSE add a new response model to test plan
% 
%  Default Model   : pResponses= AddResponse(T,VarName);
%  Two-stage model : pResponses= AddResponse(T,VarName,LocalModel,GlobalModel,DatumType);
%  One-stage model : pResponses= AddResponse(T,VarName,Model,ModelType);
%
%  Inputs
%    T           : mdevtestplan object
%    VarName     : name of variable for output
%    LocalModel  : localmod object (use default if empty)
%    GlobalModel : Response Feature model object (use default if empty)
%    DatumType   : 0=None, 1=Maximum, 2=Minimum, 3=Link

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.2 $  $Date: 2004/02/09 08:06:56 $

if numstages(T)==1
    % one-stage models
    if length(varargin)>1
        error('Too many inputs'); 
    end
    G= getModel(T.DesignDev);
    m= MakeGlobalModel(G,varargin{:});
else
    % two-stage models
    if length(varargin)>5
        error('Too many inputs'); 
    end
    m= MakeTwoStage(T,varargin{:});
end

% update response name
yi= yinfo(m);
yi.Name= VarName;
m= yinfo(m,yi);

% Add model to list to be made
T.Responses= [T.Responses {m}];

nResponses= numChildren(T);
% make response models
T= MakeResponseModels(T);

if numChildren(T)>nResponses
    % return pointer to new response nodes
    pResponses= children(T,nResponses+1:numChildren(T));
else
    % return a null pointer
    pResponses = xregpointer;
end


function TS= MakeTwoStage(T,LocalModel,GlobalModel,DatumType)

L= getModel(T.DesignDev,1);
L= L{1};

if nargin>3
    set(L,'DatumType',DatumType);
else
    DatumType= get(L,'DatumType');
end

G= getModel(T.DesignDev,2);
G= G{1};
if nargin>1 && ~isempty(LocalModel);
    L= MakeLocalModel(L,LocalModel,DatumType);
end    

if nargin>2 && ~isempty(GlobalModel);
    G= MakeGlobalModel(G,GlobalModel,4);
end    

% make two-stage object
TS= xregtwostage(L,G);



function L= MakeLocalModel(L,LocalModel,DatumType)

if ischar(LocalModel)
    % make object
    LocalModel = feval(LocalModel);
end    
nf1= nfactors(L);
ud= ModelClasses(L,nf1);
for i=1:length(ud.lmgroups)
    if ~ischar(ud.lmgroups{i})
        ud.lmgroups{i}= func2str(ud.lmgroups{i});
    end
end

clsval=find(strcmp(lmgroup(LocalModel),ud.lmgroups));
if isempty(clsval)
    error('Invalid local model');
end
if nf1 ~= nfactors(LocalModel)
    if iscell(ud.classfuncs{clsval})
        LocalModel = feval(ud.classfuncs{clsval}{:});
    else
        LocalModel = feval(ud.classfuncs{clsval});
    end        
end
L= copymodel(L,LocalModel);
set(L,'DatumType',DatumType);


function G= MakeGlobalModel(G,GlobalModel,ModelType)

if nargin <3
    ModelType=0;
end

if ischar(GlobalModel)
    % make model object
    GlobalModel = feval(GlobalModel,'nfactors',nfactors(G));
end    

if nfactors(GlobalModel) ~= nfactors(G)
    % make model with correct number of inputs
    GlobalModel = feval(class(GlobalModel),'nfactors',nfactors(G));
end

G= copymodel(G,GlobalModel);

