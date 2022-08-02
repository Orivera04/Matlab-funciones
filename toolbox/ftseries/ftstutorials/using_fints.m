% MATLAB Financial Time Series Toolbox 2.0
%
% Tutorial TWO:  Manipulations and Operations on FINTS objects...
%
%    Please refer to the Tutorial Section of the 
%    Financial Time Series Toolbox User's Guide for
%    a more detailed explanation of this tutorial
%    session

%   Author: P. N. Secakusuma, 01-08-98
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.10.2.1 $   $Date: 2003/01/16 12:51:29 $

%%% Start of Tutorial TWO %%%
clc
disp('   ');
disp('Tutorial TWO: Manipulations and Operations on FINTS objects...');
disp('   ');
disp('You should be able to see the contents of the objects, ');
disp('by using the scroll bar on the right.  In the event that the ');
disp('scroll bar does not allow you to see the whole contents of the ');
disp('object, you should terminate this tutorial session by pressing ');
disp('Ctrl-C command and, then, turn on the MORE feature of MATLAB by ');
disp('issuing ''more on'' at the command prompt.  Once you have that ');
disp('feature turned on, rerun this tutorial again.');
disp('   ');
disp('Good luck and enjoy...');
disp('   ');
disp('   ');
disp('   ');
disp('Press any key to continue...');
pause

%%
%% Referencing field(s) of a FINTS object
%%
clear
clc
fprintf('\nReferencing a field in a FINTS object...\n');
drawnow;
dates = (datenum('05/11/99'):datenum('05/11/99')+100)';
data_series1 = exp(randn(1, 101))';
data_series2 = exp(randn(1, 101))';
data = [data_series1 data_series2];
myfts = fints(dates, data);
fprintf('\nPress any key to see ALL contents of the object...\n');
fprintf('\n» myfts');
pause
myfts
fprintf('\nPress any key to reference SERIES2 only as another object...\n\n');
fprintf('\n» srs2 = myfts.series2');
pause
srs2 = myfts.series2
fprintf('\nPress any key to reference SERIES2 only as a vector/matrix...\n\n');
fprintf('\n» srs2_vec = fts2mat(myfts.series2)');
pause
srs2_vec = fts2mat(myfts.series2)
format long g
fprintf('\nPress any key to reference SERIES2 only as a vector/matrix with dates...\n\n');
fprintf('\n» srs2_mtx = fts2mat(myfts.series2, 1)');
pause
srs2_mtx = fts2mat(myfts.series2, 1)
format short
fprintf('\nPress any key to continue...\n');
pause

%%
%% Indexing using Date String(s).
%%
clc
fprintf('\nIndexing into a FINTS object using Date String(s)...\n');
drawnow;
fprintf('\nPress any key to index into the object with 1 (one) date string...\n\n');
fprintf('» myfts(''05/11/99'')');
pause
myfts('05/11/99')
fprintf('\nPress any key to index a data series with 1 (one) date string...\n\n');
fprintf('» myfts.series2(''05/11/99'')');
pause
myfts.series2('05/11/99')
fprintf('\nPress any key to index into the object with multiple date strings...\n\n');
fprintf('» myfts({''05/11/99'', ''05/21/99'', ''05/31/99''})');
pause
myfts({'05/11/99', '05/21/99', '05/31/99'})
fprintf('\nPress any key to index a data series with multiple date strings...\n\n');
fprintf('» myfts.series2({''05/11/99'', ''05/21/99'', ''05/31/99''})');
pause
myfts.series2({'05/11/99', '05/21/99', '05/31/99'})
fprintf('\nPress any key to continue...\n');
pause
 
%%
%% Indexing using Date String Range.
%%
clc
fprintf('\nIndexing into a FINTS object using Date String Range...\n');
drawnow;
fprintf('\nPress any key to index the object with date range string...\n\n');
fprintf('» myfts(''05/11/99::05/15/99'')');
pause
myfts('05/11/99::05/15/99')
fprintf('\nPress any key to index a data series with multiple date range string...\n\n');
fprintf('» myfts.series2(''05/11/99::05/15/99'')');
pause
myfts.series2('05/11/99::05/15/99')
fprintf('\nPress any key to continue...\n');
pause

