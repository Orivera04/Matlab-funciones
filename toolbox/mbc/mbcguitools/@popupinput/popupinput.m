function out = popupinput(figH,name,string,callback,varargin)
% POPUPINPUT Constructor
%
% PP = POPUPINPUT( FIG, NAME, STRING, CALLBACK, VARARGIN )
%
% The String sits in popup menu.  If string is a cell, and string{1} is numeric,
%   that is taken as the value for the menu.
%

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.3.2.4 $  $Date: 2004/02/09 07:20:20 $

if exist('figH') == 0
   figH = gcf;
end   

if ~ishandle(figH) | ~strcmp(lower(get(figH , 'type')) , 'figure')
   error('PopupInput: First argument (figure) must be a handle to a figure.');
end

obj = struct('text' , [] , ...
   'popup' , []);

obj.text = uicontrol('parent' , figH , ...
   'backgroundcolor' , get(figH , 'color') , ...
   'string' , '' , ...
   'style' , 'text' , ...
   'horizontalalignment' , 'left' , ...
   'visible' , 'off');

obj.popup = uicontrol('parent' , figH , ...
   'backgroundcolor' , [1 1 1] , ...
   'string' , '' , ...
   'style' , 'popup' , ...
   'horizontalalignment' , 'left' , ...
   'callback' , ['ListSelect(get(' sprintf('%20.15f',obj.text) ',''userdata''));'] , ...
   'visible' , 'off');

ud.split = 0.5;
ud.vector = [];
ud.callback = '';
ud.UserData = [];

if nargin == 0
else
   if ~ischar(name)
      error('PopupInput: Second argument (name) must be a character array.');
   else
      set(obj.text , 'string' , name);
   end
   
   if ~ischar(string) & ~iscell(string)
      error('PopupInput: Third argument (string) must be a string or cell array.');
  else
      num = 1;
      if iscell(string) & isnumeric(string{1})
          num = string{1};
          string = {string{2:end}};
      end
      set(obj.popup , 'string' , string,'value',num);
      ud.string = string;
   end
      
   if ~ischar(callback)
      error('PopupInput: Fourth argument (callback) must be a character array.');
   else
      ud.callback = callback;
   end  
end

set(obj.popup , 'userdata' , ud);

out = class(obj , 'popupinput');

if nargin > 4
   out = set(out , varargin{:});
end

builtin('set' , obj.text , 'UserData' , out);