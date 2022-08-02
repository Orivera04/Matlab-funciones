function [om, OK, msg]= init(LT, varargin)
%INIT Creates an optimMgr for initialising a cgnormfunction
%
% [om, OK, msg] = init(LT)
% [om, OK, msg] = init(LT, SF)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:14:52 $

if ~isfill(LT)
   OK = 0;
   msg = 'The table is empty or incomplete.';
   om = [];
   return
end

tablename = getname(LT);
   
om = contextimplementation(xregoptmgr,LT,@i_settoconstantvalue,[],['Init_' tablename],@tbinit);

if nargin > 1
   try
      SF = varargin{1}; 
      % get all the pointers in the subfeature
      SFptrs = getptrs(SF);
      
      % get the pointer TabPtr to this table
      TabPtr = [];
      for i = 1:length(SFptrs)
         if isa(SFptrs(i).info,'cgnormfunction') && strcmp(getname(SFptrs(i).info), getname(LT)); 
            TabPtr = [TabPtr SFptrs(i)];
         end   
      end   
      
      if isempty(TabPtr)
         msgbox('The table does not appear in the subfeature');
         return;
      end   
      
      % can the subfeature be solved for TabPtr?
      [pexpr, rhsexpr, problem, PtrsCreated] = solve(SF, [], TabPtr);
      if ~isempty(rhsexpr) && isa(rhsexpr.info, 'cgdivexpr')
         inittableval = 1;
      else
         inittableval = 0;
      end
      freeptr(PtrsCreated);
   catch
      inittableval = 0;
   end
else
   inittableval = 0;
end

om= AddOption(om,'InitTableValue',inittableval,{'numeric',[-Inf,Inf]}, 'Initial value');% vector of initial table values
OK = 1;
msg = '';

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [LT,cost,OK, msg] = i_settoconstantvalue(LT,om,x0)

initval = get(om, 'InitTableValue');
M = LT.Values;
valLocks = logical( get(LT, 'vlocks') );
% set unlocked values to initval
M(~valLocks) = initval;

LT = set( LT, 'values', {M, 'Initial value set'} );

OK = 1;
cost = Inf;
msg = '';





