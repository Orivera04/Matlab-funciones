function [transfts, lambdas] = boxcox(ftsa)
%@FINTS/BOXCOX transforms non-normally distributed FINTS object to a normal one.
%
%   [TRANSFTS, LAMBDAS] = boxcox(FTS) transforms the data in the FINTS
%   object FTS using the Box-Cox Transformation method into the object 
%   TRANSFTS.  It also calculates the transformation parameter LAMBDAS.
%   LAMBDAS is a structure that has fields similar to the components of
%   the object. If the object contains series names 'Open' and 'Close',
%   LAMBDAS has fields with similar names (i.e LAMBDAS.Open and 
%   LAMBDAS.Close).
%
%   The Box-Cox Transformation is the family of power transformation:
%
%      DATA(LAMBDA) = ((DATA^LAMBDA) - 1) / LAMBDA;     if LAMBDA ~= 0,
%
%   or
%
%      DATA(LAMBDA) = log(DATA);                        if LAMBDA == 0.
%
%   Here, 'log' is the natural logarithm (log base e).  The algorithm calls
%   for finding the LAMBDA value that maximizes the Log-Likelihood Function
%   (LLF).  The search is conducted using FMINSEARCH.
%
%   TRANSFTS = boxcox(LAMBDA, FTS) transforms the data in the FINTS object
%   FTS using a certain specified LAMBDA for the Box-Cox Transformation.  
%   This syntax does not find the optimum LAMBDA that maximizes the LLF.
%
%   Example:   load disney.mat
%              dis_BC = boxcox(dis);
%              hist(dis_BC.CLOSE);
%
%   See also BOXCOX, FMINSEARCH.

%   Author: P. N. Secakusuma, P. Wang
%   Copyright 1995-2002 The MathWorks, Inc.
%   $Revision: 1.9 $   $Date: 2002/01/21 12:27:01 $

% If the object is of an older version, convert it.
if fintsver(ftsa) == 1
    ftsa = ftsold2new(ftsa); % This sorts the fts too.
elseif ~issorted(ftsa)
    ftsa = sortfts(ftsa);
end

transfts = ftsa;

transfts.data{1} = ['Box-Cox: ', transfts.data{1}];
for idx = 1:ftsa.serscount
    [bctfts lamb] = boxcox(ftsa.data{4}(~isnan(ftsa.data{4}(:, idx)), idx));
    transfts.data{4}(~isnan(ftsa.data{4}(:, idx)), idx) = bctfts;
    eval(['lambdas.', ftsa.names{idx+3}, ' = lamb;']);
end

% [EOF]