function str = rcinfo(this, wf, Row, Col, HostLine)
% Constructs data tip text localizing plot in axes grid.

% Author(s): Bora Eryilmaz
% Revised: 
% Copyright 1986-2004 The MathWorks, Inc.
% $Revision: 1.1.4.1 $ $Date: 2004/04/16 22:20:58 $

p = wf.DataSrc.Estimation.Parameters(Row);
if isscalar(p.Value)
  str = sprintf('Parameter: %s', p.Name);
else
  % Recover line index
  idxEntry = find(HostLine == handle(this.Curves{Row}));
  str = sprintf('Parameter: %s(%d)', p.Name, idxEntry);
end
