%XPGIV	Givens transformation demo for the Symbolic Math Toolbox.

%       Denise L. Chen, 8-25-93.
%	Copyright (c) 1984-94 by The MathWorks, Inc.
 
if ~exist('SlideShowGUIFlag'), figNumber=0; end;

if ssinit(figNumber),
    str= ...         
    ['                                                               '
     ' Push the "Start" button to explore the Givens transformation  '  
     ' (plane rotation through an arbitrary angle) using the Symbolic'  
     ' Math Toolbox.                                                 '];
    ssdisp(figNumber,str);                                                  
    if figNumber, return; end
end

str= ...                                                             
        [' The Givens transformation is a matrix that represents a plane'  
         ' rotation through an angle t. We use this matrix to illustrate'  
         ' some aspects of the Symbolic MathToolbox.                    '  
         '                                                              '  
         ' We first create the 2 x 2 symbolic matrix G.                 '  
         '                                                              '  
         ' >> G = sym(''[cos(t), sin(t); -sin(t), cos(t)]'')              '  
         '                                                              '  
         ' G =                                                          ' 
         '                                                              '  
         ' [  cos(t), sin(t) ]                                          '  
         ' [ -sin(t), cos(t)]                                           '  
         '                                                              '];
ssdisp(figNumber,str);
if sspause(figNumber), return; end;

str1= ...                                                             
        [' Applying the Givens transformation twice represents a          '  
         ' rotation through the angle 2*t. We can form this matrix in any '  
         ' of the following ways:                                         '  
         '                                                                '  
         ' 1. Multiply G by G                                             '  
         ' >> A = symmul(G,G)                                             '  
         '                                                                '  
         ' 2. Exponentiate G to the power 2                               '  
         ' >> A = sympow(G,2)                                             '  
         '                                                                '  
         ' 3. Concatenate the inputs and evaluate the resulting           '  
         '     expression                                                 '  
         ' >> A = symop(G,''*'',G)                                          '  
         '                                                                '  
         '                                                                '
	 ' In all three cases, we get                                     '
         '                                                                '
         ' A =                                                            '  
         '                                                                '  
         ' [cos(t)^2-sin(t)^2,    2*cos(t)*sin(t) ]                       '  
         ' [ -2*cos(t)*sin(t) , cos(t)^2-sin(t)^2]                        '  
         '                                                                '];
str2 = ' Note that A doesn''t have the same form as G.';
str = str2mat(str1,'',str2);
ssdisp(figNumber,str);
if sspause(figNumber), return; end;

str= ...                                                                
        ['                                                                     ' 
         ' We can examine alternative forms using the "simple" function.       '  
         ' "simple" tries several different algebraic simplifications of its   '  
         ' input argument and returns the shortest one. (We''ll show only a     '  
         ' few of these simplifications since they are rather long.)           '];
ssdisp(figNumber,str);
if sspause(figNumber), return; end;

str= ...                                                             
        ['  >> simple(A)                                                 '  
         '                                                               '  
         ' simplify:                                                     '  
         ' [    2*cos(t)^2-1, 2*cos(t)*sin(t) ]                          '  
         ' [-2*cos(t)*sin(t),    2*cos(t)^2-1]                           '  
         '                                                               '  
         ' combine(trig):                                                '  
         ' [ cos(2*t), sin(2*t) ]                                        '  
         ' [-sin(2*t), cos(2*t)]                                         '  
         '                                                               '  
         ' factor:                                                       '  
         '  (result)                                                     '  
         '                                                               '  
         ' convert(exp):                                                 '  
         '   (result)                                                    '  
         '                                                               '  
         ' convert(tan):                                                 '  
         '   (result)                                                    '  
         '                                                               '  
         ' ans =                                                         '  
         ' [ cos(2*t), sin(2*t) ]                                        '  
         ' [-sin(2*t), cos(2*t)]                                         '  
         '                                                               '  
         '                                                               '  
         ' "ans" contains the shortest form representation of A, which is'  
         ' also the one we wanted.                                       '];
ssdisp(figNumber,str);
if sspause(figNumber), return; end;

str= ...                                                           
        [' Since a Givens rotation is an orthogonal matrix,            '  
         ' G'' = inverse(G). Let''s verify this.                         '  
         '                                                             '  
         ' >> I = symmul(transpose(G),G)                               '  
         '                                                             '  
         ' I =                                                         '  
         '                                                             '  
         ' [cos(t)^2+sin(t)^2,                          0]             '  
         ' [                         0, cos(t)^2+sin(t)^2]             '  
         '                                                             '  
         ' We now use the two-argument form of "simple". This          '  
         ' suppresses printing of intermediate results and returns the '  
         ' shortest form found as well as the method by which it was   '  
         ' obtained.                                                   '  
         '                                                             '  
         ' >> [result, how] = simple(I)                                '  
         '                                                             '  
         ' result =                                                    '  
         '                                                             '  
         ' [1, 0]                                                      '  
         ' [0, 1]                                                      '  
         '                                                             '  
         ' how =                                                       '  
         '                                                             '  
         ' simplify                                                    '];
ssdisp(figNumber,str);
if sspause(figNumber), return; end;

str= ...                                                               
    [' Finally, we look at the eigenvalues of G using the "eigensys"'  
     ' function.                                                    '  
     '                                                              '  
     ' >> e = eigensys(G)                                           '  
     '                                                              '  
     ' e =                                                          '  
     '                                                              '  
     ' [cos(t)+1/2*(-4*sin(t)^2)^(1/2)]                             '  
     ' [cos(t)-1/2*(-4*sin(t)^2)^(1/2)]                             '  
     '                                                              '  
     '                                                              '  
     ' >> [e1, how] = simple(e)                                     '  
     '                                                              '  
     ' e1 =                                                         '  
     '                                                              '  
     ' [   exp(i*t)]                                                '  
     ' [1/exp(i*t)]                                                 '  
     '                                                              '  
     '                                                              '  
     ' how =                                                        '  
     '                                                              '  
     ' convert(exp)                                                 '  
     '                                                              '];
ssdisp(figNumber,str);                                                 
