%INTRO	Introduction to MATLAB.

%	This Expo demo adapted by ...
%	Mark W. Reichelt, 7-30-93
%	Copyright (c) 1984-94 by The MathWorks, Inc.

% Demo initialization ====================
if ~exist('SlideShowGUIFlag'), figNumber=0; end;

if ssinit(figNumber)
  cla
  load logo
  n = length(L(:,1));
  if isstudent
     k = 1:2:n; n = length(k);
     L = L(k,k); R = R(k,k);
  end
  surf(L,R), colormap(M)
  axis off, axis([1 n 1 n -.2 .35]), view(-37.5,60)
  title('MATLAB.  Picture the Power.');

  str = str2mat( ...
    ' Press the "Start" button to see a brief introduction to the', ...
    ' power of MATLAB.', ...
    '', ...
    ' Here are the MATLAB commands used to produce the picture', ...
    ' shown above.', ...
    '', ...
    ' >> load logo', ...
    ' >> surf(L,R), colormap(M)', ...
    ' >> axis off, axis([1 n 1 n -.2 .35]), view(-37.5,60)', ...
    ' >> title(''MATLAB.  Picture the Power.'');' ...
  );
  ssdisp(figNumber,str);

  if figNumber, return; end
end

% Beginning of the demo ==================


str = str2mat( ...
  ' Welcome to MATLAB. In the next few minutes, we hope to', ...
  ' show you some of the power and flexibility offered by the', ...
  ' MATLAB environment.', ...
  ' ', ...
  ' This entire demonstration (and all of Expo) is written in', ...
  ' MATLAB''s fourth generation language.', ...
  ' ', ...
  ' (See the language intro demo in Expo for a brief overview of', ...
  ' the MATLAB language and M-files.)' ...
);
ssdisp(figNumber,str);                                         

if sspause(figNumber), return; end;


xptext( ...
  '>> a = [1 2 3 4 6 4 3 4 5]', ...
  ' ', ...
  'a =', ...
  ' ', ...
  '   1   2   3   4   6   4   3   4   5' ...
);

str = str2mat( ...
  ' First, let''s create a simple vector with 9 elements called ''a''.', ...
  ' ', ...
  ' (During most of this demo, we will display the MATLAB', ...
  ' commands typed at the command line prompt ">>" and the', ...
  ' corresponding output in the figure window shown above.)' ...
);
ssdisp(figNumber,str);                                         

if sspause(figNumber), return; end;


xptext( ...
  '>> b = a + 2', ...
  ' ', ...
  'b =', ...
  ' ', ...
  '   3   4   5   6   8   6   5   6   7' ...
);

str = str2mat( ...
  ' Now let''s add 2 to each element of our vector, ''a'', and store', ...
  ' the result in a new vector.', ...
  ' ', ...
  ' Notice how MATLAB requires no special handling of vector', ...
  ' or matrix math.' ...
);
ssdisp(figNumber,str);                                         

if sspause(figNumber), return; end;


cla
a = [1 2 3 4 6 4 3 4 5];
b = a + 2;
plot(b)
grid

str = str2mat( ...
  ' Creating graphs in MATLAB is as easy as one command.', ...
  ' Let''s plot the result of our vector addition with grid lines.', ...
  ' ', ...
  ' >> plot(b)', ...
  ' >> grid' ...
);
ssdisp(figNumber,str);                                         

if sspause(figNumber), return; end;


bar(b)
xlabel('Sample #')
ylabel('Pounds')

str = str2mat( ...
  ' MATLAB can make other graph types as well, with axis', ...
  ' labels.', ...
  ' ', ...
  ' >> bar(b)', ...
  ' >> xlabel(''Sample #'')', ...
  ' >> ylabel(''Pounds'')' ...
);
ssdisp(figNumber,str);                                         

if sspause(figNumber), return; end;


plot(b,'*')
axis([0 10 0 10])

str = str2mat( ...
  ' MATLAB can use symbols in plots as well. Here is an', ...
  ' example using *''s to mark the points.  MATLAB offers a', ...
  ' variety of other symbols and line types.', ...
  ' ', ...
  ' >> plot(b,''*'')', ...
  ' >> axis([0 10 0 10])' ...
);
ssdisp(figNumber,str);                                         

if sspause(figNumber), return; end;

A = [1 2 0; 2 5 -1; 4 10 -1];
xptext( ...
  '>> A = [1 2 0; 2 5 -1; 4 10 -1]', ...
  ' ', ...
  'A =', ...
  ' ', ...
  '     1     2     0', ...
  '     2     5    -1', ...
  '     4    10    -1' ...
);

str = str2mat( ...
  ' One area in which MATLAB excels is matrix computation.', ...
  ' ', ...
  ' Creating a matrix is as easy as making a vector, using', ...
  ' semicolons (;) to separate the rows of a matrix.' ...
);
ssdisp(figNumber,str);                                         

