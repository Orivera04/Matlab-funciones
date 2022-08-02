function clear(this)
% Clears data.

%  Copyright 1986-2002 The MathWorks, Inc.
%  $Revision: 1.1.4.1 $ $Date: 2004/04/16 22:21:03 $
for ct=1:length(this.SimData)
   this.SimData(ct).Time = [];
   this.SimData(ct).Amplitude = [];
end
