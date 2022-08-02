function CRRTimeSpec = crrtimespec(varargin)
% CRRTIMESPEC Specify time structure for a CRR binomial tree.
%
%  TimeSpec = crrtimespec(ValuationDate, Maturity, NumPeriods)
%
% Inputs:
%   ValuationDate - Scalar date marking the pricing date and first observation
%                   in the tree. Specify ValuationDate as a serial date number 
%                   or date string.
%   Maturity      - Scalar date marking the depth of the tree. 
%   NumPeriods    - Scalar. Determines how many time steps are in the tree.
%
% Output:
%   TimeSpec - Structure specifying the time layout for a CRR binomial tree.  
%
% Example:
%   Specify a 4-period tree with time steps of 1 year.
%
%   ValuationDate = '1-July-2002';
%   Maturity = '1-July-2006';
%   TimeSpec = crrtimespec(ValuationDate, Maturity, 4);
%
% See also CRRTREE, STOCKSPEC.

%   Author(s): M. Reyes-Kattar 01-Nov-2002
%   Copyright 1998-2003 The MathWorks, Inc. 
%   $Revision: 1.1.6.1 $  $Date: 2003/08/29 04:46:25 $

%----------------------------------------------------------------
% Checking input arguments
%----------------------------------------------------------------
if nargin<3 
    error('finderiv:crrtimespec:InvalidInputs','ValuationDate, Maturity, and NumPeriods are required input arguments.') 
end


CRRTimeSpec = bintimespec(varargin{:});