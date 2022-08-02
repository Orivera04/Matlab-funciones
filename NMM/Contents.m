% Numerical Methods with MATLAB Toolbox
% Version 1.03  20-Aug-2001
%
%  MATLAB Routines and data to accompany the book
%  ``Numerical Methods with MATLAB: Implemenations and Applications''
%  Copyright 1996-2001, Gerald W. Recktenwald.  The contents of the
%  NMM Toolbox may be copied and used without charge.  Repackaging or
%  distribution in any form for a fee is prohibited.
%
% ----------------------------------------------------------------
%
% Contents of "data" directory in the NMM toolbox
%
% airSat.dat      Saturation pressure for air as a function of temperature
%                 Pressure (MPa) in column 1, Temperature (K) in column 2
% airvisc.dat     Viscosity of air verses temperature.  Temperature (degrees C)
%                 in column 1, viscosity (kg/m/s) in column2
% bearing.dat     Wear of journal bearing as function of temperature
% capacitor.dat   Capacitor voltage versus time; Data used to create Figure 9.2
%                 Time (s) in column 1, Voltage (V) in column 2
% chip.dat        Yield data for semiconductors.  First column is serial number
%                 second column is speed (MHz) at which chip qualifies.
%                 NaN entries in second column means chip failed all speed tests.
% CorvRain.dat    Monthly total precipitation data for Corvallis, Oregon, 1890 to 1994
%                 Column 1 is the year, column 2 through 13 is monthly total
%                 precipitation in (1/100)^th of an inch
% cucon1.dat ... cucon3.dat  Thermal conductivity data for Copper versus temperature.
%                 Temperature (C) in column 1, Thermal conductivity (W/m/C) in column 2
% emission.dat    Nitrogen oxide emssion from an internal combustion engine as
%                 function of humidity and atmospheric pressure
% fan9v.dat ... fan13v.dat  Fan curve data at different voltages
% flowsys1.dat    System curve data: flow rate (m^3/s) in column 1, pressure
%                 drop (Pa) in column 2
% flowsys2.dat    System curve data: flow rate (m^3/s) in column 1, pressure
%                 drop (Pa) in column 2
% gc87.dat        Flow data for Glen Canyon Dam in 1987.  First column is hour
%                 second column is flow rate in ft^3/s
% gc87flow.dat    Flow data for Glen Canyon Dam in 1987.  Flow data only in one
%                 column (ft^3/s).  Each row is an hour in the year.
% glycerin.dat    Thermophysical properties of glycerin
% H2Odensity.dat  Density of liquid water as a function of temperature.
% H2Osat.dat      Saturation pressure of water verses temperature.
% H2Ovisc.dat     Viscosity of water verses temperature.  Temperature (degrees C)
%                 in column 1, viscosity (kg/m/s) in column2
% Jtcouple.dat    Calibration data for J type thermocouple wire in the range -50 <= T <= 250 C
% pdxPass.dat     Airline passengers from 1986 to 1996 for the Portland, OR airport
%                 Year in column 1, millions of passengers in column 2
% pdxTemp.dat     Historical average of monthly temperature variation in Portland, OR 
%                 Month in column 1, average high temperature in column 2,
%                 average average temperature in column 3, average low temperature
%                 in column 4.
% pdxThead.dat    Same data as pdxTemp.dat.  First row contains text column headings
% pdxTheadLong.dat  Same data as pdxTemp.dat.  First row contains a text description,
%                 second row contains column headings.
% SiC.dat         Selected properties of Silicon Carbide (SiC)
% sphereCd.dat    Drag coefficient for smooth spheres as a function of Reynolds number
% sprint.dat      100m dash times for C Lewis and B Johnson in 1987 World Championships
% stdatm.dat      Temperature, pressure, and density of the standard atmosphere as
%                 a function of elevation.  Additional documentation in the file.
% Tfield.dat      Temperature field from CFD model of flow over a circuit board
% traffic.dat     Set of times at which vehicles cross monitoring point on a highway
% velocity.dat    Vehicle velocity as function of time for coast-down test
% vprofile.dat    Velocity profile in a round pipe.
% wolfSun.dat     Wolfer sunspot index data with text column headings.  Year in column 1
%                 wolfer index in column two
% xinvpx.dat      Synthetic data used in curve fit using y = c1/x + c2*x 
% xtyt.dat        (x,y) data stored in rows:  first row is x, second row is y
% xy.dat          (x,y) data stored in columms:  first column is x, second column is y
% xy2.dat         (x,y1,y2) data stored in columms:  first column is x, second
%                 and third columns are y1 and y2
% xy5.dat         (x,y1,y2,y3,y4,y5) data stored in columms:  first column is x, second
%                 through sixth columns are y1, y2, ... y5
% xydy.dat        Data set used in least squares fitting; (x,y,deltay) in 3 columns
%
% ----------------------------------------------------------------
%
% Contents of "eigen" directory in the NMM toolbox
%
% eigSort     Eigenvalue/vectors sorted in ascending or descending order
% iterMult    Iterated multiplication of a vector by a matrix: u = A*A*...*A*x0
% poweritInv  Inverse power iterations with shift to find an eigenvalue of A
% powerit     Shifted power method for finding matrix eigenvalues
%
% ----------------------------------------------------------------
%
% Contents of "errors" directory in the NMM toolbox
%
% Archimedes     Perimeter of an n-sided polygon inscribed in a circle.
% bin2flt        Expand a binary representation of floating point mantissa
% demoTaylor     Accuracy of a Taylor Series approximations for f(x) = 1/(1-x)
% epprox         Demonstrate catastrophic cancellation in evaluation of
%                e = exp(1) = lim_{n->infinity} (1 + 1/n)^n
% equalTest      Script to demonstrate equality of two floating point numbers
% expSeriesPlot  Evaluate and plot series representation of exp(x)
% fidiff         Evaluate 1st order finite-difference approximation to d/dx of exp(x)
% halfDiff       Reduce the distance between two numbers until it is set to zero
% linsp1         Generate a vector of equally spaced values, version 1
% linsp2         Generate a vector of equally spaced values, version 2
% linsp3         Generate a vector of equally spaced values, version 3
% lintest        Compare schemes for generating a vector of equally spaced values
% newtsqrtBlank  Incomplete function to use Newton's method to compute the square root of a number
% sinser         Evaluate the series representation of sin(x)
% testSqrt       Test the newtsqrt function for a range of inputs
%
% ----------------------------------------------------------------
%
% Contents of "fit" directory in the NMM toolbox
%
% conductFit   LS fit of conductivity data for Copper at low temperatures
% cuconBasis1  Basis fcns for conductivity model:  1/k = c1/T + c2*T^2
% cuconBasis2  Basis fcns for conductivity model:  1/k = c1/T + c2*T + c3*T^2
% demoFanCurve Multivariate fit of fan data:  dp = f(q,v)
% demoH2OSat   Fit saturation pressure versus temperature for water
% demoPlaneFit Least squares fit of data to a plane: z = f(x,y)
% demoSiCmod   Least squares fit of bulk modulus of SiC versus temperature
% demoTcouple  Linear and quadratic fits to thermocouple data with polyfit
% demoXexp     Demonstrate fit of synthetic data to y = c1*x*exp(c2*x).
% fitnorm      Least squares fitting via solution to the normal equations
% fitqr        Least squares fitting via solution of overdetermined system with QR
% linefit      Least squares fit of data to y = a*x + b
% lineTest     Script that uses linefit to fit four data points to a line
% xexpfit      Least squares fit of data to y = c1*x*exp(c2*x)
% xinvpxBasis  Matrix with columns evaluated with 1/x and x
% xinvpxfit    Least squares fit of synthetic data to y = c1/x + c2*x
%
% ----------------------------------------------------------------
%
% Contents of "integrate" directory in the NMM toolbox
%
% adaptGK            Adaptive numerical integration using Gauss-Kronrod 7-15 rule
% adaptSimpson       Adaptive numerical integration based on Simpson's rule
% adaptSimpsonTrace  Adaptive numerical integration based on Simpson's rule, returns
%                    additional vector of x values where f(x) was evaluated
% compIntRules    Compare trapezoid, simpson, and Gauss-Legendre quadrature rules
% demoAdaptGK     Exercise adaptive Gauss-Kronrod quadrature and compare with quad8
% demoAdaptSimp   Integrate humps(x) with adaptive Simpson's rule
% demoGauss       Use Gauss-Legendre quadrature to integrate x*exp(-x) on [0,5]
% demoQuad        Use built in quad and quad8 to integrate 'humps' function on [0,5]
% demoSimp        Use composite Simpson's rule to integrate x*exp(-x) on [0,5]
% demoTrap        Use composite trapezoidal rule to integrate x*exp(-x) on [0,5]
% expmx2          Evaluate exp(-x^2), where x is a scalar or vector
% gaussKronrod15  Gauss-Kronrod quadrature pair of order 7 and 15
% gaussLagQuad    Gauss-Laguerre quadrature for integrals on [0,infinity)
% gaussQuad       Composite Gauss-Legendre quadrature
% GLagNodeWt      Nodes and weights for Gauss-Laguerre quadrature of arbitrary order
%                 by solving an eigenvalue problem
% GLagTable       Nodes and weights for Gauss-Laguerre quadrature of order n<=25
% GLNodeWt        Nodes and weights for Gauss-Legendre quadrature of arbitrary order
%                 obtained by solving an eigenvalue problem
% GLTable         Nodes and weights for Gauss-Legendre quadrature of order n<=8
% humpInt         Exact value of integral of humps function on [a,b]
% makeGLagTable   Create a table of Gauss-Laguerre nodes and weights
%                 suitable for copy/paste into the GLagTable.m function
% makeGLTable     Create a table of Gauss-Legendre nodes and weights
%                 suitable for copy/paste into the GLTable.m function
% plotSimpInt     Graphical display of composite Simpson rule integration
% plotTrapInt     Graphical display of composite trapezoid rule integration
% quadToInfinity  Integral from 0 to infinity evaluated as sum of integrals
%                 on subintervals of x axis.  Subintervals size increases
%                 geometrically from x = 0 to infinity.  Sum is terminated when
%                 contribution from subintervals is less than tolerance.
% recursiveIndent Demonstration of a recursive function
% simpson         Composite Simpson's rule
% sinxonx         Evaluate (sin(x)/x)^2  with attention to sin(0)/0 = 1
% trapezoid       Composite trapezoid rule
% trapzDat        Composite trapezoid rule for arbitrarily spaced discrete data
% trapzDatTest    Verify trapzDat function for different types of input
% xemx            Evaluate x exp(-x), where x is a scalar or vector
%
% ----------------------------------------------------------------
%
% Contents of "interact" directory in the NMM toolbox
%
% demoContour     Demonstration of contour plot
% demoSubplot     Demonstration of subplot with four sine functions
% demoSurfTypes   Different types of surface plots for z = 2 - x^2 - y^2
% sourceSinkPlot  Script to create source/sink plot
% tempPlot        Script to plot monthly temperature data in pdxTemp.dat
% tempStats       Load data from pdxTemp.dat and compute simple statistics
%                 on temperature data in the file
% Tfield          Load and plot temperature field stored in custom format text file
%
% ----------------------------------------------------------------
%
% Contents of "interp" directory in the NMM toolbox
%
% binSearch         Binary search to find index i such that x(i)<= xhat <= x(i+1)
% binSearch.c       C source code for binSearch.mex
% compInterp        Compare flops for interpolation with different polynomial bases
% compNotKnot       Compare implementations of splines with not-a-knot end conditions
%                   NMM toolbox routine splint, is compared with built in spline
%                   function in the interpolation of y=x*exp(-x) on [0,5]
% compSplintFlops   Show flops savings due to sparse storage in spline interp
% compSplinePlot    Compare cubic splines w/ different end conditions
%                   Approximations to y = x*exp(-x) are constructed and plotted
% demoGasLag        Interpolate gasoline price data with Lagrange polynomials
% demoGasNewt       Interpolate gasoline price data with Newton polynomials
% demoGasVand       Interpolate gas price data using monomial basis functions
% demoGasVandShift  Interpolate gas price data using monomials and shifted dates
% demoHermite       Piecewise cubic Hermite interpolation of y = x*exp(-x) on [0,5]
% demoInterp1       Use built in interp1 function on data sampled from 'humps'
% demoLinterp       Script demonstrating linterp function with thermocouple data
% demoSplineFE      Spline approx to y = x*exp(-x) with fixed slope end conditions
% demoWiggle        Plot wiggle from increasing order of polynomial interpolant
% divdiffTable      Construct a table of divided difference coefficients
% hermint           Piecewise cubic Hermite interpolation
% lagrint           Interpolation with Lagrange polynomials of arbitrary degree
% linterp           Piecewise linear interpolation in a table of (x,y) data
% newtint           Interpolation with a Newton polynomias of arbitrary degree
% splint            Cubic spline interpolation with various end conditions
% splintFE          Cubic spline interpolation with fixed slop end conditions
% splintFull        Cubic-spline interpolation with various end conditions; full matrix storage
%
% ----------------------------------------------------------------
%
% Contents of "linalg" directory in the NMM toolbox
%
% Cholesky        Cholesky factorization of a symmetric, positive definite matrix
% demoNewtonSys   Solve a 2-by-2 nonlinear system by Newton's method
% demoSparse      Script demonstrating some sparse matrix commands
% demoSSub        Solve a 2-by-2 nonlinear system by successive substitution
% GEPivShow       Show steps in Gauss elimination with partial pivoting and
%                 back substitution
% GEshow          Show steps in Gauss elimination and back substitution
%                 No pivoting is used.
% luNopiv         LU factorization without pivoting
% luNopivVec      LU factorization without pivoting - vectorized implementation
% luPiv           LU factorization with partial pivoting
% newtonSys       Newton's method for systems of nonlinear equations.
% pumpCurve       Coefficients of quadratic pump curve given head and flow rate
% rotvec          Rotates a three dimensional vector
% rotvectTest     Use the rotvec function to rotate some vectors
% solveSpeed      Measure elapsed time and flop rate for solving Ax=b
% tridiag         Create tridiagonal matrix from two or three scalars or vectors.
% tridiags        Create sparse tridiagonal matrix from two or three scalars or vectors.
% vectorSequence  Behavior of a vector sequence x.^k in different p-norms
%
% ----------------------------------------------------------------
%
% Contents of "ode" directory in the NMM toolbox
%
% compEM       Compare Euler and Midpoint for solution of dy/dx = -y;  y(0) = 1
% compEMRK4    Compare flops and accuracy of Euler, Midpoint and RK4 methods
%              for the solution of  dy/dx = -y;  y(0) = 1
% demoEuler    Integrate dy/dx = x^2 - y;  y(0) = 1 with Euler's method
% demoODE45    Integrate dy/dx = -y;  y(0) = 1 with ode45
% demoRK4      Integrate  dy/dx = -y;  y(0) = 1 with RK4 method
% demoSystem1  Driver for integration of system defined in rhsSys1
% odeEuler     Euler's method for integration of a single, 1st order ODE
% odeMidpt     Integrate a single ODE with the Midpoint Method
% odeRK4       Integrate a single ODE with the fourth order Runge-Kutta method
% odeRK4sys    Fourth order Runge-Kutta method for systems of first order ODEs
%              Non vectorized version
% odeRK4sysv   Use 4th order RK4 method to integrate a system of first order ODEs
%              Vectorized version.
% odeRK4v      Integrate a single ODE with the fourth order Runge-Kutta method
%              Allows pass through of parameters to ODE-defining routine
% predprey     Integrate coupled ODEs for a two-species predator-prey simulation
% rhs1         Evaluate right hand side of dy/dx = x^2 - y 
% rhs2         Evaluate right hand side of dy/dx = -y 
% rhsDecay     Define rhs of dydx = -alpha*y with a variable alpha
% rhspop2      Evaluate rhs of the ODEs for 2 species predator-prey system
% rhssmd       Evaluate right hand sides of ODEs for a spring-mass-damper system
% rhsSteelHeat Evaluate right hand side of ODE for heat treating simulation
% rhsSys1      Evaluate rhs of the system
%              dy1/dx = -y1*exp(1-x) + 0.8*y2,  dy2/dx = y1 - y2^3
% smdsys       Solve 2nd order system of ODEs for a spring-mass-damper system
% steelHeat    Set up and solve ODE describing heat treating of a steel bar.
% steelTest    Script to verify that solutions obtained by ode45 are
%              independent of the interpolative refinement of the solution.
%
% ----------------------------------------------------------------
%
% Contents of "orgbug" directory in the NMM toolbox
%
% dailyAve      Compute average daily flow rate from hourly flow data
%               Used for analysis of Glen Canyon Dam data
% indent        Script demonstrating advantages of indentation
% multiply      Compute product of two arguments
% noneg         Returns x if x>0, otherwise prints an error message and stops
% noneg2        Returns x if x>0, otherwise prints an error message and stops.
%               The error message contains the value of x.
% nonegp        Returns x if x>0, otherwise prints a message and pauses
% quadroot      Roots of quadratic equation and demo of keyboard command
% riverReport   Compute and plot summary of river flow data
% riverReport2  Compute and plot summary of river flow data.  Compatible with
%               Student version of MATLAB 5.
% weeklyAve     Compute average weekly flow rate from hourly flow data
%               Used for analysis of Glen Canyon Dam data
%
% ----------------------------------------------------------------
%
% Contents of "program" directory in the NMM toolbox
%
% addmult      Compute sum and product of two matrices
% binSearch.c  C source code for binSearch.mex --- see also binSearch.m
%              in Chapter 9, "Interpolation"
% cvcon        Use switch construct to assign constants in curve fit for cv of fluids
% demoArgs     Variable numbers of input and output parameters
% demoBreak    Show how the break command causes exit from a while loop
% demoCopy     Demonstrate vectorized copy operations
%              Messages describing various copy operations are given
%              along with the results of those operations.  See text
%              in Appendix A for additional description.
% demoLogic    Function m-file file to demonstrate logical operators
% demoLoop     Script file to demonstrate for and while loops
% demoReturn   Show how the return command causes exit from a function
% demoXcosx    Demonstrate use of an inline function object with the fsum function
% easyplot     Script to plot data in file xy.dat
% elvis        Script file to demonstrate output from fprintf
% fsum         Computes sum of f(x) values at n points in  a <= x <= b
% H2Odensity   Density of saturated liquid water
% H20Props     Thermophysical properties of saturated liquid water
% inputAbuse   Use annoying input messages to compute sum of three variables 
% myCon        Script to define useful constants in the workspace
% plotData     Plot (x,y) data from columns of an external file
% plotfun      Plot sin(x), cos(x), and sin(x)*cos(x) for a prescribed
% polyGeom     Compute area and perimeter of a regular polygon
% sincos       Evaluates sin(x)*cos(x) for any input x
% takeout      Script to display restaurant telephone numbers. 
% threesum     Adds three variables and returns the result
% trigplot     Script to plot sin(x), cos(x), and sin(x)*cos(x)
% twosum       Adds two variables and prints the result
%
% ----------------------------------------------------------------
%
% Contents of "rootfind" directory in the NMM toolbox
%
% bisect      Use bisection to find a root of the scalar equation f(x) = 0
% brackPlot   Find and plot brackets for roots of a function.
% demoBisect  Use bisection to find the root of x - x^(1/3) - 2
% demoNewton  Use Newton's method to find the root of f(x) = x - x^(1/3) - 2
% fx3         Evaluates f(x) = x - x^(1/3) - 2
% fx3n        Evaluate f(x) = x - x^(1/3) - 2 and dfdx for Newton algorithm
% legs        Evaluate f(theta) for picnic leg geometry.  Used with root-finders.
% legsn       Evaluate f(theta) and fprime(theta) for the picnic leg problem.
%             Used with the Newton's method.
% legsnNG     Evaluate f(theta) and fprime(theta) for the picnic leg problem.
%             without using global variables.  Used with newtonNG
% legz        Evaluate f(theta) for picnic leg geometry.  Use pass-through
%             parameters in fzero to send w, h, and b values to this function.
%             Used with fzero
% newton      Newton's method to find a root of the scalar equation f(x) = 0
% newtonNG    Newton's method to find a root of the scalar equation f(x) = 0
%             This version can pass optional input arguments to the f(x) function
% secant      Shell of the secant function.  Implementation left to the reader
% tablen      Use Newton's method to find dimensions of picnic table legs
% tablenNG    Use Newton's method to find dimensions of picnic table legs
%             Variable input arguments are passed through to newtonNG
% tablez      Use fzero to find dimensions of picnic table legs
%
% ----------------------------------------------------------------
%
% Contents of "utils" directory in the NMM toolbox
%
% addpwd           Add the current directory to the path
% chop10           Round a floating point number to n base-10 digits.
% drawPlane        Draws a plane in 3D
% loadColData      Import a file containing header text, column titles and data
% loadColDateData  Import a file containing header text, column titles and data.
%                  First column of data is a date in one of MATLAB's datenum formats
% makeHTMLindex    Creates HTML file listing contents of NMM toolbox
% myArrow          Draw 2D arrows with filled tip(s).
% myArrow3         Draw 3D arrows with filled head. Size and color of
%                  arrowhead can be specified
% nmmCheck         Verify installation of NMM toolbox
% nmmVersion       Returns version number of NMM toolbox currently installed
% yesNoAnswer      Prompt user with a question, and return 1 for 'yes' and 0 for 'no'
