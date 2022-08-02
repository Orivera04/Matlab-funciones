%%NAME
%%  eview  -  start ghostview to show eps-file 
%%
%%SYNOPSIS
%%  eview([epsFileName])
%%
%%PARAMETER(S)
%%  epsFileName    name of eps-file
%%                 default: string of global parameter 'eFileName' 
%%GLOBAL PARAMETER(S)
%%  eFileName
%%  eGhostview
% written by stefan.mueller@fgan.de (C) 2007
function eview(epsFileName)
  if nargin>1
    eusage('eview([epsFileName])');
  end
  eglobpar;
  if exist('eFac')
    if isempty(eFac)
      einit;
    end
  else
    einit;
  end
  if nargin<1
    epsFileName=eFileName;
  end

  if exist(epsFileName)~=2
    disp('error in eview: file not exist');
  else
    if isempty(eGhostview)
      disp('error in eview: no Postscript viewer installed');
    else
      gsview=sprintf('%s %s &',eGhostview,epsFileName);
      if exist('matlabpath')~=5
        system(gsview);
      else
        unix(gsview);
      end
    end
  end
