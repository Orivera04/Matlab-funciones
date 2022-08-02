f=figure; 

old_units=get(f,'Units');
set(f,'Units','Pixels');
p=get(f,'Position');
set(f,'Units',old_units);

flex_width=500;
flex_height=200;
p_flex=[10,p(4)-flex_height-10,flex_width,flex_height];
h = actxcontrol ('MSFlexGridLib.MSFlexGrid',p_flex,f);
h.FixedRows=1;
h.FixedCols=1;
h.Rows=4; h.Cols=5;
registerevent(h,{'keypress','kp'});
registerevent(h,{'keydown','kd'});
