% method of class @parameter
% 
% (c) 2003, University of Cambridge
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual/tools/parameter
% $Date: 2004/07/26$

function params=setfirstfocus(params,where)
% sets the first focus to an element. When the gui is opend this one gets
% the focus

params.firstfocus=where;
