echo on

% ***********************************************************************
%                   INTRODUCTION TO MATLAB
% ***********************************************************************

% Matlab is a system for doing numerical and graphical computation.
% It was initially written to provide a interface for the LINPACK
% and EISPACK linear algebra packages.  It has evolved over the years
% to become one of the premier high level languages for doing
% mathematical computation. 

% The goal of this tutorial to describe some basic features of the
% Matlab language with particular emphasis on its abilities in the
% areas of data manipulation, data analysis, and graphing.

%***********************************************************************
%                           NOTE
%-----------------------------------------------------------------------
%        WHENEVER YOU SEE THE WORD PAUSE THE M-FILE WILL PAUSE
%        PRESS ANY KEY TO CONTINUE.
%***********************************************************************

pause

%------------------------------------------------------------------------
%                           MATRIX
%------------------------------------------------------------------------
% The basic structure in Matlab is a matrix.  Let's look at a dataset
% that is discussed in Chapters 3 and 4.  For 30 students in a statistics
% class, we record the grade (A, B, C, D, F) and the score on the SAT
% exam that was taken during high school.  

% We represent this data by a matrix named 'class' that consists of 30 rows
% and 2 columns -- the first column contains the grades (coded 1 = F, 2 = D,
% 3 = C, 4 = B, 5 = A) and the second column contains the SAT scores.

% We use square brackets are used to describe the matrix.  Carriage
% returns to describe different rows.  Alternatively, a semicolon
% can be used to separate rows. Thee command is concluded with
% a semicolon.  

echo off

class=[ 3   525
        2   533
        3   545
        4   582
        2   581
        1   576
        3   572
        4   609
        2   559
        1   543
        3   576
        4   525
        0   574
        1   582
        2   574
        3   471
        3   595
        2   557
        4   557
        4   584
        3   599
        2   517
        4   649
        2   584
        1   463
        3   591
        2   488
        3   563
        3   553
        4   549 ];

echo on
pause

% We display 'class' by typing it without a semicolon at the end.

class

pause


%------------------------------------------------------------------------
%                        MATRIX MANIPULATIONS
%------------------------------------------------------------------------		
% Let's illustrate some basic manipulations of this data matrix.

% We define a list of numbers by a colon:

1:5

pause

% We look at the data for students 1-5 by use of the command

class(1:5,:)

pause

% Here we are extracting rows 1-5 and all columns (indicated by a :).
% Similarly, suppose we wish to extract the first column of the
% data matrix and assign it a column vector called 'grade'.  We extract
% the second column of 'class' and assign it to a variable called 'sat'.

grade=class(:,1); sat=class(:,2);

pause

% Note that we can have multiple statements on a line -- we separate the
% statements by ; (or ,)

% We can perform various computations on vectors and matrices.

% Suppose that we wish to scale the grades by multiplying by 10 and adding 5
% -- we'll call the new grade 'new_grade':

new_grade=10*grade+5

pause

% Suppose that we wish to square each grade -- we do this by the .^ operator.

grade.^2

pause

