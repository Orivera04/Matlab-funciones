% MATLAB Financial Time Series Toolbox 2.0
%
% Tutorial ONE:  Creating and displaying FINTS objects...
%
%    Please refer to the Tutorial Section of the 
%    Financial Time Series Toolbox User's Guide for
%    a more detailed explanation of this tutorial
%    session

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.8 $   $Date: 2002/01/21 12:32:28 $

%%% Start of Tutorial ONE %%%
clc
disp('   ');
disp('Tutorial ONE: Creating and displaying FINTS objects...');
disp('   ');
disp('You should be able to see the contents of the objects, ');
disp('by using the scroll bar on the right.  In the event that the ');
disp('scroll bar does not allow you to see the whole contents of the ');
disp('object, you should terminate this tutorial session by pressing ');
disp('Ctrl-C command and, then turn on the MORE feature of MATLAB by ');
disp('issuing ''more on'' at the command prompt.  Once you have that ');
disp('feature turned on, rerun this tutorial again.');
disp('   ');
disp('Good luck and enjoy...');
disp('   ');
disp('   ');
disp('   ');
disp('Press any key to continue...');
pause

%%%
%%% Creating a FINTS object NOT from a text data file.
%%%

%% Syntax 1:  1 (one) data series.
clc
fprintf('\nBuilding a FINTS object using Syntax #1 w/ 1 series...\n');
fprintf(['\nSyntax:\n\n', ...
        '» tsobj = fints(dates_and_data)\n']);
fprintf(['\nExample:\n\n', ...
        '» date_series = (today:today+100)'';\n', ...
        '» data_series = exp(randn(1, 101))'';\n', ...
        '» dates_and_data = [date_series data_series];\n\n', ...
        '» fts1 = fints(dates_and_data)\n']);
drawnow;
date_series = (today:today+100)';
data_series = exp(randn(1, 101))';
dates_and_data = [date_series data_series];
fts1 = fints(dates_and_data);
fprintf('\nPress any key to see the contents of the object...\n');
pause
fts1
fprintf('\nPress any key to continue...\n');
pause

%             2 (two) data series.
clc
fprintf('\nBuilding a FINTS object using Syntax #1 w/ 2 series and time...\n');
fprintf(['\nSyntax:\n\n', ...
        '» tsobj = fints(dates_times_and_data)\n']);
fprintf(['\nExample:\n\n', ...
        '» date_series = (now:now+100)'';\n', ...
        '» data_series1 = exp(randn(1, 101))'';\n', ...
        '» data_series2 = exp(randn(1, 101))'';\n', ...
        '» dates_and_data = [date_series data_series1 data_series2];\n\n', ...
        '» fts2 = fints(dates_and_data)\n']);
drawnow;
date_series = (now:now+100)';
data_series1 = exp(randn(1, 101))';
data_series2 = exp(randn(1, 101))';
dates_and_data = [date_series data_series1 data_series2];
fts2 = fints(dates_and_data);
fprintf('\nPress any key to see the contents of the object...\n');
pause
fts2
fprintf('\nPress any key to continue...\n');
pause

%             Change the frequency of the object fts.
fprintf('\nChanging frequency indicator of the object fts2...\n');
fprintf('\n» fts2.freq = 1;');
drawnow;
fts2.freq = 1;   % or,  fts2.freq = 'daily';
fprintf('\n\nPress any key to see the contents of the object...\n');
pause
fts2
fprintf('\nPress any key to continue...\n');
pause

%% Syntax 2:  2 (two) data series
clc
fprintf('\nBuilding a FINTS object using Syntax #2 w/ 2 series...\n');
fprintf(['\nSyntax:\n\n', ...
        '» tsobj = fints(dates, data)\n']);
fprintf(['\nExample:\n\n', ...
        '» dates = (today:today+100)'';\n', ...
        '» data_series1 = exp(randn(1, 101))'';\n', ...
        '» data_series2 = exp(randn(1, 101))'';\n', ...
        '» data = [data_series1 data_series2];\n\n', ...
        '» fts = fints(dates, data)\n']);
drawnow;
dates = (today:today+100)';
data_series1 = exp(randn(1, 101))';
data_series2 = exp(randn(1, 101))';
data = [data_series1 data_series2];
fts = fints(dates, data);
fprintf('\nPress any key to see the contents of the object...\n');
pause
fts
fprintf('\nPress any key to continue...\n');
pause

%% Syntax 3:  1 (one) data series
clc
fprintf('\nBuilding a FINTS object using Syntax #3 w/ 1 series...\n');
fprintf(['\nSyntax:\n\n', ...
        '» tsobj = fints(dates, data, datanames)\n']);
