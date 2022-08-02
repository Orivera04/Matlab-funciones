function [c,msg]=setparams(c,varargin)
%SETPARAMS  Set constraint parameters
%
%  C=SETPARAMS(C,PARAMLIST)  where PARAMLIST is a list
%  of parameter-value pairs.  Valid parameters for the
%  conlinear object are :
%
%     A:  vector, length nfactors
%     b:  scalar
%     model:  a model to use as a basis for default settings
%
%  where  A*x <= b
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 06:58:27 $

msg={};

for n=1:2:length(varargin)
   val=varargin{n+1};
   switch lower(varargin{n})
   case 'a'
      if length(val(:))==length(c.A)
         c.A=val(:)';
      else
         msg(end+1)={'Coefficient vector A is too long'};
      end
   case 'b'
      if length(val)==1
         c.b=val;
      else
         msg(end+1)={'Incorrect size for b'};
      end
   case 'model'
      % set up default parameters for the given model
      lims=gettarget(val);
      c.b=mean(lims(:,2));      
   end
end