% grade is currently a column vector, we can convert it to a row vector by
% the transpose (') operator:

grade'

pause

% Suppose that we wish to add 'new_grade' to 'sat'.  The addition (+) 
% operator works for matrices if the dimensions line up.

new_grade+sat

pause

% Matlab also supports logical operators.  

% Suppose that we want to define a passing grade -- if grade is 3 or higher,
% then pass = 1, otherwise pass = 0.  We define this using >=

pass=(grade>=3)

pause

% We want to define a variable 'C', which is equal to 1 if the grade is 3
% and 0 otherwise.  We use the logical equal (==) operator:

C=(grade==3)

pause

%------------------------------------------------------------------------
%                     DATA ANALYSIS COMMANDS
%------------------------------------------------------------------------

% Matlab supports many data analysis operations.  The ones described below
% are intrinsic to Matlab.  Many others are available in the Statistics
% Toolbox.

% The 'length' command gives the number of entries in a vector:

length(grade)

pause

% The commands below find the mean and standard deviation of the column 
% vector 'sat':

mean(sat), std(sat)

pause

% Here is an alternative way of computing a standard deviation -- it 
% illustrates the 'sum' and 'sqrt' commands:

sqrt(sum((sat-mean(sat)).^2/(length(grade)-1)))

pause

% Suppose we wish to tally the different grades in the vector 'grade'.
% This can be done using the Matlab 'hist' function (the graphical version
% of this command will be illustrated later).  

freq=hist(grade,0:4)

% We see that there is 1 F, 4 D's, 8 C's, 10 B's, and 7 A's.

pause

% We can find the number of D's by use of a == logical operator and a 'sum':

num_D=sum(grade==1)

pause

% Likewise, the proportion of A's is given by

prop_A=sum(grade==4)/length(grade)

pause

%------------------------------------------------------------------------
%                     GRAPHING COMMANDS
%------------------------------------------------------------------------

% Matlab has a large number of graphing commands.  Here we illustrate some
% basic Matlab commands that are helpful in data analysis.

% A histogram of the SAT scores is constructed by the 'hist' command.

hist(sat)

pause

% Suppose that we wish to use bin midpoints of 460, 480, ..., 660. We first
% define a variable, called 'bins', which contains 460 to 660 in steps of 20:

bins=460:20:600;

pause

% The histogram using these bin midpoints is given by

hist(sat,bins)

pause

% Suppose that we wish to construct a scatterplot of 'grade' (vertical axis)
% against 'sat' (horizontal axis).  We use the 'plot' command.  The horizontal
% variable goes first, and we indicate a plotting symbol at the end.

plot(sat,grade,'o')

pause

% We label this plot by the 'xlabel', 'ylabel', 'title' commands:

xlabel('SAT'); ylabel('GRADE'); title('SCATTERPLOT OF GRADE AGAINST SAT')

pause

% We look at this graph -- we see a slight positive relationship between
% SAT and GRADE.  This motivates us to fit a line.  

% We first form a regression matrix.  The matrix X contains two columns - the first
% column is a ones vector (called ones(30,1)) and the second column are the sat scores.

X=[ones(30,1) sat];

pause

% A least-squares fit of SAT on GRADE is found in Matlab using a matrix divide notation -- 
% the column vector 'b' contains the regression coefficients:

b=X\grade

pause

% Let's put this least-squares fit on the graph.  We define points on the line:

xpt=[450 750]; ypt=b(1)+b(2)*xpt;

pause

% The 'line' command will connect the points and put the line on the current plot:

line(xpt,ypt)

pause

%------------------------------------------------------------------------
%                    WORKING WITH SIMULATED DATA
%------------------------------------------------------------------------

% Let's review some of the above commands and introduce some new ones by
% doing some data analysis on simulated data.

% We simulate numbers from a standard normal distribution.  We create a
% matrix of 10 rows and 100 columns and assign it to the matrix 'rand_norm':

rand_norm=randn(10,100);

pause

% Let's construct a histogram of the first row of this matrix -- it should
% look bell shaped and centered about the value 0.

hist(rand_norm(1,:))

pause

% Another property of these simulated values is that they are uncorrelated.
% To show this, we plot the entire stream of simulated values.  We collapse
% the matrix 'rand_norm' to a column vector 'rand_c' (using the colon 
% operation and then plot the elements of 'rand_c' as a line graph.

rand_c=rand_norm(:);
plot(rand_c)

% Note that there is no pattern or trend in the graph which indicates that
% they are uncorrelated.

pause

% Next, let's explore characteristics of sample means of normal samples.
% The following command finds the mean of each column of 'rand_norm' -- the
% resulting row vector is stored in 'means':

means=mean(rand_norm);

pause

% The values in 'means' are normally distributed with mean 0 and standard
% deviation sqrt(1/10) -- let's display the distribution.

hist(means)

pause

% We can use the random matrix 'rand_norm' to illustrate other functions of
% normals.  First we'll square each element of the matrix (by the .^ operator)
% and put the result in 'chisqs' -- the elements are independent
% chi-square(1):

chisqs=rand_norm.^2;

pause

% If we sum across rows, we'll get a random sample from a chi square 
% distribution with 10 degrees of freedom.

chisq10=sum(chisqs);

pause

% We'll display a histogram of these values.

hist(chisq10)

pause

% Looking at a chi-square table, we see that the upper 10 percentage point
% of a chi-square (10) is 14.68.  So we expect that roughly 10 percent of
% our random chi-square(10)'s are larger than 14.68.  Let's check:

sum(chisq10>14.68)

% This is the number of simulated values larger than 14.68 out of 100.
% Hopefully this is about 10 percent.


echo off

