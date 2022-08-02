function EF = setparametertypes(EF, varargin);

% function EF = setparametertypes(EF, varargin);
% 
% This method defines the parameter types which can be passed
% to the various functions defined by the setfunctions method,
% together with their associated input controls.  It must be
% called before calling the setfunctions method.
%
% Each element of the argument list varargin is a cell array
% of strings containing the parameter type name as the first
% element and the parameter data type as the second element;
% subsequent elements are passed to uicontrol as property pairs
% when creating the associated input control.
%
% The parameter type name (case-sensitive) is used in three ways:
% as the tag name of the input control, as the text labelling the
% input control, and in the function definitions passed to the
% setfunctions method.
%
% The parameter data type must be one of 'String', 'Number', 'Array'
% 'Reference' or 'Output' (not case-sensitive).  This controls how the
% parameter will be passed to the called function:  strings are quoted,
% numbers are not, arrays are passed within [brackets], reference
% parameters are names of variables existing in the base workspace,
% and output parameters are names of variables created in the base
% workspace to receive the function results (default 'ans').
%
% The parameter data type may also be qualified with a display expression,
% e.g. 'Output|dec2hex($ + ($<0)*2^32)' (or in one of the other list formats
% as described below for translation lists).  The dollar sign ($) defines
% where the parameter value is to be substituted and must appear at least
% once in the display expression.  The result of the display expression is
% displayed as the TooltipString for the parameter type's uicontrol.
% If no display expression is supplied, the parameter value is displayed.
%
% The property pairs passed to uicontrol are used as specified except
% that the tag name is always the parameter type name and the position
% is automatically generated (the width and height can be specified if
% desired).  Usable default values are supplied (edit style) so that
% it is not necessary to supply the property pairs.  For 'Reference' and
% 'Output' parameters, the 'String' property (i.e. the name of the output
% or reference variable) defaults to the parameter type name.
%
% A special feature for listbox and popupmenu style uicontrols is that a
% translation list can be specified, allowing the displayed values to be
% substituted by other values which are actually passed as parameters. 
% Typically, this is used to relate meaningful names to internally-defined
% program constants.  The translation list must have the same number of
% elements as the String property, can be specified in the same ways (as a
% cell array of strings, as a padded string matrix, or as a string vector
% separated by vertical slash ('|') characters), and is held in the
% UserData property of the uicontrol.
%
% Copyright (c) SINUS Messtechnik GmbH 2003
% www.sinusmess.de - Sound & Vibration Instrumentation
%                  - PCB Services
%                  - Electronic Design & Production

UserData = get(EF, 'UserData');
UserData.ParameterTypes = varargin;
% Also change buttoncallback.m & evaltooltips.m if AllowedDataTypes changed...
AllowedDataTypes = {'string', 'number', 'array', 'reference', 'output'};
ADTNames = '';
for k = 1:length(AllowedDataTypes)
   ADTNames = [ADTNames ' ' AllowedDataTypes{k}];
end
FrameTag = get(EF, 'Tag');
DefaultParamPairs = {'Visible', 'off', ...
                     'Style', 'edit', ...
                     'Units', 'pixels', ...
                     'Position', [0 0 80 20], ...
                     'Callback', ['parametercallback(evalfunctions, ''' FrameTag ''')']};
for k = 1:length(varargin)
   PT = varargin{k};
   if length(PT) < 1 | isempty(PT{1})
      error(['Name missing for parameter type number ' num2str(k)]);
   elseif length(PT) < 2 | isempty(PT{2})
      error(['Data type missing for parameter type number ' num2str(k) ' (' PT{1} ')']);
   elseif find(strcmp(UserData.PTName, PT{1}))
      error(['Name of parameter type number ' num2str(k) ' (' PT{1} ') ' ...
             'already used for parameter type number ' num2str(find(strcmp(UserData.PTName, PT{1})))]);
   else
      PTN = PT{1};
      UserData.PTName{k} = PTN;
      DTcell = itemlist2cell(PT{2});
      DT = lower(DTcell{1});
      if strmatch(DT, AllowedDataTypes, 'exact')
         UserData.PTDataType{k} = DT;
         if length(DTcell) > 1
            if length(DTcell) > 2
               error(['Too many data type qualifiers (' num2str(length(DTcell) - 1) ...
                      ') for parameter type number ' num2str(k) ' (' PTN ') - ' ...
                      'only display expression is allowed']);
            else
               if isempty(strfind(DTcell{2}, '$'))
                  error(['Display expression "' DTcell{2} '" for parameter type number ' num2str(k) ' (' PTN ') ' ...
                         'must contain at least one dollar sign ($) to be substituted']);
               end
            end
         end
         UserData.PTDataTypeQualifier{k} = DTcell(2:end);  % Leave open for future qualifiers...
      else
         error(['Invalid data type (' PT{2} ') for parameter type number ' num2str(k) ' (' PTN ').' ...
                char(13) char(10) 'Valid data types are: '  ADTNames]);
      end
      switch DT
      case {'number', 'array'}
         HAlign = 'right';
      otherwise
         HAlign = 'left';
      end
      ParamPairs = [DefaultParamPairs {'HorizontalAlignment', HAlign, 'Tag', PTN}];
      EF = uicontrol(EF, ParamPairs{:});
      if length(PT) > 2
         EF = setchild(EF, PTN, PT{3:end});
         ControlStyle = getchild(EF,PTN,'Style');
         if strcmpi(ControlStyle, 'listbox') | strcmpi(ControlStyle, 'popupmenu')
            U = getchild(EF, PTN, 'UserData');
            if ~isempty(U)
               if ~iscell(U)
                  U = itemlist2cell(U);  % Translation list held as cell array
                  EF = setchild(EF, PTN, 'UserData', U);
               end
               L = length(itemlist2cell(getchild(EF, PTN, 'String')));
               if L ~= length(U)
                  error(['Invalid translation list (UserData property) for parameter type number ' num2str(k) ' (' PTN ')' ...
                         char(13) char(10) num2str(length(U)) ' items in UserData but ' num2str(L) ' in String property']);
               end
            end
         end
      end
      EF = setchild(EF, PTN, 'Units', 'normalized');
      Cpos = getchild(EF, PTN, 'Position');
      EF = setchild(EF, PTN, 'Position', Cpos);
      switch DT
      case {'output', 'reference'}
         if isempty(getchild(EF, PTN, 'String'))
            EF = setchild(EF, PTN, 'String', PTN);
         end
      end
      if strcmpi(DT, 'output')
         UserData.PTNameText{k} = '';
      else
         PTNtext = [PTN '_EF_Text'];
         UserData.PTNameText{k} = PTNtext;
         EF = uicontrol(EF, 'Tag', PTNtext, 'Visible', 'off', ...
                            'Style', 'Text', 'String', PTN, ...
                            'Position', Cpos+[0 Cpos(4) 0 0]);
      end
   end
end
warning off  % Integrity of graphicuserobject may be compromised - child handles accessed!
UserData.PTControls = childhandles(EF);  % Necessary for callback functions...
warning on
evaltooltips(UserData, UserData.PTName);
set(EF, 'UserData', UserData);
