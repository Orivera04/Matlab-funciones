function out = xregvectorinput(figH,name,vector,callback,varargin)
%function obj = xregvectorinput(FigureHandle , 'Name' , vector , 'Callback')
%
%A vector input control which will sit inside a thingy.

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.3 $  $Date: 2004/04/04 03:29:22 $

if nargin==0
   figH = gcf;
end   

if ~ishandle(figH) | ~strcmp(lower(get(figH , 'type')) , 'figure')
   error('xregvectorinput: First argument (figure) must be a handle to a figure.');
end

obj = struct('text' , [] , ...
   'edit' , []);

obj.text = xreguicontrol('parent' , figH , ...
   'backgroundcolor' , get(figH , 'color') , ...
   'string' , '' , ...
   'style' , 'text' , ...
   'horizontalalignment' , 'left' , ...
   'visible' , 'off');

obj.edit = xreguicontrol('parent' , figH , ...
   'backgroundcolor' , [1 1 1] , ...
   'string' , '' , ...
   'style' , 'edit' , ...
   'horizontalalignment' , 'left' , ...
   'callback' , ['typeText(get(' sprintf('%20.15f',obj.text) ',''userdata''));'] , ...
   'visible' , 'off');

ud.vector = [];
ud.callback = '';
ud.split = 0.4;
ud.UserData = [];

if nargin == 0
    
else
   if ~ischar(name)
      error('xregvectorinput: Second argument (name) must be a character array.');
   else
      set(obj.text , 'string' , name);
   end
   
   if ~isnumeric(vector)
      error('xregvectorinput: Third argument (vector) must be a numerical vector.');
   else
      set(obj.edit , 'string' , prettify(vector));
      ud.vector = vector;
   end
      
   if nargin>3 
       ud.callback = callback;
   end
end

set(obj.edit , 'userdata' , ud);

out = class(obj , 'xregvectorinput');

if nargin > 4
   out = set(out , varargin{:});
end

builtin('set' , obj.text , 'UserData' , out);