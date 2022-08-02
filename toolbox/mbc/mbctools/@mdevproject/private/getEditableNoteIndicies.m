function ind = getEditableNoteIndicies(MP)
%GETEDITABLENOTEINDICIES

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.6.4.2 $  $Date: 2004/02/09 08:05:54 $



usernow = getusername(initfromprefs(mbcuser));
ind = [];
for n = 1:length(MP.History)
   if strcmp(getusername(MP.History(n).User),usernow)
      ind = [ind n];
   end
end