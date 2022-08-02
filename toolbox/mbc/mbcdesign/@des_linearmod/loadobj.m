function smodout=loadobj(smodin)
% LOADOBJ   Object loading function
%
%   B=LOADOBJ(A) is called when a linearmod design object
%   is loaded.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:02:20 $

% Created 2/12/99

if isa(smodin,'des_linearmod');
   % loading worked ok anyway
   smodout=smodin;
else
   domodelupdate=0;
   % do version switching
   % new features are cumulatively added to this section
   if smodin.version<=1
      % version 1 -> 1.1 additions
      % need a modelstate field
      smodin.modelstate=0;
      % chuck out the store which is now incorrect
      smodin.store=[];
      smodout=des_linearmod(smodin);
   end
   
   if smodin.version<=1.1
      % version 1.1 ->
      
   end
   
   if smodin.version<=1.2
      % version 1.2 -> 2
      % the model fields have been moved to @design
      domodelupdate=1;
      m=smodin.model;
      ms=smodin.modelstate;
      smodin=mv_rmfield(smodin,'model');
      smodin=mv_rmfield(smodin,'modelstate');
   end
   smodout=des_linearmod(smodin);
   if domodelupdate
      smodout=model(smodout,m);
      smodout=modelstate(smodout,ms);
   end
end
