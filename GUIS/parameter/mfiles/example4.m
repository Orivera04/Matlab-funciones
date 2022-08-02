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
params=add(params,'float','time parameter',unit_time,1,'s');
params=add(params,'float','length parameter',unit_length,1,'cm');
params=add(params,'float','frequency parameter',unit_frequency,1,'Hz');
params=add(params,'float','frequency ratio parameter',unit_fratio,1,'frequency ratio');
params=add(params,'float','voltage parameter',unit_voltage,1,'V');
params=add(params,'float','voltage ratio parameter',unit_vratio,1,'volt ratio');
params=add(params,'float','modulation depth parameter',unit_mod,1,'lin');
params=add(params,'float','angle parameter',unit_angle,1,'deg');
params=add(params,'float','weight parameter',unit_weight,1,'g');
params=add(params,'float','capacity parameter',unit_capacity,1,'F');
params=add(params,'float','temperature parameter',unit_temperature,1,'°C');
params=add(params,'float','resistance parameter',unit_resistance,1,'Ohm');
params=add(params,'float','current parameter',unit_current,1,'A');
params=parametergui(params)