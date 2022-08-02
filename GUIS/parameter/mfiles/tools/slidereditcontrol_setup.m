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
% $Date: 2003/02/13 18:16:07 $
% $Revision: 1.4 $

function combi=slidereditcontrol_setup(sliderhandle,edithandle,minvalue,maxvalue,current_value,is_log,editscaler,nreditdigits)
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

combi.sliderhandle=sliderhandle;
combi.edithandle=edithandle;
combi.minvalue=minvalue;
combi.maxvalue=maxvalue;
combi.current_value=current_value;
combi.is_log=is_log;
combi.editscaler=editscaler;
combi.nreditdigits=nreditdigits;


combi=slidereditcontrol_set_range(combi,maxvalue/10);

% set(sliderhandle,'SliderStep',[0.01 0.1]);
