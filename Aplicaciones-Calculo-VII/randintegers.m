function[rand_ints]=randintegers(lower_bound,upper_bound,m_size)

%RANDINTEGERS Random Integers.
%
%  RANDINTEGERS(LOWER_BOUND,UPPER_BOUND) is a one line function that uses
%  RAND to return a random integer between and inclusive of the two
%  specified integers LOWER_BOUND and UPPER_BOUND (with uniform
%  probability) (and with replacement).
%
%  The third argument M_SIZE is optional. If specified as a scalar, the
%  output is a matrix with size [m_size m_size] and containing the values
%  stated bove. If specified as a row vector, the output is an array with
%  size [m_size] and containing the same.
%
%  EXAMPLES:
%
%    randintegers(11,25) may return 23 or 11 or 25
%    randintegers(11,25,2) may return [25 12; 15 24]
%    randintegers(11,25,[1 3]) may return [14 23 17]
%
%  REMARKS:
%
%   - The following toolbox function commands return a random integer:
%     (These functions can also be used to return a matrix of the same.)
%       - Communications toolbox:
%           - randint(1,1,[lower_bound,upper_bound])
%       - Statistics toolbox:
%           - round(unifrnd(lower_bound-.5,upper_bound+.5))
%           - ceil(unifrnd(lower_bound-1,upper_bound))
%           - floor(unifrnd(lower_bound,upper_bound+1))
%
%  VERSION: 20060114
%  MATLAB VERSION: 7.1.0.246 (R14) Service Pack 3
%
%  See also RAND, ROUND, CEIL, FLOOR, RANDINT, UNIFRND.

%{
REVISION HISTORY:
20060114: Added optional argument M_SIZE to return array of arbitrary size,
          and renamed function from RANDINTEGER to RANDINTEGERS.
20060101: Fixed a critical bug which caused the function outputs to not
          have exactly uniform probability density.
20051209: Added previously excluded help text.
20041107: Original release.

KEYWORDS:
rand, random, int, integer, integers, lower limit, upper limit
%}
%--------------------------------------------------------------------------

%% Declare argument M_SIZE if it does not exist

if exist('m_size','var')~=1
    m_size=1;
end    

%--------------------------------------------------------------------------

%% Generate random integer(s) between and inclusive of the specified limits

%rand_ints=round(rand(m_size)*((upper_bound+.5)-(lower_bound-.5))+...
%         (lower_bound-.5));
%Simplifying the above line leads to:
rand_ints=round(rand(m_size)*(upper_bound-lower_bound+1)+lower_bound-.5);

%Two other possible ways to do this are:
%rand_ints=ceil(rand(m_size)*(upper_bound-lower_bound+1)+lower_bound-1);
%rand_ints=floor(rand(m_size)*(upper_bound-lower_bound+1)+lower_bound);

%--------------------------------------------------------------------------