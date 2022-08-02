function desout=loadobj(desin)
% LOADOBJ   Object loading function
%
%   B=LOADOBJ(A) is called when a linearmod design object
%   is loaded.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:02:39 $

% Created 2/12/99

if isa(desin,'des_multimod');
   % loading worked ok anyway
   desout=desin;
else
   domodelupdate=0;
   % do version switching
   % new features are cumulatively added to this section
   if smodin.version<=1
      % version 1 -> 2
      % the model fields have been moved to @design
      domodelupdate=1;
      m=desin.model;
      ms=desin.modelstate;
      desin=rmfield(desin,'model');
      desin=rmfield(desin,'modelstate');
   end
   des=des_linearmod(desin);
   if domodelupdate
      desout=model(desout,m);
      desout=modelstate(desout,ms);
   end
end
