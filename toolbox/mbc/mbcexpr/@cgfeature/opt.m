function [om,OK,msg]= opt(SF)
%OPT Optimize object
%
%  [om, OK,msg] = opt(SF)
%  [SF, cost, OK ,msg] = run(om, SF, x0)
%  Create the optimMgr for filling features.
%  The feature must have a model and an equation defined.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.6.2.3 $  $Date: 2004/02/09 07:10:51 $


if isempty(SF.modelexpr)
   OK = 0;
   msg = 'Model not defined.';
   om = [];
   return
end

if isempty(SF.eqexpr)
   OK = 0;
   msg = 'Equation not defined.';
   om = [];
   return
end

sfname = getname(SF);

om= contextimplementation(xregoptmgr,SF,@i_opt,[],['Optimize ' sfname],@opt);

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
   OK = 0;
   msg = 'There are no tables in this feature.';
   om = [];
   return
end


order = 0;
PtrsCreated = [];
% create the suboptimMgrs for the tables
for i =1:NumTables 
   % create the breakpoint fill optmgr
   [tablebpom{i},OK,msg]= bpopt(TabPtrs(i).info, SF);
   if OK
      tablebpom{i} = AddOption(tablebpom{i},'Enable',1,'boolean');
      om = AddOption(om,['OptBP_' TabPtrs(i).getname],tablebpom{i},'xregoptmgr', ['Breakpoints in ' TabPtrs(i).getname]);
   else
      om = [];
      msg = ['Problem optimizing the breakpoints of ' TabPtrs(i).getname '. ' msg ];
      return
   end
   % get the om for the optimise routine
   [tableom{i},OK, msg]= opt(TabPtrs(i).info, SF);
   if OK
       tableom{i} = AddOption(tableom{i},'Enable',1,'boolean');
       om = AddOption(om,['Opt_' TabPtrs(i).getname],tableom{i},'xregoptmgr', ['Values of ' TabPtrs(i).getname]);
    else
       om = [];
       return
   end
end

fillorderstr ='[';
for i =1:NumTables
   fillorderstr = [fillorderstr num2str(i) ' '];
end
fillorderstr = [fillorderstr ']'];
om = AddOption(om,'TableFillOrder',fillorderstr,'evalstr', 'Table optimization order');

% create the suboptimMgrs for the features
for i =1:length(subSFptrs)
   [subSFom,OK,msg]=opt(subSFptrs(i).info);
   if OK
      subSFom = AddOption(subSFom,'Enable',1,'boolean');
      om = AddOption(om,['Opt_' subSFptrs(i).getname],subSFom,'xregoptmgr',subSFptrs(i).getname);
   end   
end

OK = 1;
msg = '';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [SF,cost,OK,msg]=i_opt(SF,om,x0)

%  Inputs:
%				SF - feature object
%				om - feature OptimMgr 
%				x0 - starting value (unused)

% Outputs 
%			   SF - new feature object

% get all the table pointers and subSF
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

% fill each subSF first
for  i = 1:length(subSFptrs)
    omsubSF{i} = get(om,['Opt_' subSFptrs(i).getname]);
    sfflag = get(omsubSF{i}, 'Enable');
    if sfflag
       [subSFptrs(i).info,cost,OK, msg]= run(omsubSF{i},subSFptrs(i).info,[]);
       if ~OK
          msg = ['Error encountered in optimizing feature' num2str(i) '. ' msg];
          return
       end  
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
 OK = 0;
 msg = 'There are no tables to optimize in this Feature'; 
 cost = Inf;
 return
end   

% check the fillorder is valid
fillorderstr = get(om, 'TableFillOrder');
try
    fillOrder = eval(fillorderstr{1});
catch
	 fillOrder = eval(fillorderstr{2});
	 msgdlg(['Invalid expression for the table optimization order - using default ',fillorderstr{2}])
end
if ~isnumeric(fillOrder) | any(fillOrder ~= fix(fillOrder)) | any(fillOrder < 1)
   OK = 0;
   msg = 'Table optimization order must be a vector of positive integers.';
   return
end
if any(fillOrder > NumTables) 
   OK = 0;
   msg = 'The entries in the table optimization order cannot exceed the number of tables in feature.';
   return
end

   
omTable = [];


% get the tables to be autofilled in the order of filling
AutoTabPtrs = TabPtrs(fillOrder); % find the tables to be filled


NumAutoTables = length(AutoTabPtrs);


for i= 1:NumAutoTables
   omBPTable = get(om,['OptBP_' AutoTabPtrs(i).getname]);
    % run the bpopt
   bpflag = get(omBPTable, 'Enable');
   if bpflag
      [AutoTabPtrs(i).info,cost,OK, msg]= run(omBPTable,AutoTabPtrs(i).info,[],SF);
      if ~OK
         msg = ['Problem optimizing the breakpoints of table ' AutoTabPtrs(i).getname '. ' msg];
         return
      end
   end
   
  omTable = get(om,['Opt_' AutoTabPtrs(i).getname]);
  % run the fill by optimization
  flag = get(omTable, 'Enable');
  if flag
     [AutoTabPtrs(i).info,cost,OK, msg]= run(omTable,AutoTabPtrs(i).info,[],SF, AutoTabPtrs(i));
     if ~OK
        msg = ['Problem optimizing table ' AutoTabPtrs(i).getname '. ' msg];
        return
     end
  end   
end   


cost = Inf;
OK=1;
msg = '';
