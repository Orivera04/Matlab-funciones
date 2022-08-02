function [GM,DispStr]= GrowthModels(L);
%GROWTHMODELS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.4.2.2 $  $Date: 2004/02/09 08:00:55 $

GM= {'expgrowth','gomp','logistic','logistic4','mmf','richards','weibul'};


if nargout>1
	DispStr= {'Exponential growth','Gompertz-Gertz','Logistic (3 parameters)','Logistic (4 parameters)',...
			'Morgan-Mercer-Flodin','Richard''s growth','Weibul'};
end
