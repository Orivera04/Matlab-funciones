function [X,friend,broot]= MakeBdryData(T);
%MAKEBDRYDATA
% 
% [X,friend]= MakeBdryData(T);


%  Copyright 2000-2004 The MathWorks, Inc. and Ford Global Technologies, Inc.
%  $Revision: 1.3.6.2 $    $Date: 2004/02/09 08:07:20 $ 

[xp,yp]= dataptr(T);
N= length(xp);
for i=1:N
    X{i}= xp(i);
end

if N>1
    % response data
    ssf= sweepsetfilter(yp);
    ssf= addVarsFilter( ssf, factors(T) );
    X{N+1}= ssf;
end


friend = HSModel( T.DesignDev );

if nargout>2
    
    if N > 1,
        % two stage
        broot = xregbdryroot( name(T), 'NumStages', 2 );
        broot = setdata( broot, X );
        broot= setfriend(broot,friend);
        
        % Response model
        bd = makechildren( broot );
        broot = AddChild( broot, bd );
        bd = info( bd );
        broot = setbest( broot, 1 );
        
        bc = makechildren( bd );
        bd = AddChild( bd, bc );
        bc = info( bc );
        bd = addbest( bd, 1 );
        
        % Local Model
        bd = makechildren( broot );
        broot = AddChild( broot, bd );
        bd = info( bd );
        
        bc = makechildren( bd );
        bd = AddChild( bd, bc );
        bc = info( bc );
        bd = setbest( bd, 1 );
        
        % Global Model
        bd = makechildren( broot );
        broot = AddChild( broot, bd );
        bd = info( bd );
        
        bc = makechildren( bd );
        bd = AddChild( bd, bc );
        bc = info( bc );
        bd = setbest( bd, 1 );
        
        broot = addbest( broot, 1 );
        broot = addbest( broot, 2 );
        broot = addbest( broot, 3 );
    else,
        % One-stage 
        broot = xregbdryroot( name(T) );
        broot = setdata( broot, X );
        broot= setfriend(broot,friend);
        
        bd = makechildren( broot );
        broot = AddChild( broot, bd );
        bd = info( bd );
        broot = setbest( broot, 1 );
    end
end
