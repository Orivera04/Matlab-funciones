function theAnswer=dcsc(measureInDegrees)
%pass in an angle in degrees, and you get the cosecant
%this function takes an angle in degrees, and
%automaticly does the radian conversion returning the cosecant
inRads=measureInDegrees*pi/180;
%convert from degrees to radians
%now return the cosecant
theAnswer=csc(inRads);
