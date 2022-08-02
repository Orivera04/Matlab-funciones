function theAnswer=dcot(measureInDegrees)
%pass in an angle measure in degrees, and returns the cotangent
%you pass in an angle measurement in degrees, and this automaticly
%does the degrees to radians conversion and returns the cotangent
inRads=measureInDegrees*pi/180;
%convert from degrees to radians
%now find the cotangent and return it
theAnswer=cot(inRads);
