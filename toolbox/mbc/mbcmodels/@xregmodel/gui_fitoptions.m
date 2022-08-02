function [m,OK]= gui_fitoptions(m,varargin);
%GUI_FITOPTIONS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:52:10 $

if isa(m.FitAlgorithm,'xregoptmgr')
	[m.FitAlgorithm,OK] = gui_setup(m.FitAlgorithm,'figure',{'expanded',1,'title','Model Fit Options'}, m,varargin{:});
else
	OK=0;
	errordlg('No fitting options are available for this model','Fit Options','modal');
end
