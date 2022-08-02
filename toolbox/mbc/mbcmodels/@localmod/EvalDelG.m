function L= EvalDelG(L);
% LOCALMOD/EvalDelG evaluate delG/delp for current parameter set

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.3.2.2 $  $Date: 2004/02/09 07:38:39 $

f=L;

p= double(f);
if DatumType(f)
   % need to reset datum here as function evaluation for 
   % all response features are relative to datum but only do this if using
   % datum models
   f=datum(f,0);
end
if ~all(isfinite(p))
   % make some fake parameter values
   f= update(f,0:size(f,1)-1);
end

DELG= zeros(length(f.Type),size(f,1));
for i= 1:length(f.Type);
   DELG(i,:)=   eval(f.Type(i).delG,'repmat(NaN,1,size(f,1))');
end
L.delG=DELG;