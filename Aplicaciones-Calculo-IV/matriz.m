%% Import data from spreadsheet
% Script for importing data from the following spreadsheet:
%
%    Workbook: C:\Users\UNI\R.J. Briones\Libro2.xlsx Worksheet: Hoja1
%
% To extend the code to different selected data or a different spreadsheet,
% generate a function instead of a script.

% Auto-generated by MATLAB on 2012/09/12 19:53:48

%% Import the data
matriz = xlsread('C:\Users\UNI\R.J. Briones\Libro2.xlsx','Hoja1');

%% Clear temporary variables
clearvars raw;