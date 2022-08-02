% method of class @parameter
% 
% (c) 2003, University of Cambridge
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual/tools/parameter
% $Date: 2004/07/26$


function param=setposition(param,mode)
% moves the figure identified by handle h to the specified screen location, 
% preserving the figure's size. The position argument can be any of the following strings: 
% north - top center edge of screen 
% south - bottom center edge of screen 
% east - right center edge of screen 
% west - left center edge of screen 
% northeast - top right corner of screen 
% northwest - top left corner of screen 
% southeast - bottom right corner of screen 
% southwest - bottom left corner 
% center - center of screen 
% onscreen - nearest location with respect to current location that is on screen The position argument can also be a two-element vector [h,v], where depending on sign, h specifies the 

param.position=mode;