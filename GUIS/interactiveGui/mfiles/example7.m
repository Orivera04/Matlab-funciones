% check if the folders "units" and "tools" are in the path. If not, do it
% automatically. 
% Please put them in the path permanently with file/set path...
extra_path
params=parameter('example gui with all different parameter types');

params=add(params,'int','an integer value','1:10');
params=setcallback(params,'an integer value','disp(params)');
params=add(params,'float','a float (temperature) value',unit_temperature,1,'°C');
params=setcallback(params,'a float (temperature) value','disp(params)');
params=add(params,'slider','a slider value',unit_length,5,'m',1,10,1);
params=setcallback(params,'a slider value','disp(params)');
params=add(params,'string','a string value','hallo world');
params=setcallback(params,'a string value','disp(params)');
params=add(params,'bool','a boolean value','true');   % a tick box that is set to true
params=setcallback(params,'a boolean value','disp(params)');

params=add(params,'panel','a range of radio buttons:',2);
params=add(params,'radiobutton','this',1); % this one is selected
params=setcallback(params,'this','disp(params)');
params=add(params,'radiobutton','other...'); % here the user can make its own choice
params=setcallback(params,'other...','disp(params)');

string_struct={'selection 1','selection 2','selection 3'};
params=add(params,'pop-up menu','a pop-up menu',string_struct);
params=setcallback(params,'a pop-up menu','disp(params)');
params=add(params,'filename','a file name','c:\test.m');
params=setcallback(params,'a file name','disp(params)');
params=add(params,'directoryname','a directory name','C:\MATLAB7\work');
params=setcallback(params,'a directory name','disp(params)');
params=add(params,'button','a button','msgbox(''button pressed'')');

params=parametergui(params)