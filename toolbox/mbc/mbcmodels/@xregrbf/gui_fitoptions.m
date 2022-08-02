function [m,OK]= gui_fitoptions(m,varargin);
%GUI_FITOPTIONS

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:54:47 $

if isa(m.om,'xregoptmgr')
	[m.om,OK] = gui_setup(m.om,'figure',{'expanded',1,'title','Radial Basis Function Options','topname', 'Training algorithm'},m,varargin{:});
else
	errordlg('No fitting options are available for this model','Fit Options','modal');
	OK=0;
end
