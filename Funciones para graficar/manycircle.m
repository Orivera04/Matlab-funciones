function hr=circle(varargin)
%CIRCLE Circle Graphics Object.
% CIRCLE(R,XY) draws a circle on the current axis where R is the radius,
% and XY=[Xc Yc] where Xc and Yc are the x and y coordinates of the circle
% center. If R is an N-by-1 vector and XY is an N-by-2 matrix, each row
% specifies a different circle to be drawn.
%
% CIRCLE(R,XY,S) applies the line specs given in S to the circle. S is a
% character string containing color and/or line style information in the
% same manner they are used in the function PLOT. Data markers, e.g., 'x',
% are not accepted.
%
% CIRCLE(R1,XY1,S1,R2,XY2,S2,...) draws multiple circles each with optional
% line specs.
%
% CIRCLE(Haxes,...) draws the circles on the axes having handle Haxes.
% Hr=CIRCLE(...) returns handles to the created Rectangle objects.
%
% 'axis equal' must be applied to correct visual axis distortion.
%
% See also RECTANGLE, PLOT, AXIS.

% D.C. Hanselman, University of Maine, Orono, ME 04469
% MasteringMatlab@yahoo.com
% Mastering MATLAB 7
% 2005-10-01

% parse inputs

if nargout
   hr=[];
end
ni=nargin;
if ni<2
   error('At Least Two Inputs are Required.')
end
Haxes=varargin{1}(1);
if ishandle(Haxes) && strcmp(get(Haxes,'type'),'axes')
   varargin(1)=[];
   ni=ni-1;
else
   Haxes=gca;
end

HaveR=false;
GotSet=false;
ki=1;
while ki<=ni
   arg=varargin{ki};
   if ~HaveR                                  % looking for Radius argument
      if isnumeric(arg) && isvector(arg)
         HaveR=true;
         HaveXY=false;
         R=abs(arg(:));
      else
         error('Radius Argument Expected.')
      end
   elseif ~HaveXY                                  % looking for XY Centers
      if isnumeric(arg)
         HaveXY=true;
         XY=arg;
         if ki==ni
            GotSet=true;
            S='k-';
         end
      else
         error('XY Center Argument Expected.')
      end
   else                         % looking for potential Color and Linestyle
      if ischar(arg)
         S=arg;
      else  % got next R, set defaults and don't increment to next argument
         S='k-';
         ki=ki-1;
      end
      HaveR=false;
      HaveXY=false;
      GotSet=true;
   end
   if GotSet                                % got a circle data set to plot
      [ls,c,m,msg]=colstyle(S);
      if ~isempty(msg)
         error('Line Spec String Contains Unrecognized Characters.')
      end
      if isempty(ls)
         ls='-';
      end
      if isempty(c)
         c='k';
      end
      if ~isempty(m)
         warning('Marker Types are Not Supported.')
      end
      nr=length(R);
      if nr~=size(XY,1)
         error('Length of R and Rows of XY Must be Equal.')
      end
      h=zeros(nr,1);
      for k=1:nr
         
         h(k)=rectangle('Parent',Haxes,...
            'Position',[XY(k,1)-R(k) XY(k,2)-R(k) 2*R(k) 2*R(k)],...
            'Curvature',[1 1],...
            'EdgeColor',c,...
            'Linestyle',ls);
      end
      GotSet=false;
      if nargout==1
         hr=[hr;h]; % gather handles
      end
   end
   ki=ki+1;                                       % Get next input argument
end
