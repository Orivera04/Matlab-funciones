function varargout = latex(piset,flag)
% LATEXPI LaTeX output for pis
%   LATEXPI(PISET)

% if exist the latex command from the symbolic
% math toolbox is used otherwise a local interpretation
% is used

% flag is undocumented and may change in later versions!
% flag = 1 means not to use the symbolic math toolbox

% Steffen Brueckner, 2002-02-04

% check number of input arguments
msg = nargchk(1,2,nargin);
if msg
    error(msg);
    break;
end

if nargin < 2
    flag = 0;
end

DC = [piset.D piset.C];

% determine if symbolic toolbox can be used
symtb = 1;
try
    tmp = sym('a^2+b^3');
catch
    symtb = 0;
end
    
if symtb & ~flag % sybolic toolbox seems to exist
    % format using the symbolic toolbox
    for ii=1:size(DC,1)
        p1{ii} = ['\pi_' num2str(ii) '=1'];
        for jj=1:size(DC,2)
            if DC(ii,jj) ~= 0
                p1{ii} = [p1{ii} '*' piset.Name{jj} '^(' num2str(DC(ii,jj)) ')'];
            end
        end
    end

    for ii=1:length(p1)
        p1s = sym(p1{ii});
        L{ii} = latex(p1s);
    end
else
    % symbolic toolbox seems not to exist
    % use my own subroutine insted
     for ii=1:size(DC,1)
        lside = ['{\it \pi_{' num2str(ii) '}} = '];
        nenner  = [];
        zaehler = [];
        for jj = 1:size(DC,2)
            if DC(ii,jj) > 0
                if DC(ii,jj) ~= 1
                    nenner = [nenner '{' piset.Name{jj} '}^{' num2str(DC(ii,jj)) '}'];
                else
                    nenner = [nenner '{' piset.Name{jj} '}'];
                end
            elseif DC(ii,jj) < 0
                if DC(ii,jj) ~= -1
                    zaehler = [zaehler '{' piset.Name{jj} '}^{' num2str(-DC(ii,jj)) '}'];
                else
                    zaehler = [zaehler '{' piset.Name{jj} '}'];
                end
            end
        end
        L{ii} = [lside '\frac{' nenner '}{' zaehler '}'];
    end
end


if nargout == 0
    % print to screen if no output parameters are defined
    if exist('L','var')
        for ii=1:length(L)
            disp(L{ii});
        end
    else
        disp('No dimensionless groups in this dimensional set!');
    end
else
    if exist('L','var')
        varargout{1} = L;
    else
        varargout{1} = [];
    end
end