if sspause(figNumber), return; end;


xptext( ...
  '>> B = A''', ...
  ' ', ...
  'B =', ...
  ' ', ...
  '     1     2     4', ...
  '     2     5    10', ...
  '     0    -1    -1' ...
);

str = str2mat( ...
  ' We can easily find the transpose of the matrix ''A''.' ...
);
ssdisp(figNumber,str);                                         

if sspause(figNumber), return; end;


xptext( ...
  '>> C = A * B', ...
  ' ', ...
  'C =', ...
  ' ', ...
  '     5    12    24', ...
  '    12    30    59', ...
  '    24    59   117' ...
);

str = str2mat( ...
  ' Now let''s multiply these two matrices together.', ...
  ' ', ...
  ' Note again that MATLAB doesn''t require you to deal with', ...
  ' matrices as a collection of numbers.  MATLAB knows when', ...
  ' you are dealing with matrices and adjusts your calculations', ...
  ' accordingly.' ...
);
ssdisp(figNumber,str);                                         

if sspause(figNumber), return; end;


xptext( ...
  '>> C = A .* B', ...
  ' ', ...
  'C =', ...
  ' ', ...
  '     1     4     0', ...
  '     4    25   -10', ...
  '     0   -10     1' ...
);

str = str2mat( ...
  ' Instead of doing a matrix multiply, we can multiply the', ...
  ' corresponding elements of two matrices or vectors using', ...
  ' the .* operator.' ...
);
ssdisp(figNumber,str);                                         

if sspause(figNumber), return; end;


xptext( ...
  '>> X = inv(A)', ...
  ' ', ...
  'X =', ...
  ' ', ...
  '     5     2    -2', ...
  '    -2    -1     1', ...
  '     0    -2     1' ...
);

str = str2mat( ...
  ' Let''s find the inverse of a matrix ...' ...
);
ssdisp(figNumber,str);                                         

if sspause(figNumber), return; end;


xptext( ...
  '>> I = inv(A) * A', ...
  ' ', ...
  'I =', ...
  ' ', ...
  '     1     0     0', ...
  '     0     1     0', ...
  '     0     0     1' ...
);

str = str2mat( ...
  ' ... and then illustrate the fact that a matrix times its inverse is', ...
  ' the identity matrix.' ...
);
ssdisp(figNumber,str);                                         

if sspause(figNumber), return; end;


xptext( ...
  '>> eig(A)', ...
  ' ', ...
  'ans =', ...
  ' ', ...
  '    3.7321', ...
  '    0.2679', ...
  '    1.0000' ...
);

str = str2mat( ...
  ' MATLAB has functions for nearly every type of common', ...
  ' matrix calculation.', ...
  ' ', ...
  ' There are functions to obtain eigenvalues ...' ...
);
ssdisp(figNumber,str);                                         

if sspause(figNumber), return; end;


xptext( ...
  '>> svd(A)', ...
  ' ', ...
  'ans =', ...
  ' ', ...
  '   12.3171', ...
  '    0.5149', ...
  '    0.1577' ...
);

str = str2mat( ...
  ' ... as well as the singular value decomposition.' ...
);
ssdisp(figNumber,str);                                         

if sspause(figNumber), return; end;


p = round(poly(A));
xptext( ...
  '>> p = round(poly(A))', ...
  ' ', ...
  'p =', ...
  ' ', ...
  '     1    -5     5    -1' ...
);

str = str2mat( ...
  ' The characteristic polynomial of a matrix A is', ...
  ' ', ...
  '     det(lambda*I - A)', ...
  ' ', ...
  ' The "poly" function generates a vector containing the', ...
  ' coefficients of the characteristic polynomial.' ...
);
ssdisp(figNumber,str);                                         

if sspause(figNumber), return; end;


xptext( ...
  '>> roots(p)', ...
  ' ', ...
  'ans =', ...
  ' ', ...
  '    3.7321', ...
  '    1.0000', ...
  '    0.2679' ...
);

str = str2mat( ...
  ' We can easily find the roots of a polynomial using the', ...
  ' "roots" function.', ...
  ' ', ...
  ' These are actually the eigenvalues of the original matrix.' ...
);
ssdisp(figNumber,str);                                         

if sspause(figNumber), return; end;

q = conv(p,p);
xptext( ...
  '>> q = conv(p,p)', ...
  ' ', ...
  'q =', ...
  ' ', ...
  '    1  -10   35  -52   35  -10    1' ...
);

str = str2mat( ...
  ' MATLAB has many applications beyond just matrix', ...
  ' computation.', ...
  ' ', ...
  ' To convolve two vectors ...' ...
);
ssdisp(figNumber,str);                                         

if sspause(figNumber), return; end;


r = conv(p,q);
plot(r);

str = str2mat( ...
  ' ... or convolve again', ...
  ' ', ...
  ' >> r = conv(p,q); plot(r)', ...
  ' ', ...
  ' and plot the result.' ...
);
ssdisp(figNumber,str);                                         

