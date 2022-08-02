function [name, pattern,  len, ncuts,blunt,c1,c2,c3,c4] = readrebase
%READREBASE reads a REBASE data file
%   READREBASE reads the EMBOSS format Enzyme file
%   name = name of enzyme
%   pattern = recognition site
%   len = length of pattern
%   ncuts = number of cuts made by enzyme
%          Zero represents unknown
%   blunt = true if blunt end cut, false if sticky
%   c1 = First 5' cut
%   c2 = First 3' cut
%   c3 = Second 5' cut
%   c4 = Second 3' cut
%
% Reference: REBASE The Restriction Enzyme Database 
% 
% The Restriction Enzyme data BASE 
% A collection of information about restriction enzymes and related proteins. It contains published and unpublished references,
% recognition and cleavage sites, isoschizomers, commercial availability, methylation sensitivity, crystal and sequence data.
% DNA methyltransferases, homing endonucleases, nicking enzymes, specificity subunits and control proteins are also included.
% Putative DNA methyltransferases and restriction enzymes, as predicted from analysis of genomic sequences, are also listed.
% REBASE is updated daily and is constantly expanding.
% 
% AUTHORS:
% Dr. Richard J. Roberts and Dana Macelis
% LATEST REVIEW:
% Nucleic Acids Research 29: 268-269 (2001).
% OFFICIAL REBASE WEB SITE:
% http://rebase.neb.com
% 

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/01/24 09:18:41 $

numHeaderlines = 42;

try
    [name, pattern, len, ncuts,blunt,c1,c2,c3,c4] = textread('rebase_e.txt',...
                '%s%s%d%d%d%d%d%d%d','headerlines',numHeaderlines,'delimiter','\t');
catch
    error('Bioinfo:CannotReadRebase','Unable to read the Rebase file.');
end


% About EMBOSS  (the European Molecular Biology Open Software Suite) 
% For more information about EMBOSS visit:
% 
% http://www.sanger.ac.uk/Software/EMBOSS 
