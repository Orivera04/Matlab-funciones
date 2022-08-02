% example for the usage of the parameter class
% 
% (c) 2003, University of Cambridge
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual/tools/parameter
% $Date: 2004/07/26$


% check if the folders "units" and "tools" are in the path. If not, do it
% automatically. 
% Please put them in the path permanently with file/set path...
extra_path
params=parameter('example parameters');
params=add(params,'panel','',3);
params=add(params,'bool','enable the following:',1);
params=add(params,'string','one parameter','is enabled');
params=add(params,'string','another parameter','is disabled');
params=enablefield(params,'enable the following:','one parameter');
params=disablefield(params,'enable the following:','another parameter');
params=add(params,'button','OK')
params=parametergui(params);