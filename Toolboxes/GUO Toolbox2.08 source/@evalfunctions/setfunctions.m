function EF = setfunctions(EF, varargin);

% function EF = setfunctions(EF, varargin);
% 
% This method defines the functions which can be evaluated.
% The setparametertypes method must be called first.
% The functions are evaluated in the base workspace.
%
% Each element of the argument list varargin is a cell array
% of strings containing the function name as the first element
% and the parameter type names (see setparametertypes method)
% as the subsequent elements in the correct order (output
% parameters, if any, must come first).  The parameter type
% names are case-sensitive.
%
% The function name may also contain a separate description to be
% shown in the popupmenu control (otherwise the function name is used).
% The function name and description are specified as the first and
% second elements (respectively) of an item list given in any of the
% following formats:  a cell array of strings, a padded string matrix,
% or a string vector separated by vertical slash ('|') characters.
%
% Copyright (c) SINUS Messtechnik GmbH 2003
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

UserData = get(EF, 'UserData');
UserData.Functions = varargin;
UserData.FunctionNames = {};
for k = 1:length(varargin)  % Validate function definitions
   F = varargin{k};
   Flen = length(F);
   if Flen < 1 | isempty(F{1})
      error(['Name missing for function number ' num2str(k)]);
   else
      FDN = itemlist2cell(F{1});  % Function Description & Name
      UserData.FunctionNames{k} = FDN{1};
      if length(FDN) > 1
         UserData.FunctionDescriptions{k} = FDN{2};
      else
         UserData.FunctionDescriptions{k} = FDN{1};
      end
      UserData.FirstInputParameter(k) = 999;  % Default 999 when no input parameters
      ProcessingOutputParameters = 1;
      for k2 = 2:Flen
         PTnum = find(strcmp(UserData.PTName, F{k2}));
         if length(PTnum) == 0
            error(['Undefined parameter type:  parameter number ' ...
                                     num2str(k2-1) ' (' F{k2} ')' ...
                   ' of function number ' num2str(k) ' (' F{1} ').' ...
                   char(13) char(10) 'Note:  parameter type names are case-sensitive.']);
         else
            if strcmpi(UserData.PTDataType{PTnum}, 'output')
               if ~ProcessingOutputParameters
                  error(['Output parameters must come first:  parameter number ' ...
                                                    num2str(k2-1) ' (' F{k2} ')' ...
                         ' of function number ' num2str(k) ' (' F{1} ')']);
               end
            elseif ProcessingOutputParameters
               UserData.FirstInputParameter(k) = k2;
               ProcessingOutputParameters = 0;
            end
         end
      end
   end
end
% Create button and popup
FrameTag = get(EF, 'Tag');
EF = uicontrol(EF, 'Tag', 'EF_Evaluate', ...
                   'Style', 'Pushbutton', ...
                   'Visible', 'off', ...
                   'Callback', ['buttoncallback(evalfunctions, ''' FrameTag ''')']);
EF = uicontrol(EF, 'Tag', 'EF_Help', ...
                   'Style', 'Pushbutton', ...
                   'Visible', 'off', ...
                   'Callback', ['buttoncallback(evalfunctions, ''' FrameTag ''')']);
MaxWidth = 0;  % Find maximum width of function name text
for k = 1:length(UserData.FunctionDescriptions)
   EF = setchild(EF, 'EF_Evaluate', 'String', UserData.FunctionDescriptions(k));
   PBext = getchild(EF, 'EF_Evaluate', 'Extent');
   MaxWidth = max(MaxWidth, PBext(3));
end
EF = uicontrol(EF, 'Tag', 'EF_Popup', ...
                   'Style', 'PopupMenu', ...
                   'Units', 'pixels', ...
                   'Position', [0 0 80 20], ... 
                   'String', UserData.FunctionDescriptions, ...
                   'Visible', 'off', ...
                   'Callback', ['popupcallback(evalfunctions, ''' FrameTag ''')']);
EF = setchild(EF, 'EF_Popup', 'Units', 'normalized');
PMpos = getchild(EF, 'EF_Popup', 'Position');  % Down-arrow button is approx. 2/9 of width,
PMpos(3) = MaxWidth + (PMpos(3)*0.5);          % but allow a bit more for borders etc...
PMpos(2) = (1-PMpos(4)) / 2;                   % Position vertically centred
PMpos(1) = 0.001;                              % X > 0 otherwise GUO Frame covered
EF = setchild(EF, 'EF_Evaluate', 'String', 'Evaluate', ...
                                 'Position', PMpos+[0 PMpos(4) -PMpos(3)/2 0], ...
                                 'Visible', 'on');
EF = setchild(EF, 'EF_Help', 'String', 'Help', ...
                             'Position', PMpos+[PMpos(3)/2 PMpos(4) -PMpos(3)/2 0], ...
                             'Visible', 'on');
EF = setchild(EF, 'EF_Popup', 'Position', PMpos, ...
                              'Visible', 'on');
EF = uicontrol(EF, 'Tag', 'EF_Output_text', ...
                   'Style', 'Text', ...
                   'String', ' Output variables:', ...
                   'HorizontalAlignment', 'left', ...
                   'Position', PMpos-[0 PMpos(4) 0 0.15*PMpos(4)], ...
                   'Visible', 'on');
% Handles of buttons and popup (necessary for setpopupfunction)
warning off  % Integrity of graphicuserobject may be compromised - child handles accessed!
UserData.FunctionControls = setdiff(childhandles(EF), UserData.PTControls);
warning off
set(EF, 'UserData', UserData);
EF = selectcurrentfunction(EF, 1);
