%%
%% Routine: Encoded image
%% (see demo17.png) 
%%
% create encoded image as html-file
eglobpar


% parameter
einit % for ePath
imageFile=[ePath 'default.jpg'];
htmlFile='demo17.html';
password='hokuspokus simsalabim';
title='Demo of encoded image<br>as html-file';
text='Move the mouse pointer over the lock<br> and type the password: <b>hokuspokus simsalabim</b>';

% img to html-file
eimg2shtml(imageFile,htmlFile,password,title,text);

if ~exist('noDemoShow')
  filePath=pwd;
  ebrowse(['file:///' filePath '/' htmlFile])             % start browser 
end
