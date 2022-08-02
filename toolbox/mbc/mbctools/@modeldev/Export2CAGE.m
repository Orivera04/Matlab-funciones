function OK = Export2CAGE(mdev,CGP,name,replace)
%Export2CAGE Export model to CAGE.
%
% Throws an error in the event of failure.  Return value is always true
%
% Export2CAGE(mdev,CGP);
% Export2CAGE(mdev,CGP,name);
% Export2CAGE(mdev,CGP,name,replace);
%  mdev        : modeldev node 
%  CGP         : CAGE project (pointer to cgproject or file name)
%  name        : Name of model node to create.  If a model with this name
%                exists in the CAGE project it can be replaced (depending
%                on the value of the next parameter).  However, if
%                a node of any other type exists with this name, or if the
%                existing model node has the wrong number of inputs, and error
%                will be thrown.
%  replace     : true if any existing model of the same name should be replaced.
%                The default is false, in which case an error is thrown if a
%                model of the same name already exists.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.1.6.4 $    $Date: 2004/04/04 03:31:42 $ 

isTempCGP= false;
OK = true;

if (nargin<2 || isempty(CGP))
    if get(cgbrowser,'GUIExists')
        % No CAGE project specified, so use the current one
        CGP= get(cgbrowser,'RootNode');
    else
        CGP = [];
    end
    if isempty(CGP)
        error('No existing CAGE session, and no CAGE project file specified.');
    end
elseif nargin>=2 && ischar(CGP)
    % CAGE file specified
    isTempCGP= true;
    try
        CGP = struct2cell( load('-mat',CGP) );
        if ~isa(CGP{1},'cgproject')
            error('Invalid CAGE Project')
        end
        CGP = address(CGP{1});
    catch
        error(lasterror); % probably 'File not found' or 'Invalid MAT file'.
    end
elseif ~isa(CGP,'xregpointer') || ~CGP.isa('cgproject')
    error('Argument is not a valid CAGE project');
end
% Otherwise valid pointer to open CAGE project specified

if nargin<4
    replace = false;
    if nargin<3
        name = varname(mdev);
    end
end

if nargin<3 || isempty(name)
    name = varname(mdev);
end

if nargin<4
    replace = false;
end

if isa(mdev,'mdev_local')
    
    % make a switch model for local nodes
    G= model( mdevtestplan(mdev) );
    [LocalMap,OK] = LocalModel(mdev,':');
    [X,Y]= getdata(mdev,'FIT');
    m = xregmodswitch(LocalMap(OK),double(X{end}(OK)),G);

    % boundary model
    conModel= BoundaryModel(mdevtestplan(mdev),m);
    ModelInfo= exportinfo(info(project(mdev)),address(mdev),{m});
    m = xregstatsmodel(m,varname(m),ModelInfo,conModel);
elseif status(mdev)
    m = MakeEXM(mdev);
    if isempty(m)
        error('No best model selected');
    end 
else
    error('Invalid export');
end


% find existing node in project
pModnode= findname(CGP.info,name);

replace= replace && ~isempty(pModnode) && pModnode.isa('cgmodelnode');
if replace
    pMod = pModnode.getdata;
    % has same number of inputs
    replace = pMod.nfactors == nfactors(m);
end


if replace
    pMod = pModnode.getdata;
    % replace model inside the cgmodexpr
    pMod.info = pMod.set('model',m);
else
    % make new model expression
    pMod= xregpointer( cgmodexpr(name,m) );
    % make new model node
    pModnode = cgnode(pMod.info,pMod,pMod,0);
    % Change above, so unique names are given to models
    addnodestoproject(CGP.info, pModnode);
    % add variables to data dictionary
    i_addvarstoDD(pMod, CGP);
end


if isTempCGP
    % delete CAGE project
    CGP.save;
    CGP.delete;
end
% otherwise, the CAGE model view may need to be refreshed by the caller


%---------------------------------------------------------------------
function i_addvarstoDD(pMod, CGP)
%---------------------------------------------------------------------

pData = getdd(CGP.info);
hData = pData.info;
pActModel = pMod.get('model');
R = range(pActModel);
[n,inputNames] = nfactors(pMod.info);
v = [];

% Generate a list of model names that we can use as an input instead of a
% variable
mdlnodes = filterbytype(CGP.info, cgtypes.cgmodeltype);
mdlnames = cell(size(mdlnodes));
mdlexpr = mdlnames;
for k = 1:length(mdlnames)
    mdlexpr{k} = getdata(mdlnodes{k});
    mdlnames{k} = getname(mdlexpr{k}.info);
end

for j = 1:n
    % First check for a model existing with this name (except for this
    % model)
    if strcmp(inputNames{j}, pMod.getname)
        mdlidx = [];
    else
        mdlidx = strmatch(inputNames{j}, mdlnames, 'exact');
    end

    if ~isempty(mdlidx)
        v = [v, mdlexpr{mdlidx}];
    else
        % Ask the variable dictionary to create an item for us
        [hData, newv, isInDD] = add(hData, inputNames{j});
        v = [v, newv];
        if ~isInDD
            newv.info = newv.setrange(R(:,j)');
            newv.info = newv.setnomvalue(mean(R(:,j)));
        else
            if ~newv.isconstant
                % Update the range of the input
                newv.info = newv.setrange(R(:,j)');
            end
        end
    end 
end
pMod.info = pMod.setinputs(v);
pData.info= hData;


