% Mastering MATLAB Toolbox
% Version 6.01  25-Sep-2001
%
% BY: Duane Hanselman and Bruce Littlefield, University of Maine
%
% Functions new to the Toolbox are marked with (6)
% Functions unchanged from version 5 are marked with (5)
% Functions that have been Renamed are marked with (R)
% Functions with significant Changes are marked with (C)
% Functions with Bug fixes are marked with (B)
% Functions that are obsolete but Grandfathered are marked with (G)
%
%   readme      - Last minute additions and modifications.
%                 To view,type >> whatsnew MM6
%
% Chapter 2 Basic Features
%   mmdigit     - Round Values to Given Significant Digits. (C)
%   mmhypot     - Hypotenuse. (6)
%   mmlog10     - Dissect Decimal Floating Point Numbers. (B) 
%   mmmod       - Modulus Integer Count. (6)
%   mmpa        - Principal Angle. (6)
%   mmquant     - Quantize Input Values. (B)
%   mmsinc      - Sin(x)/x Function. (6)
%
% Chapter 3 The MATLAB Desktop
%   ed          - Shortcut for Edit. (6)
%   hw          - Shortcut for Helpwin. (6)
%   mmbytes     - Variable Memory Usage. (6)
%   mmkeep      - Clear Variables or Functions Except for Those Listed. (6)
%
% Chapter 5 Arrays and Array Operations
%   mmakeidx    - Make Index Vector From Limits. (6)
%   mmdeal      - Deal Data Into Individual Arguments. (5)
%   mmfind      - Find Indices of a Vector in a Matrix. (6)
%   mmfindrc    - Find First or Last Nonzero Indices per Row or Column. (6)
%   mmlimit     - Limit Values Between Extremes. (5) 
%   mmnumfun    - Functions on Numerical Arrays. (6)
%   mmono       - Test for Monotonic Vector. (5)
%   mmrand      - Uniformly Distributed Random Arrays. (5)
%   mmrandn     - Normally Distributed Random Arrays. (5)
%   mmrepeat    - Repeat or Count Repeated Values in a Vector. (6)
%   mmshiftd    - Shift or Circularly Shift Matrix Rows. (5)
%   mmshiftr    - Shift or Circularly Shift Matrix Columns. (5)
%   mmsubdiv    - Subdivide Vector Values. (6)
%   mmtrim      - Trim Negligible Array Elements. (6)
%   mmwrap      - Form Matrix From Circular Shifted Vector. (6)
%
% Chapter 6 Multidimensional Arrays
%   mmdiffsum   - Differential Sum of Elements. (6)
%   mmx         - Expand Singleton Dimensions. (6)
%
% Chapter 7 Cell Arrays and Structures
%   mmcellfun   - Functions on cell array contents. (6)
%   mmcellstr   - Create Cell Array of Strings. (6)
%   mmrmfield   - Remove Structure Fields. (6)
%   mmrnfield   - Rename Structure Fields. (6)
%   mmrofield   - Reorder Structure Fields. (6)
%   mmstructcat - Concatenate Structures. (6)
%   mmstructfun - Functions on Contents of Structure Fields. (6)
%   mmv2struct  - Pack/Unpack Variables to/from a Scalar Structure. (6)
%
% Chapter 8 Character Strings
%   mmfindstr   - Find First String in Second String. (6)
%   mmisdigit   - True for Digits in Strings. (6)
%   mmonoff     - String ON/OFF to/from Logical Conversion. (5)
%   mmstrcmpl   - Lexical String Comparison. (6)
%   mmstridx    - Index of One String Array or Cell Array to Another.(6)
%   mmstrrep    - String Replacement Without Overlaps. (6)
%   mmstrtok    - Find Tokens in a String. (6)
%   mmstrtrim   - Trim Leading and/or Trailing White Space. (6)
%
% Chapter 9 Relational and Logical Operations
%   mmempty     - Substitute Value if Empty. (5)
%   mmisequal   - True for Elements Equal Within a Tolerance. (6)
%   mmisflint   - True for Floating Point Integers. (6)
%   mmisvect    - True for Vectors. (6)
%   mmisver     - Test for Given MATLAB Version. (6)
%
% Chapter 11 Function M-Files
%   mmbuiltin   - Built-in Function Names. (6)
%   mmswap      - Swap Two Variables. (6)
%   mmvarnames  - M-File Variable Names. (6)
%
% Chapter 13 File and Directory Management
%   mmatcmp     - True if MAT File Contents are Equal. (6)
%   mmfiledate  - Get File Modification Date. (6)
%
% Chapter 14 Set, Bit, and Base Functions
%   mmintersect - Set Intersection Within Tolerance. (6)
%   mmunique    - Set Unique Within Tolerance. (6)
%
% Chapter 16 Matrix Algebra
%   mmrwls      - Recursive Weighted Least Squares. (5)
%
% Chapter 17 Data Analysis
%   mmax        - Array Maximum Value. (C)
%   mmcount     - Count Occurances of Values in an Array. (6)
%   mmcummax    - Indices of Cumulative Maxima. (6)
%   mmcurvelen  - Length Along a Plane Curve. (5)
%   mmcurvex    - Intersections of Two Curves. (6)
%   mmin        - Array Minimum Value. (C)
%   mmlinefun   - Functions on Line Segments. (6)
%   mmpeaks     - Find Indices of Relative Extremes. (5)
%   mmsort      - General 2D sorting. (6)
%   mmsortcc    - Sort Vector into Complex Conjugate Pairs. (6)
%
% Chapter 18 Data Interpolation
%   mmsearch    - 1-D NON-Monotonic Linear Interpolation. (5)
%
% Chapter 19 Polynomials
%   mm2dp2p     - 2D Polynomial To 1D Polynomial. (6)
%   mm2dpadd    - 2D Polynomial Addition. (6)
%   mm2dpchk    - 2D Polynomial Vector Check and Parse. (6)
%   mm2dpder    - 2D Polynomial Derivative. (6)
%   mm2dpfit    - 2D Polynomial Curve Fitting. (C)
%   mm2dpint    - 2D Polynomial Integral. (6)
%   mm2dpstr    - 2D Polynomial Vector to String Conversion. (5)
%   mm2dpval    - 2D Polynomial Evaluation. (5)
%   mm2dpxy     - 2D Polynomial Variable Swap. (6)
%   mmp2pm      - Polynomial to Polynomial Matrix Conversion. (5)
%   mmp2str     - Polynomial Vector to String Conversion. (5)
%   mmpadd      - Polynomial Addition. (5)
%   mmpfit      - Interactive Polynomial Curve Fitting GUI. (6)
%   mmpintrp    - Inverse Interpolate Polynomial. (5)
%   mmpm2p      - Polynomial Matrix to Polynomial Conversion. (5)
%   mmpmder     - Polynomial Matrix Derivative. (5)
%   mmpmeval    - Polynomial Matrix Evaluation. (5)
%   mmpmfit     - Polynomial Matrix Curve Fitting. (5)
%   mmpmint     - Polynomial Matrix Integration. (5)
%   mmpmsel     - Select Subset of a Polynomial Matrix. (5)
%   mmpoly      - Make Real Polynomials from Root Locations and Polynomials.(5) 
%   mmpscale    - Scale Polynomial, A(x) -> A(x/b). (5)
%   mmpshift    - Shift Polynomial, A(x) -> A(x+b). (5)
%   mmpsim      - Polynomial Simplification, Strip Leading Zero Terms. (5)
%   mmrwpfit    - Recursive Weighted Polynomial Curve Fitting. (5)
%
% Chapter 20 Cubic Splines
%   mmhermite   - Cubic Hermite Spline Construction. (6)
%   mmppval     - Evaluate 1-D Piecewise Polynomial. (6)
%   mmsparea    - Spline Area. (5)
%   mmspbreak   - Modify Spline Breakpoints. (6)
%   mmspchk     - Check Spline Piecewise Polynomial. (6)
%   mmspcut     - Extract or Cut Out Part of a Spline. (5)
%   mmspder     - Spline Derivative Interpolation. (5)
%   mmspfit     - Spline Creation and Manipulation GUI. (6)
%   mmspget     - Get Spline Data. (6)
%   mmsphelp    - Help for Mastering MATLAB Spline Functions. (6)
%   mmspii      - Inverse Interpolate Spline. (5)
%   mmspinfl    - Spline Inflection Points. (6)
%   mmspint     - Spline Integral Interpolation. (C)
%   mmspjump    - Find Spline Discontinuities. (6)
%   mmspline    - Cubic Spline Construction with Method Choice. (5)
%   mmspmath    - Mathematics on 1-D Spline Piecewise Polynomials. (6)
%   mmsppaste   - Paste Spline Piecewise Polynomial. (6)
%   mmspplot    - Plot Spline Piecewise Polynomials. (6)
%   mmspshift   - Shift Spline Domain. (6)
%   mmsptrim    - Trim Spline Breakpoints. (6)
%   mmspxtrm    - Spline Extremes. (5)
%
% Chapter 21 Fourier Analysis
%   fsabs       - Fourier Series Absolute Value. (6)
%   fsangle     - Angle Between Two Fourier Series. (5)
%   fsarea      - Area Under Fourier Series. (6)
%   fsdelay     - Add Time Delay to a Fourier Series. (5)
%   fsderiv     - Fourier Series Derivative. (5)
%   fsdivide    - Fourier Series Time Division. (6)
%   fseval      - Fourier Series Function Evaluation. (5)
%   fsevenodd   - Fourier Series Even/Odd Time Parts. (6)
%   fsfind      - Find Fourier Series Approximation. (5)
%   fsformat    - Fourier Series Format Conversion. (R)
%   fsharm      - Fourier Series Harmonic Component Selection. (5)
%   fshelp      - Help for Mastering MATLAB Fourier Series Functions. (C)
%   fsindex     - Harmonic Index Vector. (6)
%   fsinterp    - Inverse Interpolate Fourier Series. (6)
%   fsintgrl    - Fourier Series Integral. (B)
%   fsmirror    - Fourier Series Time Mirror. (6)
%   fsmsv       - Fourier Series Mean Square Value. (5)
%   fspeak      - Fourier Series Peak Value. (5)
%   fsperiod    - Change Fourier Series Period. (6)
%   fspf        - Power Factor Computation from Fourier Series. (5)
%   fsplot      - Fourier Series Function Plot. (6)
%   fsprint     - Fourier Series Pretty Print. (6)
%   fsprod      - Fourier Series Time Product. (C)
%   fsresize    - Resize a Fourier Series. (5)
%   fsresp      - Fourier Series Linear System Response. (5)
%   fsround     - Round Fourier Series Coefficients. (5)
%   fsselect    - Fourier Series Harmonic Selection. (6)
%   fssize      - Fourier Series Size. (5)
%   fsstem      - Fourier Series Line Spectra Plot. (6)
%   fssum       - Fourier Series Addition. (C)
%   fssym       - Enforce Symmetry in Fourier Series. (5)
%   fstable     - Fourier Series Table. (C)
%   fsthd       - Total Harmonic Distortion of a Fourier Series. (5)
%   mmfftbin    - FFT Bin Frequencies. (5)
%   mmfftpfc    - FFT Positive Frequency Components. (5)
%   mmftfind    - Find Fourier Transform Approximation. (5)
%   mmwindow    - Generate Window Functions. (5)
%
% Chapter 22 Optimization
%   mmfminc     - Function Minimization with Inequality Constraints. (C)
%   mmfminc_    - Helper function for MMFMINC. (5)
%   mmfminu     - Minimize a Function of Several Variables. (5)
%   mmfsolve    - Solve a Set of Nonlinear Equations. (B)
%   mmlceval    - Evaluate a Linear Combination of Functions. (5)
%   mmlcfit     - Curve Fit to a Linear Combination of Functions. (5)
%   mmnlfit     - Nonlinear Curve Fitting. (B)
%   mmnlfit2    - 2D Nonlinear Curve Fitting. (B)
%   mmnlfit_    - Helper function for MMNLFIT and MMNLFIT2. (5)
%   mmsneval    - Simple Nonlinear Curve Fit Evaluation. (5)
%   mmsnfit     - Simple Nonlinear Curve Fit by Transformation. (5)
%
% Chapter 23 Integration and Differentiation
%   mmderiv     - Derivative Using Weighted Central Differences. (5)
%   mmgauss     - Numerically Evaluate Cumulative Integral. (6)
%   mmintgrl    - Cummulative Integral Using Simpson's Rule. (5)
%   mmquad      - Numerically Evaluate Integral. (6)
%   mmvolume    - Cummulative Volume Integral Using Trapezoidal Rule. (5)
%
% Chapter 24 Differential Equations
%   mmlsim      - Linear System Simulation Using MMODESS. (5)
%   mmlsim_     - Helper Function for MMLSIM. (5)
%   mmode45     - ODE Solution Using 4-5 Order MMODESS. (5)
%   mmode45p    - Plotted ODE Solution Using 4-5 Order MMODESS. (5)
%   mmodechi    - ODE Cubic Hermite Interpolation. (5)
%   mmodeini    - Initialize ODE Parameters for MMODESS. (5)
%   mmodess     - Single Step ODE Solution, 4-5th Order. (5)
%
% Chapter 25 2-D Graphics
%   mmarrow     - Plot Moveable Arrows on Current Linear 2D Axes. (5)
%   mmfill      - Fill Plot of Area Between Two Curves. (5)
%   mmplotc     - 2-D Plot with an ASCII Character Marker at Data Points. (5)
%   mmploti     - Incremental 2-D Line Plotting. (5)
%   mmplotxx    - Plot Data with Top and Bottom X-Axes. (6)
%   mmplotyy    - Plot 2 Data Arrays on a Common X Axis. (R)
%   mmplotz     - Plot with Axes Drawn Through ZERO. (5)
%   mmpolar     - Linear or Logarithmic Polar Coordinate Plot. (5)
%   mmprobe     - Probe Data on 2-D Axis Using Mouse. (B)
%   mmzoom      - Picture in a Picture Zoom. (C)
%
% Chapter 26 3-D Graphics
%   mmhole      - Create Hole in 3-D Graphics Data. (5)
%   mminxy      - Minima of 3-D Data Along X and Y Axes. (5)
%   mmprobe3    - Probe Data on 3-D Axis Using Mouse. (6)
%   mmxtract    - Extract Subset of 3-D Graphics Data. (5)
%   mmzoom3     - Simple 3-D Zoom-In Function Using RBBOX. (5)
%
% Chapter 27 Using Color and Light
%   mmap        - Single Color Colormap. (5)
%   mmrgb       - Color Specification Conversion and Substitution. (C)
%   mmrgb2gray  - Convert Colormap to Equivalent Grayscale Map. (6)
%   rainbow     - Colormap Variant to HSV. (5)
%
% Chapter 30 Handle Graphics
%   mmbox       - Get 2-D Axis Vector of a Rubberband Box. (5)
%   mmedit      - Edit Axes Text using Mouse. (5)
%   mmfigpos    - Position Figure Windows. (6)
%   mmfitpos    - Fit Position Within Another Object. (5)
%   mmgca       - Get Current Axes if it Exists. (5)
%   mmgcf       - Get Current Figure if it Exists. (5)
%   mmget       - Get Multiple Object Properties. (C)
%   mmgetpos    - Get Object Position Vector in Specified Units. (5)
%   mmgetpt     - Get Graphical Point With Interpolation. (5)
%   mmgetset    - Get Settable Object Property Structure. (6)
%   mmgetsiz    - Get FontSize in Specified Units. (5)
%   mmgetundoc  - Get Undocumented Object Properties. (6)
%   mmginput    - Graphical Input Using Mouse. (5)
%   mmgrid      - Custom Axis Grids. (6)
%   mmgui       - Double-Click Activation of Plotting GUIs. (5)
%   mminrect    - True when Point is Inside Position Rectangle. (5)
%   mmis2d      - True for Axes that are 2-D. (5)
%   mmpaper     - Set Default Paper Properties. (5)
%   mmplotpos   - Subplot Position Vectors. (6)
%   mmprintf    - Data Array to String Matrix Conversion. (5)
%   mmputptr    - Place Mouse Pointer. (R)
%   mmsetpos    - Set Position Relative to Another Object. (5)
%   mmtext      - Place and Drag Text with Mouse. (5)
%   mmxy        - Show and Get x-y Coordinates Using Mouse. (6)
%   mmzap       - Delete Graphics Object Using Mouse. (5)
%
% Chapter 31 Graphical User Interfaces
%   mmsaxes     - Set Axes Specifications using a GUI. (B)
%   mmsfont     - Set Font Characteristics using a GUI. (5)
%   mmsline     - Set Line Specifications using a GUI. (C)
%   mmsmap      - Set Figure Colormap using a GUI. (5)
%   mmssurf     - Set Surface Specifications using a GUI. (5)
%   mmstext     - Set Text Specifications using a GUI. (6)
%   mmstick     - Set Axis Tick Specifications using a GUI. (6)
%
% Chapter 33 MATLAB Classes and OOP
%   mmclass     - MATLAB Object Class Existence. (6)
%   @mmrp          - Rational Polynomial Object Class (6)
%   @mmrp\char     - Overloaded CHAR function for MMRP object.
%   @mmrp\diff     - Overloaded DIFF function for MMRP object.
%   @mmrp\disp     - Overloaded DISP function for MMRP object.
%   @mmrp\display  - DISPLAY method for MMRP object.
%   @mmrp\double   - Extract numerical data from MMRP object.
%   @mmrp\get      - Overloaded GET function for MMRP object.
%   @mmrp\int      - Integrate MMRP object.
%   @mmrp\ldivide  - Left Division method for MMRP object.
%   @mmrp\minreal  - Overloaded MINREAL function for MMRP object.
%   @mmrp\minus    - Subtraction method for MMRP object.
%   @mmrp\mldivide - Left Division method for MMRP object.
%   @mmrp\mmrp     - Constructor for MMRP objects.
%   @mmrp\mpower   - Power method for MMRP object.
%   @mmrp\mrdivide - Right division method for MMRP object.
%   @mmrp\mtimes   - Multiplication method for MMRP object.
%   @mmrp\plus     - Addition method for MMRP object.
%   @mmrp\poles    - Poles of MMRP object.
%   @mmrp\poly     - Overloaded POLY function for MMRP object.
%   @mmrp\polyder  - Overloaded POLYDER function for MMRP object.
%   @mmrp\polyint  - Overloaded POLYINT function for MMRP object.
%   @mmrp\power    - Power method for MMRP object.
%   @mmrp\rdivide  - Right division method for MMRP object.
%   @mmrp\residue  - Overloaded RESIDUE function for MMRP object.
%   @mmrp\roots    - Overloaded ROOTS function for MMRP object.
%   @mmrp\set      - Overloaded SET function for MMRP object.
%   @mmrp\size     - Overloaded SIZE function for MMRP object.
%   @mmrp\subsasgn - Subscripted assignment method for MMRP object.
%   @mmrp\subsref  - Subscripted reference method for MMRP object.
%   @mmrp\tf       - Convert MMRP object to TF object in Control Toolbox.
%   @mmrp\times    - Multiplication method for MMRP object.
%   @mmrp\uminus   - Unary minus method for MMRP object.
%   @mmrp\uplus    - Unary plus method for MMRP object.
%   @mmrp\zeros    - Overloaded ZEROS function for MMRP object.
%
% Chapter 34 MATLAB Programming Interfaces
%
% Chapter 35 Extending MATLAB with Java
%
% Chapter 36 Windows Application Integration
%
% Chapter 37 Getting Help
%
% Chapter 38 Examples, Examples, Examples
%
%  mmrepeat     - See Chapter 5 listing above
%  mmwrap       - See Chapter 5 listing above
%  mmakeidx     - See Chapter 5 listing above
%  mmsubdiv     - See Chapter 5 listing above
%  mmfindrc     - See Chapter 5 listing above
%  mmdiffsum    - See Chapter 6 listing above
%  mmx          - See Chapter 6 listing above
%  mmv2struct   - See Chapter 7 listing above
%  mmrmfield    - See Chapter 7 listing above
%  mmstructcat  - See Chapter 7 listing above
%  mmrnfield    - See Chapter 7 listing above
%  mmrofield    - See Chapter 7 listing above
%  
% Grandfathered
%
%   mmbrowse    - Graphical Matrix Browser. (G)
%   mmcd        - Change Working Directory. (G)
%   mminterp    - 1-D Monotonic Linear Interpolation. (G)
%   mmismem     - True for Set Members. (G)
%   mmisv5      - True for MATLAB Version 5. (G)
%   mmload      - Load Matrix and Header(s) from an ASCII File. (G)
%   mmspage     - Set Figure Paper Position When Printed using a GUI. (G)
%   mmsave      - Save Array and Header to an ASCII File. (G)
%   mmscolor    - Set RGB Specification using a GUI. (G)
%   mmsview     - Set Azimuth and Elevation using a GUI. (G)
%   mmtile      - Tile Figure Windows. (5)
