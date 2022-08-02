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

%  $Revision: 1.3.6.1 $    $Date: 2004/02/09 06:55:53 $

msg={};

for n=1:2:length(varargin)
   val=varargin{n+1};
   switch lower(varargin{n})
   case 'modptr'
         c.modptr=val(:)';
   case 'bound'
      if length(val)==1 && isnumeric(val)
         c.bound=val;
      else
         msg(end+1)={'Incorrect bound'};
      end
   case 'bound_type'
       if length(val)==1 && (val==0 || val==1)
           c.bound_type= val;   
       else
           msg(end+1)={'Bound_type should be 0 or 1'};
       end
   case 'evaltype'
       if length(val)==1 && (val>=0 || val<=2)
           c.evaltype= val;   
       else
           msg(end+1)={'Evaltype should be 0, 1 or 2'};
       end
   end
end
