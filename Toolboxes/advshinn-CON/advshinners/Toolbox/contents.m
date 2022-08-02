% Modern Control System Thoery and Design (MCSTD) Toolbox
% Version 1.1  3-April-94
% Created by S. M. Shinners
%
% Polynomial Utilities
%   poly_add   - add two polynomials
%   polysbst   - substitution of a polynomial variable with a polynomial
%   polyder    - derivative of a polynomial (Supplied with MATLAB)
%   polyintg   - integratal of a polynomial  
%   polymag    - locate roots of a polynomial that generate a given magnitude
%   polyangl   - locate roots of a polynomial that generate a given angle
%   rootmag    - locate roots of a polynomial that are at given magnitude
%   rootangl   - locate roots of a polynomial that are at given angle
%
% Interpolation Utilities
%   crossing   - Interpolates the index of specified values from a data set
%   crosses    - Interpolates the value of a data set at specified indices
%   crosser    - Iterates the solution of a function to a specified value
%
% Control Utilities
%   margins    - analytic calculations of all the Phase and Gain Margins
%   rlpoba     - Root Locus Point Of Break-Away/Break-In
%   rlaxis     - real axis portion of the root locus
%   wpmp       - Maximum feedback frequency location
%   nichgrid   - Nichols grid at user requested inputs
%
% Non-Linear Funtions (using the describing function implementation)
%   back_lsh   - backlash response
%   dead_zn    - deadzone response
%   relays     - hystersis response
%
% Compatibility Functions
%   sbplot     - subplot replacement
%   frz_axis   - axis replacement
%
% DISCLAIMER : These M-files (scripts and functions) for all applications in 
% this book and Solutions Manual have been supplied to The MathWorks, Inc., 
% for distribution, upon request, on an "as is"  basis.  Although these 
% routines have been carefully checked, The MathWorks and I assume no
% responsibility and/or liability for the correctness of the M-files, or any
% errors that exist in this Modern Control System Theory and Design Toolbox.
% Users of this toolbox are encouraged to contact me if you have any questions.
%
%                                             S. M. Shinners
%                                             28 Sagamore Way North
%                                             Jericho, N.Y. 11753
