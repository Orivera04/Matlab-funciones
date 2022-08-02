function out = xregstepinput(fH , name , range , num , callback , varargin)
%function obj = xregstepinput(FigureHandle , 'Name' , range , num , 'Callback')
%
%FigureHandle. The Parent figure for the object.
%Name. The name of the input which will be displayed in the leftmost text-box.
%range. A two-element vector which specifies the range over which this input
%       should exist.
%num. the number of points over the range.
%callback. A callback to be executed after stepping in the range or typing in the editable box.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:32:51 $

obj = struct('text' , [] , ...
   'leftbutton' , [] , ...
   'rightbutton' , [] , ...
   'edit' , []);

if exist('fH') == 0
   fH = gcf;
end   

if ~ishandle(fH) | ~strcmp(lower(get(fH , 'type')) , 'figure')
   error('xregstepinput: First argument (figure) must be a handle to a figure.');
end

%Set up a structure which will be the editable box userdata.
edud.range = [];
edud.index = [];
edud.currstr = '';
edud.callback = [];
edud.UserData = [];

str = which('xregstepinput');
indx = find(str == filesep);
str1 = [str(1:indx(end)) 'stepinputicons.mat'];load(str1);

edud.LeftEn = LeftE;
edud.LeftDis = LeftD;
edud.RightEn = RightE;
edud.RightDis = RightD;

obj.text = xreguicontrol('parent' , fH , ...
   'backgroundcolor' , get(fH , 'color') , ...
   'style' , 'text' , ...
   'horizontalalignment' , 'left' , ...
   'visible' , 'off');

obj.leftbutton = xreguicontrol('parent' , fH , ...
   'style' , 'push' , ...
   'visible' , 'off' , ...
   'cdata' , edud.LeftEn , ...
   'callback' , ['stepLeft(get(' sprintf('%20.15f',obj.text) ',''userdata''));']);

obj.edit = xreguicontrol('parent' , fH , ...
   'style' , 'edit' , ...
   'backgroundcolor' , [1 1 1] , ...
   'visible' , 'off' , ...
   'callback' , ['typeText(get(' sprintf('%20.15f',obj.text) ',''userdata''));']);

obj.rightbutton = xreguicontrol('parent' , fH , ...
   'style' , 'push' , ...
   'visible' , 'off' , ...
   'cdata' , edud.RightEn , ...
   'callback' , ['stepRight(get(' sprintf('%20.15f',obj.text) ',''userdata''));']);

if nargin == 0
else
   if ~ischar(name)
      error('xregstepinput: Second argument (name) must be a character array.');
   end
   set(obj.text , 'string' , name);
   
   if ~isnumeric(range) | length(range) ~= 2 | diff(range) <= 0
      error('xregstepinput: Problem in range vector.');
   end
   if ~isnumeric(num) | prod(size(num)) > 1
      error('xregstepinput: Incorrect input for number of points.');
   end
   if num < 2
      num = 3;
   end
   edud.range = linspace(range(1) , range(2) , num);
   edud.index = floor(num/2);
   edud.callback = callback;
   edud.currstr = num2str(edud.range(edud.index));
   edud.enable = 1;
   set(obj.edit , 'string' , num2str(edud.range(edud.index)));
end

set(obj.edit , 'UserData' , edud);

out = class(obj , 'xregstepinput');

if nargin > 5
   out = set(out , varargin{:});
end

builtin('set' , obj.text , 'UserData' , out);
 	 