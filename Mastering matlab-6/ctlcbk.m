function ctlcbk(varargin)
%ctlcbk Sample event handle for ActiveX server.
%  SAMPEV is a sample event handler function for the Matlab sample 
%  control. The only event fired by the control is 'Click', which is fired 
%  when the user clicks on the control with the mouse. The event handler
%  displays a text message in the Matlab command window when the event is 
%  fired.
%
persistent numclicks

if isempty(numclicks)
  numclicks=0;
end
if (str2num(varargin{1}) == -600);
    numclicks = numclicks + 1;
    evalstr=['Click #',num2str(numclicks)];
    evalin('caller',...
          ['h.Label=''',evalstr,''';invoke(h,''Redraw'');'] );
end
