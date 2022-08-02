function theAnswer=dtan(measureInDegrees)
%pass in an angle measure in degrees, and returns the tangent
%you pass in an angle measurement in degrees, and this automaticly
%the degrees to radians conversion and returns the tangent
inRads=measureInDegrees*pi/180;
%convert from degrees to radians
%now find the tangent
theAnswer=tan(inRads);
