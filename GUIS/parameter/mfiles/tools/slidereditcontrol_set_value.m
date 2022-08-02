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
% $Date: 2003/02/14 14:39:32 $
% $Revision: 1.5 $

function combi=slidereditcontrol_set_value(combi,value)
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

% translate the value to the value, the slider wants to see
if combi.is_log==1
	sliderval=f2f(value,combi.minvalue,combi.maxvalue,0,1,'loglin');
else
	sliderval=f2f(value,combi.minvalue,combi.maxvalue,0,1,'linlin');
end
sliderval=max(sliderval,0);
sliderval=min(sliderval,1);
set(combi.sliderhandle,'Value',sliderval);

editval=value*combi.editscaler;
editval=max(editval,combi.minvalue*combi.editscaler);
editval=min(editval,combi.maxvalue*combi.editscaler);

editval=fround(editval,combi.nreditdigits);
set(combi.edithandle,'String',num2str(editval));

combi.current_value=value;