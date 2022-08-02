function pretty(piset)
% PRETTY pretty output for pis
%   PRETTY(PISET)

% Steffen Brueckner, 2002-02-04

% check number of input arguments
msg = nargchk(1,1,nargin);
if msg
    error(msg);
    break;
end

DC = [piset.D piset.C];
% format with the symbolic toolbox
for ii=1:size(DC,1)
    p1{ii} = ['pi' num2str(ii) '=1'];
    for jj=1:size(DC,2)
        if DC(ii,jj) ~= 0
            p1{ii} = [p1{ii} '*' piset.Name{jj} '^(' num2str(DC(ii,jj)) ')'];
        end
    end
end

% check if symbolic toolbox exists
symtb = 1;
try
    a = sym('a^2+b^2');
catch
    symtb = 0;
end

if symtb
    % Symbolic toolbox seems to exist
    for ii=1:length(p1)
        p1s = sym(p1{ii});
        pretty(p1s);
    end
else
    % symbolic toolbox does not exist
    % use my own display method
    for ii=1:size(DC,1)
        lside = ['pi' num2str(ii) ' = '];
        nenner  = [];
        zaehler = [];
        for jj = 1:size(DC,2)
            if DC(ii,jj) > 0
                nenner = [nenner ' ' piset.Name{jj} '^(' num2str(DC(ii,jj)) ')'];
            elseif DC(ii,jj) < 0
                zaehler = [zaehler ' ' piset.Name{jj} '^(' num2str(-DC(ii,jj)) ')'];
            end
        end
        lmax      = max(length(nenner),length(zaehler));
        bruch(1:lmax) = '-';
        leernenn(1:(length(lside) + floor((lmax - length(nenner))/2))) = ' ';
        leerzaeh(1:(length(lside) + floor((lmax - length(zaehler))/2))) = ' ';
        disp([leernenn nenner]);
        disp([lside bruch]);
        disp([leerzaeh zaehler]);
        disp(' ');
    end
end