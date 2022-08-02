function DDev=validatemodels(DDev,Stage,allowedlist,defmdl)
%VALIDATEMODELS  Chack all models on a design tree are allowed 
%
%  DDEV=VALIDATEMODELS(DDEV,STAGE,ALLOWEDMDLLIST,DEFAULTMDL)  checks all of the designs
%  for the specified stage to make sure the model in each of them appears in
%  ALLOWEDMDLLIST.  If any don't, they are altered to DEFAULTMDL.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 07:04:16 $

Dcell= DesignDev2Cell(DDev);
d= Dcell{Stage};

alldes=d.DesignTree.designs;
for n=1:length(alldes)
   m=model(alldes{n});
   mok=0;
   for i=1:length(allowedlist)
      mok= mok | isa(m,allowedlist{i});
   end
   if ~mok
      m= copymodel(m,defmdl);
      alldes{n}=model(alldes{n},m);
   end
end
d.DesignTree.designs=alldes;

Dcell{Stage}= d;
DDev= Cell2DesignDev(Dcell);