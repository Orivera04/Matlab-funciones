function draw(this, Data, NormalRefresh)
% DRAW  Draws time response curves.
%
% DRAW(VIEW,DATA) maps the response data in DATA to the curves in VIEW.

% Author(s): John Glass, Bora Eryilmaz
% Copyright 1986-2002 The MathWorks, Inc.
% $Revision: 1.1.4.1 $ $Date: 2004/04/16 22:20:47 $

% Input and output sizes
Np = length(this.Curves);

% Map data to curves
for ct = 1:Np
  ParCurves = this.Curves(ct);
  if isempty(Data.Amplitude)
    set( double(ParCurves), 'XData', [], 'YData', [] );
  else
    set( double(ParCurves), 'XData', Data.Time, 'YData', Data.Amplitude(:,ct));
  end
end
