function ind=Terms(m);
% xreglinear/TERMS  Logical Index to Terms included in Model
%
% ind=Terms(m)

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%   $Revision: 1.4.4.2 $  $Date: 2004/02/09 07:49:10 $



ind= ~m.TermsOut;

% Changes below made for term_selector only?  They break the char method
% so I've removed them.  Put them back if they break something more important!
%if ~isempty(m.Store) & isfield(m.Store,'DispOrder') & m.Store.DispOrder
%   ind= ind(termorder(m));
%end