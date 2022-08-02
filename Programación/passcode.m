function pass = passcode(charset);
%PASSCODE  password input dialog box.
%  passcode creates a modal dialog box that returns user password input.
%  Given characters are substituted with '*'-Signs like in usual Windows dialogs.
%  
%  usage:
%  answer = PASSCODE 
%     without input parameter allows to type any ASCII-Character
%  answer = PASSCODE('digit') 
%     allows only digits as input characters [0-9]
%  answer = PASSCODE('letter')
%     allows only letters as input characters [a-z_A-Z]
%  answer = PASSCODE(<string>)
%     allows to use characters from the specified string only
%     
%  See also PCODE.

% Version: v1.2 (03-Mar-2008)
% Author:  Elmar Tarajan [MCommander@gmx.de]

if nargin==0
   charset = default;
else
   if any(strcmp({'letter' 'digit'},charset))
      charset = eval(charset);
   elseif ~isa(charset,'char')
      error('string expected. Check input parameters.')
   end% if
end% if
%
ScreenSize = get(0,'ScreenSize');
hfig = figure('Menubar','none', ...
   'Units','Pixels', ...
   'Resize','off', ...
   'NumberTitle','off', ...
   'Name',['password required'], ...
   'Position',[ (ScreenSize(3:4)-[300 75])/2 300 75], ...
   'Color',[0.8 0.8 0.8], ...
   'WindowStyle','modal');
hedit = uicontrol('Parent',hfig, ...
   'Style','Edit', ...
   'Enable','inactive', ...
   'Units','Pixels','Position',[49 28 202 22], ...
   'FontSize',15, ...
   'String',[], ...   
   'BackGroundColor',[0.7 0.7 0.7]);
hpass = uicontrol('Parent',hfig, ...
   'Style','Text', ...
   'Tag','password', ...
   'Units','Pixels','Position',[51 30 198 18], ...
   'FontSize',15, ...
   'BackGroundColor',[1 1 1]);
hwarn = uicontrol('Parent',hfig, ...
   'Style','Text', ...
   'Tag','error', ...
   'Units','Pixels','Position',[50 2 200 20], ...
   'FontSize',8, ...
   'String','character not allowed',...
   'Visible','off',...
   'ForeGroundColor',[1 0 0], ...
   'BackGroundColor',[0.8 0.8 0.8]);
%
set(hfig,'KeyPressFcn',{@keypress_Callback,hedit,hpass,hwarn,charset}, ...
         'CloseRequestFcn','uiresume')
%
uiwait
pass = get(hpass,'userdata');
delete(hfig)
  %
  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function keypress_Callback(hObj,data,hedit,hpass,hwarn,charset)
%--------------------------------------------------------------------------
pass = get(hpass,'userdata');
%
switch data.Key
   case 'backspace'
      pass = pass(1:end-1);
      %
   case 'return'
      uiresume
      return
      %
   otherwise
      try
         if any(charset == data.Character)
            pass = [pass data.Character];
         else
            set(hwarn,'Visible','on')
            pause(0.5)
            set(hwarn,'Visible','off')
         end% if
      end% try
      %
end% switch
%
set(hpass,'userdata',pass)
set(hpass,'String',char('*'*sign(pass)))
  %
  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function charset = default
%--------------------------------------------------------------------------
% charset = [letter digit '<>[]{}()@!?*#=~-+_.,;:§$%&/|\'];
charset = char(1:255);
  %
  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function charset = digit
%--------------------------------------------------------------------------
charset = '0123456789';
  %
  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function charset = letter
%--------------------------------------------------------------------------
charset = char([65:90 97:122]);
  %
  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% I LOVE MATLAB %%%