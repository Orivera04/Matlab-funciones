% example for the usage of the parameter class
% 
% (c) 2003, University of Cambridge
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual/tools/parameter
% $Date: 2004/07/26$


function example1(params)
% example function puts a simple gui on the screen that draws some markers
% call it without parameters: type draw

% check if the folders "units" and "tools" are in the path. If not, do it
% automatically. 
% Please put them in the path permanently with file/set path...
extra_path


% check the number of inputs
if nargin==0 % initial call without parameters.
    params=parameter('drawing parameters'); % create an object of the parameter class with name
    % now we add some items to it:
    params=add(params,'panel','select shape',3); % a panel is a square around the following (in this case 3) items
    params=add(params,'radiobutton','square'); % three radiobuttons
    params=add(params,'radiobutton','circle',1); % this one is selected
    params=add(params,'radiobutton','other...'); % here the user can make its own choice
    params=add(params,'slider','radius',unit_length,5,'cm',0,10); % a slider value with the unit "length". watch what happens!
%     params=setcallback(params,'radius','example1(params)'); % try this!
%     params=add(params,'float','radius',unit_length,5,'cm',0,inf); % a float value with the unit "length". watch what happens!
    params=add(params,'bool','hold on','true');   % a tick box that is set to true
    params=add(params,'button','clear','figure(1),cla;'); % first button: clear the figure
    params=add(params,'button','draw','example1(params)'); % second button calls the drawing part of the function

    figure(1)   % opens new figure
    parametergui(params); % create the gui
    return  % and return to the shell. From now on the gui has the control 
end


% if we are here then we are called from the gui with the parameter
% structure in "params"

figure(1)   % always work in the same figure
% check the value of the tick box. Get it by its name:
if get(params,'hold on') % returns the value of the item in params with the name 'hold on'
    hold on
else
    clf
end

% we plot a shape in the figure. Lets see how big the user wants it.
% get the entry of the float field as units poits (not exactly cm but close enough...)
radius=getas(params,'radius','point');
switch get(params,'select shape') % get the currently selected radiobutton
    case 'circle'
        mark='o';
    case 'triangle'
        mark='^';
    otherwise % non of the two above. It must be the 'other...' value
        mark=get(params,'select shape'); % get the string in the "other..." line
end
% and finally plot something
plot(0,0,'markersize',radius,'marker',mark);

%wait for further commands from the gui...



