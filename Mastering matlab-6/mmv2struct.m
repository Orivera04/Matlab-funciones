function varargout=mmv2struct(varargin)
%MMV2STRUCT Pack/Unpack Variables to/from a Scalar Structure. (MM)
% MMV2STRUCT(X,Y,Z,...) returns a structure having fields X,Y,Z,...
% containing the corresponding data stored in X,Y,Z,...
% Inputs that are not variables are stored in fields named ansN
% where N is an integer identifying the Nth unnamed input.
%
% MMV2STRUCT(S)assigns the contents of the fields of the scalar structure
% S to variables in the calling workspace having names equal to the
% corresponding field names.
%
% Example: X=zeros(3); Y='Testing123'; Z=cell(2,3);
% S=MMV2STRUCT(X,Y,Z,pi) returns a structure S containing the following
% fields: S.X  S.Y  S.Z  S.ans1 each containing the contents of the
% corresponding variables.
% MMV2STRUCT(S) creates or overwrites variables X, Y, Z, ans1 in the caller
% with the contents of the corresponding named fields.
%
% [A,B,C,...]=MMV2STRUCT(S) assigns the contents of the fields of the
% scalar structure S to the variables A,B,C,... rather than overwriting
% variables in the caller. If there are fewer output variables than
% there are fields in S, the remaining fields are not extracted.
%
% Using the above example, [A,B,C]=MMV2STRUCT(S) returns the contents of
% S.X in A, S.Y in B, and S.Z in C and does not extract S.ans1 because
% no output argument was provided for it. FIELDNAMES(S) determines the
% order in which the fields in S are assigned to the output arguments
% of MMV2STRUCT.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% 4/28/99, 9/29/99, renamed 10/19/99
% Mastering MATLAB 5, Prentice Hall, ISBN 0-13-858366-8

if nargin==0
    error('Input Arguments Required.')
elseif nargin==1 % Unpack
    arg=varargin{1};
    if ~isstruct(arg)|length(arg)~=1
        error('Single Input Must be a Scalar Structure.')
    end
    names=fieldnames(arg);
    if nargout==0 % assign in caller
        for i=1:length(names)
            assignin('caller',names{i},getfield(arg,names{i}))
        end
    else % dump into variables
        for i=1:nargout
            varargout{i}=getfield(arg,names{i});
        end
    end
else % Pack
   num=1;
   for i=1:nargin
      name=inputname(i);
      if isempty(name)
         name=sprintf('ans%d',num);
         num=num+1;
      end
      eval(['y.' name '=varargin{i};'])
   end
   varargout{1}=y;
end