%%
%% Routine: Encoded text
%% (see demo18.png) 
%%
% create encoded text as html-file

% init
eglobpar

% parameter
einit % for ePath
textFile=[ePath 'default.html'];
htmlFile='demo18.html';
password='hokuspokus simsalabim';
title='Demo of encoded text<br>as html-file';
legend='Move the mouse pointer over the lock<br> and type the password: <b>hokuspokus simsalabim</b>';

% img to html-file
etxt2shtml(textFile,htmlFile,password,title,legend);
disp('Note: switch off popup blocker for looking the encoded text!')

if ~exist('noDemoShow')
  filePath=pwd;
  ebrowse(['file:///' filePath '/' htmlFile])             % start browser 
end
