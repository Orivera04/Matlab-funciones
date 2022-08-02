function success = fill(obj, outdata, outfactors, outweights, optimname, DOWAITBAR, varargin)
%FILL Fill tables in optimization filling object
%
%  SUCCESS = FILL(OBJ, OUTDATA, OUTFACTORS, OUTWEIGHTS, OPTIMNAME,
%  DOWAITBAR) fills all the tables that are set up in OBJ. The data to fill
%  these tables is specified in OUTDATA and must be a numeric matrix.
%  OUTDATA should be the cube of data, OPTIM.OUTPUTDATA, where OPTIM is the
%  optimization you wish to fill the tables from. OUTFACTORS is a pointer
%  row vector of filling items, where length(OUTFACTORS) must equal sz(2),
%  where sz = size(OUTDATA). Again, OUTFACTORS is intended to be the third
%  output argument from the CGOPTIM method, GETSOLUTION. OUTWEIGHTS must be
%  a numeric column vector of length sz(1). This is intended to be
%  OPTIM.OUTPUTWEIGHTS. OPTIMNAME is the name of the optimization (will
%  appear in the table history). DOWAITBAR determines whether a progress
%  bar will be shown (TRUE) or not (FALSE). A (1-by-NTAB) logical vector
%  indicating the success of each table filling operation is returned in
%  SUCCESS.
%
%  SUCCESS = FILL(OBJ, OUTDATA, OUTFACTORS, OUTWEIGHTS, OPTIMNAME,
%  DOWAITBAR, TABLES) fills the tables in the pointer array, TABLES. All
%  members of tables must be in OBJ. 
%  
%  See also CGOPTIMTABLEFILLER, CGOPTIM/GETSOLUTION

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%   $Revision: 1.1.6.2 $  $Date: 2004/02/09 06:54:07 $

% Input argument checks
if nargin > 6

    % Ensure that tables input is a pointer array of tables
    [ok, msg] = pCheckTables(varargin{1});
    if ~ok
        error('mbc:cgoptimtablefiller:InvalidArgument', msg);
    end

    % Ensure that all the pointers can be located in the object
    inds = findptrs(varargin{1}, obj.tables);
    if ~all(inds)
        errmsg = 'Cannot find all tables in the table filler';
        error('mbc:cgoptimtablefiller:InvalidArgument', errmsg);
    end
end

if nargin > 6
    % Filling specified tables
    inds = findptrs(varargin{1}, obj.tables);
    fillflag = false(1, length(obj.tables));
    fillflag(inds) = true; 
else
    % Filling all tables
    fillflag = true(1, length(obj.tables));
end
success = pFill(obj, outdata, outfactors, outweights, optimname, DOWAITBAR, fillflag);
