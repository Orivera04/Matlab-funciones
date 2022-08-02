function hOut = traceplot(thetrace,C,G,T)
%TRACEPLOT draws a nucleotide trace plot.
%
%   TRACEPLOT(TRACESTRUCT) creates a trace plot from data in structure
%   TRACESTRUCT with fields A,C,G,T.
%
%   TRACEPLOT(A,C,G,T) creates a trace plot from data in vectors A,C,G,T.
%
%   h = TRACEPLOT(...) returns a structure of the handles of the lines
%   corresponding to A, C, G, and T.
%
%   Example:
%
%       tstruct = scfread('sample.scf');
%       traceplot(tstruct)
%
%   Sample SCF files can be found in
%   ftp://ftp.ncbi.nih.gov/pub/TraceDB/example/
%
%   See also SCFREAD.

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.1.4.2 $  $Date: 2004/01/24 09:19:11 $

if nargin ~=4
    if ~isstruct(thetrace) || numel(intersect(fieldnames(thetrace),{'A','C','G','T'})) ~= 4
        error('Bioinfo:NotAStructure',...
            'The input to TRACEREAD must be a structure with fields A,C,G and T.');
    end
else
    thetrace.A = thetrace;
    thetrace.C = C;
    thetrace.G = G;
    thetrace.T = T;
end


h.A = plot(thetrace.A,'g');
holdState = ishold;
hold('on');

h.C = plot(thetrace.C,'b');
h.G = plot(thetrace.G,'k');
h.T = plot(thetrace.T,'r');
legend({'A','C','G','T'});

if ~holdState
    hold('off');
end

if nargout > 0
    hOut = h;
end
