function h=graph_and_table(x,y,colhead,vertorhoriz,figuretitle,whichgrid)
% Creates a graph and a data table below it.
% the table is put in an activex control using
% the column labels colhead
%
% NOTE: TO SEE AN EXAMPLE OF HOW TO USE THE MICROSOFT SPREADSHEET
%       OBJECT, WHICH ALLOWS INPUTS AS WELL AS CALCULATIONS, SEE
%       MY EXAMPLE CALLED "SPREADSHEET.M" WHICH IS AVAILABLE ON
%       THE MATHWORKS FILE EXCHANGE: 
%           http://www.mathworks.com/matlabcentral/fileexchange
%
% This function is meant to be an example for CSSM and not
% to be used as is.
%
% It is meant to demonstrate ActiveX grid usage and works with
% MSFLEXGRID (which comes with Windows and doesn't allow editing)
% and SIMPLE GRID (which is available for free at 
% http://adfsoft.hypermart.net/sgrid/ ).
%
% Use 'SGRID' for the whichgrid parameter to use
% simple grid, but you must first you must download it from the above
% website and register it.  To register, find sgrid.ocx by clicking on
% the windows start button and selecting "find".  Change your directory  
% to its directory and  type "regsvr32 sgrid.ocx"
%
%  ___________________      ____________________ 
% |        /\         |    |    /\   |  X   Y  ##
% |   /\  /  \/\     /|    |    ||  ||  1  1.0 ##
% |  /  \/      \_/\/ |    ||\  ||/\||  2  1.5 ##
% |_/_________________|    || | |  |||  3  2.0 ##
% |  X   Y           ||    || |/     |  4  1.6 ##
% |  1  1.0          ||    ||        |  5  2.0 ||
% |  2  1.5          ##    |         |  6  2.5 ||
% |__3__2.0__________||    |_________|__7__2.3_||
%
%    horizontal split           vertical split
%
% INPUTS       DESCRIPTION              DEFAULT VALUE
% x            x data                   [1:10]
% y            y data                    rand(size(x));
% colhead      table header              {'X','Y'};
% vertorhoriz  vert or horiz split       0 %(vertical)
% figuretitle  figure title              'graph_and_table'
% whichgrid    MSFlexGrid or Simple Grid 'MSFlexGrid'
%
% OUTPUTS:
% h.fig   handle to figure
% h.graph handle to graph
% h.line  handle to data line
% h.grid  handle to grid object
%
% USAGE:
% x=1:10;
% y=rand(size(x));
% colhead={'X','Y'};
% vertorhoriz=0; % vertical
% figuretitle='graph_and_table';
% h=graph_and_table(x,y,colhead,vertorhoriz,figuretitle);
% vertorhoriz=1; % horizontal
% h=graph_and_table(x,y,colhead,vertorhoriz,figuretitle);
% h=graph_and_table(x,y,colhead,vertorhoriz,figuretitle,'SGRID');
%
% See also: SPREADSHEET on the MATLAB File Exchange
% 
% IT'S NOT FANCY, BUT IT WORKS

% Michael Robbins, CFA
% robbins@us.cibc.com
% michael.robbins@us.cibc.com

if nargin<1 x=1:10; end;
if nargin<2 y=rand(size(x)); end;
if nargin<3 colhead={'X','Y'}; end;
if nargin<4  vertorhoriz=0; end; %(vertical)
if nargin<5  figuretitle='graph_and_table'; end;
if nargin<6  whichgrid='MSFLEXGRID'; end;

% name of the ActiveX control

switch upper(whichgrid)
	% MSFLEXGRID comes with Windows, but the grid doesn't permit
	% data entry
	case 'MSFLEXGRID', progid = 'MSFlexGridLib.MSFlexGrid.1';
	% Simple Grid is available at http://adfsoft.hypermart.net/sgrid/
	% and is freeware
	case 'SGRID', progid = 'SGRID.SgCtrl.1';
	% THESE DON'T SEEM TO WORK WELL
	%	progid = 'TranscendGridCtl.TranscendGrid';
	%	progid = 'EasyGrid.SGCtrl.32';
	%	progid = 'GridDTC.Grid';
	%	progid = 'MSGrid.Grid';
	%	progid = 'ubGridXControl.ubGridx';
end;

% Some grids have different properties than others
switch progid
    case 'MSFlexGridLib.MSFlexGrid.1',
        FONTS='CellFontName';
        NCOL='Cols';
        NROW='Rows';
        LABEL=1;
    case 'SGRID.SgCtrl.1',
        FONTS='Font';
        NCOL='LastCol'; 
        NROW='LastRow';
        LABEL=0;
    otherwise,
        FONTS='CellFontName';
        NCOL='Cols';
        NROW='Rows';
        LABEL=1;
end;


% we need to pump the data in by a for loop, which is going to take
% some time. therefore, turn visibility off until we are all
% setup.
h.fig = figure(...
    'Name',figuretitle,...
    'NumberTitle','off',...
    'Resize','off',...
    'Visible','off',...
    'Menubar','none');

% plot graph
if vertorhoriz
    h.graph=subplot(1,2,1);
else
    h.graph=subplot(2,1,1);
end;
h.line=plot(x,y);
if length(colhead)>1
    title(sprintf('%s vs. %s',colhead{1},colhead{2}));
end;

% grid position
if vertorhoriz
    htemp=subplot(1,2,2);
else
    htemp=subplot(2,1,2);
end;
set(htemp,'Units','pixels')
gposition=get(htemp,'Position');
delete(htemp);


% instantiate our control
h.grid = actxcontrol(...
    progid, gposition, h.fig);

data = [x(:) y(:)];
[L,W]=size(data);

% grow the number of rows and cols
set(h.grid,NROW,L+LABEL);
set(h.grid,NCOL,W+LABEL);

if LABEL
    % set the row data
    set(h.grid,'Col',0);
    for i = 1:L
        set(h.grid,'Row',i);
        set(h.grid,'Text',['#' num2str(i)]);
        set(h.grid,FONTS,'CourierNew');
    end;
    
    % label columns
    for i=1:length(colhead)
        set(h.grid,'Row',0);
        set(h.grid,'Col',i);
        set(h.grid,'Text',colhead{i});
        set(h.grid, FONTS,'CourierNew');
    end;
end;

% now pump in the data...
data = rand(14,2);
for j = 1:W
    set(h.grid,'Col',j);
    for i = 1:L
        set(h.grid,'Row',i);
        set(h.grid,'Text',sprintf('%7.5f',data(i,j)));
        set(h.grid,FONTS,'CourierNew');
    end;
end

% now that all of the data is in, make the figure visible
set(h.fig,'Visible','on');