function out=get(rl,varargin)
%ROLLER/GET   /get interface for roller object
%   Implements get interface for graph1d object
%   Currently supported properties are:
%    'Position'   -   4 element vector
%    'Visible'    -   'on'/'off'
%    'Value'      -   1/0
%    'String'     -   two element cell array, for
%                     the 0 and then the 1 state.
%    'Callback'   -   callback string

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 07:20:05 $



% Bail if we've not been given a graph1d object
if ~isa(rl,'roller')
   error('Cannot get properties: not a roller object!')
end

% loop over varargin
for n=1:(nargin-1)
   switch lower(varargin{n})
   case 'position'
      out=get(rl.frame1,'position');      
   case 'visible'
      out=get(rl.frame1,'userdata');
      if out
         out='on';
      else
         out='off';
      end
   case 'value'
      out=get(rl.frame2,'userdata');
   case 'string'
      out=get([rl.text1;rl.text2],{'string'});
   case 'callback'
      out=get(rl.text2,'userdata');
      out=out.callback;
   otherwise
      out=get([rl.text1;rl.text2],varargin{n});
   end
   
end