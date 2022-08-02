function [x,y]=plotsample(opt,varargin)
%PLOTSAMPLE  Display a sample plot.
%   PLOTSAMPLE displays some noisy sample data. Try to fit the data with
%   SHOWFIT or SELECTFIT, following the instructions given in the command
%   window. The sample data is chosen randomly among the 9 predefined plots
%   described below.
%
%   PLOTSAMPLE is also available from the item 'Plot Sample' of the EzyFit
%   menu (see EFMENU).
%
%   PLOTSAMPLE(OPT)  specifies the sample plot:
%     'power':   noisy power law
%     'linear':  noisy data to be fitted by a linear function
%     'damposc': damped oscillation
%     'cste':    noisy constant
%     'exp':     noisy exponential decay
%     'hist':    histogram of 1000 realizations of a random variable
%     'hist2':   histogram with two gaussian peaks.
%     'powco':   noisy power law with an exponential cut-off.
%     'poly2':   3 curves to be fitted by a 2nd order polynomial fit
%
%   PLOTSAMPLE(N) specifies the number of the sample plot (1 to 8).
%
%   PLOTSAMPLE(...,'fit') also displays the fit.
%
%   [X,Y] = PLOTSAMPLE(...) also returns the sample data (this is
%   equivalent to PLOTSAMPLE; [X,Y] = PICKDATA;).
%
%   Example:
%       plotsample power fit
%       (it shows a power law and fits it).
%
%   See also SHOWFIT, SELECTFIT, FIT, PICKDATA, EFMENU.

%   F. Moisy, moisy_at_fast.u-psud.fr
%   Revision: 1.35,  Date: 2006/10/29
%   This function is part of the EzyFit Toolbox

% History:
% 2005/10/17: v1.00, first version.
% 2005/10/31: v1.10, option added. output argument (x,y).
% 2005/11/02: v1.11, another plot sample.
% 2005/12/06: v1.20, displays the Ezyfit menu.
% 2005/12/13: v1.21, displays the text with a matlab link
% 2006/02/03: v1.30, fits with free parameter names; new plot samples.
% 2006/02/10: v1.31, also clears the annotation objects
% 2006/02/16: v1.32, fits with free lhs 'y(x)=...'. Simpler plot title.
%                    option fitmode added.
% 2006/03/08: v1.33, the figure is not reset any more; this caused bugs
%                    with insert line.
% 2006/09/05: v1.34, bug in the help text fixed.
% 2006/10/29: v1.35, 'hist' now plots a true histogram plot


error(nargchk(0,2,nargin));

rmfit; % remove previous fits

listopt = {'power','linear','damposc','cste','exp','hist','hist2','powco','poly2'};
nsample = length(listopt);

if nargin==0
    opt=floor(nsample*rand+1);
end

if isnumeric(opt)
    opt=listopt{max(1,min(opt,nsample))};
end

