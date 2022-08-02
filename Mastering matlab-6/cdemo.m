function cdemo(varargin)
%CDEMO Sample function to manage an ActiveX object.
%  Function to create a sample ActiveX control. The function creates
%  a figure window, adds a nice plot, creates an MWSAMP control,
%  embeds the control in the figure window, sets the 'Label' and 
%  'Radius' properties of the control, and invokes the 'Redraw'
%  method on the control.
%
%  CDEMO is also the event handler for this control. The only event
%  fired by the control is 'Click', which is fired when the user
%  clicks on the control with the mouse. The event handler changes
%  the text message in the control when the event is fired.
%  The control is deleted when the figure window is closed.

% Keep track of a few things between calls.
persistent numclicks h
if isempty(numclicks), numclicks=0; end

if nargin == 0      % Initial call -- do the setup.

  % Create a new figure window and draw a nice plot.
  f = figure;
  surf(peaks);

  % Embed an MWSAMP ActiveX control in the lower left corner 
  % of the Figure window and set the callback to recall this 
  % function (cdemo).
  h = actxcontrol('MWSAMP.MwsampCtrl.1',[0 0 90 90],f,'cdemo');
  
  % Set the initial label and circle radius in the control 
  % showing two methods of setting the property values.
  set(h, 'Label', 'Click Here');
  h.Radius=28;
  
  % Tell the control to redraw itself by invoking the Redraw method.
  invoke(h, 'Redraw');

else    % This part handles the callback. If a mouse click event
        % is detected, the first argument will be a string that
        % resolves to the value -600. No other events are supported.

  if ~ischar(varargin{1})
    error('Invalid input.');
  end
     
  % Increment the click total, change the label, and redraw.
  if str2num(varargin{1}) == -600
     numclicks = numclicks + 1;
     h.Label=['Click #',num2str(numclicks)];
     invoke(h,'Redraw');
  else
    error('Invalid input.');
  end
end
