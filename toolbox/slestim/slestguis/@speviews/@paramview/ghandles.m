function h = ghandles(this)
%  GHANDLES  Returns a 3-D array of handles of graphical objects associated
%            with a paramview object.

%  Author(s): Bora Eryilmaz
%  Copyright 1986-2004 The MathWorks, Inc.
%  $Revision: 1.1.6.2 $ $Date: 2004/04/11 00:41:31 $
Np = length(this.Curves);

% Determine max number of entries
Ne = max(cellfun('length',this.Curves));
h = repmat(handle(NaN),[Np 1 Ne]);
for ct=1:Np
   c = this.Curves{ct};
   nc = length(c);
   h(ct,:,1:nc) = reshape(c,[1 1 nc]);
end