switch lower(opt),
    case 'power',
        x=logspace(1,3,20);
        x=(1 + 0.3*(rand(1,20)-0.5)).*x;
        y=4*rand*(1 + .6*(rand(1,20)-0.5)).*x.^(-(rand+1));
        loglog(x, y, 'bo');
        xlabel('x'); ylabel('y');
        f='power';
        txtl=['Try to fit with <a href="matlab:showfit(''' f ''')">showfit(''' f ''')</a>'];
    case 'linear',
        x=linspace(0,12,20);
        y=(rand*1.4+0.9)*x+rand*0.4;
        x=x+(rand(1,20)-.5)*1.2;
        y=y+(rand(1,20)-.5)*1.6;
        plot(x,y,'ks');
        xlabel('x'); ylabel('y');
        f='linear';
        txtl='Try to fit with <a href="matlab:showfit(''linear'')">showfit(''linear'')</a> or <a href="matlab:showfit(''affine'')">showfit(''affine'')</a>';
    case 'damposc',
        x=linspace(0,40,800);
        y=2*rand+(2*rand+1)*(1+0.7*rand(1,800)).*sin(x/(1+.3*rand)).*exp(-x/(8+.3*rand));
        plot(x,y,'b.');
        xlabel('t (seconds)'); ylabel('U(t) [Volts]');
        f='U(t)=offset+U_0*sin(2*pi*t/T)*exp(-t/tau_0); offset=1; T=5; U_0=2; tau_0=10';
        txtl=['Try to fit with <a href="matlab:showfit(''' f ''')">showfit(''' f ''')</a>'];
    case 'cste',
        x=linspace(0,20,20);
        y=(rand+.5)*11.1+(rand(1,20)-.5)*(rand+1)*1.3;
        x=x+(rand(1,20)-.5)*.7;
        plot(x,y,'ro');
        axis([0 20 0 1.3*max(y)]);
        xlabel('x'); ylabel('y');
        f='cste';
        txtl='Try to fit with <a href="matlab:showfit(''cste'')">showfit(''cste'')</a> or <a href="matlab:showfit(''affine'')">showfit(''affine'')</a>';
    case 'exp',
        x=linspace(0,20,20);
        y=(rand+0.5)*2*exp(-x/(2.8*rand+3));
        x=x+(rand(1,20)-.5)*.7;
        y=y+(rand(1,20)-.5)*0.05;
        plot(x,y,'k*');
        axis([0 20 0 1.3*max(y)]);
        xlabel('t (s)'); ylabel('N(t)');
        f='N(t)=N_0*exp(-t/tau)';
        txtl=['Try to fit with <a href="matlab:showfit(''' f ''')">showfit(''' f ''')</a>'];
    case 'hist',
        a=ones(1,1000);
        for i=1:1000,
            a(i)=rand+rand+rand+rand+rand+rand+rand+rand-3;
        end;
        x=linspace(-5,5,100);
        hist(a,x);
        xlabel('x'); ylabel('hist');
        f='gauss';
        txtl=['Try to fit with <a href="matlab:showfit(''' f ''')">showfit(''' f ''')</a>'];
    case 'hist2',
        a=ones(1,10000);
        for i=1:3000,
            a(i)=(rand+rand+rand+rand+rand+rand+rand+rand)/2+5;
        end;
        for i=3001:9000,
            a(i)=(rand+rand+rand+rand+rand+rand+rand+rand)*1.7+8;
        end;
        a(9001:10000)=rand(1,1000)*20;
        x=linspace(0,20,500);
        y=hist(a,x);
        plot(x,y,'r+');
        xlabel('x'); ylabel('hist');
        f='a_1*exp(-(x-m_1)^2/(2*s_1^2))+a_2*exp(-(x-m_2)^2/(2*s_2^2)); a_1=100; a_2=100; m_1=10; m_2=10';
        txtl=['Try to fit with <a href="matlab:showfit(''' f ''')">showfit(''' f ''')</a>'];
    case 'powco',
        x=logspace(0,3,50);
        x=(1 + 0.4*(rand(1,50)-0.5)).*x;
        y=4*rand*(1 + .9*(rand(1,50)-0.5)).*x.^(-(rand+1)).*exp(-x/(100*(rand+.5)));
        loglog(x, y, 'd');
        xlabel('k'); ylabel('E(k)');
        f='E(k)=C*k^(-n)*exp(-k/k_c); log; C=5; n=2; k_c=100';
        txtl=['Try to fit with <a href="matlab:showfit(''' f ''')">showfit(''' f ''')</a>'];
    case 'poly2',
        x=linspace(0,15,20);
        y=rand*2.2*x+(rand*0.6-0.35)*x.^2+(rand(1,20)-.5)*2.5;
        y2=rand*2.2*x+(rand*0.6-0.35)*x.^2+(rand(1,20)-.5)*2.5;
        y3=rand*2.2*x+(rand*0.6-0.35)*x.^2+(rand(1,20)-.5)*2.5;
        plot(x,y,'bo',x,y2,'rs',x,y3,'md');
        xlabel('x'); ylabel('y');
        f='poly2';
        txtl=['Try to fit with <a href="matlab:showfit(''' f ''')">showfit(''' f ''')</a>'];
    otherwise
        error('Invalid plotsample option.');
end;
title('Sample data');
efmenu;

if any(strcmpi(varargin,'fit'))
    showfit(f);    
else
    disp(txtl);
end

if nargout==0
    clear x y;
end;
