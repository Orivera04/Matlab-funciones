function Exprs = pr_makeProjectDisplay(Exprs,opptr,nd,IL,opt)
% Exprs = pr_makeProjectDisplay(Exprs,opptr,node,opt)
%
% 1 x x x  = build parents of exprlist and list of vectors
% x 1 x x  = check evaluation of exprlist and dataset
% x x 1 x  = build icon list

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.5.2.3 $  $Date: 2004/02/09 08:22:35 $

if nargin<5
    opt = Exprs.recalc;
end

do_exprlist = (opt(1)~=0);
do_checkeval = (opt(2)~=0);
do_buildgui = (opt(3)~=0);

if do_exprlist
    % Search project for all pointers;
    %  build up list of node pointers; get parent list for each ptr.
    %
    %  This stuff may not change between calls, so preserve a copy
    %  (building the parent list may take some time)
    
    Exprs = i_GetListStuff(Exprs,nd);
end

if do_checkeval
    % Check evaluation of everything in project.
    %  Only need to check this when something has changed
    [check,need] = check_eval(opptr.info,Exprs.Eptrs,Exprs.Eparents);
    Exprs.Echeck = check;
    Exprs.Eneed = need;
end

if do_buildgui
    % Build up list of names, icons, types, infos, for display.
    % This one will change more frequently.
    Exprs = i_DoDisplay(Exprs,opptr,IL);
end

Exprs.UnitFilter = junit;
Exprs.plot_index = [];
Exprs.recalc = [0 0 0 0];



%-----------------------------------------------------------------------
function Exprs = i_GetListStuff(Exprs,nd)
%-----------------------------------------------------------------------
% Get list of everything in project
[ndlist,ptrlist] = i_GetList(nd);

objarray = infoarray(ptrlist);
nms = cell(size(objarray));
prnts = cell(size(objarray));
for n = 1:length(objarray)
    nms{n} = getname(objarray{n});
    prnts{n} = getsource(objarray{n});
end
Exprs.Enames = nms;
Exprs.Eparents = prnts;
Exprs.Eptrs = ptrlist;
Exprs.ENptrs = ndlist;

    
%-----------------------------------------------------------------------
function [ndlist,ptrlist] = i_GetList(nd)
%-----------------------------------------------------------------------
pr = project(nd);

% Get dd stuff
ptrlist = getvars(pr, 'nonconstant');
ndlist = repmat(getdd(pr), size(ptrlist));

% Get everything else in the project
E = infoarray(children(pr));
for n = 1:length(E)
    if isa(E{n},'cgcontainer')
        this = getdata(E{n});
        if isa(this,'xregpointer') && this.isdsvariable
            ndlist = [ndlist address(E{n})];
            ptrlist = [ptrlist this];
        end
    end
end
[unused,idx] = unique(double(ptrlist));
ptrlist = ptrlist(idx);
ndlist = ndlist(idx);



%-----------------------------------------------------------------------
function Exprs = i_DoDisplay(Exprs,opptr,IL)
%-----------------------------------------------------------------------
% Combine project and dataset into one list
Exprs = i_CombineDSandPR(Exprs,opptr);
% Get some useful flags
flags = i_getFlags(Exprs,opptr);

inds = struct('outind',[],'dsind',[],'prind',[],'featureind',[],'ErrPtrs',[],'ddind',[]);
infostr = cell(1, length(Exprs.ptrs));
icons = zeros(1, length(Exprs.ptrs));
typestr = infostr;

hoppt = opptr.info;

% Items that are only in the dataset will have no associated project node
DSonly = ~flags.nvalid;
for n = find(DSonly)
    [icons(n), typestr{n}, infostr{n}, inds] = ...
        i_DatasetOnly(n, IL, Exprs, hoppt, inds, flags); 
end

% Create information for items in the project
[icons(flags.nvalid), typestr(flags.nvalid), infostr(flags.nvalid), inds] = ...
    i_Project(find(flags.nvalid), IL, Exprs, hoppt, inds, flags);

inds.dsind = find(Exprs.factor_index>0);

