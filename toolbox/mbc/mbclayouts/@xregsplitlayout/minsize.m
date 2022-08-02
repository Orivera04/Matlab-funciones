function sz=minsize(obj)
% MINSIZE   Return minimum size of object
%
%   S=MINSIZE(OBJ) returns a 2 element vector indicating the
%   minimum renderable size of the object OBJ.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:37:08 $

% splitlayout's need to recurse

sz=[0 0];
h=get(obj,'elements');
for n=1:min(2,length(h))
   subsz(n,1:2)=minsize(h{n});
end

ud=obj.datastore.info;
if ud.orientation
   %ud
   sz(1)=max(subsz(:,1));
   sz(2)=sum(subsz(:,2));  
else
   %lr
   sz(2)=max(subsz(:,2));
   sz(1)=sum(subsz(:,1));  
end



