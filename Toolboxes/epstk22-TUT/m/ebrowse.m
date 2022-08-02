%%NAME
%%  ebrowse  -  start browser to show html-file(s) 
%%
%%SYNOPSIS
%%  ebrowse(url)
%%
%%PARAMETER(S)
%%  url    url-address
%%
%%GLOBAL PARAMETER(S)
%%  eBrowser
%%
% written by stefan.mueller@fgan.de (C) 2007
function ebrowse(url)
  if nargin<1
    eusage('ebrowse(url)');
  end
  eglobpar;
  if exist('eFac')
    if isempty(eFac)
      einit;
    end
  else
    einit;
  end

  if isempty(eBrowser)
    disp('error in ebrowse: no browser installed');
  else
    browsercmd=sprintf('%s %s &',eBrowser,url);
    if exist('matlabpath')~=5
      system(browsercmd);
    else
      unix(browsercmd);
    end
  end
