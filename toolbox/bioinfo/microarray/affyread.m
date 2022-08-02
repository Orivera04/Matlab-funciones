function affystruct = affyread(filename,libdir)
%AFFYREAD reads Affymetrix GeneChip data files.
%   AFFYDATA = AFFYREAD(FILE) reads the Affymetrix data file, FILE, and
%   creates a structure, AFFYDATA. AFFYREAD can read DAT, EXP, CEL, CHP and
%   CDF files.
%
%   AFFYDATA = AFFYREAD(FILE,LIBDIR) allows you to specify the directory
%   where the library (CDF) files are stored.
%
%   Example:
%
%       % Read in a CEL file 
%       celStruct = affyread('Drosophila-121502.CEL')
%       % Display a spatial plot of probe intensities
%       maimage(celStruct,'Intensity');
%
%       % Read in a DAT file and display the raw image data
%       datStruct = affyread('Drosophila-121502.dat')
%       imagesc(datStruct.Image); 
%       axis image;
%
%   Sample data is available from 
%   http://www.affymetrix.com/support/technical/sample_data/demo_data.affx 
%
%   See also GPRREAD, SPTREAD.
%
%   GeneChip and Affymetrix are registered trademarks of Affymetrix, Inc. 

% Copyright 2003-2004 The MathWorks, Inc.
% $Revision: 1.1.6.6 $   $Date: 2004/03/22 23:53:40 $ 

% Currently only supported on Windows
if ~ispc
    error('Bioinfo:AffyreadWindowsOnly',...
        'AFFYREAD is only supported on Windows.');
end

if nargin < 1
    error('Bioinfo:NotEnoughInputs','Not enough input arguments.');
end

% The GDAC runtime libraries must be installed. Check to see if they are.
% If not try to install them.
try
    verNum  = winqueryreg('HKEY_LOCAL_MACHINE',... 
        'SOFTWARE\Affymetrix\GDAC', 'GDACFiles Version'); %#ok
catch
    % GDAC runtime not installed...
    theButton =questdlg(...
        sprintf(['The Affymetrix GDAC Runtime Libraries must be installed. \n',...
            'Would you like to install them now?']),...
        'Install GDAC Runtime Libraries?',...
        'Yes','No','Yes');
    if strcmp(theButton,'Yes')
        system([matlabroot '\toolbox\bioinfo\microarray\lib\GDACFilesInstall.exe']);
    else
        error('Bioinfo:GDACNotInstalled',...
            'Affyread requires the Affymetrix GDAC Runtime Libraries.');    
    end
end

% figure out if the file is in the current directory of not
[pathdir,theName,theExt] = fileparts(filename);

% if no path part, use the local directory
if isempty(pathdir)
    pathdir = pwd;
end

% check for valid extensions?
theFile = [theName,upper(theExt)];

% Set up the lib path
if nargin == 1    
    libdir = pathdir;
end

if ~exist([pathdir,filesep,theFile])
    error('Bioinfo:AffyreadFileDoesNotExist',...
        '%s does not appear to exist.',theFile);
end

% read the file using affymex

affystruct = affymex(theFile,pathdir,libdir);

if isempty(affystruct)
    error('Bioinfo:AffyreadFailed','Unable to read file %s.',theFile);
end
