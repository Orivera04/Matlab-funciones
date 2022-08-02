function [x,n]=localmaxmin(y,xn)
%LOCALMAXMIN(Y) Local Maxima and Minima.
% X = LOCALMAXMIN(Y) or LOCALMAXMIN(Y,'max') for vector Y returns a logical
% vector X the same size as Y such that Y(X) contains the local maxima in Y.
%
% N = LOCALMAXMIN(Y,'min') for vector Y returns a logical vector N the same
% size as Y such that Y(N) contains the local minima in Y.
%
% [X,N] = LOCALMAXMIN(Y) for vector Y returns logical vectors X and N such
% that Y(X) contains the local maxima and Y(N) contains the local minima.
%
% When Y is a matrix, outputs are logical array(s) the same size as Y, and
% the minima and/or maxima are computed down the rows of each column in Y.
%
% See also MAX, MIN.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% MasteringMatlab@yahoo.com
% Mastering MATLAB 7
% 2006-03-08

mm=['min';'max'];
if nargin==1
   xn='max';
elseif nargin~=2
   error('localmaxmin:NotEnoughInputArguments',...
         'One or Two Input Arguments Required.')
end
if ~ischar(xn) || isempty(strcmp(xn,mm))
   error('localmaxmin:UnknownArgument','Unknown Second Input Argument.')
end
if ~isnumeric(y) || ~isreal(y)
   error('localmaxmin:IncorrectDataType','Y Must be Real Valued.')
end
ysiz=size(y);
isrow=ysiz(1)==1;
if isrow % if row, convert to column for now
   y=y';
   ysiz(1)=ysiz(2);
   ysiz(2)=1;
end
if ysiz(1)<4
   error('localmaxmin:InsufficientData','Y Must Have at Least 4 Elements.')
end
x=false(ysiz);
   
sdiff=sign(diff(y));
zdiff=sdiff==0;
idz=find(sum(zdiff)); % columns where zero differences appear

if strcmp(xn,'min') || nargout==2   % get minima
   x(2:end-1,:)=diff(sdiff)==2;
   x(1,:)=sdiff(1,:)>0;
   x(end,:)=sdiff(end,:)<0;
   if any(zdiff)
      ir=1:ysiz(1);
      for k=idz % handle columns with zero differences
         itmp=ir;
         itmp(zdiff(:,k))=[];
         if all(sdiff(:,k)==0) % entire column is flat
            x(:,k)=true;
         else
            tmp=diff(sign(diff(y(itmp,k))))==2;
            x(itmp(tmp)+1,k)=true;
            if sdiff(1,k)==0
               nr=find(sdiff(:,k)>0,1);
               nf=find(sdiff(:,k)<0,1);
               if ~(isempty(nr)||isempty(nf))
                  x(1,k)=nr<nf;
               end
            end
            if sdiff(end,k)==0
               nr=find(sdiff(:,k)>0,1,'last');
               nf=find(sdiff(:,k)<0,1,'last');
               if ~(isempty(nr)||isempty(nf))
                  x(end,k)=nr<nf;
               end
            end
         end
      end
   end
   if isrow
      x=x.';
   end
   if nargout==2
      n=x;
   end
end
if strcmp(xn,'max') || nargout==2 % get maxima
   x=false(ysiz);
   x(2:end-1,:)=diff(sdiff)==-2;
   x(1,:)=sdiff(1,:)<0;
   x(end,:)=sdiff(end,:)>0;
   if any(zdiff)
      ir=1:ysiz(1);
      for k=idz % handle columns with zero differences
         itmp=ir;
         itmp(zdiff(:,k))=[];
         if all(sdiff(:,k)==0) % entire column is flat
            x(:,k)=true;
         else
            tmp=diff(sign(diff(y(itmp,k))))==-2;
            x(itmp(tmp)+1,k)=true;
            if sdiff(1,k)==0
               nr=find(sdiff(:,k)>0,1);
               nf=find(sdiff(:,k)<0,1);
               if ~(isempty(nr)||isempty(nf))
                  x(1,k)=nr>nf;
               end
            end
            if sdiff(end,k)==0
               nr=find(sdiff(:,k)>0,1,'last');
               nf=find(sdiff(:,k)<0,1,'last');
               if ~(isempty(nr)||isempty(nf))
                  x(end,k)=nr>nf;
               end
            end
         end
      end
   end
   if isrow
      x=x';
   end
end

