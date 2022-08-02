function yunits= TransUnits(m)
% XREGMODEL/TRANSUNITS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:51:16 $

yunits= char(m.Yinfo.Units);
if ~isempty(yunits) && ~isempty(m.ytrans);
	Fy= m.ytrans;
	transUnits= char( subs(sym(Fy),'MBCUNITS' ) );
	yunits= strrep(transUnits, 'MBCUNITS', yunits);
end