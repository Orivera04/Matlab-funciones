function em = setranges(em , R)
% ExportModel/setranges
%	E = setranges(E,rangeMatrix)
%   RangeMatrix must be a double array [2 x nfactors] 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:47:48 $

if ~isempty(R)
	%For this case, range must be a [2 x nfactors] matrix. The 1st row of which must be the Upper range info.
	n = nfactors(em);
	[row,col] = size(R);
	if row~=2 | col~=n
		error('Exportmodel\set: Incorrect size of matrix for range information.');
	end
	if any(R(1,:) >= R(2,:))
		% warning ?
	end
	em.ranges = R;
end