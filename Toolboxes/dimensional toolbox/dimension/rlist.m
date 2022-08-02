function RL = rlist(RL,Name,Dimension,Factor)
% RLIST  manage relevance liste
%    RL = RLIST(RL,NAME,DIMENSION,FACTOR) add a
%    variable NAME to the relevance list RL with
%    the dimension exponents row vector DIMENSION 
%    which is padded with zeros to a length of 7
%    if shorter. The optional argument FACTOR
%    (default 1) is the factor between given data
%    and the data in SI units
%    NAME, DIMENSION and FACTOR can also be cell
%    arrays and matrices of identical length.
%
%    RL = RLIST(NAME,DIMENSION,FACTOR) creates a
%    new relevance list RL and inserts the variables
%    given in NAME, DIMENISION and FACTOR with FACTOR
%    beeign optional (default = 1)

% Steffen Bruecker, 2002-02-04
% mod. Bü - 2002-02-07

    % check for number of input arguments
    msg = nargchk(2,4,nargin);
    if msg
        error(msg);
        break;
    end

    % check for creation of new relevance list or adding
    % a variable
    if ~isstruct(RL) & ~isequal(RL,[])
        % create new relevance list and rename input parameters
        msg = nargchk(2,3,nargin);
        if msg
            error(msg);
        end
        if nargin == 3
            Factor = Dimension;
        else
            if ~isnumeric(Name)
                error('Dimension must be numeric array!');
                break;
            end
            Factor = [];
        end
        Dimension = Name;
        Name = RL;
        RL = [];
    else
        % check if FACTOR is given
        if nargin < 4
            Factor = [];
        end
    end
    
    % use default FACTOR if not given
    if isequal(Factor,[])
        if isstr(Name)
            Factor = 1;
        else
            Factor = ones(1,length(Name));
        end
    end
    
    % see if RL already exists
    if exist('RL','var') ~= 1
        RL = [];
    end
    
    if isstr(Name)
        % only one variable to add
        n = length(RL)+1;
        RL(n).Name      = Name;
        Dimension = [Dimension ; zeros(7,1)];
        Dimension = Dimension(1:7);
        RL(n).Dimension = Dimension;
        RL(n).Factor    = Factor;
    else
        for ii=1:length(Name)
            % more variables to add
            n = length(RL)+1;
            RL(n).Name      = Name{ii};
            D = [Dimension(:,ii) ; zeros(7,1)];
            D = D(1:7);
            RL(n).Dimension = D;
            RL(n).Factor    = Factor(ii);
        end
    end
    
            