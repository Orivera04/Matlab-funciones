function [om,OK,msg]=bpfillthenopt(LT, sf)
%BPFILLTHENOPT

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.3 $  $Date: 2004/02/09 07:10:02 $

% LookUpTwo/bpfillthenopt
% creates an optimMgr for filling the breakpoints of LT
% These use the 'initialisation routines' that use curvature and errors
% [om, OK, msg] = bpfillthenopt(LT)
% [LT, cost, OK, msg] = run(om, LT, [],sf)

% create the breakpoint fill optmgr
[fillbpom,OK, msg]=bpfill(LT, sf);
if ~OK
   om = [];
   msg = ['Problem creating options manager for filling the breakpoints of ' getname(LT) '. ' msg];
   return
end   
   
% create the breakpoint opt optmgr
[optbpom,OK, msg]=bpopt(LT, sf);
if ~OK
   om = [];
   msg = ['Problem creating options manager for optimizing the breakpoints of ' getname(LT) '. ' msg];
   return
end   
tablename = getname(LT);


om= contextimplementation(xregoptmgr,LT,@i_bpfillthenopt,[],['FillBPthenOpt_' tablename],@bpfillthenopt);

fillbpom = AddOption(fillbpom,'Enable',1,'boolean');
om = AddOption(om,['FillBP_' getname(LT)],fillbpom,'xregoptmgr','Fill Breakpoints');
optbpom = AddOption(optbpom,'Enable',0,'boolean');
om = AddOption(om,['OptBP_' getname(LT)],optbpom,'xregoptmgr', 'Optimize Breakpoints');


OK = 1;
msg = '';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [LT,cost,OK, msg] = i_bpfillthenopt(LT,om,x0, sf)


% run the bpfill
fillbpom = get(om, ['FillBP_' getname(LT)]);
fillflag = get(fillbpom, 'Enable');
if fillflag 
   [LT, cost, OK, msg] = run(fillbpom, LT, [], sf);
   if ~OK
      return
   end
end


% then run the bpopt
optbpom = get(om, ['OptBP_' getname(LT)]);
optflag = get(optbpom, 'Enable');
if optflag
   [LT, cost, OK, msg] = run(optbpom, LT, [], sf);
end

if ~optflag & ~fillflag
    cost = Inf;
    OK = 1;
    msg = '';
end

