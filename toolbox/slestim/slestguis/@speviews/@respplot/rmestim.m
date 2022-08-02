function rmestim(this, hEstim)
% Removes waves associated with a particular estimation.

% Author(s): Bora Eryilmaz
% Copyright 1986-2003 The MathWorks, Inc.
% $Revision: 1.1.4.1 $ $Date: 2004/04/16 22:21:15 $

% Remove waves associated with estimation
r = this.Response;
for ct = 1:length(r)
   if r(ct).DataSrc.Estimation == hEstim
      this.rmresponse( r(ct) );
   end
end
