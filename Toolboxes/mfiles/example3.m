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
P=parameter;

P=add(P,'float','cm value',unit_length,1,'cm')

in_inch=getas(P,'cm value','inch')
