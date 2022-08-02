function varargout= matchnames(T,action,varargin)
%TESTPLAN/OK
%TP=matchnames('create',TP,Sweepset)
%Matches symbols from the testplan model to names from the sweepset

%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.


%   $Revision: 1.2.2.2 $  $Date: 2004/02/09 08:07:59 $


switch lower(action)
case 'layout'
	D= T.DesignDev;
	m= HSModel(D);
	if T.DataLink ~= 0
        S= info(T.DataLink);
        if isa(S,'xregpointer')
            S= info(S);
        end
		S= sweepset(S);
	else
        % choose the first one
		DDev= peval('dataptrs',project(T));
		S= DDev(1).sweepset;
	end

	p= xregpointer(m);
	
	[lyt]= gui_signalchooser(m,'layout',varargin{1},p,S,1);

	varargout= {lyt,p};
	
case 'update'
	
	fH= allchild(0);
	% figure should be on the top
	udh= findobj(fH(1),'tag','SignalChooser');
	ud= get(udh,'userdata');
	m= ud.pointer.info;
	
	
	NameList= factorNames(m);
	
	if length(unique(NameList))~=length(NameList)
		OK= 0;
		errordlg('Factors must be unique.','Data Error','modal');
	else
		OK= 1;
		freeptr(ud.pointer);
		
		% update design dev object
		T.DesignDev=  UpdateModels( T.DesignDev, m );
        % Update internals before setting-up tssf. The Testplan needs to be
        % up-to-date before calling testplansweepsetfilter, which is done
        % in setupTSSF. Note that setupTSSF internally updates the testplan
        % pointer when it is finished
		xregpointer(T);
        % setup TSSF data objects
        T= setupTSSF(T);
	end
	
	varargout= {T,OK};
end