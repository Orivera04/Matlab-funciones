function [om,OK, msg]= bpinit(LT, varargin)
%BPINIT
% [om, OK] = bpinit(LT)  (uses the underlying values of the variables to set the breakpoints)
% [om, OK] = bpinit(LT, minBP, maxBP, maxVal, numBPs)
% LT - lookuptwo
% minBP -  1 x 2 vector of minimum breakpoint values
% maxBP - 1 x 2 vector of maximum breakpoint values
% maxVal - largest normaliser output (an integer)
% numBP - the number of breakpoints (red ones!)
% an optmgr for equally spacing the moveable breakpoints. 
% Run with
% [NF,cost,OK]= run(om,NF,[]);

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.3 $  $Date: 2004/02/09 07:11:25 $

if ~isfill(LT)
   OK = 0;
   msg = 'The table is empty or incomplete.';
   om = [];
   return
end

% create the xregoptmgr. It is a context object, associated with a lookuptwo
om= contextimplementation(xregoptmgr,LT,@i_autospace,[],['InitBP_' getname(LT)],@bpinit);

if nargin > 1
   minBP = varargin{1};
   maxBP = varargin{2};
   maxVal = varargin{3};
   numBP = varargin{4};
   % create the optimMgr for the normalisers
   [omNx, OKx, msgx] = bpinit(LT.Xexpr.info, minBP(1), maxBP(1), maxVal(1), numBP(1));
   [omNy, OKy, msgy] = bpinit(LT.Yexpr.info, minBP(2), maxBP(2), maxVal(2), numBP(2));
else
   % create the optimMgr for the normalisers
   [omNx, OKx, msgx]= bpinit(LT.Xexpr.info);
   [omNy, OKy, msgy] = bpinit(LT.Yexpr.info);
end

if OKx
   % make the optmgrs for the normalisers suboptmgrs
   om = AddOption(om,['InitBP_' getname(LT.Xexpr.info)],omNx,'xregoptmgr', ['Breakpoints of ' getname(LT.Xexpr.info)]);
else
   om = [];
   OK = OKx;
   msg = msgx;
   return
end


if OKy 
   om = AddOption(om,['InitBP_' getname(LT.Yexpr.info)],omNy,'xregoptmgr', ['Breakpoints of ' getname(LT.Yexpr.info)]);
else
   om = [];
   OK = OKy;
   msg = msgy;
   return
end

OK = 1;
msg = '';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [LT,cost,OK, msg] = i_autospace(LT,om,x0)

omNx = get(om, ['InitBP_' getname(LT.Xexpr.info)]);
omNy = get(om, ['InitBP_' getname(LT.Yexpr.info)]);

Normx = LT.Xexpr;
Normy = LT.Yexpr;

%run the initialisation algorithm (autospace) on the normalisers
[Normx.info, cost, OK, msg]  = run(omNx, Normx.info, []);
if ~OK % if there is a problem
   return
else
   [Normy.info, cost, OK, msg2]  = run(omNy, Normy.info, []);

   % label messages with normaliser names, if messages were returned.
   if ~isempty(msg2)
       if isempty(msg)
           msg = [getname(LT.Yexpr.info) ': ' msg];
       else
           msg = [getname(LT.Xexpr.info) ': ' msg '.     ' getname(LT.Yexpr.info) ': ' msg2];
       end
   elseif ~isempty(msg)
       msg = [getname(LT.Xexpr.info) ': ' msg];
   end
end

