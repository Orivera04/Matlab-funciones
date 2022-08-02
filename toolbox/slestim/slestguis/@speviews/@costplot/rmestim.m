function rmestim(this, hEstim)
% Removes wave associated with a particular estimation.

% Author(s): Bora Eryilmaz
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.6.3 $ $Date: 2004/04/11 00:40:56 $

Waves = this.Waves;

for ct = 1:length(Waves)
   if Waves(ct).DataSrc.Estimation == hEstim
      this.rmwave( Waves(ct) );
   end
end
