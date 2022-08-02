function df= dferror(m);
% MODEL/DFERROR degrees of freedom for error 

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:51:43 $

if isfield(m.Stats,'df')
	df= m.Stats.df;
	if isempty(df)
		df=Inf;
	end
else
	df= Inf;
end