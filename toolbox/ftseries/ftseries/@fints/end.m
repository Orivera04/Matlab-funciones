function endidx = end(fts, K, N)
%@FINTS/END returns the index to the last date entry in a FINTS object.
%
%   Let's say that we have a FINTS object called fts as follows:
%
%      fts = 
% 
%          'desc:'           'DJI30MAR94.dat'
%          'freq:'           'Daily (1)'     
%                      ''                  ''
%          'dates:  (20)'    'Open:  (20)'   
%          '04-Mar-1994'     [        3830.9]
%          '07-Mar-1994'     [        3851.7]
%          '08-Mar-1994'     [        3858.5]
%          '09-Mar-1994'     [          3854]
%          '10-Mar-1994'     [        3852.6]
%          '11-Mar-1994'     [        3832.6]
%          '14-Mar-1994'     [        3870.3]
%          '15-Mar-1994'     [        3863.4]
%          '16-Mar-1994'     [          3851]
%          '17-Mar-1994'     [        3853.6]
%          '18-Mar-1994'     [        3865.4]
%          '21-Mar-1994'     [        3878.4]
%          '22-Mar-1994'     [        3865.7]
%          '23-Mar-1994'     [        3868.9]
%          '24-Mar-1994'     [        3849.9]
%          '25-Mar-1994'     [        3827.1]
%          '28-Mar-1994'     [        3776.5]
%          '29-Mar-1994'     [        3757.2]
%          '30-Mar-1994'     [        3688.4]
%          '31-Mar-1994'     [        3639.7]
%
%   Then,
%
%      fts(15:end)
%
%      ans =
%
%          'desc:'           'DJI30MAR94.dat'
%          'freq:'           'Daily (1)'     
%                      ''                  ''
%          'dates:  (20)'    'Open:  (20)'   
%          '24-Mar-1994'     [        3849.9]
%          '25-Mar-1994'     [        3827.1]
%          '28-Mar-1994'     [        3776.5]
%          '29-Mar-1994'     [        3757.2]
%          '30-Mar-1994'     [        3688.4]
%          '31-Mar-1994'     [        3639.7]
%
%
%   Note: The K and N arguments are always 1's here because the object
%         is essentially an array.

%   Author: P. N. Secakusuma, 01-08-98
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.8 $   $Date: 2002/01/21 12:25:04 $

endidx = fts.datacount;

% [EOF]