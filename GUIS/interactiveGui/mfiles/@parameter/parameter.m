% method of class @parameter
% 
% (c) 2003, University of Cambridge
% Stefan Bleeck (stefan@bleeck.de)
% http://www.mrc-cbu.cam.ac.uk/cnbh/aimmanual/tools/parameter
% $Date: 2004/07/26$
function dstr=parameter(inp,mode,position)
% class parameter


if nargin<1
    param.name='data structure';
    param.entries=[];
else
    if isobject(inp)
        param=inp;
    else
        if isstr(inp)
            param.name=inp;
            param.entries=[];
        else
            error('data structure must be called with a name');
        end
    end
end



% protected variables (only accessible through set/get)

% version number. 
% Version 1.0: basic functionallity works
param.version='1.0';


% these values are used when a gui is used
% that one is the default value that is given back when the gui is closed
param.default_value='';

% that one defines whether the gui is modal or not
if nargin < 2
    param.mode='nonmodal';
else
    if strcmp(mode,'modal') || strcmp(mode,'nonmodal')
        param.mode=mode;
    else
        disp('mode not recognised');
        param.mode='nonmodal';
    end
end
% data that the user can use to shift it between gui and application:
param.userdata=[];

% north - top center edge of screen 
% south - bottom center edge of screen 
% east - right center edge of screen 
% west - left center edge of screen 
% northeast - top right corner of screen 
% northwest - top left corner of screen 
% southeast - bottom right corner of screen 
% southwest - bottom left corner 
% center - center of screen 
% onscreen - nearest location with respect to current location that is on
% screen The position argument can also be a two-element vector [h,v], where depending on sign, h specifies the 
% the default position of the gui is in the top right corner
if nargin <3
    param.position='center';
else
    if strcmp(position,'north') || strcmp(position,'south') || strcmp(position,'west') || strcmp(position,'east') || strcmp(position,'northeast') || strcmp(position,'northwest') || strcmp(position,'southeast') || strcmp(position,'southwest') || strcmp(position,'center') || strcmp(position,'onscreen') 
        param.position=position;
    elseif size(position)==2
        param.position=position;
    else
        disp('position not reconised');
        param.position='center';
    end
end

% where the focus is directly after calling
param.firstfocus='';

% diosplayed when with the mouse over it
param.tooltiptext='';


% a couple of informations that are used during installations (private
% variables
param.panelinfo=[];

dstr=class(param,'parameter');



