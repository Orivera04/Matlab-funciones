% check if the folders "units" and "tools" are in the path. If not, do it
% automatically. 
% Please put them in the path permanently with file/set path...
extra_path

params=parameter('slider panel');

params=add(params,'slider','a slider value',unit_length,5,'cm',1,10,0);
params=add(params,'slider','another slider value',5,1,10);
params=add(params,'button','OK');

params=parametergui(params);