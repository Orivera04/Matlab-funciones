function PiData = dtrans(XData,piset)
% DTRANS transform data from x to pi domain
%   PiData = DTRANS(XData,piset) transforms the
%   given XData from the x-domain to the PiData
%   in the pi-domain of dimensionless groups
%   using the pi transform given in piset
%   The rows in XData correspond to the variables
%   in x, the rows in PiData correspond to the
%   pi numbers. The columns correspond to the
%   individual data record.

% Dimensional Analysis Toolbox for Matlab
% Steffen Brueckner, 2002-02-07

% check input arguments
msg = nargchk(2,2,nargin);
if msg
    error(msg);
    break;
end

% check dimensional set for consistency
msg = chkDimensionalSet(piset);
if msg
    error(msg);
    break;
end

% sort XData according to the order in piset
XData = XData(piset.order,:);

% determine the number of dimensionless groups
npi = size(piset.D,1);
DC  = [piset.D piset.C];
for ii=1:npi
    PiData(ii,:) = ones(1,size(XData,2));
    for jj = 1:size(DC,2)
        mtmp = (XData(jj,:).^DC(ii,jj));
        PiData(ii,:) = PiData(ii,:) .* mtmp;
    end
end

% --------------------------------------------------------------

function msg = chkDimensionalSet(piset)
% checks the dimensional set for consistency
% Steffen Brueckner, 2002-02-07
    msg = [];
    A = piset.A;
    B = piset.B;
    C = piset.C;
    D = piset.D;
    order = piset.order;
    Name  = piset.Name;
    
    if isequal(A,[])
        msg = 'no base variables selected';
        break;
    end
    if isequal(B,[])
        msg = 'no dependent variables selected';
        break;
    end
    if size(B,1) ~= size(A,1)
        msg = 'A and B matrices must have same number of rows';
        break;
    end
    if isequal(D,[])
        msg = 'D matrix not defined';
    else
        if size(D,1) ~= size(D,2)
            msg = 'D matrix must be square';
            break;
        end
        if size(D,2) ~= size(B,2)
            msg = 'B and D matrices must have same number of columns';
            break;
        end
    end
    if isequal(C,[])
        msg = 'C matrix not defined!';
    else
        if isequal(D,[])
            msg = 'C matrix without D matrix makes no sense';
            break;
        end
        if size(D,1) ~= size(C,1)
            msg = 'C and D matrices must have same number of rows';
            break;
        end
        if size(C,2) ~= size(A,2)
            msg = 'A and C matrices must have same number of columns';
            break;
        end
    end
    if rank([B A]) ~= rank(A)
        msg = 'A matrix must have same rank as [B A]';
        break;
    end
    if length(order) ~= (size(B,2) + size(A,2))
        msg = 'order must be of same length as [B A] has columns';
        break;
    end
    if length(Name) ~= (size(B,2) + size(A,2))
        msg = 'Name must be of same length as [B A] has columns';
        break;
    end
