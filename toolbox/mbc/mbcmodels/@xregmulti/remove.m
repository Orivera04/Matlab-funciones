function mm=remove(mm,ind)
% REMOVE remove the specified model from a xregmulti
%
%   M=REMOVE(M,I) removes the model at position I from the
%   xregmulti M.  If I is omitted, the current model is deleted.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:54:06 $

% Created 25/5/2000

if nargin<2
   ind=m.currentindex;
end

if length(mm.weights)==1
   % cannot delete last model
   error('You cannot delete the last model from a mulstimodel object!');
   return   
end

if ind<=length(mm.weights) & ind>0
   mm.models(ind)=[];
   mm.weights(ind)=[];
   mm.weights=mm.weights./sum(mm.weights);
   if mm.currentindex>length(mm.weights)
      mm.currentindex=length(mm.weights);
   end
end
return