%%
%% Indexing using Integer indexes (Array indexing).
%%
clc
fprintf('\nIndexing into a FINTS object using Integer indexes...\n');
drawnow;
fprintf('\nPress any key to index a data series with an integer...\n\n');
fprintf('» myfts.series2(1)');
pause
myfts.series2(1)
fprintf('\nPress any key to index a data series with an array of integers...\n\n');
fprintf('» myfts.series2([1, 3, 5])');
pause
myfts.series2([1, 3, 5])
fprintf('\nPress any key to index a data series with an array of integers...\n\n');
fprintf('» myfts.series2(16:20)');
pause
myfts.series2(16:20)
fprintf('\nPress any key to index an object with an array of integers...\n\n');
fprintf('» myfts(16:20)');
pause
myfts(16:20)
fprintf('\nPress any key to index an object with the END function...\n\n');
fprintf('» myfts(end)');
pause
myfts(end)
fprintf('\nPress any key to continue...\n');
pause

%%
%% List of Methods for FINTS objects.
%%
clc
fprintf('\nList of methods for FINTS object class...\n\n');
methods fints
fprintf('\n\n\n\n\nPress any key to continue...\n');
pause

%%
%% Basic Arithmetic Operations on FINTS objects.
%%
clear
clc
fprintf('\nBasic Arithmetic Operations on FINTS objects...\n');
fprintf('\n');
fprintf('\nIn this section, whenever we operate on 2 objects, they are always ');
fprintf('\nidentical.  Identical objects are objects with the same data series ');
fprintf('\nnames, dates, and frequency indicator.  Keep that in mind!!!');
fprintf('\n');
fprintf('\nPress any key to continue...\n');
pause
clc
fprintf('\nLoading data from a MAT-file called dji30Short.mat...  Please wait...\n\n');
fprintf('» load dji30short');
drawnow;
load dji30short
fprintf('\n\nPress any key to continue...\n');
pause
fprintf('\n\n\nLet''s look at the objects that we have just loaded...\n\n');
fprintf('» whos');
fprintf('\n\n');
drawnow;
whos
fprintf('\n\nPress any key to continue...\n');
pause
fprintf('\n\nCreate another FINTS object that is IDENTICAL to myfts1.\n\n');
fprintf('» newfts = fints(myfts1.dates, fts2mat(myfts1)/10000, {''Open'', ''High'', ''Low'', ''Close''}, 1, ''New FTS'');');
drawnow
newfts = fints(myfts1.dates, fts2mat(myfts1)/10000, {'Open', 'High', 'Low', 'Close'}, 1, 'New FTS');
fprintf('\n\nPress any key to continue...\n');
pause
fprintf('\n\nLet''s do some arithmetic operations to them...\n\n');
fprintf('» addup = myfts1 + newfts;')
drawnow;
addup = myfts1 + newfts;
fprintf('\n\nDisplay some of the result:\n\n');
fprintf('» addup(1:5)');
drawnow
addup(1:5)
fprintf('\n\nPress any key to continue...\n');
pause
fprintf('» subout = myfts1 - newfts;');
drawnow;
subout = myfts1 - newfts;
fprintf('\n\nDisplay some of the result:\n\n');
fprintf('» subout(6:10)');
drawnow;
subout(6:10)
fprintf('\n\nPress any key to continue...\n');
pause
fprintf('» addscalar = myfts1 + 10000;');
drawnow;
addscalar = myfts1 + 10000;
fprintf('\n\nDisplay some of the result:\n\n');
fprintf('» addscalar(11:15)');
drawnow;
addscalar(11:15)
fprintf('\n\nPress any key to continue...\n');
pause
fprintf('» submtx = myfts1 - randn(20, 4);');
drawnow;
submtx = myfts1 - randn(20, 4);
fprintf('\n\nDisplay some of the result:\n\n');
fprintf('» submtx(16:20)');
drawnow;
submtx(16:20)
fprintf('\n\nPress any key to continue...\n');
pause

