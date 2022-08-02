function IL= imlistMBrowser(T)
%IMLISTMBROWSER

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.5.4.2 $  $Date: 2004/02/09 06:47:50 $




bmpfiles= {'mbcmodel','mbcmodel_sel',...
	'testplanTree','testplanTreeSelected',...
	'locreg','locreg_sel','best_locreg',...
	'gloreg','gloreg_sel','best_gloreg',...
	'tworeg','tworeg_sel','best_tworeg',...
	'mle2','mle2_sel','best_mle2',...
	'mlerf','mlerf_sel','best_mlerf'};

ilm= xregGui.ILmanager;

for i= 1:length(bmpfiles)
	ind= bmp2ind(ilm,[bmpfiles{i},'.bmp']);
end
ilm.IL.MaskColor=uint32(256*256*255+255);   % Magenta is the transparent color	 
IL= ilm.IL;
