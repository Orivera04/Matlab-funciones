% tool
% 
%   INPUT VALUES:
%  
%   RETURN VALUE:
%
% 
% (c) 2003, University of Cambridge, Medical Research Council 
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual
% $Date: 2003/01/17 16:57:45 $
% $Revision: 1.3 $

function value=slidereditcontrol_get_value(combi)
% a slidereditcontrol consists of a slider and an edit object, that are 
% related. When one value changes, the other also changes.
% The combination has the following variables:
% sliderhandle - the handle of the slider control
% edithandle - the handle of the edit control
% minvalue - the minimum value allowed
% maxvalue - the maximum allowed value
% (current_value - the current value)
% is_log - whether the slider reponds logarithmically
% editscaler - a number, that is multiplied to the edit control (to make ms of secs)
% nreditdigits - the number of digits in the edit control

value=combi.current_value;