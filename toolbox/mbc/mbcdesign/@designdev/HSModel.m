function m= HSModel(D,NewM);
% DESIGNDEV/HSMODEL Hierarchical Statistical Model from Design dev object

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/02/09 07:02:54 $

if nargin==1
	switch length(D)
	case 1
		m= getModel(D);
	case 2
		m= getModel(D,':');
		m= xregtwostage(m{:});
	otherwise
		error('Not supported yet')
	end
else
	switch length(D)
	case 1
		D= setmodel(D,NewM);
	case 2
		L= get(NewM,'Local');
		G= get(NewM,'Global');
		D= DesignDev2Cell(D);
		D{1}= setmodel(D{1},L);
		D{2}= setmodel(D{2},G{1});
		D= Cell2DesignDev(D);
	otherwise
		error('Not supported yet')
	end
	m= D;
end
	
