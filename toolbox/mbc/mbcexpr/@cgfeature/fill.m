function [om,OK, msg]=fill(SF)
%FILL Creates an OptimMgr for filling the feature
%
% [om, OK, msg] = fill(SF)
% [SF, cost, OK, msg] = run(om, SF, x0)
%
% The feature must have a model defined.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.7.2.3 $  $Date: 2004/02/09 07:10:34 $

OK = 0;
om = [];
msg = '';

if isempty(SF.modelexpr)
    msg = 'Model not defined.';
    return
end

if isempty(SF.eqexpr)
    msg = 'Equation not defined.';
    return
end

sfname = getname(SF);
sfom = contextimplementation(xregoptmgr,SF,@i_fill,[],['Fill ' sfname],@fill);

% get all the table pointers and any feature pointers 
SFptrs = getptrsnomod(SF);
subSFptrs = [];
TabPtrs = [];
for i = 1:length(SFptrs)
    if istable(SFptrs(i).info)
        TabPtrs = [TabPtrs SFptrs(i)];
    elseif   isfeature(SFptrs(i).info)
        subSFptrs = [subSFptrs SFptrs(i)];
    end   
end   

% find all ptrs in all subSFs
tmpPtrs = [];
for i = 1:length(subSFptrs)
    tmpPtrs = [tmpPtrs; subSFptrs(i).getptrs];
end 

% indices to tables not in a subSF
[junk, ind] = setdiff(double(TabPtrs),double(tmpPtrs));
% only use tables at the top level
TabPtrs = TabPtrs(ind);

NumTables = length(TabPtrs);
if NumTables == 0
    msg = 'There are no tables in this feature.';
    return
end

order = 0;
PtrsCreated = [];
% create the suboptimMgrs for the tables
for i =1:NumTables 
    % create the breakpoint fill optmgr
    [tablebpom{i},success, bpmsg]=bpfillthenopt(TabPtrs(i).info, SF);
    if ~success
        msg = bpmsg;
        freeptr(PtrsCreated);
        return
    end

    % solve the expression to isolate each table 
    [tab, tableexpr, problem, NewPtrs]   = solve(SF,[], TabPtrs(i));
    PtrsCreated = [PtrsCreated NewPtrs]; 
    if ~problem % add to the list
        % get the om for the fill routine
        [tableom{i},success, tablemsg] = fill(TabPtrs(i).info, tableexpr); 
        if ~success
            msg = ['Problem creating options manager for filling ' TabPtrs(i).getname '.' tablemsg];
            freeptr(PtrsCreated);
            return
        end   
    else 
        % get the om for the optimise routine
        [tableom{i},success, optmsg] = opt(TabPtrs(i).info, SF);
        if ~success
            msg = ['Problem creating options manager for optimizing ' TabPtrs(i).getname '.' optmsg];
            freeptr(PtrsCreated);
            return
        end   
    end

    % option removed as there are already enable options on bpopt and bpfill submanagers of bpoptthenfill
    %tablebpom{i} = AddOption(tablebpom{i},'Enable',1,'boolean');
    sfom = AddOption(sfom,['FillBPthenOpt_' TabPtrs(i).getname],tablebpom{i},'xregoptmgr',['Breakpoints of ' TabPtrs(i).getname]);
    tableom{i} = AddOption(tableom{i},'Enable',1,'boolean');
    sfom = AddOption(sfom,['Fill_' TabPtrs(i).getname],tableom{i},'xregoptmgr',['Values of ' TabPtrs(i).getname]);
end

fillorderstr ='[';
for i =1:NumTables
    fillorderstr = [fillorderstr num2str(i) ' '];
end
fillorderstr = [fillorderstr ']'];
sfom = AddOption(sfom,'TableFillOrder',fillorderstr,'evalstr', 'Table fill order');

% create the suboptimMgrs for the features
for i =1:length(subSFptrs)
    [subSFom,success,sfmsg]=fill(subSFptrs(i).info);
    if ~success
        msg = ['Problem creating options manager for filling ' subSFptrs(i).getname '. ' sfmsg];
        freeptr(PtrsCreated);
        return
    else 
        subSFom = AddOption(subSFom,'Enable',1,'boolean');
        sfom = AddOption(sfom,['Fill_' subSFptrs(i).getname],subSFom,'xregoptmgr', subSFptrs(i).getname);
    end   
end

