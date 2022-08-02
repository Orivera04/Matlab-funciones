function Qplot()

clear all
warning off
global A cds opt holdon leg label

% opt.xc= 1; opt.yc= 2; opt.ec= 3; opt.zc= 3
opt= struct('xc',1,'yc',2,'ec',3,'zc',3);
label= struct('x','X','y','Y','z','Z','t','Title');
holdon= 0;
fullm= 0;
% leg= struct('tex','');

fp = get(0,'defaultfigureposition');
fp = [fp(1)-150 fp(2)+fp(4)-1 150 1];
figmain= figure ('menubar','None','Name','EZplot','Resize','Off','NumberTitle','off','Color','white','Position',fp);

mfile= uimenu('Label','File');
	uimenu(mfile,'Label','Read Text File','Callback','getdata(1)','Accelerator','R');
	uimenu(mfile,'Label','Read Excel File: All','Callback','getdata(2)','Accelerator','E');
	uimenu(mfile,'Label','Read Excel File: Selected Data','Callback','getdata(3)','Accelerator','I');
	uimenu(mfile,'Label','Quit','Callback','exit','Separator','on','Accelerator','Q');

mopt= uimenu('Label','Options');
	uimenu(mopt,'Label','X column  (def. 1)','Callback','getcols(''x'')','Accelerator','X')
	uimenu(mopt,'Label','Y columns','Callback','getcols(''y'')','Accelerator','Y')
	uimenu(mopt,'Label','Z column','Callback','getcols(''z'')','Accelerator','Z')
	uimenu(mopt,'Label','Error column','Callback','getcols(''e'')')
	uimenu(mopt,'Label','Axis Labels','Callback','getlabel','Accelerator','L')
	uimenu(mopt,'Label','Add graph to plot','Callback','window','Accelerator','A')

graph= uimenu('Label','Graphs');
	m2d= uimenu(graph,'Label','2D');
		uimenu(m2d,'Label','XY Scatter','Callback','plot2d(''xyscatter'')');
		uimenu(m2d,'Label','XY Line','Callback','plot2d(''xyline'')');
		uimenu(m2d,'Label','XY Line with error bar','Callback','plot2d(''error'')');
		uimenu(m2d,'Label','Horizontal Bar (grouped)','Callback','plot2d(''hbarg'')');
		uimenu(m2d,'Label','Horizontal Bar (stacked)','Callback','plot2d(''hbars'')');
		uimenu(m2d,'Label','Vertical Bar (grouped)','Callback','plot2d(''vbarg'')');
		uimenu(m2d,'Label','Vertical Bar (stacked)','Callback','plot2d(''vbars'')');
		uimenu(m2d,'Label','Vertical Bar with error bars','Callback','plot2d(''barerror'')');
		uimenu(m2d,'Label','Histogram','Callback','plot2d(''hist'')');
		uimenu(m2d,'Label','Stem','Callback','plot2d(''stem'')');
		uimenu(m2d,'Label','Stairs','Callback','plot2d(''stairs'')');
		uimenu(m2d,'Label','Rose','Callback','plot2d(''rose'')');
		uimenu(m2d,'Label','Polar','Callback','plot2d(''polar'')');
		uimenu(m2d,'Label','Compass','Callback','plot2d(''compass'')');
		uimenu(m2d,'Label','Pie','Callback','plot2d(''pie'')');

m3d= uimenu(graph,'Label','3D');
		uimenu(m3d,'Label','Scatter 3D','Callback','plot3d(''plot3'')');
		uimenu(m3d,'Label','Stem 3D','Callback','plot3d(''stem3'')');
		uimenu(m3d,'Label','Bar 3D','Callback','plot3d(''bar3'')');
		uimenu(m3d,'Label','Waterfall','Callback','plot3d(''waterfall'')');
		uimenu(m3d,'Label','Ribbon','Callback','plot3d(''ribbon'')');
		uimenu(m3d,'Label','Grid','Callback','plot3d(''grid'')');
		uimenu(m3d,'Label','Surface','Callback','plot3d(''surface'')');
		uimenu(m3d,'Label','Smooth Surface','Callback','plot3d(''smooth'')');
		uimenu(m3d,'Label','Contour','Callback','plot3d(''contour'')');

return