% Basic Operations on non-identical objects.
clc
fprintf('\nIn this section, the 2 objects we are working with are not ');
fprintf('\nidentical.  However, they do need to have the dates and frequency ');
fprintf('\nindicators to be the same.  Keep that in mind!!!');
fprintf('\n');
fprintf('\nPress any key to continue...\n');
pause
clc
fprintf('\n\nCreate another FINTS object that is NOT identical to myfts1.\n\n');
fprintf('» newfts2 = fints(myfts1.dates, fts2mat(myfts1)/10000, {''Rat1'', ''Rat2'', ''Rat3'', ''Rat4''}, 1, ''New FTS'');');
drawnow;
newfts2 = fints(myfts1.dates, fts2mat(myfts1)/10000, {'Rat1', 'Rat2', 'Rat3', 'Rat4'}, 1, 'New FTS');
fprintf('\n\nPress any key to continue...\n\n');
pause
fprintf('\nHere, we need to use the function fts2mat to carry out the operation...\n\n');
fprintf('» addother = myfts1 + fts2mat(newfts2);')
drawnow;
addother = myfts1 + fts2mat(newfts2);
fprintf('\n\nDisplay some of the result:\n\n');
fprintf('» addother(6:15)');
drawnow;
addother(6:15)
fprintf('\n\nPress any key to continue...\n');
pause

%%
%% Box-Cox Data Trasnformation Example
%%
close all
clear
clc
fprintf('\nBox-Cox Transformation Example...\n');
fprintf('\nCalculating and Generating a figure...  Please wait...\n');
fprintf('\nOnce a figure window is displayed, please move it ');
fprintf('\nso that you can see the messages displayed in this main ');
fprintf('\nCommand Window...\n');
drawnow;

% Let's get a FINTS object into our workspace from a file
whrl = ascii2fts('whirlpool.dat', 1, 2, []);

% Fill any missing values denoted with NaN's in whrl with values 
% calculated using Linear method.
f_whrl = fillts(whrl);

% Transform the non-normally distributed filled data series, f_whrl, 
% into a normally distributed one using Box-Cox Transformation.
bc_whrl = boxcox(f_whrl);

% Let's compare the result of the Close data series with a normal 
% (Gaussian) PDF as well as the non-normally distributed f_whrl.
subplot(2, 1, 1);
hist(f_whrl.Close);
grid; title('Non-normally Distributed Data');
subplot(2, 1, 2);
hist(bc_whrl.Close);
grid; title('Box-Cox Transformed Data');

% End of Box-Cox Transformation Example.
fprintf('\nPress any key to continue...\n');
pause

%%
%% An example using the SMOOTHTS function
%%
close all
clear
clc
fprintf('\nSMOOTHTS Example...\n');
fprintf('\nCalculating and Generating a figure...  Please wait...\n');
fprintf('\nOnce a figure window is displayed, please move it ');
fprintf('\nso that you can see the messages displayed in this main ');
fprintf('\nCommand Window...\n');
drawnow;

% Import a data file into a FINTS object.
ibm = ascii2fts('ibm9599.dat', 1, 3, 2);

% Fill the holidays missing data with data interpolated using the Spline 
% method through the function FILLTS.
f_ibm = fillts(ibm, 'Spline');

% Smooth the filled data series using the default Box (rectangular window) 
% method.
sm_ibm = smoothts(f_ibm);

% Plot the original and smoothed series of one of the data series.
plot(f_ibm.CLOSE('11/01/97::02/28/98'), 'r')
datetick('x', 'mmmyy')
hold on
plot(sm_ibm.CLOSE('11/01/97::02/28/98'), 'b')
hold off
datetick('x', 'mmmyy')
legend('Filled', 'Smoothed')
title('Filled IBM CLOSE Price vs. Smoothed Series');

% End of SMOOTHTS Example.
fprintf('\nPress any key to continue...\n');
pause

%%% End of Tutorial TWO %%%
close all
clear
clc
disp('   ');
disp('End of Tutorial TWO...');
disp('   ');
disp('Tutorial THREE (tech_analysis) is about using the Technical Analysis functions...');
disp('...');
disp('   ');
disp('   ');
disp('   ');

