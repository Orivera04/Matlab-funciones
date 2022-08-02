%FITDEMO Nonlinear curve fit with simplex algorithm.

%	Ned Gulley, 6-21-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% Demo initialization ====================
if ~exist('SlideShowGUIFlag'), figNumber=0; end;

%	Consider the following data:
global Data
Data = ...
  [ 0.0000    5.8955
    0.1000    3.5639
    0.2000    2.5173
    0.3000    1.9790
    0.4000    1.8990
    0.5000    1.3938
    0.6000    1.1359
    0.7000    1.0096
    0.8000    1.0343
    0.9000    0.8435
    1.0000    0.6856
    1.1000    0.6100
    1.2000    0.5392
    1.3000    0.3946
    1.4000    0.3903
    1.5000    0.5474
    1.6000    0.3459
    1.7000    0.1370
    1.8000    0.2211
    1.9000    0.1704
    2.0000    0.2636];
t = Data(:,1); 
y = Data(:,2);

if ssinit(figNumber), 
    %	Let's plot this data.
    cla reset;
    axis([0 2 0 6])
    hold on
    plot(t,y,'co','EraseMode','none')
    title('Input data')

    str= ...                                                           
    [' Press the "Start" button to see a demonstration of the   '  
     ' optimal fitting of a nonlinear function to a set of data.'];
    ssdisp(figNumber,str);                                             
 
    if figNumber, return; end
end;

% Beginning of the demo ==================

str= ...                                                            
    [' This example demonstrates fitting a nonlinear function    '  
     ' to a set of data.  We''ll use a function called FMINS      '  
     ' that implements the Nelder-Mead simplex algorithm         '  
     ' for minimizing a nonlinear function of several variables. '];
ssdisp(figNumber,str);                                              

if sspause(figNumber), return; end;

str= ...                               
    ['  >> Data = ...               '  
     '          [ 0.0000    5.8955  '  
     '            ...               '  
     '            2.0000    0.2636];'  
     ' >> t = Data(:,1);            '  
     ' >> y = Data(:,2);            '  
     ' >> plot(t,y,''co'')            '];
ssdisp(figNumber,str);                 

if sspause(figNumber), return; end;

str= ...                                                           
    [' We would like to fit the following function with 2 linear'  
     ' parameters and 2 nonlinear parameters to the data:       '  
     '                                                          '  
     ' y =  c(1)*exp(-lam(1)*t) + c(2)*exp(-lam(2)*t)           '];
ssdisp(figNumber,str);                                             

if sspause(figNumber), return; end;

str= str2mat(...                                                                       
     ' To fit this function to the data, we write a function "fitfun" '  , ...
     ' that returns the error in the fit given the nonlinear parameter', ...
     ' "lam" and the data.  We can then guess for initial estimates of', ...
     ' the nonlinear parameters, and invoke FMINS.'  , ...
     '    '  , ...
     ' >> plot(t,y,''EraseMode'',''xor'')');
ssdisp(figNumber,str);

global Plothandle
Plothandle = plot(t,y,'EraseMode','xor');

if sspause(figNumber), return; end;

str= ...                                                             
    [' And the optimal curve fit occurs automatically with the use'  
     ' of the FMINS command.                                      '  
     '                                                            '  
     ' >> lam = [1 0]'';                                           '  
     ' >> trace = 0;                                              '  
     ' >> tol = .1;                                               '  
     ' >> lambda = fmins(''fitfun'',lam,[trace tol]);               '];
ssdisp(figNumber,str);

lam = [1 0]'; 
trace = 0;
tol = .1;
lambda = fmins('fitfun',lam,[trace tol]);

hold off
echo off

% End of the demo ========================

