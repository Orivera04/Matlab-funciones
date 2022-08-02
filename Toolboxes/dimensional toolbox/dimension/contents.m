% Dimensional Analysis
% MATLAB Toolbox   Ver. 1.01   18-Feb-2002
%
%
% Dimensional Analysis
%   checkdm     - check dimension matrix for validity
%   createab    - create A and B submatrices
%   created     - create a D submatrix
%   datool      - GUI for dimensional analysis
%   rlist       - manage relevance list
%   diman       - perform dimensional analysis
%   dtrans      - transform data from x to pi
%   numpi       - number of base variables
%
% Output
%   pretty      - pretty print of dimensionless groups
%   latex       - LaTeX output of dimensionless groups
%   texfile     - write TeX output of a pi set to file
%
% Helper
%   getdv       - get dependent variables
%   matedit     - GUI matrix editor
%   unit2si     - converts units to dimensional representation
%   data2si     - converts data to basic SI units
%   xsort       - resort data arrays
%
% Demos
%   beamdemo    - cantilever beam with tip load
%   blastdemo   - energy in a nuclear explosion
%   dguidemo    - starts GUI with demo input
%   oscdemo     - simple oscillator (use of D submatrix)
%   spheredemo  - sphere in a flow
%   transfdemo  - sphere in a flow (data transformation)
%

% Copyright (c) Steffen Brueckner, 2002-02-18
