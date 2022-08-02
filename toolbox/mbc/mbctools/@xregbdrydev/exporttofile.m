function [ok, err] = exporttofile( bdev, file )
%EXPORTTOFILE A short description of the function
%
%  [OK, ERR] = EXPORTTOFILE(BDEV, NAME)
%  

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.

%  $Revision: 1.2.6.1 $    $Date: 2004/02/09 08:13:00 $ 

if nargin < 2 || isempty( file ),
    err = 'No filename specified';
    ok = 0;
end

con = model( bdev );
%%M = xregStatsModel( con, 'constraint' );
try
    save( file, 'con', '-mat' );
    ok = 1;
    err = '';
catch
    err = ['Unable to save to file: ' file '. ' lasterr ];
    ok = 0;
end

%------------------------------------------------------------------------------|
% EOF
%------------------------------------------------------------------------------|
