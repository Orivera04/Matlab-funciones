function [str2,str,d] = AutoHelp(handles)
% AUTOHELP generates a helpfile automatically.
% AUTOHELP only works on GUI's.  It reads the data stored
% in HANDLES.  Look at the function SEARCHREPLACEMANYGUI
% to see how it's used.  This function is designed to
% be used by  OKDLGWITHLISTBOX which will display the help
% it in a popup window with a listbox.
%
% OKDLGWITHLISTBOX and SEARCHREPLACEMANYGUI can be found
% at the MATLAB File Exchange at www.mathworks.com
%
% INPUT
% HANDLES                  OR a filename preceeded by "-f"
%
% OUTPUT
%  STR2 = a cell array of help strings
%  STR  = a single long string of help output
%
% USAGE
% 
% OKDlgWithListBox(['This is the automatically generated help ' ...
%     'for SEARCHREPLACEMANYGUI.  It was generated using the ' ...
%     'AUTOHELP function and displayed using the OKDLGWITHLISTBOX ' ...
%     'function.  All of the above mentioned functions can be found ' ...
%     'on the MATLAB File Exchange.'], ...
%     'SearchReplaceManyGUI :: Help',AutoHelp(handles));%
% 
% ANOTHER EXAMPLE:
% 
% OKDlgWithListBox(['This is the automatically generated help ' ...
%     'for SEARCHREPLACEMANYGUI.  It was generated using the ' ...
%     'AUTOHELP function and displayed using the OKDLGWITHLISTBOX ' ...
%     'function.  All of the above mentioned functions can be found ' ...
%     'on the MATLAB File Exchange.'], ...
%     'SearchReplaceManyGUI :: Help',AutoHelp(handles));%
% 
% KEYWORDS
%    help helpdlg quesdlg grid_and_table spreadsheet question dialog
%    okdlgwithlistbox searchreplacemanygui
%
% SEE ALSO OKDLGWITHLISTBOX SEARCHREPLACEMANYGUI QUESTDLGWITHGRID
%          AUTOHELP QUESTDLG GRID_AND_TABLE SPREADSHEET
%
% IT'S NOT FANCY, BUT IT WORKS

% Michael Robbins
% MichaelRobbins1@yahoo.com
% MichaelRobbinsUsenet@yahoo.com
% robbins@bloomberg.net

ENUM = {'Tag','Type','Style','TooltipString','String'};
fn = fieldnames(handles);
idx = 0;
d=[];
for i=1:length(fn)
    try
        if ~strmatch('activex',fn{i})
            fld = getfield(handles,fn{i});
            switch  get(fld,'Type')
                % ONLY EXTRACT INFORMATION FROM CONTROLS
                case 'uicontrol',
                    % EXTRACT INFO
                    idx = idx+1;
                    for j = 1:length(ENUM)
                        d = setfield(d,{idx},ENUM{j},get(fld,ENUM{j}));
                    end;
                    switch d(idx).Style
                        % FOR CONTROLS WITH NAMES (STRINGS) PRINTED ON THEM,
                        % EXTRACT THE NAMES
                        case {'checkbox','popupmenu','pushbutton', ...
                                'radiobutton','togglebutton'},
                            name = d(idx).String;
                        % FOR CONTROLS THAT DON'T HAVE NAMES (STRINGS)
                        % PRINTED ON THEM, USE THE TAG
                        case {'edit','listbox','slider','text'},
                            if ~isempty( ...
                               regexprep(d(idx).TooltipString,'\s+',''))
                               name = d(idx).Tag;
                               % TAKE ONLY THE STUFF AFTER THE UNDERSCORE
                               % SO NAMES LIKE PUSHBUTTION_SELFDESTRUCT
                               % BECOMES SELFDESTRUCT
                               i_ = findstr(name,'_');
                               if ~isempty(i_)
                                   name = name(i_+1:end);
                               end;
                            else
                                name = 'FAIL';
                            end;
                        % FOR UNANTICIPATED CONTROLS
                        otherwise
                            name = 'FAIL';
                    end;
                    switch name
                        case 'FAIL', d(idx) = []; idx = idx-1;
                        otherwise
                            d(idx).Msg = sprintf('The %s, called "%s," : %s', ...
                                d(idx).Style,name,d(idx).TooltipString);
                    end;
            end;
        end;
    end;
end;
str = sprintf('%s\n',d(:).Msg);
str2 = {d(~cellfun('isempty',{d(:).Msg})).Msg};