fprintf(['\nExample:\n\n', ...
        '» dates = (today:today+100)'';\n', ...
        '» data = exp(randn(1, 101))'';\n', ...
        '» fts1 = fints(dates, data, {''First''})\n']);
drawnow;
dates = (today:today+100)';
data = exp(randn(1, 101))';
fts1 = fints(dates, data, {'First'});
fprintf('\nPress any key to see the contents of the object...\n');
pause
fts1
fprintf('\nPress any key to continue...\n');
pause

%             2 (two) data series
clc
fprintf('\nBuilding a FINTS object using Syntax #3 w/ 2 series and time...\n');
fprintf(['\nSyntax:\n\n', ...
        '» tsobj = fints(dates, data, datanames)\n']);
fprintf(['\nExample:\n\n', ...
        '» dates = (now:now+100)'';\n', ...
        '» data_series1 = exp(randn(1, 101))'';\n', ...
        '» data_series2 = exp(randn(1, 101))'';\n', ...
        '» data = [data_series1 data_series2];\n\n', ...
        '» fts2 = fints(dates, data, {''First'', ''Second''})\n']);
drawnow;
dates = (now:now+100)';
data_series1 = exp(randn(1, 101))';
data_series2 = exp(randn(1, 101))';
data = [data_series1 data_series2];
fts2 = fints(dates, data, {'First', 'Second'});
fprintf('\nPress any key to see the contents of the object...\n');
pause
fts2
fprintf('\nPress any key to continue...\n');
pause

%% Syntax 4:  2 (two) data series
clc
fprintf('\nBuilding a FINTS object using Syntax #4...\n');
fprintf(['\nSyntax:\n\n', ...
        '» tsobj = fints(dates, data, datanames, freq)\n']);
fprintf(['\nExample:\n\n', ...
        '» dates = (now:now+100)'';\n', ...
        '» data_series1 = exp(randn(1, 101))'';\n', ...
        '» data_series2 = exp(randn(1, 101))'';\n', ...
        '» data = [data_series1 data_series2];\n\n', ...
        '» fts = fints(dates, data, {''First'', ''Second''}, 1)\n']);
drawnow;
dates = (now:now+100)';
data_series1 = exp(randn(1, 101))';
data_series2 = exp(randn(1, 101))';
data = [data_series1 data_series2];
fts = fints(dates, data, {'First', 'Second'}, 1);
fprintf('\nPress any key to see the contents of the object...\n');
pause
fts
fprintf('\nPress any key to continue...\n');
pause

%% Syntax 5:  2 (two) data series
clc
fprintf('\nBuilding a FINTS object using Syntax #5...\n');
fprintf(['\nSyntax:\n\n', ...
        '» tsobj = fints(dates, data, datanames, freq, desc)\n']);
fprintf(['\nExample:\n\n', ...
        '» dates = (today:today+100)'';\n', ...
        '» data_series1 = exp(randn(1, 101))'';\n', ...
        '» data_series2 = exp(randn(1, 101))'';\n', ...
        '» data = [data_series1 data_series2];\n\n', ...
        '» fts = fints(dates, data, {''First'', ''Second''}, 1, ''Test TS'')\n']);
drawnow;
dates = (today:today+100)';
data_series1 = exp(randn(1, 101))';
data_series2 = exp(randn(1, 101))';
data = [data_series1 data_series2];
fts = fints(dates, data, {'First', 'Second'}, 1, 'Test TS');
fprintf('\nPress any key to see the contents of the object...\n');
pause
fts
fprintf('\nPress any key to continue...\n'); 
pause

%%%
%%% Creating a FINTS object FROM a text data file.
%%%

%% The ASCII data file is DISNET.DAT.
clc
fprintf('Building a FINTS object from an ASCII data file...\n');
fprintf(['\nSyntax:\n\n', ...
        '» tsobj = ascii2fts(filename, descrow, colheadrow, skiprows)\n']);
fprintf(['\nExample:\n\n', ...
        '» disfts = ascii2fts(''disney.dat'', 1, 3, 2)\n\n']);
drawnow;
disfts = ascii2fts('disney.dat', 1, 3, 2);
fprintf('\nPress any key to see the contents of the object...\n');
pause
fprintf('\nPlease wait...\n');
drawnow;
disfts
fprintf('\nPress any key to continue...\n'); 
pause

%%% End of Tutorial ONE %%%
clc
disp('   ');
disp('End of Tutorial ONE...');
disp('   ');
sprintf(['Tutorial TWO (using_fints) is about what you can do\n', ...
        'with the object once you have it...']);
disp('...');
disp('   ');
disp('   ');
disp('   ');


