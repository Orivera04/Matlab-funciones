function fshelp
%FSHELP Help for Mastering MATLAB Fourier Series Functions. (MM)
% Fourier series coefficients are stored in ascending order
% in a row vector:
% Kn = [k   k     ... k  ...k   k    k ]
%        -N  -N+1      0     i   N-1  N
%
% The highest harmonic number or index is N. FSSIZE(Kn) returns N.
% The row vector has length 2N+1 and has vector indices 1:1:2N+1.
%
% Kn(N+1) is the DC term.
% Kn(N+1+i) is the i-th harmonic.
% For real time functions Kn(N+1-i)=conj( Kn(N+1+i) ).
%
%   FSABS     - Fourier Series Absolute Value.
%   FSANGLE   - Angle Between Two Fourier Series.
%   FSAREA    - Area Under Fourier Series.
%   FSDERIV   - Fourier Series Derivative.
%   FSDELAY   - Add Time Delay to a Fourier Series.
%   FSDIVIDE  - Fourier Series Time Division.
%   FSEVAL    - Fourier Series Function Evaluation.
%   FSEVENODD - Fourier Series Even/Odd Time Parts.
%   FSFIND    - Find Fourier Series Approximation.
%   FSFORMAT  - Fourier Series Format Conversion.
%   FSHARM    - Fourier Series Harmonic Component Selection.
%   FSINDEX   - Harmonic Index Vector.
%   FSINTERP  - Inverse Interpolate Fourier Series.
%   FSINTGRL  - Fourier Series Integral.
%   FSMIRROR  - Fourier Series Time Mirror.
%   FSMSV     - Fourier Series Mean Square Value (Square of RMS Value).
%   FSPEAK    - Fourier Series Peak Value.
%   FSPERIOD  - Change Fourier Series Period.
%   FSPF      - Fourier Series Power Factor Computation.
%   FSPLOT    - Fourier Series Function Plot.
%   FSPRINT   - Fourier Series Pretty Print.
%   FSPROD    - Fourier Series of a Product of Time Functions.
%   FSRESIZE  - Resize a Fourier Series.
%   FSRESP    - Fourier Series Linear System Response.
%   FSROUND   - Round Fourier Series Coefficients.
%   FSSELECT  - Fourier Series Harmonic Selection.
%   FSSIZE    - Highest Harmonic in a Fourier Series.
%   FSSTEM    - Fourier Series Line Spectra Plot.
%   FSSUM     - Fourier Series of a Sum of Time Functions.
%   FSSYM     - Enforce Symmetry Constraints.
%   FSTABLE   - Generate Common Fourier Series.
%   FSTHD     - Total Harmonic Distortion of a Fourier Series.
%   MMWINDOW  - Generate Window Functions.

% D. Hanselman, University of Maine, Orono, ME  04469
% 5/2/96, v5: 1/14/97
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8
% Mastering MATLAB 6, Prentice Hall, ISBN 0-13-019468-9

helpwin fshelp
