% This set of functions were developed to supplement the book
% Mastering MATLAB 6 A Comprehensive Tutorial and Reference
% by Duane Hanselman and Bruce Littlefield
% (Prentice Hall, 2001, ISBN  0-13-019468-9)
%
% Mastering MATLAB Web Site:   http://www.eece.maine.edu/mm
% E-mail address:              mm@eece.maine.edu
%
% These MATLAB functions are the property of the above authors. They are not a
% product of The Mathworks, Inc. and The Mathworks assumes no responsibility for 
% any errors that may exist in these functions.
%
% While a reasonable effort has been made to create error-free functions,
% the authors of these functions assume no responsibility for any errors 
% that may exist in these functions. Moreover, the authors do not accept 
% any liability for errors that may result from the use of these functions.
%
% _________________________________________________________________________
%
% Last minute modifications and additions:
%
% Initial Toolbox Release 1/1/2001
%
% 2/17/01   mmspfit     bug fixed
% 2/18/01   mmsptrim    totally rewritten and much improved
% 2/20/01   mmppval     Evaluate 1-D Piecewise Polynomial Fast.
% 2/20/01   mmv2struct  rewritten, 3X faster
% 3/20/01   mmspshift   Shift Spline Domain.
% 3/25/01   mmprobe3    bug fixed
% 3/26/01   mmfsmirror  Fourier Series Time Mirror.
% 3/27/01   mmhypot     Hypotenuse.
% 4/19/01   mmfstable   Finite slope pulses added.
% 5/31/01   mmstridx    Index of One String Array or Cell Array to Another.
% 9/14/01   fsprint     Fourier Series Pretty Print.
% 9/25/01   fsabs       Fourier Series Absolute Value.

