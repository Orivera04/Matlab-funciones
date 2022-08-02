function cdemo(varargin)
%CDEMO Sample function to manage an ActiveX object.
%  Function to create a sample ActiveX control. The function creates
%  a figure window, adds a nice plot, creates an MWSAMP control,
%  embeds the control in the Figure window, sets the 'Label' and 
%  'Radius' properties of the control, and invokes the 'Redraw'
%  method on the control.
%
%  CDEMO is also the event handler for this control. The three events
%  fired by the control are 'Click', 'DblClick', and 'MouseDown'.
%  The event handler changes the text message in the control when 
%  a Click or DblClick event is fired.
%  The control is deleted when the figure window is closed.

% Keep track of a few things between calls.
persistent numclicks h

if nargin == 0      % Initial call -- do the setup.

  % Create a new figure window and draw a nice plot.
  f = figure;
  surf(peaks);
  numclicks=0;

  % Embed an MWSAMP2 ActiveX control in the lower left corner 
  % of the Figure window and set the callback to recall this 
  % function (cdemo).
  h = actxcontrol('MWSAMP.MwsampCtrl.2',[0 0 90 90],f,'cdemo');
  
  % Set the initial label and circle radius in the control 
  % showing two methods of setting the property values.
  set(h, 'Label', 'Click Here');
  h.Radius=28;
  
  % Tell the control to redraw itself by invoking the Redraw method.
  invoke(h, 'Redraw');

else    % This part handles the callback. For each valid event
        % detected, the last argument will be a string that
        % resolves to the event name.

  if strcmp(varargin{end},'Click')
    % Increment the click total.
    numclicks = numclicks + 1;
    h.Label=['Click #',num2str(numclicks)];

  elseif strcmp(varargin{end},'DblClick')
    % Decrement the click total by 2. The first of the pair
    % generated a Click event and incremented by 1. The second
    % click within the time limit generated this DblClick event.
    numclicks = numclicks - 2;
    h.Label=['Click #',num2str(numclicks)];

  elseif strcmp(varargin{end},'MouseDown')
    % Display the x,y coordinates of the mouse pointer.
    h.Label=['(x,y)=(',num2str(varargin{5}),',',num2str(varargin{6}),')']; 

  else
    error('Invalid input.');
  end
  % Redraw the control.
  h.Redraw;
end