freeptr(PtrsCreated);
om = sfom;
OK = 1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [SF,cost,OK, msg]=i_fill(SF,om,x0)
%  Inputs:
%				SF - Feature object
%				om - Feature OptimMgr 
%				x0 - starting value (unused)

% Outputs 
%			   SF - new feature object

cost = Inf;
OK = 0;
msg = '';

% get all the table pointers and features
SFptrs = getptrsnomod(SF);
TabPtrs = [];
subSFptrs = [];
for i = 1:length(SFptrs)
    if istable(SFptrs(i).info)
        TabPtrs = [TabPtrs SFptrs(i)];
    elseif   isfeature(SFptrs(i).info)
        subSFptrs = [subSFptrs SFptrs(i)];   
    end   
end   

% fill each feature first
for  i = 1:length(subSFptrs)
    omsubSF{i} = get(om,['Fill_' subSFptrs(i).getname]);
    flag = get(omsubSF{i},'Enable');
    if flag
        [subSFptrs(i).info,cost,success, runmsg]= run(omsubSF{i},subSFptrs(i).info,[]);
        if ~success
            msg = ['Error encountered in filling Feature' num2str(i) '. ' runmsg];
            return
        end  
    end
end

% find all ptrs in all SFs
tmpPtrs = [];
for i = 1:length(subSFptrs)
    tmpPtrs = [tmpPtrs; subSFptrs(i).getptrs];
end 

% indices to tables not in a SF
[junk, ind] = setdiff(double(TabPtrs),double(tmpPtrs));
% only use tables at the top level
TabPtrs = TabPtrs(ind);

NumTables = length(TabPtrs);
if NumTables == 0
    msg = 'There are no tables to fill in this feature';
    return
end   

% check the fillorder is valid
fillorderstr = get(om, 'TableFillOrder');
try
    fillOrder = eval(fillorderstr{1});
catch
    fillOrder = eval(fillorderstr{2});
    msgbox(['Invalid expression for TableFillOrder - using default ',fillorderstr{2}])
end
if ~isnumeric(fillOrder) | any(fillOrder ~= fix(fillOrder)) | any(fillOrder < 1)
    msg = 'TableFillOrder must be a vector of positive integers.';
    return
end
if any(fillOrder > NumTables) 
    msg = 'The entries in TableFillOrder cannot exceed the number of tables in feature.';
    return
end

% get the tables to be autofilled in the order of filling
AutoTabPtrs = TabPtrs(fillOrder); % find the tables to be filled

NumAutoTables = length(AutoTabPtrs);
PtrsCreated = [];

for i= 1:NumAutoTables
    % breakpoint filling 
    bpinitomTable = get(om,['FillBPthenOpt_' TabPtrs(fillOrder(i)).getname]);
    % fill the breakpoints
    [AutoTabPtrs(i).info, cost, success, runmsg] = run(bpinitomTable, AutoTabPtrs(i).info, [], SF);
    if ~success
        msg= ['Error encountered in filling the breakpoints in '  AutoTabPtrs(i).getname '. ' runmsg] ;
        return
    end       

    % table filling
    omTable = get(om,['Fill_' TabPtrs(fillOrder(i)).getname]);
    flag = get(omTable, 'Enable');
    if flag
        % solve the feature for the table
        [tab, tableexpr, problem, NewPtrs]   = solve(SF,[],AutoTabPtrs(i));
        PtrsCreated = [PtrsCreated NewPtrs];
        if ~problem % run the fill
            [AutoTabPtrs(i).info,cost,success, runmsg]= run(omTable,AutoTabPtrs(i).info,[],tableexpr);
            if ~success
                msg = ['Problem filling table ' AutoTabPtrs(i).getname '. ' runmsg];
                freeptr(PtrsCreated);
                return
            end  
        else % run the fill by optimisation
            edH = errordlg(['Problem filling table "' AutoTabPtrs(i).getname '" so values optimized instead.'], 'Feature Fill Message', 'modal');
            drawnow; uiwait(edH); drawnow; % drawnows added to make sure dlg is drawn correctly.
            [AutoTabPtrs(i).info, cost, success, runmsg]= run(omTable,AutoTabPtrs(i).info,[],SF, AutoTabPtrs(i));
            if ~success
                msg = ['Problem optimizing table ' AutoTabPtrs(i).getname '. ' runmsg];
                freeptr(PtrsCreated);
                return
            end  
        end  
    end
end   

freeptr(PtrsCreated);
cost = Inf;
OK = 1;