% Check for: overwrite and link (these override normal icons)
typeicons = icons;
for n = inds.dsind
    if flags.overwrites(Exprs.factor_index(n))
        if flags.valid(n) && ~flags.indd(n)
            typestr{n} = ['Data set overwrites ' typestr{n}];
            typeicons(n) = bmp2ind(IL,'cgdsoverwrite.bmp');
        end
    end
    if flags.islink(Exprs.factor_index(n))
        typeicons(n) = bmp2ind(IL,'cglink.bmp');
        linkptr = getlink(hoppt, Exprs.factor_index(n));
        typestr{n} = ['Linked to ' linkptr.getname];
    end
end

Exprs.infos = infostr;
Exprs.tpicons = icons;
Exprs.icons = typeicons;
Exprs.types = typestr;
Exprs.units = cell(size(typestr));
Exprs.unitchar = repmat({''}, size(typestr));
Exprs.FilterIndex = {inds.prind inds.outind inds.featureind inds.dsind inds.ddind};
Exprs.ErrPtrs = inds.ErrPtrs;


%-----------------------------------------------------------------------
function Exprs = i_CombineDSandPR(Exprs,opptr)
%-----------------------------------------------------------------------
% Combine project expression list with factors;
%  Remove repeated ptrs.
%------ dataset
[o_check,o_need,o_parents] = check_eval(opptr.info);
ptrlist = opptr.get('ptrlist');

% Build up the main lists of ptrs, nodeptrs, names, parents, eval status
[keep,opnptr,Exprs.Emap] = i_CheckRepeats(Exprs.Eptrs,Exprs.ENptrs,ptrlist);

[in_i,out_i] = getFactorTypes(opptr.info);
seen = [in_i out_i];
factors = opptr.get('factors');

Exprs.ptrs = [ptrlist(seen) Exprs.Eptrs(keep)];
Exprs.Nptrs = [opnptr(seen) Exprs.ENptrs(keep)];
Exprs.names = [factors(seen) Exprs.Enames(keep)];
Exprs.parents = [o_parents(seen) Exprs.Eparents(keep)];
Exprs.eval = [o_check(seen) Exprs.Echeck(keep)];
Exprs.need_ptrs = [o_need(seen) Exprs.Eneed(keep)];
% mark expressions which are factors
Exprs.factor_index = [seen zeros(1,length(keep))];
Exprs.shown_factors = zeros(1,length(ptrlist));
Exprs.shown_factors(seen) = 1:length(seen);

% Set up the blank fields to be filled with display stuff
Exprs.infos = [];
Exprs.icons = [];
Exprs.tpicons = [];
Exprs.types = [];
Exprs.units = [];
Exprs.unitchar = [];

%-----------------------------------------------------------------------
function [keep,nptr,map] = i_CheckRepeats(Eptrs,Nptrs,ptrlist)
%-----------------------------------------------------------------------
% Remove ptrs which are in dataset from expression list.
%  Build node list for factors, by matching with project ptr.
keep = find(~ismember(Eptrs,ptrlist));
map = zeros(1,length(Eptrs));
map(keep) = length(ptrlist) + (1:length(keep));

% Get nodes for each dataset pointer
nptr = null(xregpointer, size(ptrlist));
[hasnode, nodeidx] = ismember(ptrlist, Eptrs);
nptr(hasnode) = Nptrs(nodeidx(hasnode));


%-----------------------------------------------------------------------
function flags = i_getFlags(Exprs,opptr)
%-----------------------------------------------------------------------
flags = [];
% Get some useful flags for each factor
hoppt = opptr.info;
flags.overwrites = get(hoppt, 'isoverwrite');
flags.opunits = get(hoppt, 'units');
flags.islink = isLink(hoppt);
[flags.isinput,flags.isoutput,flags.isignored] = getIsFactorType(hoppt);

% And for everything
if isempty(Exprs.ptrs)
    flags.valid= [];
    flags.nvalid = [];
else
    flags.valid = isvalid(Exprs.ptrs);
    flags.nvalid = isvalid(Exprs.Nptrs);
end

flags.indd = zeros(1,length(flags.valid));
indd = pveceval(Exprs.ptrs(flags.valid), @isddvariable);
flags.indd(flags.valid) = [indd{:}];

