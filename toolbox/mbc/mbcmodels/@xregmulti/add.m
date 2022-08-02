function mm=add(mm,m,wt)
% ADD add a new model to a xregmulti
%
%  M=ADD(M) adds a default new model
%  M=ADD(M,NEWMODEL) adds the model specified.
%  M=ADD(M,NEWMODEL,WEIGHT) adds the specified model
%  and sets it's relative weight to WEIGHT.
%
%  The default relative WEIGHT value is 1/n where n is the number
%  of models after the new on is added.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:53:55 $

% Created 25/5/2000


if nargin<3
   wt=1./(length(mm.models));
end

if nargin<2
   m=xregcubic('nfactors',get(mm,'nfactors'));
   % copy basic model definition in
   m=copymodel(mm,m);
end

mm.models(end+1)={m};
mm.weights(end+1)=wt;
mm.weights=mm.weights./sum(mm.weights);

return
