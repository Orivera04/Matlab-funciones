function [om,OK, msg]= bpinit(LT, varargin)
%BPINIT
% [om, OK, msg] = bpinit(LT)  (uses the underlying values of the variables to set the breakpoints)
% LT = bpinit(LT, minBP, maxBP, maxVal, numBPs)
% LT - normfunction
% minBP - minimum breakpoint value
% maxBP - maximum breakpoint value
% maxVal - largest normaliser output (an integer)
% numBP - the number of breakpoints (red ones!)
% an optmgr for equally spacing the moveable breakpoints. 
% Run with
% [LT,cost,OK, msg]= run(om,LT,[]);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.3 $  $Date: 2004/02/09 07:14:31 $

if ~isfill(LT)
   OK = 0;
   msg = 'The table is empty or incomplete.';
   om = [];
   return
end

% create the xregoptmgr. It is a context object, associated with a normfunction LT
om= contextimplementation(xregoptmgr,LT,@i_autospace,[],['InitBP_' getname(LT)],@bpinit);

% create the optimMgr for the normaliser
[Nom, OK, msg] = bpinit(LT.Xexpr.info, varargin{:});

% make the optmgr for the normaliser a suboptmgr
if OK
   om = AddOption(om,['InitBP_' getname(LT.Xexpr.info)],Nom,'xregoptmgr', ['Breakpoints of ' LT.Xexpr.getname]);
end
OK = 1;
msg = '';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [LT,cost,OK, msg] = i_autospace(LT,om,x0)

Nom = get(om, ['InitBP_' getname(LT.Xexpr.info)]);

Norm = LT.Xexpr;
%run the initialisation algorithm (autospace) on the normaliser
[Norm.info, cost, OK, msg]  = run(Nom, Norm.info, []);
