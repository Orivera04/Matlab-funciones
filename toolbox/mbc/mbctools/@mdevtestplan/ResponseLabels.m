function str= ResponseLabels(T);
% MDEVTESTPLAN/RESPONSELABEL

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:07:24 $

if numChildren(T)
	str= children(T,'ResponseLabel');
else
	str= cell(1,length(T.Responses));
	for k=1:length(T.Responses)
		str{k}= [ ResponseLabel(T.Responses{k}) '**' ];
	end
end
