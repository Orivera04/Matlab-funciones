function str=char(nn,hg);
% CHAR  Char function for xregnnet

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:56:13 $

% Created 9/5/2000

neurs = get(nn,'hiddenneurons');
if length(neurs)==1
   str = ['1 hidden layer containing ' num2str(neurs) 'neurons.'];
else
   str = strvcat(['2 hidden layers'],...
      ['     First layer: ' num2str(neurs(1)) ' neurons.'],...
      ['     Second layer: ' num2str(neurs(2)) ' neurons.']);
end
return