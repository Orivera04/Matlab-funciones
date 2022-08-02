function [b,matrixInfo] = pam(N,varargin)
%PAM returns members of the PAM family of scoring matrices.
%
%   B = PAM(N) returns the PAMN matrix. Supported values of N are
%   10:10:500. Default ordering of the outputs is
%   A R N D C Q E G H I L K M F P S T W Y V B Z X *.
%
%   B = PAM(...,'EXTENDED',false) returns the scoring matrix for the 20
%   amino acids only and not for the extended symbols B,Z,X, and *.
%
%   B = PAM(...,'ORDER',ORDER) returns the Blosum N matrix ordered by
%   the amino acid sequence ORDER. If ORDER does not contain the extended
%   characters B,Z,X, and *, then these characters are not returned.
%
%   [B,MATRIXINFO] = PAM(N) returns a structure of information about
%   the PAM N matrix with fields Name, Scale, Entropy, Expected, and
%   Order.
%
%   Examples:
%
%      PAM50 = pam(50)
%      PAM250 = pam(250,'order','CSTPAGNDEQHRKMILVFYW')
%
%   See also BLOSUM, NWALIGN, PAM250, SWALIGN.

%   Reference: Dayhoff M.O., Schwartz R. and Orcutt B.C. (1978) Atlas of
%   protein sequence and structure. Vol. 5, Suppl. 3, Ed. M. O. Dayhoff.
%

%   Copyright 2003-2004 The MathWorks, Inc.
%   $Revision: 1.2.6.4 $  $Date: 2004/03/14 15:31:32 $

extended=true;
ordered=false;
possibleN = 10:10:500;

names='ARNDCQEGHILKMFPSTWYVBZX*';
intOrder = aa2int(names);

if ~ismember(N,possibleN)
    error('Bioinfo:InvalidBlosumN',...
        'PAM%d does not exist. Valid numbers are 10:10:500.',N);
end

if nargin > 1
    if rem(nargin,2)== 0
        error('Bioinfo:IncorrectNumberOfArguments','Incorrect number of arguments to %s.',mfilename);
    end
    okargs = {'extended','order'};
    for j=1:2:nargin-2
        pname = varargin{j};
        pval = varargin{j+1};
        k = strmatch(lower(pname), okargs);
        if isempty(k)
            error('Bioinfo:UnknownParameterName','Unknown parameter name: %s.',pname);
        elseif length(k)>1
            error('Bioinfo:AmbiguousParameterName','Ambiguous parameter name: %s.',pname);
        else
            switch(k)
                case 1 % extended
                    extended = opttf(pval);
                    if isempty(extended)
                        error('Bioinfo:InputOptionNotLogical','%s must be a logical value, true or false.',...
                            upper(char(okargs(k))));
                    end
                case 2 %order
                    order=pval;
                    ordered=true;
                    if ischar(order)
                        intOrder = aa2int(order);
                    else
                        intOrder = order;
                    end

                    if numel(intOrder)<20
                        error('Bioinfo:ShortOrder','The length of the order is less than 20.');
                    end
                    if any(intOrder == 0)
                        error('Bioinfo:InvalidOrder','The order contains characters that are not valid amino acids.');
                    end
            end
        end
    end
end

[b,matrixInfo] = feval(sprintf('pam%d',N));

% permute matrix if necessary.
if ordered || ~extended
    if extended == false
        intOrder(intOrder>20) = [];
    end
    b = b(intOrder,intOrder);
    matrixInfo.Order = int2aa(intOrder);
end
