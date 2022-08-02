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
% written by stefan.mueller stefan.mueller@fgan.de (C) 2003
function eview(epsFileName)
  if nargin>1
    eusage('eview([epsFileName])');
  end
  eglobpar;
  if nargin<1
    epsFileName=eFileName;
  end
  if exist('eGhostview')~=1
    einit;
    eglobpar;
  end
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
