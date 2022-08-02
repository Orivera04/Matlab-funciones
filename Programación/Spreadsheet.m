function Spreadsheet1=Spreadsheet
% SPREADSHEET is an example of how to use
% the Microsoft Office Spreadsheet Object.
%
% This example, in response to the CSSM thread "ActiveX (Microsoft Office
% Spreadsheet)," demonstrates how to use the MS Office Spreadsheet object
% to display cell, character, logical and numeric matricies.  It also
% demonstrates how to use an enumerated class workaround and how to
% get the active cell, sheet, row and column from the spreadsheet.
% Various other methods and properties are explored and demonstrated.
% Much has been lifted from ML examples.
%
% The Microsoft Office Spreadsheet object allows inputs and calcuations.
%
% NOTE: TO SEE AN EXAMPLE OF HOW TO USE GRID OBJECTS WHICH HAVE
%       SOME ADVANTAGES OVER THE MICROSOFT SPREADSHEET OBJECT,  SEE
%       MY EXAMPLE CALLED "GRAPH_AND_TABLE" WHICH IS AVAILABLE ON
%       THE MATHWORKS FILE EXCHANGE: 
%           http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=3477&objectType=file 
%       ALSO SEE THREE PROGRAMS THAT MAKES EXTENSIVE USE OF SPREADSHEET:
%       DATABASEEDITINGTOOL
%       DUPLICATEFILEFINDER
%       FILLSPREADSHEET
%
% NOTE: If you cannot instantiate the control, try changing 
%       'OWC11.Spreadsheet.11' to 'OWC10.Spreadsheet.10' or even
%       'OWC9.Spreadsheet.9'
%
% See Also: Grid_and_Table at the MATLAB File Exchange
%           http://www.mathworks.com/matlabcentral/fileexchange
%           DatabaseEditingTool
%           DuplicateFileFinder
%           FillSpreadsheet
%
% Keywords: grid spreadsheet ActiveX Active-X Active X GUI Table
%           graph_and_table plot graph table grid object flexgrid
%           msflexgrid ocx tabular
%
% Thanks: TMW, Max Chtangeev, useActiveXControl, Brett Shoelson

% IT'S NOT FANCY, BUT IT WORKS
% Michael Robbins
% robbins@bloomberg.net
% michaelrobbins1@yahoo.com
% 2/7/05

% Here are a list of propertes, methods and events I got from
% http://msdn.microsoft.com/library/default.asp?url=/library/en-us/owcvba11/html/ocobjSpreadsheet.asp
%
% Properties:
% ActiveCell Property, ActiveSheet Property, ActiveWindow Property,
% ActiveWorkbook Property, AllowPropertyToolbox Property, Application
% Property, AutoFit Property, Build Property, BuildNumber Property,
% Calculation Property, CalculationVersion Property, CanUndo Property,
% Caption Property, Cells Property, Columns Property, Commands Property,
% Constants Property, CSVData Property, CSVURL Property, DataMember
% Property, DataSource Property, DataType Property, DefaultQueryOnLoad
% Property, DesignMode Property, Dirty Property, DisplayDesignTimeUI
% Property, DisplayOfficeLogo Property, DisplayPropertyToolbox Property,
% DisplayTitleBar Property, DisplayToolbar Property, EnableEvents
% Property, EnableUndo Property, HTMLData Property, HTMLURL Property,
% International Property, LanguageSettings Property, MajorVersion
% Property, MaxHeight Property, MaxWidth Property, MinorVersion Property,
% MoveAfterReturn Property, MoveAfterReturnDirection Property, Name
% Property, Names Property, Range Property, RevisionNumber Property,
% RightToLeft Property, Rows Property, ScreenUpdating Property,
% Selection Property, Sheets Property, TitleBar Property, Toolbar
% Property, Value Property, Version Property, ViewOnlyMode Property,
% Windows Property, Workbooks Property, Worksheets Property, XMLData
% Property, XMLURL Property 
%
% Methods:
% AddIn Method, BeginUndo Method, Calculate Method, CalculateFull Method,
% EndUndo Method, Evaluate Method, Export Method, FireParametersOut
% Method, RectIntersect Method, RectUnion Method, Refresh Method,
% Repaint Method, ShowAbout Method, ShowContextMenu Method, ShowHelp
% Method, Undo Method, UpdatePropertyToolbox Method
%
% Events:
% BeforeContextMenu Event, BeforeKeyDown Event, BeforeKeyPress Event,
% BeforeKeyUp Event, BindingAdded Event, BindingCompleted Event,
% BindingDeleted Event, BindingError Event, BindingUpdated Event, Click
% Event, CommandBeforeExecute Event, CommandChecked Event,
% CommandEnabled Event, CommandExecute Event, CommandTipText Event,
% DblClick Event, EndEdit Event, Initialize Event, KeyDown Event,
% KeyPress Event, KeyUp Event, LoadCompleted Event, MouseDown Event,
% MouseOut Event, MouseOver Event, MouseUp Event, MouseWheel Event,
% ParametersOutReady Event, RowReady Event, SelectionChange Event,
% SelectionChanging Event, SheetActivate Event, SheetCalculate Event,
% SheetChange Event, SheetDeactivate Event, SheetFollowHyperlink Event,
% StartEdit Event, ViewChange Event
%
% Parent Objects: 
%
% Child Objects:
% Names Object, OCCommands Object, OWCLanguageSettings Object, Range
% Object, Sheets Object, TitleBar Object, Window Object, Windows Object,
% Workbook Object, Workbooks Object, Worksheet Object, Worksheets
% Object


