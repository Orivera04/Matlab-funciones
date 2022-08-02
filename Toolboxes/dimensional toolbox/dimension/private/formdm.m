function [D,B,ind] = formdm(Din,Bin)
% FORMDM forms a dimensional matrix
%  [D,ind] = FORMDM(Din) deletes zero rows from the
%  matrix Din and returns the resulting matrix and
%  the index vector
%  [A,B,ind] = formdm(A,B);

% Dimensional Analysis Toolbox for Matlab
% Steffen Brueckner, 2002-02-09

% check number of input arguments
msg = nargchk(1,2,nargin);
if msg
    error(msg);
    break;
end

if nargin == 2
    Din = [Bin Din];
end

% find zero rows
ind = ~fzerom(Din,2);

D = Din(ind,:);
if nargin == 2
    B = Bin(ind,:);
end

% Ueberfluessige Dimensionen loeschen
[D,ind] = rmlindep(D);
if nargin == 2
    B       = D(:,1:size(Bin,2));
    D       = D(:,size(Bin,2)+1:end);
end