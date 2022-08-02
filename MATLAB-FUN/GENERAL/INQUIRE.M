function [a,b] = inquire(arg1)
%INQUIRE  MATLAB internal states.
%	INQUIRE('echo') returns 1 if ECHO is on, 0 if ECHO is off.
%	INQUIRE('casesen') returns 1 if CASESEN is on, 0 if off. 
%	INQUIRE('hold') returns 1 if HOLD is on, 0 if HOLD is off.
%
%	[S,V] = INQUIRE('axis') returns S=0 if AXIS is autoranging,
%	S=1 if the AXIS is frozen.  Vector V contains the current
%	axis limits, V = [Xmin Xmax Ymin Ymax].
%
%	INQUIRE('subplot') returns the current SUBPLOT state, e.g.
%	111, 211, 223, etc.
%
%	[F,D] = INQUIRE('format') returns strings F and D such that
%	EVAL(F),EVAL(D) would restore the current format state. 
%	F is a string like 'format short e' or 'format hex'.
%	D is either 'format compact' or 'format loose'.
%
%	[S,FNAME] = INQUIRE('diary') returns S=0 if the diary is
%	off, S=1 if the diary is on, and the name of the current
%	diary file in FNAME.  FNAME is empty if no file is named.
%
%	This function is obsolete.  Please use GET to inquire
%	state values.

%	Copyright (c) 1984-94 by The MathWorks, Inc.

disp('This usage of inquire(''property'') is obsolete and will be eliminated in future')
disp('versions.  Please use get(handle,''property'') instead.')
if nargin < 1
	error('Must be one input argument.');
end

if strcmp(arg1,'hold')
	cax = gca;
	next = lower(get(cax,'NextPlot'));
	a = strcmp(next,'add') & strcmp('add',lower(get(gcf,'NextPlot')));
elseif strcmp(arg1,'axis')
	a1 = axis('state');
	if strcmp(a1,'auto')
		a = 0;
	else
		a = 1;
	end
	b = axis;
elseif strcmp(arg1,'echo')
	a1 = get(0,'echo');
	if strcmp(a1,'on')
		a = 1;
	else
		a = 0;
	end
elseif strcmp(arg1,'casesen')
	a1 = get(0,'casesen');
	if strcmp(a1,'on')
		a = 1;
	else
		a = 0;
	end
elseif strcmp(arg1,'format')
	a = get(0,'format');
	b = get(0,'formatspacing');
elseif strcmp(arg1,'diary')
	a1 = get(0,'diary');
	if strcmp(a1,'on')
		a = 1;
	else
		a = 0;
	end
	b = get(0,'diaryfile');
elseif strcmp(arg1,'subplot');
	rect = get(gca,'position');
	table = [ 0.13   0.11  0.77 0.81
   0.13   0.11   0.3175   0.81
   0.5825   0.11   0.3175   0.81
   0.13   0.11   0.17566666666667   0.81
   0.42716666666667   0.11   0.17566666666667   0.81
   0.72433333333333   0.11   0.17566666666667   0.81
   0.13   0.5825   0.77   0.3375
   0.13   0.11   0.77   0.3375
   0.13   0.5825   0.3175   0.3375
   0.5825   0.5825   0.3175   0.3375
   0.13   0.11   0.3175   0.3375
   0.5825   0.11   0.3175   0.3375
   0.13   0.5825   0.17566666666667   0.3375
   0.42716666666667   0.5825   0.17566666666667   0.3375
   0.72433333333333   0.5825   0.17566666666667   0.3375
   0.13   0.11   0.17566666666667   0.3375
   0.42716666666667   0.11   0.17566666666667   0.3375
   0.72433333333333   0.11   0.17566666666667   0.3375
   0.13   0.7310   0.77   0.1890
   0.13   0.4205   0.77   0.1890
   0.13   0.11   0.77   0.1890
   0.13   0.7310   0.3175   0.1890
   0.5825   0.7310   0.3175   0.1890
   0.13   0.4205   0.3175   0.1890
   0.5825   0.4205   0.3175   0.1890
   0.13   0.11   0.3175   0.1890
   0.5825   0.11   0.3175   0.1890
   0.13   0.7310   0.17566666666667   0.1890
   0.42716666666667   0.7310   0.17566666666667   0.1890
   0.72433333333333   0.7310   0.17566666666667   0.1890
   0.13   0.4205   0.17566666666667   0.1890
   0.42716666666667   0.4205   0.17566666666667   0.1890
   0.72433333333333   0.4205   0.17566666666667   0.1890
   0.13   0.11   0.17566666666667   0.1890
   0.42716666666667   0.11   0.17566666666667   0.189
   0.72433333333333   0.11   0.17566666666667   0.189];
	[m,n] = size(table);
	ind = [
     1     1     1
     1     2     1
     1     2     2
     1     3     1
     1     3     2
     1     3     3
     2     1     1
     2     1     2
     2     2     1
     2     2     2
     2     2     3
     2     2     4
     2     3     1
     2     3     2
     2     3     3
     2     3     4
     2     3     5
     2     3     6
     3     1     1
     3     1     2
     3     1     3
     3     2     1
     3     2     2
     3     2     3
     3     2     4
     3     2     5
     3     2     6
     3     3     1
     3     3     2
     3     3     3
     3     3     4
     3     3     5
     3     3     6
     3     3     7
     3     3     8
     3     3     9];
	a = nan;
	for i = 1:m
		if norm(table(i,:)-rect) < .00001
			a = 100*ind(i,1)+10*ind(i,2)+ind(i,3);
			break;
		end
	end
else
	error(['OPTION ',arg1,' is unknown.']);
end








