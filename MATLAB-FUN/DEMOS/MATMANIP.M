%MATMANIP Introduction to matrix manipulation.

%	Denise L. Chen, 7-7-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% Demo initialization ====================
if ~exist('SlideShowGUIFlag'), figNumber=0; end;

if ssinit(figNumber),
    xpsubplt(1,1,1);
    pltmat(magic(3),' ','m',18);
    set(gcf,'color',get(gcf,'color'));	% refresh the screen

    str= ...                                                   
    [' Press the "Start" button to see some basic matrix'  
     ' manipulations in MATLAB.                         '];
    ssdisp(figNumber,str);                                     
    if figNumber, return; end
end

% Beginning of the demo ==================

str= ...                                                            
    [' We start by creating a magic square and assigning it to the'  
     ' variable A.                                                '  
     '                                                            '  
     ' >> A = magic(3);                                           '];
ssdisp(figNumber,str);                                              
A = magic(3);
title('A');
set(gcf,'color',get(gcf,'color'));	% refresh the screen
if sspause(figNumber), return; end;

xpsubplt(1,1,1);
str= ...                                                 
    [' Here''s how to add 2 to each element of A.       '  
     '                                                 '  
     ' >> A+2;                                         '  
     '                                                 '  
     ' Note that MATLAB requires no special handling of'  
     ' matrix math.                                    '  
     '                                                 '];
ssdisp(figNumber,str);                                   
xpsubplt(1,2,1);
pltmat(A,'A','m',18);
xpsubplt(1,2,2);
pltmat(A+2,'A+2','r',18);
set(gcf,'color',get(gcf,'color'));	% refresh the screen
watchoff;
if sspause(figNumber), return; end;

str= ...                                                        
    [' The apostrophe symbol denotes the complex conjugate    '  
     ' transpose of a matrix.                                 '  
     '                                                        '  
     ' Here''s how to take the transpose of A.                 '  
     '                                                        '  
     ' >> A'' ;                                                '  
     '                                                        '];
ssdisp(figNumber,str);                                          
xpsubplt(1,2,2);
pltmat(A','transpose of A','r',18);
if sspause(figNumber), return; end;

xpsubplt(1,1,1);
str= ...                                                         
    [' The symbol * denotes multiplication of matrices.       '  
     '                                                        '
     ' Let''s create a new matrix B and multiply A by B.       '  
     '                                                        '  
     ' >> B = 2*ones(3);                                      '  
     ' >> A*B;                                                '  
     '                                                        '];
ssdisp(figNumber,str);                                           
B = 2*ones(3);
xpsubplt(1,3,1);
pltmat(A,'A','m',10);
xpsubplt(1,3,2);
pltmat(B,'B',[0.4 0.6 0.8],10);
xpsubplt(1,3,3);
pltmat(A*B,'A*B','r',10);
set(gcf,'color',get(gcf,'color'));	% refresh the screen

if sspause(figNumber), return; end;

str= ...                                                                                                           
    [' We can also multiply each element of A with its                                                          '  
     ' corresponding element of B by using the  .* operator.                                                    '  
     '                                                                                                          '  
     ' >> A.*B;                                                                                                 '];
ssdisp(figNumber,str);
pltmat(A.*B,'A.*B','r',10);

if sspause(figNumber), return; end;

xpsubplt(1,1,1);
str= ...                                                               
    [' MATLAB has functions for nearly every type of common         '  
     ' matrix calculation.  For example, we can find the eigenvalues'  
     ' of A using the "eig" command.                                '  
     '                                                              '  
     '  >> eig(A);                                                  '];
ssdisp(figNumber,str);                                                 
xpsubplt(1,2,1);
pltmat(A,'A','m',18);
xpsubplt(1,2,2);
pltmat(eig(A),'eigenvalues of A','r',18);
set(gcf,'color',get(gcf,'color'));	% refresh the screen
if sspause(figNumber), return; end;

xpsubplt(1,1,1);
str= ...                                                     
    [' This concludes our brief tour of some MATLAB matrix '  
     ' handling capabilities.                              '  
     '                                                     '];
ssdisp(figNumber,str);                                       
pltmat(magic(3),' ','m',18);
set(gcf,'color',get(gcf,'color'));	% refresh the screen

% End of the demo ========================
