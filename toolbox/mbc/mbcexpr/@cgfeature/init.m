function [om,OK, msg]=init(SF)
% routine to initialise features
% [om,OK,msg]=init(SF)
% set up om then run it
% [SF, cost, OK ] = run(om, SF, x0)
%  Inputs:
%				SF - cgfeature object
%				om - cgfeature OptimMgr 
%				x0 - starting value (unused)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.6.2.3 $  $Date: 2004/02/09 07:10:46 $

% Outputs 
%			   SF - new cgfeature object

if isempty(SF.eqexpr)
   OK = 0;
   msg = 'Equation not defined.';
   om = [];
   return
end


name = getname(SF);

% create the optimMgr for initialising cgfeatures
om= contextimplementation(xregoptmgr,SF,@i_init,[],['Initialize ' name],@init);


% get all the table pointers and any cgfeature pointers 

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
% create the suboptimMgrs for the tables
for i =1:NumTables
   [inittableom,OK,msg]= init(TabPtrs(i).info, SF);
   if ~OK
      msg = ['Problem creating options manager for setting initial value of ' TabPtrs(i).getname '. ' msg];
      return
   end   
   [bpinittableom,OK]= bpinit(TabPtrs(i).info);
   if ~OK
      msg = ['Problem creating options manager for autospacing breakpoints linearly in ' TabPtrs(i).getname '. ' msg];
      return
   end   
   bpinittableom = AddOption(bpinittableom,'Enable',1,'boolean');
   om = AddOption(om,['InitBP_' TabPtrs(i).getname],bpinittableom,'xregoptmgr', ['Breakpoints of ' TabPtrs(i).getname]);
   inittableom = AddOption(inittableom,'Enable',1,'boolean');
   om = AddOption(om,['Init_' TabPtrs(i).getname],inittableom,'xregoptmgr', ['Values of ' TabPtrs(i).getname]);
end

% create the suboptimMgrs for the cgfeatures
for i =1:length(subSFptrs)
   [subSFom,OK]=init(subSFptrs(i).info);
   if OK
      subSFom = AddOption(subSFom,'Enable',1,'boolean');
      om = AddOption(om,['Init_' subSFptrs(i).getname],subSFom,'xregoptmgr', ['Initialize ' subSFptrs(i).getname]);
   else
      msg = ['Problem creating options manager for ' subSFptrs(i).getname '. ' msg];
      return
   end   
end
OK = 1;
msg = '';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [SF,cost,OK, msg]=i_init(SF,om,x0)

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

% init each subSF first
for  i = 1:length(subSFptrs)
    omsubSF{i} = get(om,['Init_' subSFptrs(i).getname]);
    sfflag = get(omsubSF{i}, 'Enable');
    if sfflag
       [subSFptrs(i).info,cost,OK, msg]= run(omsubSF{i},subSFptrs(i).info,[]);
       if ~OK
          msg = ['Error encountered in initializing Feature_' subSFptrs(i).getname '. ' msg];
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
  msg = 'There are no tables in this feature.'; 
  return
end   
   
omTable = [];
for i =1:NumTables
   initomTable{i} = get(om,['Init_' TabPtrs(i).getname]);
   flag = get(initomTable{i},'Enable');
   if flag 
      [TabPtrs(i).info, cost, OK, msg] = run(initomTable{i}, TabPtrs(i).info, []);
      if ~OK
         msg = ['Error encountered in setting initial value of '  TabPtrs(i).getname '. ' msg] ;
         return
      end       
   end
   
   bpinitomTable{i} = get(om,['InitBP_' TabPtrs(i).getname]);
   bpflag = get(bpinitomTable{i},'Enable');
   if bpflag % initialise the breakpoints
      [TabPtrs(i).info, cost, OK, msg] = run(bpinitomTable{i}, TabPtrs(i).info, []);
      if ~OK
         msg = ['Error encountered in autospacing the breakpoints of '  TabPtrs(i).getname '. ' msg] ;
         return
      end       
   end  
end

cost = Inf;
OK=1;
msg = '';
