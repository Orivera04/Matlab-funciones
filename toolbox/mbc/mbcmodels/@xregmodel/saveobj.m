function m= saveobj(m);
% XREGMODEL/SAVEOBJ

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:53:02 $

xu= m.Xinfo.Units;
for i=1:length(xu)
	if isa(xu{i},'junit')
		xu{i}= saveobj(xu{i});
	end
end
m.Xinfo.Units= xu;


yu= m.Yinfo.Units;
if isa(yu,'junit')
	yu= saveobj(yu);
	m.Yinfo.Units= yu;
end