% INSTANTIATE THE CONTROL
h.f  = figure;
psn  = get(h.f,'Position');
%Spreadsheet1 = actxcontrol('OWC9.Spreadsheet.9',[0 0 psn(3:4)]);
%Spreadsheet1 = actxcontrol('OWC10.Spreadsheet.10',[0 0 psn(3:4)]);
Spreadsheet1 = actxcontrol('OWC11.Spreadsheet.11',[0 0 psn(3:4)]);

% USE AN ENUMERATED TYPE WORKAROUND
ClassEnumType = {'cell','char','logical','numeric'};

% FIND THE ACTIVE SHEET
ActSheet = get(Spreadsheet1,'ActiveSheet');

% FIND THE ACTIVE CELL, ROW AND COLUMN
% THIS IS NOT NECESSARY, BUT IT IS DONE FOR DEMONSTRATION
ActCell = get(Spreadsheet1,'ActiveCell');
ActCellRow = get(ActCell,'Row');
ActCellColumn = get(ActCell,'Column');

% SET COLUMN WIDTH
ActCell.ColumnWidth = 14;

% SET ROW HEIGHT
ActCell.RowHeight = 21;

% LOOP THROUGH THE FOUR CLASS TYPES
for i=1:length(ClassEnumType)
    switch ClassEnumType{i}
        case 'cell', M={'one','two','three';'four','five','six'};
        case 'char', M='This is a string';
        case 'logical', M=rand(3)>0.5;
        case 'numeric', M=magic(3);
        otherwise, errordlg('loop exceeds maximum');
    end
           
    [L,W] = size(M);
    
    for r = 1:L
        for c = 1:W

            % Select current cell
            XLfmt = nn2an(ActCellRow+r-1,ActCellColumn+c-1);
            Select(Range(ActSheet,XLfmt));

            % Assign value
            ActCell = get(Spreadsheet1,'ActiveCell');
            switch class(M)
                case 'cell',  set(ActCell,'Value',M{r,c});
                case 'char',  set(ActCell,'Value',M(r,:)); break;
                case 'logical', set(ActCell,'Value',M(r,c));
                otherwise
                    if isnumeric(M)
                        set(ActCell,'Value',M(r,c));
                    else
                        errordlg('bad class');
                    end
            end

            % Re-select starting cell
            XLfmt = nn2an(ActCellRow,ActCellColumn);
            Select(Range(ActSheet,XLfmt));

        end
    end
    
    % SKIP A ROW
    ActCellRow = ActCellRow + r + 2;
end

% GET VALUE
ActCellValue = get(ActCell,'Value');

% FIND
ActCellIs8 = Find(ActCell,'8');
ActCellIs2 = Find(ActCell,'2');

% CLEAR CELL CONTENTS
ActCell.Clear;

% DRAW A BORDER AROUND A SELECTION
ActCell.BorderAround;

% ENTER AND CALCULATE AN ALGEBRAIC EQUATION
ActCell.Value = '=5*6';

% COPY FROM A1 TO A3
Select(Range(ActSheet,'A1'));
ActCell = get(Spreadsheet1,'ActiveCell');
ActCell.Copy;
Select(Range(ActSheet,'A3'));
ActCell = get(Spreadsheet1,'ActiveCell');
ActCell.Paste;

% CUT FROM B1 AND PASTE TO B3
Select(Range(ActSheet,'B1'));
ActCell = get(Spreadsheet1,'ActiveCell');
ActCell.Cut;
Select(Range(ActSheet,'B3'));
ActCell = get(Spreadsheet1,'ActiveCell');
ActCell.Paste;


%---------------------------

function cr = nn2an(r,c)
% Thanks Brett Shoelson

t = [floor((c - 1)/26) + 64 rem(c - 1, 26) + 65];
if(t(1)<65), t(1) = []; end
cr = [char(t) num2str(r)];

