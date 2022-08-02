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
% $Date: 2003/03/03 19:50:26 $
% $Revision: 1.6 $

function combi=slidereditcontrol_set_range(combi,duration)
% sets the range and the step size, so that the width of the slider is OK
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

% works only for linear sliders (yet)
if combi.is_log==1
	set(combi.sliderhandle,'SliderStep',[0.01 0.1]);
else
	dur=combi.maxvalue-combi.minvalue; % so long is it indeed
	if abs(dur-duration)>0
		step1=duration/abs(dur-duration);
		% 		step1=duration/dur;
		if abs(dur) > 0
			step2=duration/dur/10;
			step1=max(0,step1);
			step1=min(1,step1);
			step2=max(0,step2);
			step2=min(1,step2);
			set(combi.sliderhandle,'SliderStep',[step2 step1]);
			return
		end
	end
	step1=1;
	step2=1;
	set(combi.sliderhandle,'SliderStep',[step2 step1]);
end