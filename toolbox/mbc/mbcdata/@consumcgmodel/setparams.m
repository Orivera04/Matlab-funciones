function [c,msg]=setparams(c,varargin)
%SETPARAMS  Set constraint parameters
%
%  C=SETPARAMS(C,PARAMLIST)  where PARAMLIST is a list
%  of parameter-value pairs.  Valid parameters for the
%  conlinear object are :
%
%     modptr:  model
%     bound:  scalar
%     bound_type:  0 for upper, 1 for lower
%
%  where  A*x <= b
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 06:56:20 $

msg={};

for n=1:2:length(varargin)
   val=varargin{n+1};
   switch lower(varargin{n})
   case 'modptr'
      if isa(val, 'xregpointer') & isa(info(val), 'cgmodexpr')
         c.modptr=val(:)';
      else
         msg(end+1)={'modptr must be a pointer to a cgmodexpr'};
      end
   case 'bound'
      if length(val)==1 & isnumeric(val)
         c.bound=val;
      else
         msg(end+1)={'Incorrect bound'};
      end
   case 'bound_type'
      if length(val)==1 & (val==0 | val==1)
         c.bound_type= val;   
      else
         msg(end+1)={'Bound_type should be 0 or 1'};
      end
   case 'oppoint'
      if isa(val, 'xregpointer') & isa(info(val), 'cgoppoint')
         c.oppoint = val;
      else
         msg(end+1)={'oppoint must be a pointer to a cgoppoint'};
      end         
   case 'weights'
      pOp = c.oppoint;
      if ~isempty(pOp)
         data = get(pOp.info, 'data');
      else
         data = [];
      end
      if isreal(val) & ~ischar(val) & size(val, 2) == 1 & size(val, 1) ==  size(data, 1)
         c.weights = val;
      else
         msg(end+1)={'Incorrect weights specification'};         
      end
   end
end
