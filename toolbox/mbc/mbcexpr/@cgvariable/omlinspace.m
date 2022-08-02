function [om,OK]= omlinspace(var, varargin)
%OMLINSPACE
%
% [om,OK] = omlinspace(var) or
% [om, OK] = omlinspace(var, minvar, maxvar, ngridpts)
% om = gui_setup(om, 'figure', 1) to view/set options
% [var, cost, OK, msg] = run(om, var, []) to run
% set up om to linearly space the variable (cgvalue) var given a range and number of gridpoints

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.3.6.2 $  $Date: 2004/02/09 07:16:52 $


name = getname(var);
   
om= contextimplementation(xregoptmgr,var,@i_linspace,[],['Set_' name],@omlinspace);


if nargin > 1
   varmin = varargin{1};
   varmax = varargin{2};
   ngridpts = varargin{3};
else
   varmin = min(getvalue(var));
   varmax = max(getvalue(var));
   ngridpts = 10;
end

if varmin == varmax
   om= AddOption(om,'Range',varmin,{'range',[-Inf,Inf]});
else
   om= AddOption(om,'Range',[varmin varmax],{'range',[-Inf,Inf]});
end
om= AddOption(om,'NGridPts', ngridpts,{'int',[1,Inf]}, 'Number of points');

OK=1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [var, cost, OK, msg] = i_linspace(var, om,x0)

range = get(om, 'Range');
ngridpts = get(om, 'ngridpts');

if length(range) ==1
   range(2) = range(1);
end

if range(1) > range(2) 
   OK = 0;
   msg = ['Range_' getname(var) ' must be increasing. '];
   cost = Inf;
   return
elseif range(1) == range(2)
   if ngridpts >1
      OK = 0;
      msg = ['Range_' getname(var) ' must be strictly increasing. '];
      cost = Inf;
      return
   else % ngridpts =1 
      var = setvalue(var, range(1));
   end
else
    if ngridpts >1
       var = setvalue(var, linspace(range(1), range(2), ngridpts));
    else
       var = setvalue(var, mean(range));
    end
end   

cost = Inf;
OK = 1;
msg = '';