if sspause(figNumber), return; end;

xptext( ...
  '>> whos', ...
  'Name    Size  Elements Bytes Density Complex', ...
  ' ', ...
  '   A   3 by 3       9    72    Full    No ', ...
  '   p   1 by 4       4    32    Full    No ', ...
  '   q   1 by 7       7    56    Full    No ', ...
  '   r   1 by 10     10    80    Full    No ', ...
  ' ', ...
  'Grand total is 4 elements using 240 bytes' ...
);

str = str2mat( ...
  ' At any time, we can get a listing of the variables we have', ...
  ' stored in memory using the "who" or "whos" command.' ...
);
ssdisp(figNumber,str);                                         

if sspause(figNumber), return; end;

set(gca,'box','on')
xptext( ...
  '>> A', ...
  ' ', ...
  'A =', ...
  ' ', ...
  '     1     2     0', ...
  '     2     5    -1', ...
  '     4    10    -1' ...
);

str = str2mat( ...
  ' You can get the value of a particular variable by typing its', ...
  ' name.' ...
);
ssdisp(figNumber,str);                                         

if sspause(figNumber), return; end;


xptext( ...
  ' >> sqrt(-1), log(0)', ...
  '  ', ...
  ' ans =', ...
  '         0 + 1.0000i', ...
  ' ', ...
  ' Warning: Log of zero', ...
  ' ', ...
  ' ans =', ...
  '   -Inf' ...
);

str = str2mat( ...
  ' You can have more than one statement on a single line by', ...
  ' separating each statement with commas or semicolons.', ...
  ' ', ...
  ' If you don''t assign a variable to store the result of an operation,', ...
  ' the result is stored in a temporary variable called "ans".' ...
);
ssdisp(figNumber,str);                                         

if sspause(figNumber), return; end;


str = str2mat( ...
  ' In this case, since we separated the statements with commas,', ...
  ' the result of each operation was echoed to the screen.', ...
  ' ', ...
  ' As you can see, MATLAB easily deals with complex and', ...
  ' infinite numbers in calculations.' ...
);
ssdisp(figNumber,str);                                         

if sspause(figNumber), return; end;


cla
A = zeros(32); A(14:16,14:16) = ones(3);
y = fft2(A);
mesh(abs(y));
title('Magnitude of Two-Dimensional FFT of a Matrix')

str = str2mat( ...
  ' MATLAB has functions which make it ideal as a signal', ...
  ' processing tool.', ...
  ' ', ...
  ' For more details, see the Expo demos of the Signal', ...
  ' Processing Toolbox', ...
  ' ', ...
  ' >> A = zeros(32); A(14:16,14:16) = ones(3);', ...
  ' >> y = fft2(A);', ...
  ' >> mesh(abs(y));', ...
  ' >> title(''Magnitude of Two-Dimensional FFT of a Matrix'')' ...
);
ssdisp(figNumber,str);                                         

if sspause(figNumber), return; end;

cla
view(2)
fplot('humps',[0,2]), hold on
patch([0.5 0.5:0.01:1 1 0.5],[0 humps(0.5:0.01:1) 0 0],'r');
hold off
title('A region under an interesting function.'), grid

str = str2mat( ...
  ' MATLAB also allows you to create and analyze functions', ...
  ' easily.', ...
  ' ', ...
  ' For examples, see the Expo demo "Funfuns" under', ...
  ' MATLAB Numerics.', ...
  ' ', ...
  ' >> fplot(''humps'',[0,2]), hold on', ...
  ' >> patch([0.5 0.5:0.02:1 1 0.5],[0 humps(0.5:0.02:1) 0 0],''r'');', ...
  ' >> hold off', ...
  ' >> title(''A region under an interesting function.''), grid' ...
);
ssdisp(figNumber,str);                                         

if sspause(figNumber), return; end;

if isstudent
   cla reset
   membrane(5,10)
   
   str = str2mat( ...
     ' Thank you for participating in this introduction to MATLAB.', ...
     ' ', ...
     ' Enjoy the Expo!', ...
     ' ', ...
     ' ', ...
     ' ', ...
     ' >> cla reset', ...
     ' >> membrane(5,10)' ...
   );
else
   load clown
   cla reset
   image(X), colormap(map), axis image
   set(gca,'XTick',[],'YTick',[])
   
   str = str2mat( ...
     ' Thank you for participating in this introduction to MATLAB.', ...
     ' ', ...
     ' Enjoy the Expo!', ...
     ' ', ...
     ' ', ...
     ' ', ...
     ' >> load clown', ...
     ' >> cla reset', ...
     ' >> image(X), colormap(map), axis image', ...
     ' >> set(gca,''XTick'',[],''YTick'',[])' ...
   );
end
ssdisp(figNumber,str);                                         


% End of the demo ========================
