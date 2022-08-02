function display(GUO);

% function display(GUO);
% 
% Lists number, style and tag for the GUO frame, child GUOs and child objects
% of "GUO" in the MATLAB command window;  this method is executed by MATLAB
% when the GUO name is typed without a semicolon.
%
% Copyright (c) SINUS Messtechnik GmbH 2002
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

LSlen = 4;
LeftSpace = repmat(' ', 1, LSlen);
FrameStyle = 'GUO frame';
FrameTag = get(GUO.Frame, 'Tag');
Styles = {};
Tags = {};
nChildGUOs = length(GUO.ChildGUOs);
for k = 1:nChildGUOs
   Styles = [Styles {'GUO child'}];
   Tags = [Tags; {get(GUO.ChildGUOs{k}, 'Tag')}];
end
nChildren = length(GUO.Children);
if nChildren > 0
   for k = 1:nChildren
      try
         Styles = [Styles {get(GUO.Children(k), 'Style')}];
      catch
         Styles = [Styles {'axes'}];
      end
   end
   ChildTags = get(GUO.Children, 'Tag');
   if ~iscell(ChildTags)
      ChildTags = {ChildTags};  % force cell array
   end
   Tags = [Tags; ChildTags];
end
disp([inputname(1) ' =']);
FSlen = length(FrameStyle);
MaxStyleLength = max([0 cellfun('length', Styles)]);
StyleWidth = LSlen + max(FSlen, MaxStyleLength);
disp([LeftSpace 'No.  ' 'Style'    repmat(' ',1,StyleWidth-5)     'Tag']);
disp([LeftSpace '~~~  ' '~~~~~'    repmat(' ',1,StyleWidth-5)     '~~~']);
disp([LeftSpace '     ' FrameStyle repmat(' ',1,StyleWidth-FSlen) FrameTag]);
ChildNo = [1:nChildGUOs 1:nChildren];
for k = 1:(nChildGUOs+nChildren)
   disp([LeftSpace sprintf('%3u', ChildNo(k)) '  ' Styles{k} repmat(' ',1,StyleWidth-length(Styles{k})) Tags{k}]);
end