flags.modeltype = cgtypes.cgmodeltype;
flags.featuretype = cgtypes.cgfeaturetype;



%-----------------------------------------------------------------------
function [icon,type,info,inds] = i_DatasetOnly(idx,IL,Exprs,hoppt,inds,flags)
%-----------------------------------------------------------------------

fact_i =  Exprs.factor_index(idx);
info = '';
% Only in dataset; not in project
if flags.valid(idx)
    if isUniqueToDataset(hoppt, fact_i)
        [iserr, pL, pR] = i_isErrorExpr(Exprs.ptrs(idx));
        if iserr
            inds.ErrPtrs = [inds.ErrPtrs; i double([pL pR])];
            icon = bmp2ind(IL,'cgdserror.bmp');
            info = Exprs.ptrs(idx).char;
        else
            icon = bmp2ind(IL,'cgdatasetnode.bmp');
        end
    else
        % Does not have a node; but created from Cage.
        %  Something gone wrong!
        info = '** Not in project **';
        icon = bmp2ind(IL,'cross.bmp');
    end
elseif flags.isignored(fact_i)
    icon = bmp2ind(IL,'cgdsignore.bmp');
else
    icon = bmp2ind(IL,'cgdatasetnode.bmp');
end
if flags.isinput(fact_i)
    type = 'Data set Input';
    info = 'Unassigned';
elseif flags.isoutput(fact_i)
    type = 'Data Set';
    inds.outind = [inds.outind idx];
else
    type = 'X  Ignored';
end

% ------ info about required inputs
if ~Exprs.eval(idx) 
    if ~isempty(Exprs.need_ptrs{idx})
        info = i_InputsRequired('Inputs required', Exprs.need_ptrs{idx});
    end
end


%------------------------------------------------------------------
function [iserr,l,r] = i_isErrorExpr(ptr)
%------------------------------------------------------------------
iserr = false; l = []; r = [];
hObj = ptr.info;
if isa(hObj, 'cgsubexpr')
    l = get(hObj, 'left');
    r = get(hObj, 'right');
    if length(l)==1 && isvalid(l) && length(r)==1 && isvalid(r)
        iserr = true;
    end
end
    


%-----------------------------------------------------------------------
function [icons,types,infos,inds] = i_Project(idx,IL,Exprs,hoppt,inds,flags)
%-----------------------------------------------------------------------

iconfiles = pveceval(Exprs.ptrs(idx), @iconfile);
icons = zeros(size(iconfiles));
for n = 1:length(iconfiles)
    icons(n) = bmp2ind(IL, iconfiles{n});
end

types = pveceval(Exprs.ptrs(idx), @get, 'type');

infos = repmat({''}, size(idx));
inDS = Exprs.factor_index(idx)>0;
infos(inDS) = {'In data set'};
infos(~Exprs.eval(idx) & flags.indd(idx) & inDS) = {'No data assigned to variable'};
infos(~Exprs.eval(idx) & flags.indd(idx) & ~inDS) = {'Not in data set'};
gen_requirements = (~Exprs.eval(idx) & ~flags.indd(idx));
for n = find(gen_requirements)
    infos{n} = i_InputsRequired('Inputs required', Exprs.need_ptrs{idx(n)});
end


inds.prind = [inds.prind idx];
inds.ddind = [inds.ddind idx(logical(flags.indd(idx)))];
inds.outind = [inds.outind idx(~flags.indd(idx))];

ismodel = pveceval(Exprs.ptrs(idx), @isa, 'cgmodexpr');
isfeature = pveceval(Exprs.ptrs(idx), @isa, 'cgfeature');
inds.featureind = [inds.featureind,  idx([ismodel{:}] & [isfeature{:}])];



%-----------------------------------------------------------------------
function str = i_InputsRequired(str1,ptrs)
%-----------------------------------------------------------------------
if length(ptrs)
    names = pveceval(ptrs, @getname);
    str = [str1, ': ', sprintf('%s, ', names{:})];
    str = str(1:end-2);  
else
    str = [str1, ': none'];
end
