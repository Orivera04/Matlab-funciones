function output = odesolve(action,input1)

% ODESOLVE is a MATLAB function which provides a Graphical User
%          Interface (GUI) for the use of MATLAB's differential
%          equation solvers.   

% Copyright (c) 2003 John C. Polking, Rice University.  

startstr = 'odesolve';

if nargin < 1
    action ='initialize';
end


switch action
    case 'initialize'
        
        % First we make sure that there is no other copy of ODESOLVE
        % running, since this causes problems.	
        
        dfh = findobj('tag','odesolve');	
        if ~isempty(dfh);
            qstring = {'There are some open ODESOLVE figures.  These may be' ...
                    ' invisible.   What do you want to do?'};
            tstring = 'Only one copy of ODESOLVE can be open at one time.';
            b1str = 'Close and restart.';
            b2str = 'Just close.';
            b3str = 'Nothing.';
            answer = questdlg(qstring,tstring,b1str,b2str,b3str,b1str);
            switch answer
                case b1str
                    delete(dfh);
                    eval(startstr);return
                case b2str
                    delete(dfh);return
                case b3str
                    return
            end 
        end  % if ~isempty(dfh);
        
        % Make sure tempdir is on the MATLABPATH.  We want to be sure that we
        % return the path to its current position when we exit.
        
        p = path;
        tmpdir = tempdir;
        ll = length(tmpdir);
        tmpdir = tmpdir(1:ll-1);
        ud.remtd = 0;
        if isempty(findstr(tmpdir,p))
            ud.remtd = 1;
            addpath(tempdir)
        end
        
        % Next we look for old files created by odesolve.
        
        oldfiles = dir('odes*.m');
        kk = zeros(0,1);
        for k = 1:length(oldfiles)
            fn = oldfiles(k).name;
            fid = fopen(fn,'r');
            ll = fgetl(fid);
            ll = fgetl(fid);
            ll = fgetl(fid);
            fclose(fid);
            if strcmp(ll,'%% Created by odesolve')
                delete(fn)
            else
                kk = [kk;k];
            end
        end
        oldfiles = dir([tempdir,'odes*.m']);
        for k = 1:length(oldfiles)
            fn = [tempdir,oldfiles(k).name];
            fid = fopen(fn,'r');
            ll = fgetl(fid);
            ll = fgetl(fid);
            ll = fgetl(fid);
            fclose(fid);
            if strcmp(ll,'%% Created by odesolve')
                delete(fn)
            else
                kk = [kk;k];
            end
        end
        
        %%  Default settings.
        
        ud.ssize = get(0,'defaultaxesfontsize');
        ud.oddir = pwd;
        ud.solvers = {'ode45';
            'ode23';
            'ode113';
            'ode15s';
            'ode23s';
            'ode23t';
            'ode23tb'};
        ud.outputhandle = @tpout;
        comp = computer;
        if strcmp(comp,'PCWIN')
            ud.fontsize = 0.8*ud.ssize;
        else
            ud.fontsize = ud.ssize;
        end
        
        ecolor = 'w';  %% Background for text boxes
        dcolor = 'r';  %% Indicates errors
        ccolor = 'y';  %% Caution
        
        %% The initial window
        
        odesolveset = figure('name','ODESOLVE Setup','numb','off',...
            'tag','odesolve','visible','off',...
            'user',ud);
        tcolor = get(gcf,'defaultuicontrolbackgroundcolor');
        odesolve('figdefault',odesolveset)
        
        eq(1)=uicontrol('style','text',...
            'horizon','center',...
            'string','The differential equations.',...
            'visible','off');
        ext = get(eq(1),'extent');
        rr=ext(4)/10;
        
        texth =ext(4)+4;      % Height of text boxes.
        varw = 40*rr;		% Length of variable boxes.
        equalw =13*rr;	% Length of equals.(30)
        eqlength = 230*rr;	% Length of right hand sides of equations.
        winstrlen = 120*rr;	% Length of string boxes in display frame.
        left = 1;		% Left margin of the frames.
        frsep = 1;    	% Separation between frames.
        separation = texth;	% Separation between boxes.
        eqleft = left +5;
        fudge = 0.15*separation;
        
        system.name = 'default system';
        system.NN = 2;
        system.xname = {'x', 'y'};
        system.der = {' y', ' y^2 - x' };
        system.ic = {'2', '0'};
        system.tname = 't';
        system.tvals = [0 0 30];
        system.pname = {};
        system.pval = [];
        system.exname = {};
        system.exval = {};
        
        system(2).name = 'forced oscillator';
        system(2).NN = 2;
        system(2).xname = {'x', 'v'};
        system(2).der = {' v', ' -C*v -om0^2*x + A*cos(om *t)' };
        system(2).ic = {'0', '0'};
        system(2).tname = 't';
        system(2).tvals = [0 0 30];
        system(2).pname = {'C', 'om0','A','om'};
        system(2).pval = [1,4,1,2];
        system(2).exname = {};
        system(2).exval = {};
        
        system(3).name = 'immune system';
        system(3).NN = 3;
        system(3).xname = {'E_1'  'E_2'  'V'};
        system(3).der = {' GG - mu*E_1 + EEEE + KK*V*E_1'  ' GG - mu*E_2 + EEEE'  ' rr*V - kk*V*E_1'};
        system(3).ic = {'1', '1', '1'};
        system(3).tname = 't';
        system(3).tvals = [0 0 100];
        system(3).pname = {'GG'  'mu'  'rr'  'KK'  'kk'  ''};
        system(3).pval = [1 1.25 0.1 0.05 0.01];
        system(3).exname = {'EEEE'  ''  ''  ''};
        system(3).exval = {'0.252*E_1*E_2/(1+0.008*E_1*E_2)'};
        
        system(4).name = 'forced Duffing';
        system(4).NN = 2;
        system(4).xname = {'x','v'};
        system(4).der = {' v',' (-C*v -om0^2*x - k*x^3 + FF)/m'};
        system(4).ic = {'0', '0'};
        system(4).tname = 't';
        system(4).tvals = [0   0  30];
        system(4).pname = {'C','om0','k','om','A','m'};
        system(4).pval = [1  4  1  2  1 1];
        system(4).exname = {'FF','','',''};
        system(4).exval = {'A*cos(om *t)'};
        
        
        system(5).name = 'Lorenz';
        system(5).NN = 3;
        system(5).xname = {'x','y','z'};
        system(5).der = {'  -a*x + a*y',' b*x - y - x*z',' -r*z + x*y'};
        system(5).ic = {'10', '-10',  '15'};
        system(5).tname = 't';
        system(5).tvals = [0   0 100];
        system(5).pname = {'a','r','b','','',''};
        system(5).pval = [10      2.66667           28];
        system(5).exname = {'','','',''};
        system(5).exval = {};
        
        system(6).name = 'logistic';
        system(6).NN = 1;
        system(6).xname = {'P'};
        system(6).der = {'rr*P*(1 - P)'};
        system(6).ic = {'0.1'};
        system(6).tname = 't';
        system(6).tvals = [0   0 20];
        system(6).pname = {'rr'};
        system(6).pval = [0.5];
        system(6).exname = {'','','',''};
        system(6).exval = {};
        
        system(7).name = '1D stiff';
        system(7).NN = 1;
        system(7).xname = {'y'};
        system(7).der = {'exp(t)*cos(y)'};
        system(7).ic = {'0'};
        system(7).tname = 't';
        system(7).tvals = [0   0 12];
        system(7).pname = {};
        system(7).pval = [];
        system(7).exname = {'','','',''};
        system(7).exval = {};
        
        H.name = 'two springs';
        H.NN = 4;
        H.xname = {'x','u','y','v'};
        H.der = {'u','(k2*(y-x) - k1*x)/M1','v','(-k2*(y-x) + F)/M2'};
        H.ic = {'2','0','2','0'};
        H.tname = 't';
        H.tvals = [0   0  30];
        H.pname = {'k1','k2','A','M1','M2','om'};
        H.pval = [1  1  0  1  2  4];
        H.exname = {'F','','',''};
        H.exval = {'A*cos(om*t)','','',''};
        
        system(8) = H;
        
        ud.c = system(1);	% Changed values.
        ud.o = system(1);	% Original values.
        %%  ud.h.NN = system(1).NN;
        ud.h.name = system(1).name;
        ud.h.xname = [];  % This will be the handles in the
        ud.h.equals = [];
        ud.h.der = [];
        ud.h.icname = [];
        ud.h.icval = [];
        ud.h.pname = [];
        ud.system = system;
        
        eqfrw = varw+equalw+eqlength+10;
        
        icnamew = 38*rr;
        icvalw = 60*rr;
        % iceqw = 8*rr;
        % icfrw = icnamew+iceqw+icvalw+10;
        icfrw = icnamew+icvalw+10;
        setfigw = 2*left + eqfrw + icfrw + frsep;
        
        %%  The buttons
        
        buttw = setfigw/3;
        qwind = [0,frsep,buttw,separation];	        % Quit button
        rwind = [buttw,frsep,buttw,separation];	% Revert
        sowind = [buttw,frsep,buttw,separation];	% Solve in old fig
        snwind = [2*buttw,frsep,buttw,separation];	% Solve in new fig
        buttht = 2*frsep+separation;
        
        butt(1) = uicontrol('style','push',...
            'pos',qwind,...
            'string','Quit',...
            'call','odesolve(''quit'')',...
            'visible','off');
        
        socall = [
            'ud = get(gcf,''user'');'...
                'ud.addflag = 1;'...
                'set(gcf,''user'',ud);'...
                'odesolve(''solve'')'];
        
        butt(2) = uicontrol('style','push',...
            'pos',sowind,...
            'string','Add to the existing display',...
            'call',socall,...
            'enable','off',...
            'visible','off');
        ud.h.sobutt = butt(2);
        
        sncall = [
            'ud = get(gcf,''user'');'...
                'ud.addflag = 0;'...
                'set(gcf,''user'',ud);'...
                'odesolve(''solve'')'];
        
        butt(3) = uicontrol('style','push',...
            'pos',snwind,...
            'string','Solve in a new window',...
            'call',sncall,....
            'visible','off');
        
        %% The Options frame
        
        opfrbot = buttht;
        opfrw = setfigw - 2*left;
        opfrht = separation + 10;
        opfrwind = [left, opfrbot, opfrw, opfrht];
        opframeht = opfrbot + opfrht + frsep;
        opframe = uicontrol('style','frame','pos',opfrwind);
        opw = (setfigw - 2*eqleft)/5;
        opbot = opfrbot + 5;
        solvtith = uicontrol('style','text',...
            'pos',[eqleft,opbot-fudge,opw,texth],...
            'horizon','right',...
            'string','Solver:    ',...
            'visible','off',...
            'backgroundcolor',tcolor);
        solvcall = [
            '[h,fig] = gcbo;',...
                'sud = get(fig,''user'');',...
                'oldsolver = sud.solver;',...
                'solverlist = get(h,''string'');',...
                'newsolver = solverlist{get(h,''value'')};',...
                'if ~strcmp(oldsolver,newsolver),',...
                '  sud.settings = sud.defaultsettings;',...
                '  if ~strcmp(newsolver,''ode45''),',...
                '    sud.settings.refine = 1;',...
                '  end,',...
                '  sud.solver = newsolver;',...
                '  set(fig,''user'',sud);',...
                'end'];
        
        ud.h.solver = uicontrol('style','popup',...
            'pos',[eqleft+opw opbot, opw texth],...
            'horizon','center',...
            'string',ud.solvers,...
            'user','',...
            'call',solvcall,...
            'visible','off',...
            'backgroundcolor',ecolor);
        outtith = uicontrol('style','text',...
            'pos',[eqleft+2*opw,opbot-fudge,opw,texth],...
            'horizon','right',...
            'string','Output:    ',...
            'visible','off',...
            'backgroundcolor',tcolor);
        outputlist = {'time plot', '2D phase plot', '3D plot'};
        ud.h.output = uicontrol('style','popup',...
            'pos',[eqleft+3*opw opbot, opw texth],...
            'horizon','center',...
            'string',outputlist,...
            'user',1,...
            'call','odesolve(''outputchoice'')',...
            'visible','off',...
            'backgroundcolor',ecolor);
        ud.h.outputstr = uicontrol('style','text',...
            'pos',[left+4*opw,opbot-fudge,opw,texth],...
            'horizon','left',...
            'string','     all variables vs t',...
            'visible','off',...
            'backgroundcolor',tcolor);
        
        
        
        %% The expressions frame
        
        exfrbot = opframeht;
        exfrw = setfigw - 2*left;
        exfrht = 2*separation + 10;
        exfrwind = [left, exfrbot, exfrw, exfrht];
        exframeht = exfrbot + exfrht + frsep;
        exframe = uicontrol('style','frame','pos',exfrwind);
        exnamew = 30*rr;
        exeqw = 8*rr;
        exbot(2) = exfrbot + 5;
        exbot(1) = exbot(2) +separation;
        extit = uicontrol('style','text',...
            'horizon','center',...
            'string','Expressions:',...
            'visible','off','backgroundcolor',tcolor);
        ext = get(extit,'extent');
        extitw = ext(3);
        pos = [eqleft exbot(1)-fudge extitw texth];
        set(extit,'pos',pos);
        exncall = [
            '[h,fig] = gcbo;'...
                'ud =  get(fig,''user'');'...
                'num = get(h,''user'');'...
                'ud.c.exname{num} = get(ud.h.exname(num),''string'');'...
                'ud.fileflag = 1;'...
                'odesolve(''reset'');'...
                'set(fig,''user'',ud);'];
        exvcall = [
            '[h,fig] = gcbo;'...
                'ud =  get(fig,''user'');'...
                'num = get(h,''user'');'...
                'ud.c.exval{num} = get(ud.h.exval(num),''string'');'...
                'ud.fileflag = 1;'...
                'set(h,''backgroundcolor'',ud.ecolor);'...
                'odesolve(''reset'');'...
                'set(fig,''user'',ud);'];
        exsep = 20;
        exvalw = (setfigw - 2*eqleft - extitw)/2 - exsep - exnamew - exeqw;
        exval = ud.c.exval;
        exname = ud.c.exname;
        for jj = 1:2
            for kk = 1:2
                exleft = eqleft +extitw +exsep +(kk-1)*(exnamew+exeqw+exvalw+ exsep);
                exeqleft = exleft+exnamew;
                exvleft = exeqleft +exeqw;
                K = kk + 2*(jj-1);
                if K > length(exname)
                    exname{K} = '';
                    exval{K} = '';
                end
                name = exname{K};
                value = exval{K};
                ud.h.exname(K) = uicontrol('style','edit',...
                    'pos',[exleft exbot(jj) exnamew texth],...
                    'horizon','right','string',name,...
                    'user',K,...
                    'call',exncall,...
                    'visible','off',...
                    'backgroundcolor',ecolor);
                
                exequal(K) = uicontrol('style','text',...
                    'pos',[exeqleft exbot(jj)-fudge exeqw texth],...
                    'horizon','center',...
                    'string','=',...
                    'visible','off',...
                    'backgroundcolor',tcolor);
                
                ud.h.exval(K) = uicontrol('style','edit',...
                    'pos',[exvleft exbot(jj) exvalw texth],...
                    'string',value,...
                    'call',exvcall,...
                    'visible','off',...
                    'user',K,...
                    'backgroundcolor',ecolor);
            end
        end
        ud.c.exname = exname;
        ud.c.exval = exval;
        
        
        
        %% The parameter frame
        
        pfrbot = exframeht;
        pfrw = setfigw - 2*left;
        pfrht = 2*separation + 10;
        pfrwind = [left, pfrbot, pfrw, pfrht];
        pframeht = pfrbot + pfrht + frsep;
        pframe = uicontrol('style','frame','pos',pfrwind);
        pncall = [
            '[h,fig] = gcbo;'...
                'ud =  get(fig,''user'');'...
                'num = get(h,''user'');'...
                'ud.c.pname{num} = get(ud.h.pname(num),''string'');'...
                'ud.fileflag = 1;'...
                'odesolve(''reset'');'...
                'set(gcf,''user'',ud);'];
        
        pvcall = [
            '[h,fig] = gcbo;'...
                'ud =  get(fig,''user'');'...
                'num = get(h,''user'');'...
                'nstr = str2num(get(ud.h.pval(num),''string''));'...
                'if ~isempty(nstr),'...
                'ud.c.pval(num) = str2num(get(ud.h.pval(num),''string''));'...
                'else, ud.c.pval(num) = NaN;'...
                'end,'...
                'set(h,''backgroundcolor'',ud.ecolor);'...
                'set(gcf,''user'',ud);'];
        
        pnamew = 30*rr;
        peqw = 8*rr;
        pbot1 = pfrbot + 5;
        pbot2 = pbot1 +separation;
        pbot(1) = pbot2;
        pbot(2) = pbot1;
        
        paratit=uicontrol('style','text',...
            'horizon','center',...
            'string','Parameters:',...
            'visible','off','backgroundcolor',tcolor);
        
        paratitw = extitw;
        pos = [eqleft pbot2-fudge paratitw texth];
        set(paratit,'pos',pos);
        psep = 20;
        pvalw = (setfigw - 2*eqleft - paratitw)/3 - psep - pnamew - peqw;
        pval = ud.c.pval;
        pname = ud.c.pname;
        for jj = 1:2
            for kk = 1:3
                pleft = eqleft + paratitw +psep +(kk-1)*(pnamew+peqw+pvalw+ psep);
                peqleft = pleft + pnamew;
                pvleft = peqleft + peqw;
                K = kk +3*(jj-1);
                if K > length(pname)
                    pname{K} = '';
                end
                name = pname{K};
                if K <= length(pval)
                    value = num2str(pval(K));
                else
                    value = '';
                end
                ud.h.pname(K) = uicontrol('style','edit',...
                    'pos',[pleft pbot(jj) pnamew texth],...
                    'horizon','right','string',name,...
                    'user',K,...
                    'call',pncall,...
                    'visible','off',...
                    'backgroundcolor',ecolor);
                equal(K) = uicontrol('style','text',...
                    'pos',[peqleft pbot(jj)-fudge peqw texth],...
                    'horizon','center',...
                    'string','=',...
                    'visible','off',...
                    'backgroundcolor',tcolor);
                
                ud.h.pval(K) = uicontrol('style','edit',...
                    'pos',[pvleft pbot(jj) pvalw texth],...
                    'string',value,...
                    'call',pvcall,...
                    'visible','off',...
                    'user',K,...
                    'backgroundcolor',ecolor);
            end
        end
        ud.c.pname = pname;
        ud.c.pval = pval;
        
        %% The number of equations frame
        
        frw = (eqfrw-2)/3;  %% The width of the middle three frames.
        
        nfrbot = pframeht;
        nfrw = frw;
        nfrht = 2*separation + 10;
        nfrwind = [left, nfrbot, nfrw, nfrht];
        nframe = uicontrol('style','frame','pos',nfrwind);
        nbot1 = nfrbot + 5;
        nbot2 = nbot1 + separation;
        numbeqw = nfrw - 4;
        numbeqwind = [left+2 nbot2 numbeqw texth];
        numbeq = uicontrol('style','text',...
            'pos',numbeqwind,...
            'string','Number of equations.',...
            'background',tcolor);
        
        neqnw = 30*rr;
        ll = (numbeqw - neqnw)/2;
        neqnwind = [2+ll nbot1 neqnw texth];
        neqn = uicontrol('style','edit',...
            'pos',neqnwind,...
            'string','2',...
            'call','odesolve(''numchange'')',...
            'background',ecolor);
        ud.h.NN = neqn;
        
        %% The independent variable frame.
        
        tfrbot = pframeht;
        tfrleft = left + nfrw + frsep;
        tfrw = frw;
        tfrht = 2*separation + 10;
        tfrwind = [tfrleft,tfrbot,tfrw,tfrht];
        tframeht = tfrbot + tfrht + frsep;
        tframe = uicontrol('style','frame','pos',tfrwind);
        
        tbot1 = nbot1;
        tbot2 = nbot2;
        tstrw = tfrw - 4;
        tstrwind = [tfrleft+2, tbot2, tstrw, texth];
        tstr = uicontrol('style','text',...
            'pos',tstrwind,...
            'string','Independent variable.',...
            'background',tcolor);
        tvarw = 30*rr;
        ll = (tstrw - tvarw)/2;
        tvarwind = [tfrleft+2+ll tbot1 tvarw texth];
        tcall = [
            '[h,fig] = gcbo;'...
                'ud =  get(fig,''user'');'...
                'str = get(h,''string'');'...
                'ud.c.tname = str;'...
                'set(ud.h.tic,''string'',[str '' = '']);'...
                'set(ud.h.solint(1),''string'',['' <= '',str, '' <= '']);'...
                'str = [''     all variables vs '', str, ''.''];'...
                'set(ud.h.outputstr,''string'',str);'...
                'ud.fileflag = 1;'...
                'set(fig,''user'',ud);' ];
        
        
        ud.h.tvar = uicontrol('style','edit',...
            'pos',tvarwind,...
            'string','t',...
            'call',tcall,...
            'background',ecolor);
        
        
        
        %% The solution interval frame.
        
        solfrbot = pframeht;
        solfrleft = tfrleft + tfrw + frsep;
        solfrw = frw;
        solfrht = 2*separation + 10;
        solfrwind = [solfrleft,solfrbot,solfrw,solfrht];
        solframeht = tfrbot + tfrht + frsep;
        solframe = uicontrol('style','frame','pos',solfrwind);
        
        solbot1 = nbot1;
        solbot2 = nbot2;
        solstrw = solfrw - 4;
        solstrwind = [solfrleft+2, solbot2, solstrw, texth];
        solstr = uicontrol('style','text',...
            'pos',solstrwind,...
            'string','Solution interval.',...
            'background',tcolor);
        solvarw = 30*rr;
        ll = (solstrw - solvarw)/2;
        solvarwind = [solfrleft+2+ll tbot1 tvarw texth];
        
        solineqstr = ['  <=  ',ud.c.tname, '  <=  '];
        ud.h.solint(1) = uicontrol('style','text',...
            'string',solineqstr,...
            'background',tcolor);
        ext = get(ud.h.solint(1),'extent');
        www = ext(3);
        ddd = (solfrw - www)/2 ;
        solineql = ddd + solfrleft;
        solineqwind = [solineql, tbot1-fudge ,www,texth];
        set(ud.h.solint(1),'pos',solineqwind);
        wind = [ solfrleft+3 tbot1,ddd-3,texth];
        str = num2str(ud.c.tvals(2));
        solintcall = [
            '[h,fig] = gcbo;'...
                'ud =  get(fig,''user'');'...
                'tvals = ud.c.tvals;'...
                'num = get(h,''user'');'...
                'value = str2num(get(h,''string''));'...
                'tvals(num) = value;'...
                'if (tvals(2)>tvals(1) | tvals(3)<tvals(1)),',...
                '   col = ud.dcolor;',...
                'else,',...
                '   col = ud.ecolor; end,'...
                'set([ud.h.solint(2:3) ud.h.tval],''background'',col);'...
                'ud.c.tvals =tvals;'...
                'set(fig,''user'',ud);'];
        
        ud.h.solint(2) = uicontrol('style','edit',...
            'pos',wind,...
            'horizon','right',...
            'string',str,...
            'call',solintcall,...
            'user',2,...
            'visible','off',...
            'backgroundcolor',ecolor);
        wind = [ solineql+www tbot1,ddd-3,texth];
        str = num2str(ud.c.tvals(3));
        ud.h.solint(3) = uicontrol('style','edit',...
            'pos',wind,...
            'horizon','left',...
            'string',str,...
            'call',solintcall,...
            'user',3,...
            'visible','off',...
            'backgroundcolor',ecolor);
        
        %% The equation frame.
        
        eqfrbot = tframeht;
        eqfrht = 3*separation + 10;
        eqfrwind = [left, eqfrbot, eqfrw, eqfrht];
        frame(1) = uicontrol('style','frame','pos',eqfrwind);
        ud.eqnlabel = uicontrol('style','text',...
            'string','The differential equations.',...
            'vis','off',...
            'background',tcolor);
        
        %% The ic frame
        
        icfrbot = solfrbot;
        icfrht = solfrht + eqfrht +frsep;
        icfrl = 2*left+eqfrw;
        icnleft = icfrl +2;
        icvleft = icnleft + icnamew;
        icfrwind = [icfrl, icfrbot, icfrw, icfrht]; 
        frame(2) = uicontrol('style','frame','pos',icfrwind);
        ud.iclabel = uicontrol('style','text',...
            'string','The initial conditions.',...
            'vis','off',...
            'background',tcolor);
        tbot = nbot1;
        tnamstr = [ud.c.tname, ' = '];
        tvalstr = num2str(ud.c.tvals(1));
        ud.h.tic = uicontrol('style','text',...
            'pos',[icnleft,tbot-fudge,icnamew,texth],...
            'horizon','right',...
            'string',tnamstr,...
            'call','',...
            'visible','off',...
            'background',tcolor);
        ud.h.tval = uicontrol('style','edit',...
            'pos',[icvleft,tbot,icvalw,texth],...
            'string',tvalstr,...
            'horizon','left',...
            'user',1,...
            'call',solintcall,...
            'visible','off',...
            'background',ecolor);
        
        %% The figure
        
        setfight = eqfrbot + eqfrht +frsep;	% Height of the figure.
        setfigl = 30;
        setfigbot = 60;
        set(odesolveset,'pos',[setfigl setfigbot setfigw setfight]);
        
        
        
        ud.separation = separation;
        ud.left = left;
        ud.fudge = fudge;
        ud.frsep = frsep;
        ud.eqleft = eqleft;
        ud.varw = varw;
        ud.equalw = equalw;
        ud.tframeht = tframeht;
        ud.solfrbot = solfrbot;
        ud.icfrw = icfrw;
        ud.icfrl = icfrl;
        ud.frame = frame;
        ud.eqfrw = eqfrw;
        ud.solfrht = solfrht;
        ud.texth = texth;
        ud.eqlength = eqlength;
        ud.icnamew = icnamew;
        ud.icvalw = icvalw;
        ud.setfigw = setfigw;
        ud.ecolor = ecolor;
        ud.tcolor = tcolor;
        ud.dcolor = dcolor;
        ud.ccolor = ccolor;
        ud.dfname = '';
        ud.fileflag = 1;
        us.addflag = 0;
        ud.iflag = 1;    %% This is the initialization step.
        ud.settings.atol = .000001;
        ud.settings.rtol = .001;
        ud.settings.refine = 4;
        ud.settings.istep = 'computed';
        ud.settings.mstep = 'computed';
        ud.settings.ncval = 2;
        ud.defaultsettings = ud.settings;
        ud.solver = 'ode45';
        
        set(odesolveset,'user',ud);
        odesolve('numchange');
        ud = get(gcf,'user');
        NN = str2num(get(ud.h.NN,'string'));
        ud.NNN = 1:NN;
        for k = 1:NN
            set(ud.h.xname(k),'string',ud.c.xname{k});
            set(ud.h.der(k),'string',ud.c.der{k});
            set(ud.h.icname(k),'string',[ud.c.xname{k}, ' = ']);
            set(ud.h.icval(k),'string',ud.c.ic{k});
        end
        
        % The menus
        
        hhsetup = get(0,'showhiddenhandles');
        set(0,'showhiddenhandles','on');
        mefile = findobj(odesolveset,'label','&File');
        meedit = findobj(odesolveset,'label','&Edit');
        delete(findobj(odesolveset,'label','&Tools'));
        delete(findobj(odesolveset,'label','&View'));
        delete(findobj(odesolveset,'label','&Insert'));
        
        % The File menu
        
        meexp = findobj(mefile,'label','&Export...');
        meprev = findobj(mefile,'label','Print Pre&view...');
        mepset = findobj(mefile,'label','Pa&ge Setup...');
        set(get(mefile,'child'),'vis','off');
        meload = uimenu(mefile,'label','Load a system ...',...
            'call','odesolve(''loadsyst'',''system'');',...
            'pos',1);
        mesave = uimenu(mefile,'label','Save the current system ...',...
            'call','odesolve(''savesyst'',''system'');',...
            'pos',2);
        meloadg = uimenu(mefile,'label','Load a gallery ...',...
            'call','odesolve(''loadsyst'',''gallery'');',...
            'separator','on','pos',3);
        mesaveg = uimenu(mefile,'label','Save a gallery ...',...
            'call','odesolve(''savesyst'',''gallery'');',...
            'tag','savegal',...
            'pos',4);
        delgall = ['sud = get(gcf,''user'');',...
                'mh = get(sud.h.gallery,''children'');',...
                'add = findobj(sud.h.gallery,''tag'',''add system'');',...
                'mh(find(mh == add)) = [];',...
                'delete(mh);',...
                'set(sud.h.gallery,''user'',[]);',...
                'set(sud.h.loaddefgal,''enable'',''on'')'];
        
        
        medelg = uimenu(mefile,'label','Delete the current gallery.',...
            'call',delgall,'pos',5);
        melddg = uimenu(mefile,'label','Load the default gallery.',...
            'call','odesolve(''loadsyst'',''default'');',...
            'enable','off',...
            'tag','load default',...
            'pos',6);
        ud.h.loaddefgal = melddg;
        mesolnew = uimenu(mefile,...
            'label','Solve in a new window.',...
            'call',sncall,...
            'separator','on',...
            'accelerator','G','pos',7);
        mesoladd = uimenu(mefile,...
            'label','Add to the existing display.',...
            'call',socall,...
            'enable','off',...
            'separator','off',...
            'accelerator','H','pos',8);
        ud.h.somenu = mesoladd;
        set(mepset,'vis','on','pos',9);
        set(meprev,'vis','on','pos',10);
        set(meexp,'vis','on','pos',11,'separator','off');
        merestart = uimenu(mefile,'label',...
            'Restart ODESOLVE.',...
            'call','odesolve(''restart'')',...
            'separator','on','pos',12);
        
        mequit = uimenu(mefile,...
            'label','Quit ODESOLVE',...
            'call','odesolve(''quit'')',...
            'separator','off','pos',13);
        
        % The Edit menu
        
        set(get(meedit,'child'),'vis','off');
        eqclear = [
            'ud = get(gcf,''user'');h = ud.h;',...
                'set([h.xname,h.der,h.icname,h.icval],''string'','''');'];
        meclrf = uimenu(meedit,'label','Clear equations',...
            'call',eqclear,...
            'accelerator','E');
        pclear = [
            'ud = get(gcf,''user'');h = ud.h;',...
                'set([h.pname,h.pval],''string'','''');',...
                'ud.c.pname = {};',...
                'ud.c.pval = [];',...
                'set(gcf,''user'',ud);',...
            ];
        meclrp = uimenu(meedit,'label','Clear parameters',...
            'call',pclear,...
            'accelerator','P');
        exclear = [
            'ud = get(gcf,''user'');h = ud.h;',...
                'set([h.exname,h.exval],''string'','''');',...
                'ud.c.exname = {};',...
                'ud.c.exval = {};',...
                'set(gcf,''user'',ud);',...
            ];
        meclrex = uimenu(meedit,'label','Clear expressions',...
            'call',exclear,...
            'accelerator','X');
        allclear = [
            'ud = get(gcf,''user'');h = ud.h;',...
                'set([h.xname,h.der,h.icname,h.icval],''string'','''');',...
                'set([h.pname,h.pval],''string'','''');',...
                'set([h.exname,h.exval],''string'','''');',...
                'ud.c.pname = {};',...
                'ud.c.pval = [];',...
                'ud.c.exname = {};',...
                'ud.c.exval = {};',...
                'set(gcf,''user'',ud);',...
            ];
        meclrall = uimenu(meedit,'label','Clear all',...
            'call',allclear,...
            'accelerator','A',...
            'separator','on');
        
        % The Gallery Menu
        
        sysmenu = uimenu('label','Gallery','visible','off','pos',3);
        
        meadd = uimenu(sysmenu,'label','Add current system to the gallery',...
            'call','odesolve(''addgall'');',...
            'tag','add system');
        sep = 'on';
        for kk = 1:length(system)
            kkk = num2str(kk);
            if kk == 2, sep = 'off';end
            sysmen(kk) = uimenu(sysmenu,'label',system(kk).name,...
                'call',['odesolve(''system'',',kkk,')'],...
                'separator',sep,'visible','off');
        end
        set(sysmenu,'user',system);
        ud.h.gallery = sysmenu;
        ud.egg = (exist('EASTEREGG') ==2);
        
        % The Options Menu
        
        optmenu = uimenu('label','Options','visible','off','pos',4);
        ud.pplotflag = 0;
        pplotcall = [
            '[h,fig] = gcbo;',...
                'sud = get(fig,''user'');',...
                'sw = get(h,''checked'');',...
                'switch sw,',...
                ' case ''on'',',...
                '  set(h,''checked'',''off'');',...
                '  sud.pplotflag = 0;',...
                ' case ''off'',',...
                '  set(h,''checked'',''on'');',...
                '  sud.pplotflag = 1;',...
                'end,',...
                'set(fig,''user'',sud);',...
            ];
        
        
        
        mepplot = uimenu(optmenu,'label','Mark computed points.',...
            'call',pplotcall,...
            'visible','off');
        
        ud.icplotflag = 0;
        icplotcall = [
            '[h,fig] = gcbo;',...
                'sud = get(fig,''user'');',...
                'sw = get(h,''checked'');',...
                'switch sw,',...
                ' case ''on'',',...
                '  set(h,''checked'',''off'');',...
                '  sud.icplotflag = 0;',...
                ' case ''off'',',...
                '  set(h,''checked'',''on'');',...
                '  sud.icplotflag = 1;',...
                'end,',...
                'set(fig,''user'',sud);',...
            ];
        
        meicplot = uimenu(optmenu,'label','Mark initial points.',...
            'call',icplotcall,...
            'visible','off');
        
        mefileexport = uimenu(optmenu,'label','Export ODE function file.',...
            'call','odesolve(''fileexport'')',...
            'visible','off');
        
        mesolvset = uimenu(optmenu,'label','Solver settings.',...
            'call','odesolve(''settings'')',...
            'visible','off');
        
        
        
        % Record the handles in the User Data of the Set Up figure.
        
        set(odesolveset,'user',ud);
        hhhh = findobj(odesolveset,'type','uicontrol');
        set(hhhh,'units','normal')
        
        children = get(odesolveset,'children');
        ics = ud.h.icval;
        for kk = 1:NN
            children(find(children == ics(kk))) = [];
        end
        children = [fliplr(ics)';children];
        set(odesolveset,'children',children);
        
        set(odesolveset,'visible','on','resize','on');
        set(get(odesolveset,'children'),'visible','on');
        set(get(sysmenu,'children'),'visible','on');
        set(get(optmenu,'children'),'visible','on');
        set(0,'showhiddenhandles',hhsetup);
        
        
    case 'numchange'
        
        fig = findobj('name','ODESOLVE Setup');
        hhhh = findobj(fig,'type','uicontrol');
        set(hhhh,'units','pix')
        ud = get(fig,'user');
        iflag = ud.iflag;
        eqfrbot = ud.tframeht;
        separation = ud.separation;
        left = ud.left;
        fudge = ud.fudge;
        eqleft = ud.eqleft;
        varw = ud.varw;
        equalw = ud.equalw;
        tframeht = ud.tframeht;
        frame = ud.frame;
        eqfrw = ud.eqfrw;
        frsep = ud.frsep;
        texth = ud.texth;
        eqlength = ud.eqlength;
        icnamew = ud.icnamew;
        icvalw = ud.icvalw;
        ecolor = ud.ecolor;
        tcolor = ud.tcolor;
        dcolor = ud.dcolor;
        ccolor = ud.ccolor;
        xname = ud.h.xname;
        equals = ud.h.equals;
        der = ud.h.der;
        icname = ud.h.icname;
        icval = ud.h.icval;
        
        NN = str2num(get(ud.h.NN,'string'));  %% New number
        NNN = length(ud.h.xname);             %% Old number
        if NNN == NN        %% No changes needed.
            return
        elseif NNN > NN      %% Remove extra boxes and handles.
            delete(xname(NN+1:NNN));
            xname = xname(1:NN);
            ud.c.xname = ud.c.xname(1:NN);
            delete(equals(NN+1:NNN));
            equals = equals(1:NN);
            delete(der(NN+1:NNN));
            der = der(1:NN);
            ud.c.der = ud.c.der(1:NN);
            KK = length(ud.c.ic);
            if NN <= KK
                ud.c.ic = ud.c.ic(1:NN);
            end
            delete(icname(NN+1:NNN));
            icname = icname(1:NN);
            delete(icval(NN+1:NNN));
            icval = icval(1:NN);
        end
        
        eqfrht = (NN+1)*separation +10;
        eqfrwind = [left, eqfrbot, eqfrw, eqfrht];
        
        set(frame(1),'pos',eqfrwind);
        icfrbot = ud.solfrbot;
        icfrht = ud.solfrht + eqfrht +frsep;
        icfrw = ud.icfrw;
        icfrl = 2*left+eqfrw;
        icfrwind = [icfrl, icfrbot, icfrw, icfrht]; 
        set(frame(2),'pos',icfrwind);
        
        xnamecall = [ 
            '[h,fig] = gcbo;'...
                'ud =  get(fig,''user'');'...
                'num = get(h,''user'');'...
                'str = get(h,''string'');'...
                'ud.c.xname{num} = str;'...
                'set(ud.h.icname(num),''string'',[str, '' = '']);'...
                'ud.fileflag = 1;'...
                'set(fig,''user'',ud);' ];
        
        dercall = [
            '[h,fig] = gcbo;'...
                'ud =  get(fig,''user'');'...
                'num = get(h,''user'');'...
                'ud.c.der{num} = get(h,''string'');'...
                'ud.fileflag = 1;'...
                'set(h,''backgroundcolor'',ud.ecolor);'...
                'odesolve(''reset'');'...
                'set(fig,''user'',ud);' ];
        iccall = [
            '[h,fig] = gcbo;'...
                'ud =  get(fig,''user'');'...
                'value = get(h,''string'');'...
                'num = get(h,''user'');'...
                'ud.c.ic{num} = value;'...
                'set(h,''background'',ud.ecolor);'...
                'set(fig,''user'',ud);' ];
        
        equalsleft = ud.eqleft+varw;
        derleft = equalsleft+equalw;
        icnleft = icfrl +2;
        icvleft = icnleft + icnamew;
        for kk = 1:NN
            ebot(kk) = eqfrbot + 5 + (NN - kk)*separation;
        end   
        
        %% Move the boxes.
        
        KK = length(ud.c.xname);
        for kk = 1:min(NN,NNN)
            set(xname(kk),'pos',[eqleft, ebot(kk), varw, texth]);
            set(equals(kk),'pos',[equalsleft, ebot(kk)-fudge, equalw, texth]);
            set(der(kk),'pos',[derleft, ebot(kk), eqlength, texth]);
            set(icname(kk),'pos',[icnleft,ebot(kk)-fudge,icnamew,texth]);
            set(icval(kk),'pos',[icvleft,ebot(kk),icvalw,texth]);
        end
        
        %% Create new boxes if NN > NNN
        
        for kk =(NNN+1):NN
            if kk <= KK
                namstr = ud.c.xname{kk};
                derstr = ud.c.der{kk};
                icnamstr = [namstr, ' = '];
                icvalstr = ud.c.ic(kk); 
            else
                namstr = '';
                derstr = '';
                icnamstr = ' = ';
                icvalstr = ''; 
            end
            xname(kk) = uicontrol('style','edit',...
                'pos',[eqleft, ebot(kk), varw, texth],...
                'horizon','right',...
                'string',namstr,...
                'call',xnamecall,...
                'user',kk,...
                'visible','off',...
                'parent',fig,...
                'backgroundcolor',ecolor);
            ud.c.xname{kk} = namstr;
            equals(kk) = uicontrol('style','text',...
                'pos',[equalsleft,ebot(kk)-fudge,equalw,texth],...
                'horizon','center',...
                'string',''' = ',...
                'visible','off',...
                'parent',fig,...
                'backgroundcolor',tcolor);
            der(kk) = uicontrol('style','edit',...
                'pos',[derleft,ebot(kk),eqlength,texth],...
                'string',derstr,...
                'user',kk,...
                'horizon','left',...
                'call',dercall,...
                'visible','off',...
                'parent',fig,...
                'backgroundcolor',ecolor);
            ud.c.der{kk} = derstr;
            icname(kk) = uicontrol('style','text',...
                'pos',[icnleft,ebot(kk)-fudge,icnamew,texth],...
                'horizon','right',...
                'string',icnamstr,...
                'visible','off',...
                'parent',fig,...
                'background',tcolor);
            if iflag
                col = ecolor;
            else
                col = ecolor;
            end
            icval(kk) = uicontrol('style','edit',...
                'pos',[icvleft,ebot(kk),icvalw,texth],...
                'string',icvalstr,...
                'user',kk,...
                'call',iccall,...
                'horizon','left',...
                'visible','off',...
                'parent',fig,...
                'background',col);
        end
        eqlabbot = eqfrbot+5+NN*separation;
        eqlabw = varw+equalw+eqlength;
        set(ud.eqnlabel,'pos',[eqleft,eqlabbot,eqlabw,texth]);
        iclabbot = eqfrbot+5+NN*separation;
        iclabl = ud.icfrl+left;
        iclabw = icfrw - 2*left;
        set(ud.iclabel,'pos',[iclabl,iclabbot,iclabw,texth]);
        ud.c.NN = NN;
        ud.h.xname = xname;
        ud.h.equals = equals;
        ud.h.der = der;
        ud.h.icname = icname;
        ud.h.icval = icval;
        ud.iflag = 0;
        ud.NNN = (1:length(xname))';
        setfight = eqfrbot + eqfrht + frsep;	% Height of the figure.
        setfigl = 30;
        setfigbot = 60;
        set(fig,'pos',[setfigl setfigbot ud.setfigw setfight])
        set(fig,'vis','on','user',ud);
        odesolve('reset');
        set(get(fig,'children'),'vis','on');  
        
        hhhh = findobj(fig,'type','uicontrol');
        set(hhhh,'units','normal')
        if NN == 1
            set(ud.h.output,'enable','off')
        else
            set(ud.h.output,'enable','on');
        end
        
    case 'reset'
        
        odset = findobj('name','ODESOLVE Setup');
        ud = get(odset,'user');
        set(ud.h.output,'value',1)
        str = ['     all variables vs ', ud.c.tname, '.'];
        set(ud.h.outputstr,'string',str);
        ud.outputhandle = @tpout;
        set(ud.h.sobutt,'enable','off');
        if isfield(ud.h,'somenu')
            set(ud.h.somenu,'enable','off');
        end
        set(odset,'user',ud);
        
    case 'savesyst'
        
        odset = findobj('name','ODESOLVE Setup');
        type = input1;
        sud = get(odset,'user');
        systems = get(sud.h.gallery,'user');
        
        switch type
            case 'system'  
                fn = sud.h.name;
                if ~isempty(fn)
                    fn(find(abs(fn)==32))='_';   % Replace spaces by underlines.
                end	
                fname = [fn,'.ods'];
                comp = computer;
                switch  comp
                    case 'PCWIN'
                        filter = [sud.oddir,'\',fname];
                    case 'MAC2'
                        filter = [sud.oddir,':',fname];
                    otherwise
                        filter = [sud.oddir,'/',fname];
                end
                [fname,pname] = uiputfile(filter,'Save the system as:');
                if fname == 0,return;end
                ll = length(fname);
                if (ll>4 & strcmp(fname(ll-3:ll),'.ods'))
                    fn = fname(1:(ll-4));
                else
                    fn =fname;
                end
                fname = [fn,'.ods'];
                sud.h.name = fn;
                set(odset,'user',sud);
                sud.c.name = fn;
                newsysts = sud.c;
                
            case 'gallery'
                ll = length(systems); 
                if ll == 0
                    warndlg(['There are no systems to make up a gallery.'],'Warning');
                    return
                end
                [names{1:ll}] = deal(systems.name);
                [sel,ok] = listdlg('PromptString','Select the systems',...
                    'Name','Gallery selection',...
                    'ListString',names);
                if isempty(sel)
                    return
                else
                    newsysts = systems(sel);
                end	
                comp = computer;
                switch  comp
                    case 'PCWIN'
                        prompt = [sud.oddir,'\*.odg'];
                    case 'MAC2'
                        prompt = [sud.oddir,':*.odg'];
                    otherwise
                        prompt = [sud.oddir,':/.odg'];
                end
                [fname,pname] = uiputfile(prompt,'Save the gallery as:');
                if fname == 0,return;end
                ll = length(fname);
                if (ll>4 & strcmp(fname(ll-3:ll),'.odg'))
                    fn = fname(1:(ll-4));
                else
                    fn =fname;
                end
                fname = [fn,'.odg'];
            end
            
            ll = length(newsysts);
            fid = fopen([pname fname],'w');
            for k = 1:ll
                NN = newsysts(k).NN;
                nstr = ['H.name = ''', newsysts(k).name, ''';\n'];
                fprintf(fid,nstr);
                NNstr = ['H.NN = ', num2str(NN), ';\n'];
                fprintf(fid,NNstr);
                xname = newsysts(k).xname;
                xnstr = ['H.xname = {''', xname{1}, ''''];
                for kk = 2:NN
                    xnstr = [xnstr, ',''', xname{kk}, ''''];
                end
                xnstr = strrep(xnstr,'\','\\');
                xnstr = [xnstr, '};\n'];
                fprintf(fid,xnstr);
                der = strrep(newsysts(k).der,'\','\\');
                derstr = ['H.der = {''', der{1}, ''''];
                for kk = 2:NN
                    derstr = [derstr, ',''', der{kk}, ''''];
                end
                derstr = [derstr, '};\n'];
                fprintf(fid,derstr);
                ics = newsysts(k).ic;
                icstr = ['H.ic = {''', ics{1}, ''''];
                for kk = 2:NN
                    icstr = [icstr, ',''',ics{kk}, ''''];
                end
                icstr = [icstr, '};\n'];
                fprintf(fid,icstr);
                tnstr = ['H.tname = ''', newsysts(k).tname, ''';\n'];
                fprintf(fid,tnstr);
                tvstr =['H.tvals = [', num2str(newsysts(k).tvals), '];\n'];
                fprintf(fid,tvstr);
                NNN = length(newsysts(k).pname);
                if NNN == 0
                    pnstr = 'H.pname = {};\n';
                    pvstr = 'H.pval = [];\n';
                else
                    pname = strrep(newsysts(k).pname,'\','\\');
                    pnstr = ['H.pname = {''', pname{1}, ''''];
                    for kk = 2:NNN
                        pnstr = [pnstr, ',''', pname{kk}, ''''];
                    end
                    pnstr = [pnstr, '};\n'];
                    pvstr = ['H.pval = [', num2str(newsysts(k).pval), '];\n'];
                end
                fprintf(fid,pnstr);
                fprintf(fid,pvstr);
                NNN = length(newsysts(k).exname);
                if NNN == 0
                    exnstr = 'H.exname = {};\n';
                else
                    exname = strrep(newsysts(k).exname,'\','\\');
                    exnstr = ['H.exname = {''', exname{1}, ''''];
                    for kk = 2:NNN
                        exnstr = [exnstr, ',''', exname{kk}, ''''];
                    end
                    exnstr = [exnstr, '};\n'];
                end
                fprintf(fid,exnstr);
                NNN = length(newsysts(k).exval);
                if NNN == 0
                    exvstr = 'H.exval = {};\n';
                else
                    exval = strrep(newsysts(k).exval,'\','\\');
                    exvstr = ['H.exval = {''', exval{1}, ''''];
                    for kk = 2:NNN
                        exvstr = [exvstr, ',''', exval{kk}, ''''];
                    end
                    exvstr = [exvstr, '};\n'];
                end
                fprintf(fid,exvstr);
            end
            fclose(fid);
            
        case 'loadsyst'
            
            sud = get(gcf,'user');
            pos = get(gcf,'pos');
            wpos = [pos(1),pos(2)+pos(4)+20,300,20];
            waith = figure('pos',wpos,...
                'numb','off',...
                'vis','off',...
                'next','replace',...
                'menubar','none',...
                'resize','off',...
                'createfcn','');
            axes('pos',[0.01,0.01,0.98,0.98],...
                'vis','off');
            xp = [0 0 0 0];
            yp = [0 0 1 1];
            xl = [1 0 0 1 1];
            yl = [0 0 1 1 0];
            patchh = patch(xp,yp,'r','edgecolor','r','erase','none');
            lineh = line(xl,yl,'erase','none','color','k');
            type = input1;  
            set(sud.h.gallery,'enable','off');
            
            switch type
                case 'default'
                    set(waith,'name','Loading the default gallery.','vis','on');
                    set(findobj('tag','load default'),'enable','off');
                    megall = sud.h.gallery;
                    mh = get(megall,'children');
                    add = findobj(megall,'tag','add system');
                    mh(find(mh == add)) = [];
                    delete(mh);
                    newsysstruct = get(megall,'user');
                    system = sud.system;
                    LL = length(system);
                    x = 1/(LL+2);
                    xp = [xp(2),x,x,xp(2)];
                    set(patchh,'xdata',xp);
                    set(lineh,'xdata',xl);
                    drawnow;
                    sep = 'on';
                    for kk = 1:length(system)
                        kkk = num2str(kk);
                        if kk == 2, sep = 'off';end
                        uimenu(megall,'label',system(kk).name,...
                            'call',['odesolve(''system'',',kkk,')'],...
                            'separator',sep);
                    end % for
                    set(megall,'user',system);
                    set(sud.h.loaddefgal,'enable','off')
                    
                otherwise
                    comp = computer;
                    switch  comp
                        case 'PCWIN'
                            prompt = [sud.oddir,'\'];
                        case 'MAC2'
                            prompt = [sud.oddir,':'];
                        otherwise
                            prompt = [sud.oddir,'/'];
                    end
                    
                    switch type
                        case 'system'
                            prompt = [prompt,'*.ods'];
                            [fname,pname] = uigetfile(prompt,'Select a system to load.');
                        case 'gallery'
                            prompt = [prompt,'*.odg'];
                            [fname,pname] = uigetfile(prompt,'Select a gallery to load.');
                    end  % switch type
                    if fname == 0
                        delete(waith);
                        set(sud.h.gallery,'enable','on');
                        return;
                    end
                    set(waith,'name',['Loading ',fname],'vis','on');
                    fid = fopen([pname fname],'r');
                    newsysts = {};
                    kk = 0;
                    while ~feof(fid)
                        kk = kk + 1;
                        newsysts{kk} = fgetl(fid);
                    end
                    fclose(fid);
                    if mod(kk,11)
                        switch type
                            case 'system'
                                warndlg(['The file ',fname, ' does not define a proper system.'],...
                                    'Warning');
                            case 'gallery'
                                warndlg(['The file ',fname, ' does not define a proper gallery.'],...
                                    'Warning');
                        end
                        set(sud.h.gallery,'enable','on');
                        delete(waith);
                        return
                    end % if mod(kk,11)
                    x = 11/(kk+22);
                    xp = [xp(2),x,x,xp(2)];
                    set(patchh,'xdata',xp);
                    set(lineh,'xdata',xl);
                    drawnow;
                    nnn = kk/11;
                    for j = 1:nnn
                        for k = 1:11;
                            eval(newsysts{(j-1)*11+k});
                        end
                        newsysstruct(j) = H;
                    end
                    %    end
                    ignoresyst = {};
                    for j = 1:nnn
                        x = (j+1)/(nnn+2);
                        xp = [xp(2),x,x,xp(2)];
                        set(patchh,'xdata',xp);
                        set(lineh,'xdata',xl);
                        drawnow;
                        newsyst = newsysstruct(j);
                        sname = newsyst.name;
                        sname(find(abs(sname) == 95)) = ' '; % Replace underscores with spaces.
                        newsyst.name = sname;
                        ignore = odesolve('addgall',newsyst);
                        if ignore == -1;
                            ignoresyst{length(ignoresyst)+1} = sname;
                        end  
                    end
                    l = length(ignoresyst);
                    if l  % There was at least one system which was a dup with a different name.
                        if l == 1
                            message = {['The system "',ignoresyst{1},'" duplicates a ',...
                                        'system already in the gallery and was not added.']};
                        else
                            message = 'The systems ';
                            for k = 1:(l-1)
                                message = [message,'"',ignoresyst{k},'", ']; 
                            end
                            message = {[message,'and "',ignoresyst{l},'" duplicate ',...
                                        'systems already in the gallery and were not added.']};
                        end % if l == 1 & else
                        helpdlg(message,'Ignored systems');
                    end  % if l
                    if strcmp(type,'system') % Added a system.
                        if ignore > 0 % The system was ignored.
                            kk = ignore;
                        else
                            systems = get(sud.h.gallery,'user');
                            kk = length(systems);
                        end
                        odesolve('system',kk);
                    end 
            end
            if strcmp('type','default')
                odesolve('system',1);
            end  
            set(sud.h.gallery,'enable','on');
            x = 1;
            xp = [xp(2),x,x,xp(2)];
            set(patchh,'xdata',xp);
            set(lineh,'xdata',xl);
            drawnow;
            delete(waith);
            
            
        case 'addgall'
            
            output = 0;
            odset = findobj('name','ODESOLVE Setup');
            sud = get(odset,'user');
            if nargin < 2    % We are adding the current system.
                syst = sud.c;
                sname = inputdlg('Provide a name for this system.','System name',1,{syst.name});
                if isempty(sname),return;end
                sname = sname{1};
                if ~strcmp(sname,syst.name)
                    sud.c.name = sname;
                    set(odset,'user',sud);
                    syst.name = sname;
                end  
            else  % We have a system coming from a file.
                syst = input1;
                sname = syst.name;
            end
            systems = get(sud.h.gallery,'user');
            LL = length(systems);
            kk = 1;
            while ((kk<=LL) & (~strcmp(sname,systems(kk).name)))
                kk = kk + 1;
            end
            nameflag = (kk<=LL);
            ssyst = rmfield(syst,'name');
            kk = 1;
            while ((kk<=LL) & (~isequal(ssyst,rmfield(systems(kk),'name'))))
                kk = kk + 1;
            end
            systflag = 2*(kk<=LL);
            flag = nameflag + systflag;
            switch flag
                case 1  % Same name but different system.
                    mh = findobj(sud.h.gallery,'label',sname);
                    prompt = {['The system "',sname,'", which you wish to add to the gallery has ',...
                                'the same name as a different system already in the gallery.  Please ',...
                                'specify the name for the newly added system.'],...
                            'Specify the name for the old system.'};
                    title = 'Two systems with the same name';
                    lineno = 1;
                    defans = {sname,sname};
                    answer = inputdlg(prompt,title,lineno,defans);
                    if isempty(answer)
                        return
                    end
                    sname = answer{1};
                    systems(kk).name = answer{2};
                    set(mh,'label',answer{2});
                    output = kk;
                case 2  % Two names for the same system.
                    oldname = systems(kk).name;
                    mh = findobj(sud.h.gallery,'label',oldname);
                    prompt = {['The system "',sname,'", which you wish to add ',...
                                'to the gallery is the same as a system which is ',...
                                'already in the gallery with the name "',oldname,'".  ',...
                                'Please specify which name you wish to use.']};
                    title = 'Two names for the same system.';
                    lineno = 1;
                    defans = {oldname};
                    answer = inputdlg(prompt,title,lineno,defans);
                    if isempty(answer),return,end
                    systems(kk).name = answer{1};
                    set(mh,'label',answer{1});
                    output = kk;
                case 3 % Systems and names the same.
                    output = -1;
                otherwise
                end  % switch
                set(sud.h.gallery,'user',systems);
                syst.name = sname;
                if flag <=1
                    switch LL
                        case 0
                            systems = syst;
                            sepstr = 'on';
                        case 8
                            systems(9) = syst;
                            if strcmp(systems(8).name,'Duffing''s equation')
                                sepstr = 'on';
                            else
                                sepstr = 'off';
                            end
                        otherwise
                            systems(LL+1) = syst;
                            sepstr = 'off';
                    end      
                    kkk = num2str(LL+1);
                    newmenu = uimenu(sud.h.gallery,'label',sname,...
                        'call',['odesolve(''system'',',kkk,')'],...
                        'separator',sepstr);
                    set(findobj('tag','savegal'),'enable','on');
                end
                set(sud.h.gallery,'user',systems);
                
            case 'system'
                
                odset = findobj('name','ODESOLVE Setup');
                ud = get(odset,'user');
                ud.fileflag = 1;
                kk = input1;
                if isstr(kk)
                    kk = str2num(input1);
                end
                system = get(ud.h.gallery,'user');
                syst = system(kk);
                ud.o = syst;
                ud.c = syst;
                ud.h.name = syst.name;
                NN = syst.NN;
                str = ['     all variables vs ', syst.tname, '.'];
                set(ud.h.outputstr,'string', str);
                ud.NNN = 1:NN;
                set(ud.h.NN,'string',num2str(syst.NN));
                set(odset,'user',ud);
                odesolve('numchange');
                ud = get(odset,'user');
                for k = 1:NN
                    set(ud.h.xname(k),'string',syst.xname{k},'vis','on');
                    set(ud.h.der(k),'string',syst.der{k});
                    set(ud.h.icname(k),'string',[syst.xname{k}, ' = ']);
                    set(ud.h.icval(k),'string',syst.ic{k});
                end
                tname = syst.tname;
                pname = syst.pname;
                pval = syst.pval;
                
                for k = 1:length(ud.h.pname)
                    if k > length(pname)
                        pname{k} = '';
                    end
                    name = pname{k};
                    if k <= length(pval)
                        value = num2str(pval(k));
                    else
                        value = '';
                    end
                    set(ud.h.pname(k),'string',name);
                    set(ud.h.pval(k),'string',value);
                end
                
                exval = syst.exval;
                exname = syst.exname;
                for k = 1:length(ud.h.exname)
                    if k > length(exname)
                        exname{k} = '';
                    end
                    name = exname{k};
                    if k <= length(exval)
                        value = num2str(exval{k});
                    else
                        value = '';
                    end
                    set(ud.h.exname(k),'string',name);
                    set(ud.h.exval(k),'string',value);
                end
                ud.c.exname = exname;
                ud.c.exval = exval;
                ud.c.pname = pname;
                ud.c.pval = pval;
                tn = tname;
                set(ud.h.tvar,'string',tn);
                set(ud.h.solint(1),'string',[' <=  ', tn, '  <= ']);
                str = num2str(syst.tvals(2));
                set(ud.h.solint(2),'string',str);
                str = num2str(syst.tvals(3));
                set(ud.h.solint(3),'string',str);
                set(ud.h.tic,'string',[tn, ' = ']);
                set(ud.h.tval,'string',num2str(syst.tvals(1)));
                set(odset,'user',ud);
                odesolve('reset');
                
            case 'solve'
                
                %%  Change the defaults.  We might want to delay this a little.
                
                odesolveset = findobj('name','ODESOLVE Setup');
                sud = get(odesolveset,'user');
                sud.o = sud.c;
                set(odesolveset,'user',sud);
                
                %% Get the pertinent information
                
                NN = sud.c.NN;
                xname = sud.c.xname;
                tname = sud.c.tname;
                der = sud.c.der;
                % ic = sud.c.ic;
                tvals = sud.c.tvals;
                tinit = tvals(1);
                solvers = get(sud.h.solver,'string');
                value = get(sud.h.solver,'value');
                solver = str2func(solvers{value});
                
                %% Check that all of the ICs have an entry.
                
                hempt = findobj(sud.h.icval,'string','');
                if ~isempty(hempt)
                    set(hempt,'backgroundcolor',sud.dcolor);
                    mtitle = 'Initial condition error';
                    mmsg = 'Some initial conditions have no values.';
                    msgbox(mmsg,mtitle);
                    return
                end
                
                % Find the parameters and expressions that are actually used.
                
                [renn,rpnn] = pandecheck('write');
                
                exname = sud.h.exname;
                exval = sud.h.exval;
                krex = length(renn);
                rexname = cell(1,krex);
                for kk = 1:krex
                    rexname{kk} = get(exname(renn(kk)),'string');
                    rexval{kk} = get(exval(renn(kk)),'string');
                end
                
                pname = sud.h.pname;
                pval = sud.h.pval;
                icond = sud.c.ic;
                krp = length(rpnn);
                rpval = cell(1,krp);
                for kk = 1:krp
                    pn = get(pname(rpnn(kk)),'string');
                    rpname{kk} = [',', pn];
                    rpns{kk} = pn;
                    rpval{kk} = get(pval(rpnn(kk)),'string');
                end  
                
                %% Check that the parameter values are numbers.
                
                if ~isempty(rpnn)
                    hbad = [];
                    for kk = 1:length(rpnn)
                        if isempty(str2num(rpval{kk}))
                            hbad = [hbad, pval(rpnn(kk))];
                        end
                    end
                    if ~isempty(hbad)
                        set(hbad ,'backgroundcolor',sud.dcolor);
                        mtitle = 'Parameter error';
                        mmsg = 'Some parameters do not have numerical values.';
                        msgbox(mmsg,mtitle,'modal');
                        return
                    end      
                end
                
                rpvalstr = cell(1,0);
                for k = 1:length(rpval)
                    rpvalstr{k} = str2num(rpval{k});
                end
                
                
                %% Compute the initial conditions, which may involve parameters.
                
                ic = zeros(NN,1);
                hbad = [];
                for kk = 1:NN           % Replace parameters by their values.
                    str = deblank(sud.c.ic{kk});
                    if exist('rpname')
                        lrp =length(rpns);
                        for jj = 1:lrp
                            str = pareval(str,rpns{jj},rpval{jj});
                        end
                    end
                    try
                        ic(kk) = eval(str);
                    catch
                        hbad = [hbad,sud.h.icval(kk)];
                    end
                end
                if ~isempty(hbad )
                    set(hbad ,'backgroundcolor',sud.dcolor);
                    mtitle = 'Initial condition error';
                    mmsg = 'Some initial conditions do not evaluate to numerical values.';
                    msgbox(mmsg,mtitle,'modal');
                    return
                end
                
                %% Compute the solution interval.  The endpoints may involve
                %%  parameters. 
                
                % Yet to be done.
                
                
                % Error check the expressions.
                
                if krex
                    hbad = [];
                    for kk = 1:krex
                        str = rexval{kk};
                        str = pareval(str,tname,num2str(tinit));
                        for jj = 1:krp
                            str = pareval(str,rpns{jj},rpval{jj});
                        end
                        for jj = 1:NN
                            str = pareval(str,xname{jj},num2str(ic(jj)));
                        end
                        try
                            exvalue(kk) = eval(str);
                        catch
                            hbad = [hbad,exval(renn(kk))];
                        end
                    end
                    if ~isempty(hbad)
                        set(hbad ,'backgroundcolor',sud.dcolor);
                        mtitle = 'Expression error';
                        mmsg = 'Some expressions are not entered correctly.';
                        msgbox(mmsg,mtitle,'modal');
                        return
                    end      
                end
                
                % Error check the derivative strings.
                
                hbad = [];
                for kk = 1:NN
                    str = der{kk};
                    str = pareval(str,tname,num2str(tinit));
                    for jj = 1:krp
                        str = pareval(str,rpns{jj},rpval{jj});
                    end
                    for jj = 1:NN
                        str = pareval(str,xname{jj},num2str(ic(jj)));
                    end
                    for jj = 1:krex
                        str = pareval(str,rexname{jj},num2str(exval(jj)));
                    end
                    try
                        derval(kk) = eval(str);
                    catch
                        hbad = [hbad, sud.h.der(kk)];
                    end
                end
                if ~isempty(hbad)
                    set(hbad ,'backgroundcolor',sud.dcolor);
                    mtitle = 'Equation error';
                    mmsg = 'Some equations are not entered correctly.';
                    msgbox(mmsg,mtitle,'modal');
                    return
                end      
                
                % Start a new derivative m-file if necessary.
                
                dfcn = sud.dfname;
                if sud.fileflag
                    if exist(dfcn) == 2
                        delete([tempdir, dfcn, '.m']);
                    end
                    
                    tee = clock;
                    tee = ceil(tee(6)*100);
                    dfcn=['odestp',num2str(tee)];
                    
                    writefile(dfcn, tempdir, renn, rpnn);
                    
                    sud.dfname = dfcn;
                    sud.fileflag = 0;
                    set(odesolveset,'user',sud);
                end
                
                %% Solve the system.
                
                intplus = tvals([1 3]);
                intminus = tvals([1 2]);
                settings = sud.settings;
                opt = odeset('outputfcn',sud.outputhandle,...
                    'abstol',settings.atol,...
                    'reltol',settings.rtol,...
                    'refine',settings.refine);
                if ~isstr(settings.istep)
                    opt = odeset(opt,'initialstep',settings.istep);
                end
                if ~isstr(settings.mstep)
                    opt = odeset(opt,'maxstep',settings.mstep);
                end
                if settings.ncval == 1
                    opt = odeset(opt,'normcontrol','on');
                end
                
                odesdisp = findobj('name','ODESOLVE Display');
                NNN = sud.NNN;
                
                if isempty(odesdisp)
                    odesdisp = figure('name','ODESOLVE Display',...
                        'numb','off',...
                        'tag','odesolve');
                    odesolve('figdefault',odesdisp);
                    dud.solutions = [];
                    dud.axes = axes('units','pix',...
                        'box','on',...
                        'interrupt','on',...
                        'xgrid','on',...
                        'ygrid','on',...
                        'drawmode','fast',...
                        'tag','display axes');
                    set(sud.h.sobutt,'enable','on');
                    set(sud.h.somenu,'enable','on');
                    
                    doptmenu = uimenu('label','Options','visible','off','pos',3);
                    
                    meexportdata = uimenu(doptmenu,'label','Export solution data.',...
                        'call','odesolve(''export'')',...
                        'separator','off','tag','dexp');
                    
                    
                    sud.addflag = 0;
                    sud.h.disp = odesdisp;
                    set(odesolveset,'user',sud);
                    set(odesdisp,'user',dud);
                    set(get(odesdisp,'children'),'vis','on')
                    set(get(doptmenu,'children'),'vis','on')
                else
                    figure(sud.h.disp);
                end
                
                dud = get(odesdisp,'user');
                dud.ic = ic;
                set(odesdisp,'user',dud);
                if sud.addflag
                    set(dud.axes,'next','add');
                else
                    set(dud.axes,'next','replace');
                    dud.solutions = [];
                    set(odesdisp,'user',dud);
                end
                
                exist(dfcn);
                dfh = str2func(dfcn);
                cflag = 0;
                
                if intplus(1) < intplus(2)
                    cflag = cflag + 1;
                    [tp,xp] = feval(solver,dfh,intplus,ic,opt,rpvalstr{:});
                    dud = get(odesdisp,'user');
                    hnew1 = dud.lines;
                    set(dud.axes,'next','add');
                end
                if intminus(1) > intminus(2)
                    cflag = cflag + 2;
                    [tm,xm] = feval(solver,dfh,intminus,ic,opt,rpvalstr{:});
                    dud = get(odesdisp,'user');
                    hnew2 = dud.lines;
                end
                
                dud.lines = [];
                set(odesdisp,'user',dud);
                
                % Store the trajectory.
                
                switch cflag
                    case 1 % positive only
                        x = xp;
                        t = tp;
                        dud.currentplot = hnew1;
                        
                    case 2 % negative only
                        x = flipud(xm);
                        t = flipud(tm);
                        dud.currentplot = hnew2;
                        
                    case 3 % both directions
                        x = flipud(xm);
                        t = flipud(tm);
                        x=[x;xp];
                        t=[t;tp];
                        delete(hnew2)
                        dud.currentplot = hnew1;
                        
                end	 % switch cflag
                
                LL = length(dud.solutions);
                if LL == 0
                    dud.solutions = struct('tdata',t,'xdata',x,'handles',dud.currentplot);
                else
                    dud.solutions(LL+1).tdata = t;
                    dud.solutions(LL+1).xdata = x;
                    dud.solutions(LL+1).handles = dud.currentplot;
                end
                set(dud.axes,'next','replace');
                set(odesdisp,'user',dud);
                set(dud.axes,'user',LL+1);
                val = get(sud.h.output,'value');
                set(sud.h.sobutt,'enable','on');
                set(sud.h.somenu,'enable','on');
                switch val
                    case 1
                        odesolve('tpdone');
                    case 2
                        odesolve('ppdone');
                    case 3
                        odesolve('p3done');
                end % switch val
                
            case 'tpdone'
                
                odesolveset = findobj('name','ODESOLVE Setup');
                sud = get(odesolveset,'user');
                odesdisp = findobj('name','ODESOLVE Display');
                dud = get(odesdisp,'user');
                NNN = sud.NNN;
                tvals = sud.c.tvals;
                axh = dud.axes;
                solution = dud.solutions(get(axh,'user'));
                t = solution.tdata;
                x = solution.xdata;
                
                
                x = x(:,NNN);
                N = length(t);
                if (tvals(3) == t(N) ) & (tvals(2) == t(1))
                    uu = sort(x(:));
                    NN = length(uu);
                    del = (uu(NN) - uu(1))/10;
                    ymin = uu(1)-del;
                    ymax = uu(NN)+del;
                else 
                    tf = tvals(1) +(t(N) - tvals(1))/2;
                    ti = tvals(1) +(t(1) - tvals(1))/2;
                    K = find( (t<tf)&(t>ti) );
                    uu = x(K,:);
                    uu = sort(uu(:));
                    NN = length(uu);
                    rr = 0.1;
                    n1 = ceil(rr*NN);
                    n2 = floor((1-rr)*NN);
                    del = uu(n2) - uu(n1);
                    if del == 0
                        del = 1;
                    end
                    ymin = max(uu(1) - rr*del, uu(n1) - del);
                    ymin = min(ymin,min(dud.ic));
                    ymax = min(uu(NN) + rr*del, uu(n2) +del);
                    ymax = max(ymax,max(dud.ic));
                end
                if sud.addflag
                    ylim = get(dud.axes,'ylim');
                    ymin = min(ymin,ylim(1));
                    ymax = max(ymax,ylim(2));
                end
                for j = 1:length(NNN)
                    set(dud.currentplot(j),'xdata',t,'ydata',x(:,j));
                end
                if sud.icplotflag
                    hold on
                    plot(tvals(1),dud.ic(NNN),'k.','markersize',6);
                    hold off
                end
                set(dud.axes,'ylim',[ymin,ymax]);
                grid on
                xlabel(sud.c.tname)
                xname = sud.c.xname;
                xname = xname(NNN);
                LL = length(xname);
                ystr = xname{1};
                if LL == 2
                    ystr = [ystr, ' and ' xname{2}];
                elseif LL > 2
                    for j = 2:[LL-1]
                        ystr = [ystr, ', ', xname{j}];
                    end
                    ystr = [ystr, ', and ' xname{LL}];
                end
                ylabel(ystr)
                legend(xname,0)
                
            case 'ppdone'
                
                odesolveset = findobj('name','ODESOLVE Setup');
                sud = get(odesolveset,'user');
                odesdisp = findobj('name','ODESOLVE Display');
                dud = get(odesdisp,'user');
                NNN = sud.NNN;
                tvals = sud.c.tvals;
                axh = dud.axes;
                solution = dud.solutions(get(axh,'user'));
                t = solution.tdata;
                x = solution.xdata;
                x = x(:,NNN);
                N = length(t);
                if (tvals(3) == t(N) ) & (tvals(2) == t(1))  
                    
                    % If the solution is over the complet t interval choose the figure
                    % limits to show all of the solution and more.
                    uu = sort(x(:,1));
                    del = (uu(N) - uu(1))/10;
                    if del == 0
                        del = 1;
                    end
                    xmin = uu(1)-del;
                    xmax = uu(N)+del;
                    vv = sort(x(:,2));
                    del = (vv(N) - vv(1))/10;
                    if del == 0
                        del = 1;
                    end
                    ymin = vv(1)-del;
                    ymax = vv(N)+del;
                else 
                    
                    % Otherwise limit ourselves to 1/2 of the limits in both
                    % directions. However, include the initial point for sure. 
                    
                    tf = tvals(1) +(t(N) - tvals(1))/2;
                    ti = tvals(1) +(t(1) - tvals(1))/2;
                    K = find( (t<tf)&(t>ti) );
                    uu = x(K,1); vv = x(K,2);
                    uu = sort(uu);  vv = sort(vv);
                    NN = length(uu);
                    rr = 0.1;
                    n1 = ceil(rr*NN);
                    n2 = floor((1-rr)*NN);
                    ic = dud.ic(NNN);
                    del = uu(n2) - uu(n1);
                    if del == 0
                        del = 1;
                    end
                    xmin = max(uu(1) - rr*del, uu(n1) - del);
                    xmin = min(xmin,ic(1));
                    xmax = min(uu(NN) + rr*del, uu(n2) + del);
                    xmax = max(xmax,ic(1));
                    del = vv(n2) - vv(n1);
                    if del == 0
                        del = 1;
                    end
                    ymin = max(vv(1) - rr*del, vv(n1) - del);
                    ymin = min(ymin,ic(2));
                    ymax = min(vv(NN) + rr*del, vv(n2) + del);
                    ymax = max(ymax,ic(2));
                end
                if sud.addflag
                    xlim = get(dud.axes,'xlim');
                    xmin = min(xmin,xlim(1));
                    xmax = max(xmax,xlim(2));
                    ylim = get(dud.axes,'ylim');
                    ymin = min(ymin,ylim(1));
                    ymax = max(ymax,ylim(2));
                end
                set(dud.currentplot,'xdata',x(:,1),'ydata',x(:,2));
                if sud.icplotflag
                    hold on
                    plot(dud.ic(NNN(1)),dud.ic(NNN(2)),'k.','markersize',6)
                    hold off
                end
                set(dud.axes,'xlim',[xmin,xmax],'ylim',[ymin,ymax]);
                grid on
                xlabel(sud.c.xname(NNN(1)));
                ylabel(sud.c.xname(NNN(2)));
                
            case 'p3done'
                
                odesolveset = findobj('name','ODESOLVE Setup');
                sud = get(odesolveset,'user');
                odesdisp = findobj('name','ODESOLVE Display');
                dud = get(odesdisp,'user');
                NNN = sud.NNN;
                NN = sud.c.NN;
                tvals = sud.c.tvals;
                axh = dud.axes;
                solution = dud.solutions(get(axh,'user'));
                t = solution.tdata;
                x = solution.xdata;
                kt = 0;
                for k = 1:3
                    if NNN(k) > NN
                        X(:,k) = t;
                        Y(k) = tvals(1);
                        kt = k;  % This is the t-variable.
                    else
                        X(:,k) = x(:,NNN(k));
                        Y(k) = dud.ic(NNN(k));
                    end
                end
                N = length(t);
                if (tvals(3) == t(N) ) & (tvals(2) == t(1))  
                    
                    % If the solution is over the complet t interval choose the figure
                    % limits to show all of the solution and more.
                    xmin = zeros(1,3);
                    xmax = zeros(1,3);
                    for k = 1:3
                        uu = sort(X(:,k));
                        del = (uu(N) - uu(1))/10;
                        xmin(k) = uu(1)-del;
                        xmax(k) = uu(N)+del;
                    end
                else 
                    
                    
                    % Otherwise limit ourselves to 1/2 of the limits in both
                    % directions. However, include the initial point for sure. 
                    
                    tf = tvals(1) +(t(N) - tvals(1))/2;
                    ti = tvals(1) +(t(1) - tvals(1))/2;
                    K = find( (t<tf)&(t>ti) );
                    NK = length(K);
                    rr = 0.1;
                    n1 = ceil(rr*NK);
                    n2 = floor((1-rr)*NK);
                    for k = 1:3
                        if k == kt
                            xmin(k) = t(1);
                            xmax(k) = t(N); 
                        else 
                            uu = X(K,k);
                            uu = sort(uu);
                            del = uu(n2) - uu(n1);
                            xmin(k) = max(uu(1) - rr*del, uu(n1) - del);
                            ic = dud.ic(NNN(k));
                            xmin(k) = min(xmin(k),ic);
                            xmax(k) = min(uu(NN) + rr*del, uu(n2) +del);
                            xmax(k) = max(xmax(k),ic);
                        end
                    end
                end
                if sud.addflag
                    xlim = get(dud.axes,'xlim');
                    xmin(1) = min(xmin(1),xlim(1));
                    xmax(1) = max(xmax(1),xlim(2));
                    ylim = get(dud.axes,'ylim');
                    xmin(2) = min(xmin(2),ylim(1));
                    xmax(2) = max(xmax(2),ylim(2));
                    zlim = get(dud.axes,'zlim');
                    xmin(3) = min(xmin(3),zlim(1));
                    xmax(3) = max(xmax(3),zlim(2));
                end
                for k = 1:3
                    if xmin(k) == xmax(k)
                        if xmin(k) == 0
                            del = 1;
                        else
                            del = xmin(k)/10;
                        end
                        xmin(k) = xmin(k)-del;
                        xmax(k) = xmax(k)+del;
                    end
                end
                set(dud.currentplot,'xdata',X(:,1),...
                    'ydata',X(:,2),...
                    'zdata',X(:,3));
                set(dud.axes,'xlim',[xmin(1),xmax(1)],...
                    'ylim',[xmin(2),xmax(2)],...
                    'zlim',[xmin(3),xmax(3)]);
                if sud.icplotflag
                    hold on
                    plot3(Y(1),Y(2),Y(3),'k.','markersize',6)
                    hold off
                end
                grid on
                for k = 1:3
                    if k == kt
                        name{k} = sud.c.tname;
                    else
                        name{k} = sud.c.xname{NNN(k)};
                    end
                end
                xlabel(name(1));
                ylabel(name(2));
                zlabel(name(3));
                
                
            case 'figdefault'
                
                fig = input1;
                set(fig,'CloseRequestFcn','odesolve(''closefcn'')');
                dfset = findobj('name','ODESOLVE Setup');
                sud = get(dfset,'user');
                ud = get(fig,'user');
                ud.ssize = sud.ssize;
                fs = sud.fontsize;
                ud.fontsize = fs;
                set(fig,'defaulttextfontsize',fs);
                set(fig,'defaultaxesfontsize',fs);
                set(fig,'defaultuicontrolfontsize',0.9*fs)
                lw = 0.5*fs/10;
                set(fig,'defaultaxeslinewidth',lw)
                set(fig,'defaultlinelinewidth',lw)
                set(fig,'defaultaxesfontname','helvetica')
                set(fig,'defaultaxesfontweight','normal')
                
                set(fig,'user',ud);
                
            case 'export'
                odesdisp = gcf;
                dud = get(odesdisp,'user');
                odset = findobj('name','ODESOLVE Setup');
                sud = get(odset,'user');
                solutions = dud.solutions;
                lsol = length(solutions);
                switch lsol
                    case 0
                        mtitle = 'Solution choice';
                        mmessage = 'There are no solutions.';
                        msgbox(mmessage, mtitle, 'modal')
                        return
                    case 1
                        sol = solutions;
                    otherwise
                        ginput(1);
                        solh = get(odesdisp,'currentobject');
                        if isempty(solh)
                            mtitle = 'Solution choice';
                            mmessage = 'The item selected is not a solution.';
                            msgbox(mmessage, mtitle, 'modal')
                            return
                        end	
                        looking = 1;
                        kk = 0;
                        while looking & kk<=lsol
                            kk = kk + 1;
                            if kk <= lsol
                                kkk = find(solutions(kk).handles == solh);
                                if ~isempty(kkk)
                                    looking = 0;
                                end
                            else
                                looking = 0;
                            end	
                        end
                        if kk <= lsol
                            sol = solutions(kk);
                        else
                            mtitle = 'Solution choice';
                            mmessage = 'The item selected is not a solution.';
                            msgbox(mmessage, mtitle, 'modal')
                            return
                        end
                end
                vars = evalin('base','who');
                no = 1;
                kk = 0;
                while no
                    kk = kk + 1;
                    vstr = ['odedata',num2str(kk)];
                    if ~any(strcmp(vars,vstr))
                        no = 0;
                    end
                end
                tname = sud.c.tname;
                xname = sud.c.xname;
                NN = sud.c.NN;
                ivstr = struct(tname,sol.tdata);
                fieldstr = tname;
                for kk = 1:NN
                    name = xname{kk};
                    name(find(abs(name) == 92)) = [];
                    string = ['ivstr.', name, ' =  sol.xdata(:,kk);'];
                    eval(string)
                    if kk < NN
                        fieldstr = [fieldstr,', ',name];
                    else
                        fieldstr = [fieldstr, ', and ', name];
                    end
                end
                assignin('base',vstr,ivstr);
                mtitle = 'Solution choice';
                mmessage = ['The data has been exported as the sructure ',...
                        vstr, ' with fields ', fieldstr, '.'];
                msgbox(mmessage, mtitle, 'modal')
                
            case 'fileexport'
                
                comp = computer;
                switch  comp
                    case 'PCWIN'
                        prompt = '\*.m';
                    case 'MAC2'
                        prompt = ':*.m';
                    otherwise
                        prompt = ':/.m';
                end
                [fname,pathname] = uiputfile(prompt,'Save the file as:');
                L = length(fname);
                if L > 2 
                    if strcmp(fname([L-1,L]),'.m')
                        fname = fname([1:L-2]);
                    end
                end
                
                [renn,rpnn] = pandecheck('export');
                writefile(fname, pathname, renn, rpnn);
                
            case 'revert'
                
                sud = get(gcf,'user');
                sud.c = sud.o;
                syst = sud.o;
                sh = sud.h;
                set(sh.tvar,'string',syst.tname);
                xname = syst.xname;
                der = syst.der;
                ic = syst.ic;
                NN = syst.NN;
                set(sh.NN,'string',num2str(NN));
                for kk = 1:NN
                    set(sh.xname(kk),'string',xname{kk});
                    set(sh.der(kk),'string',der{kk});
                    set(sh.icval(kk),'string',ic{kk});
                end
                
            case 'quit'
                
                odesolveset = findobj('name','ODESOLVE Setup');
                sud = get(odesolveset,'user');
                if sud.remtd 
                    rmpath(tempdir);
                end
                oldfiles = dir([tempdir,'odestp*.m']);
                for k = 1:length(oldfiles)
                    fn = [tempdir,oldfiles(k).name];
                    fid = fopen(fn,'r');
                    ll = fgetl(fid);
                    ll = fgetl(fid);
                    ll = fgetl(fid);
                    fclose(fid);
                    if strcmp(ll,'%% Created by ODESOLVE')
                        delete(fn)
                    end
                end
                h = findobj('tag','odesolve');
                delete(h);
                
                
            case 'closefcn'
                
                fig = gcf;  
                name = get(fig,'name');
                if strcmp(name,'ODESOLVE Setup') | strcmp(name,'ODESOLVE Display')
                    quest = ['Closing this window will cause all ODESOLVE ',...
                            'windows to close, and ODESOLVE will stop.  ',...
                            'Do you want to quit ODESOLVE?'];
                    butt = questdlg(quest,'Quit ODESOLVE?','Quit','Cancel','Quit');
                    if strcmp(butt,'Quit')
                        odesolve('quit');
                    end
                else
                    delete(findobj('label',name));
                    delete(fig);
                    
                end
                
            case 'outputchoice'
                
                [h,fig] = gcbo;
                value = get(h,'value');
                ud = get(fig,'user');
                NN = ud.c.NN;
                
                
                odeputf = figure('name','ODESOLVE output',...
                    'vis','off',...
                    'numb','off','tag','odesolve');
                odesolve('figdefault',odeputf);
                set(odeputf,'menubar','none');
                switch value
                    case 1     %  Time plot
                        txtstr = ['Check the variables to be plotted vs. ',...
                                ud.c.tname, '.'];
                        pcall = 'odesolve(''tpout'')';
                    case 2    % Phase plane plot
                        txtstr = 'Choose the X-variable and the Y-variable.' ;
                        pcall = 'odesolve(''ppout'')';
                    case 3    % 3 dimensional plot
                        txtstr = 'Choose the X-variable, Y-variable, and  Z-variable.' ;
                        pcall = 'odesolve(''p3out'')';
                end
                canceldata = ud.h.output;
                
                figdir = uicontrol('style','text',...
                    'horiz','left',...
                    'string',txtstr);
                ext = get(figdir,'extent');
                nudge = 2;
                left = 2;
                bbott = 2;
                sep = 2;
                ht = ext(4)+nudge;
                fdw = ext(3) + nudge;
                figw = fdw +2*left;
                buttw = fdw/2;
                cbutt = uicontrol('style','push',...
                    'pos',[left,bbott,buttw,ht],...
                    'string','Cancel',...
                    'call','odesolve(''outcancel'')',...
                    'user',canceldata);
                pbutt = uicontrol('style','push',...
                    'pos',[left+buttw,bbott,buttw,ht],...
                    'string','Change',...
                    'user',fig,...
                    'call',pcall);
                switch value
                    case 1     %  Time series
                        checkbott = bbott + ht + sep;
                        checkleft = left + 10;
                        checkw = fdw - checkleft;
                        cpos = [checkleft,checkbott,checkw,ht];
                        allcall = [
                            '[h,fig] = gcbo;',...
                                'checks = get(fig,''user'');',...
                                'NN = length(checks)-1;',...
                                'allch = checks(NN+1);',...
                                'val = get(allch,''value'');',...
                                'set(checks(1:NN),''value'',val);'];
                        checks(NN+1) = uicontrol('style','check',...
                            'pos',cpos,...
                            'string','all',...
                            'value',1,...
                            'call',allcall);
                        checkbott = checkbott +ht+sep;
                        ichcall = [
                            '[h,fig] = gcbo;',...
                                'checks = get(fig,''user'');',...
                                'NN = length(checks)-1;',...
                                'allch = checks(NN+1);',...
                                'values = get(checks(1:NN),''value'');',...
                                'vals = zeros(1:NN);',...
                                'for kk = 1:NN,',...
                                '  vals(kk) = values{kk};',...
                                'end,',...
                                'if all(vals),',...
                                '  set(allch,''value'',1),',...
                                'else,',...
                                '  set(allch,''value'',0),',...
                                'end'];
                        
                        
                        for k = 1:NN
                            cpos = [checkleft,checkbott,checkw,ht];
                            checks(NN+1-k) = uicontrol('style','check',...
                                'pos',cpos,...
                                'value',1,...
                                'string',ud.c.xname{NN+1-k},...
                                'call',ichcall);
                            checkbott = checkbott+ht;
                        end
                        fdbott = checkbott+sep;
                        putdata = checks;
                        
                    case 2  % Phase plane plot
                        radbott = bbott + ht + sep;
                        xradleft = left +10;
                        radw = fdw/2 - 10;
                        yradleft = xradleft +radw+10;
                        for k = 1:NN
                            xradpos = [xradleft,radbott,radw,ht];
                            yradpos = [yradleft,radbott,radw,ht];
                            if k == NN;
                                xval = 1;
                                yval = 0;
                            elseif k == NN - 1;
                                xval = 0;
                                yval = 2;
                            else
                                xval = 0;
                                yval = 0;
                            end
                            xrad(NN+1-k) = uicontrol('style','radio',...
                                'pos',xradpos,...
                                'string',ud.c.xname{NN+1-k},...
                                'value',xval,...
                                'max',NN+1-k);
                            yrad(NN+1-k) = uicontrol('style','radio',...
                                'pos',yradpos,...
                                'string',ud.c.xname{NN+1-k},...
                                'value',yval,...
                                'max',NN+1-k);
                            radbott = radbott + ht;
                        end
                        for k = 1:NN
                            set(xrad(k),'user',[xrad(:,[1:(k-1),(k+1):NN]),yrad(k)]);
                            set(yrad(k),'user',[yrad(:,[1:(k-1),(k+1):NN]),xrad(k)]);
                        end
                        rcall = [
                            'me = get(gcf,''currentobject'');',...
                                'kk = get(me,''max'');',...
                                'set(get(me,''user''),''value'',0),',...
                                'set(me,''value'',kk);'];
                        set([xrad,yrad],'call',rcall);
                        xpos = [xradleft,radbott,radw,ht];
                        ypos = [yradleft,radbott,radw,ht];
                        uicontrol('style','text',...
                            'pos',xpos,...
                            'string','X-variable');
                        uicontrol('style','text',...
                            'pos',ypos,...
                            'string','Y-variable');
                        radbott = radbott +ht;
                        fdbott = radbott+sep;
                        putdata = struct('xvar',xrad,'yvar',yrad);
                        
                    case 3  % 3 dimensional plot
                        radbott = bbott + ht + sep;
                        xradleft = left +10;
                        radw = fdw/3 - 10;
                        yradleft = xradleft +radw+10;
                        zradleft = yradleft +radw+10;
                        if NN == 1
                            errordlg(['A 3 dimensional plot is not useful for a single' ...
                                    ' equation.'])
                            return;
                        end
                        xradpos = [xradleft,radbott,radw,ht];
                        yradpos = [yradleft,radbott,radw,ht];
                        zradpos = [zradleft,radbott,radw,ht];
                        radbott = radbott +ht;
                        xrad(NN+1) = uicontrol('style','radio',...
                            'pos',xradpos,...
                            'string',ud.c.tname,...
                            'value',0,...
                            'max',NN+1);
                        yrad(NN+1) = uicontrol('style','radio',...
                            'pos',yradpos,...
                            'string',ud.c.tname,...
                            'value',0,...
                            'max',NN+1);
                        zrad(NN+1) = uicontrol('style','radio',...
                            'pos',zradpos,...
                            'string',ud.c.tname,...
                            'value',NN+1,...
                            'max',NN+1);
                        
                        for k = 1:NN
                            xradpos = [xradleft,radbott,radw,ht];
                            yradpos = [yradleft,radbott,radw,ht];
                            zradpos = [zradleft,radbott,radw,ht];
                            if k == NN;
                                xval = 1;
                                yval = 0;
                                zval = 0;
                            elseif k == NN - 1;
                                xval = 0;
                                yval = 2;
                                zval = 0;
                            else
                                xval = 0;
                                yval = 0;
                                zval = 0;
                            end
                            xrad(NN+1-k) = uicontrol('style','radio',...
                                'pos',xradpos,...
                                'string',ud.c.xname{NN+1-k},...
                                'value',xval,...
                                'max',NN+1-k);
                            yrad(NN+1-k) = uicontrol('style','radio',...
                                'pos',yradpos,...
                                'string',ud.c.xname{NN+1-k},...
                                'value',yval,...
                                'max',NN+1-k);
                            zrad(NN+1-k) = uicontrol('style','radio',...
                                'pos',zradpos,...
                                'string',ud.c.xname{NN+1-k},...
                                'value',zval,...
                                'max',NN+1-k);
                            radbott = radbott + ht;
                        end
                        
                        for k = 1:NN+1
                            set(xrad(k),'user',[xrad(:,[1:(k-1),(k+1):NN+1]),yrad(k),zrad(k)]);
                            set(yrad(k),'user',[yrad(:,[1:(k-1),(k+1):NN+1]),xrad(k),zrad(k)]);
                            set(zrad(k),'user',[zrad(:,[1:(k-1),(k+1):NN+1]),xrad(k),yrad(k)]);
                        end
                        rcall = [
                            'me = get(gcf,''currentobject'');',...
                                'kk = get(me,''max'');',...
                                'set(get(me,''user''),''value'',0),',...
                                'set(me,''value'',kk);'];
                        set([xrad,yrad,zrad],'call',rcall);
                        xpos = [xradleft-8,radbott,radw,ht];
                        ypos = [yradleft-8,radbott,radw,ht];
                        zpos = [zradleft-8,radbott,radw,ht];
                        uicontrol('style','text',...
                            'pos',xpos,...
                            'string','X-variable');
                        uicontrol('style','text',...
                            'pos',ypos,...
                            'string','Y-variable');
                        uicontrol('style','text',...
                            'pos',zpos,...
                            'string','Z-variable');
                        radbott = radbott +ht;
                        fdbott = radbott+sep;
                        putdata = struct('xvar',xrad,'yvar',yrad,'zvar',zrad);
                        
                end  % switch value
                
                set(figdir,'pos',[left,fdbott,fdw,ht]);
                fight = fdbott + ht + nudge;
                set(odeputf,'pos',[100,300,figw,fight],...
                    'user',putdata,...
                    'vis','on');
                set(get(odeputf,'child'),'vis','on');
                set(findobj(odeputf,'type','uicontrol'),'units','normal');
                figure(odeputf)
                
                
            case 'outcancel'  % Callback for Cancel in output choice window.
                
                [h,fig] = gcbo;
                cud =get(h,'user');
                set(cud,'value',get(cud,'user'));
                close;
                
                
                
                
            case 'tpout'  % setup time plot output
                
                [h,fig] = gcbo;
                checks = get(fig,'user');
                NN = length(checks) - 1;
                checks = checks(1:NN);
                val = get(checks,'value');
                val = c2m(val);
                NNN = find(val);
                if isempty(NNN)
                    errordlg('At least one variable must be chosen.');
                    return;
                end
                odesetup = get(h,'user');
                ud = get(odesetup,'user');
                ud.NNN = NNN;     
                hh = ud.h.outputstr;
                if length(NNN) == ud.c.NN
                    str = ['     all variables vs ', ud.c.tname,'.'];
                elseif NNN == 1
                    str = ['     ', ud.c.xname{NNN}, ' vs ' ud.c.tname,'.'];
                else
                    str = ['     ', ud.c.xname{NNN(1)}];
                    for kk = 2:length(NNN)
                        str = [str, ', ', ud.c.xname{NNN(kk)}];
                    end
                    str = [str, ' vs ' ud.c.tname,'.'];
                end
                set(hh,'string',str);     
                ud.outputhandle = @tpout;
                set(ud.h.sobutt,'enable','off');
                set(ud.h.somenu,'enable','off');
                set(odesetup,'user',ud);
                close
                
            case 'ppout'
                
                [h,fig] = gcbo;
                ppud = get(fig,'user');
                xval = c2m(get(ppud.xvar,'value'));
                yval = c2m(get(ppud.yvar,'value'));
                xvar = find(xval);
                yvar = find(yval);
                if isempty(xvar) | isempty(yvar)
                    errordlg('You must choose both an X-variable and a Y-variable.');
                    return;
                end
                odesetup = get(h,'user');
                ud = get(odesetup,'user');
                hh = ud.h.outputstr;
                str = ['     ', ud.c.xname{yvar}, ' vs ',ud.c.xname{xvar}];
                set(hh,'string',str);
                ud.outputhandle = @ppout;
                set(ud.h.sobutt,'enable','off');
                set(ud.h.somenu,'enable','off');
                %  ud.outputhandle = @odesp2;
                ud.NNN = [xvar,yvar];
                set(odesetup,'user',ud);
                close
                
            case 'p3out'
                
                [h,fig] = gcbo;
                ppud = get(fig,'user');
                xval = c2m(get(ppud.xvar,'value'));
                yval = c2m(get(ppud.yvar,'value'));
                zval = c2m(get(ppud.zvar,'value'));
                xvar = find(xval);
                yvar = find(yval);
                zvar = find(zval);
                if isempty(xvar) | isempty(yvar) | isempty(zvar)
                    errordlg('You must choose an X-variable,a Y-variable, and a Z-variable.');
                    return;
                end
                odesetup = get(h,'user');
                ud = get(odesetup,'user');
                hh = ud.h.outputstr;
                NN = ud.c.NN;
                if xvar == NN+1
                    xn = ud.c.tname;
                else 
                    xn = ud.c.xname{xvar};
                end
                if yvar == NN+1
                    yn = ud.c.tname;
                else 
                    yn = ud.c.xname{yvar};
                end
                if zvar == NN+1
                    zn = ud.c.tname;
                else 
                    zn = ud.c.xname{zvar};
                end
                
                str = ['     ', xn, ', ', yn, ', and ', zn];
                set(hh,'string',str);
                ud.outputhandle = @p3out;
                set(ud.h.sobutt,'enable','off');
                set(ud.h.somenu,'enable','off');
                ud.NNN = [xvar,yvar,zvar];
                set(odesetup,'user',ud);
                close
                
            case 'settings'
                
                % Routine for changing solver settings.
                
                [h,fig] = gcbo;
                sud = get(fig,'user');
                NN = sud.c.NN;
                settings = sud.settings;
                ecol = sud.ecolor;
                setf = findobj('name','Solver settings');
                if ~isempty(setf)
                    close(setf)
                end
                setf = figure('name','Solver settings',...
                    'vis','off',...
                    'tag','odesolve',...
                    'numb','off');
                odesolve('figdefault',setf);
                set(setf,'menubar','none')
                val = get(sud.h.solver,'value');
                solver = sud.solvers{val};
                titlestring = ['Settings for ', solver,'.'];
                title = uicontrol('style','text',...
                    'horizon','center',...
                    'string',['Settings for ', solver, '.'],...
                    'visible','off');
                ext = get(title,'extent');
                delete(title)
                texth = ext(4) + 4;
                left = 1;
                eleft = left + 4;
                frw = 258;
                figw = frw + 2*left;
                frsep = 1;
                sep = 1;
                
                %% The buttons.
                
                buttw = (frw-3*frsep)/2;
                cwind = [left+frsep,1,buttw,texth];
                awind = [cwind(1)+cwind(3)+frsep,1,buttw,texth];
                
                ccall = [
                    '[h,fig] = gcbo;',...
                        'close(fig)'];
                butt(1) = uicontrol('style','push',...
                    'pos',cwind,...
                    'string','Cancel',...
                    'call',ccall,...
                    'visible','off');
                butt(2) = uicontrol('style','push',...
                    'pos',awind,...
                    'string','Apply',...
                    'call','odesolve(''setapply'')',...
                    'visible','off');
                
                frbot = 1 + texth + frsep;
                KK = ceil(NN/2);
                if strcmp(solver,'ode15s')
                    frht = (9 + KK)*(texth+sep)+3*sep;
                else
                    frht = (7 + KK)*(texth+sep)+sep;
                end
                frwind = [left,frbot,frw,frht];
                fr = uicontrol('style','frame',...
                    'pos', frwind);
                fight = frbot + frht + frsep;
                figwind = [20,200,figw,fight];
                set(setf,'pos',figwind);
                
                optw = 170;
                ncbot = frbot+sep;
                ncwind = [eleft,ncbot,optw,texth];
                normcont = uicontrol('style','text',...
                    'horizon','left',...
                    'string','Norm control',...
                    'visible','off',...
                    'pos',ncwind);
                editleft = eleft + optw;
                editw = 80;
                encwind = [editleft,ncbot+2,editw,texth];
                onoffstr ={'       on','      off'};
                editnormcont = uicontrol('style','popupmenu',...
                    'horizon','center',...
                    'string',onoffstr,...
                    'value',settings.ncval,...
                    'visible','off',...
                    'backgroundcolor',ecol,...
                    'pos',encwind);
                
                mscall = [
                    '[h,fig] = gcbo;',...
                        'str = get(h,''string'');',...
                        'nstr = str2num(str);',...
                        'if isempty(nstr) | nstr <= 0,',...
                        '  set(h,''string'',''computed'');'...
                        'end,',...
                    ];
                
                msbot = ncbot + texth + sep;
                mswind = [eleft,msbot,optw,texth];
                maxstep = uicontrol('style','text',...
                    'horizon','left',...
                    'string','Maximum step size',...
                    'visible','off',...
                    'pos',mswind);
                emswind = [editleft,msbot+2,editw,texth];
                editmaxstep = uicontrol('style','edit',...
                    'horizon','center',...
                    'string',settings.mstep,...
                    'call',mscall,...
                    'visible','off',...
                    'backgroundcolor',ecol,...
                    'pos',emswind);
                iscall = [
                    '[h,fig] = gcbo;',...
                        'str = get(h,''string'');',...
                        'nstr = str2num(str);',...
                        'if isempty(nstr) | nstr <= 0,',...
                        '  set(h,''string'',''computed'');'...
                        'end,',...
                    ];
                isbot = msbot+texth+sep;
                iswind = [eleft,isbot,optw,texth];
                initstep = uicontrol('style','text',...
                    'horizon','left',...
                    'string','Initial step size',...
                    'visible','off',...
                    'pos',iswind);
                eiswind = [editleft,isbot+2,editw,texth];
                editinitstep = uicontrol('style','edit',...
                    'horizon','center',...
                    'string',settings.istep,...
                    'call',iscall,...
                    'visible','off',...
                    'backgroundcolor',ecol,...
                    'pos',eiswind);
                refcall = [
                    '[h,fig] = gcbo;',...
                        'refine = str2num(get(h,''string''));',...
                        'if isempty(refine) | refine<=0,',...
                        '  refine = 1;',... 
                        'end,',...
                        'refine = ceil(refine);',...
                        'set(h,''string'',refine);',...
                    ];
                
                refbot = isbot + texth + sep;
                refwind = [eleft,refbot,optw,texth];
                refine = uicontrol('style','text',...
                    'horizon','left',...
                    'string','Refine',...
                    'visible','off',...
                    'pos',refwind);
                erefwind = [editleft,refbot+2,editw,texth];
                editrefine = uicontrol('style','edit',...
                    'horizon','center',...
                    'string',settings.refine,...
                    'call',refcall,...
                    'visible','off',...
                    'backgroundcolor',ecol,...
                    'pos',erefwind);
                rtolbot = refbot + texth + sep;
                rtolwind = [eleft,rtolbot,optw, texth];
                rtol = uicontrol('style','text',...
                    'horizon','left',...
                    'string','Relative tolerance',...
                    'visible','off',...
                    'pos',rtolwind);
                ertolwind = [editleft,rtolbot+2,editw,texth];
                editrtol = uicontrol('style','edit',...
                    'horizon','center',...
                    'string',num2str(settings.rtol),...
                    'visible','off',...
                    'backgroundcolor',ecol,...
                    'pos',ertolwind);
                
                vatolcall = [
                    '[h,fig] = gcbo;',...
                        'ud = get(fig,''user'');',...
                        'set(ud.editatol,''string'','''');',...
                    ];
                
                vleft = eleft +8;
                vw = 40;
                evw = 80;
                vjbot = rtolbot;
                xname = sud.c.xname;
                for kk = 1:KK
                    vjbot = vjbot +texth + sep;
                    for jj = 0:1
                        vk = 2*(KK - kk) + 1 + jj;
                        if vk <= NN
                            vjleft = vleft + jj*(vw + evw + sep);
                            vjwind = [vjleft,vjbot,vw,texth];
                            tv = uicontrol('style','text',...
                                'horizon','center',...
                                'string',xname{vk},...
                                'visible','off',...
                                'pos',vjwind);
                            evjleft = vjleft + vw + sep;
                            evjwind = [evjleft,vjbot+2,evw,texth];
                            ev(vk) = uicontrol('style','edit',...
                                'horizon','center',...
                                'string','???',...
                                'call',vatolcall,...
                                'visible','off',...
                                'backgroundcolor',ecol,...
                                'pos',evjwind);
                        end
                    end
                end
                atolbot = vjbot + texth + sep;
                atolwind = [eleft,atolbot,optw, texth];
                atol = uicontrol('style','text',...
                    'horizon','left',...
                    'string','Absolute tolerance:              All',...
                    'visible','off',...
                    'pos',atolwind);
                eatolwind = [editleft,atolbot+2,editw,texth];
                
                atolcall = [
                    '[h,fig] = gcbo;',...
                        'ud = get(fig,''user'');',...
                        'ev = ud.ev;',...
                        'at = get(ud.editatol,''string'');',...	'[h,fig] = gcbo;',...
                        'ud = get(fig,''user'');',...
                        'ev = ud.ev;',...
                        'at = get(ud.editatol,''string'');',...
                        'set(ev,''string'',at);',...
                    ];
                
                
                editatol = uicontrol('style','edit',...
                    'horizon','center',...
                    'string','what goes here?',...
                    'visible','off',...
                    'call',atolcall,...
                    'backgroundcolor',ecol,...
                    'pos',eatolwind);
                atol = settings.atol;
                if length(atol) == 1
                    set(ev,'string',num2str(atol));
                    set(editatol,'string',atol);
                else
                    for kk = 1:NN
                        set(ev(kk),'string',num2str(atol(kk)));
                        set(editatol,'string','');
                    end
                end
                
                tbot = atolbot + texth + sep;
                tw = figw - 2*eleft;
                twind = [eleft,tbot,tw,texth];
                title = uicontrol('style','text',...
                    'horizon','center',...
                    'string',['Settings for ', solver, '.'],...
                    'visible','off',...
                    'pos',twind);
                
                ud.editnormcont = editnormcont;
                ud.editmaxstep = editmaxstep;
                ud.editinitstep = editinitstep;
                ud.editrefine = editrefine;
                ud.editrtol = editrtol;
                ud.ev = ev;
                ud.editatol = editatol;
                set(setf,'user',ud);
                
                
                
                
                set(setf,'vis','on');
                set(get(setf,'child'),'vis','on');
                
            case 'setapply'
                
                [h,fig] = gcbo;
                ud = get(fig,'user');
                odset = findobj('name','ODESOLVE Setup');
                sud = get(odset,'user');
                settings = sud.settings;
                atol = get(ud.editatol,'string');
                if isempty(atol);
                    ev = ud.ev;
                    atol = zeros(1,sud.c.NN);
                    for kk = 1:sud.c.NN
                        atol(kk) = str2num(get(ev(kk),'string'));
                    end
                else
                    atol = str2num(atol);
                end
                settings.atol = atol;
                str = get(ud.editrtol,'string');
                settings.rtol = str2num(get(ud.editrtol,'string'));
                settings.refine = str2num(get(ud.editrefine,'string'));
                is = get(ud.editinitstep,'string');
                if strcmp(is,'computed')
                    settings.istep = is;
                else
                    settings.istep = str2num(is);
                end
                ms = get(ud.editmaxstep,'string');
                if strcmp(ms,'computed')
                    settings.mstep = ms;
                else
                    settings.mstep = str2num(ms);
                end
                settings.ncval = get(ud.editnormcont,'value');
                sud.settings = settings;
                set(odset,'user',sud);
                sud = get(odset,'user');
                close(fig);
                
            case 'restart'
                
                odesolve
                
            end
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            function status = tpout(t,y,flag,varargin)
            
            status = 0;                             % Assume stop button wasn't pushed.
            chunk = 128;                            % Memory is allocated in chunks.
            odset = findobj('name','ODESOLVE Setup');
            sud = get(odset,'user');
            NNN = sud.NNN;     % The variables to be plotted.
            dispfig = sud.h.disp;
            ud = get(dispfig,'user');
            NS = length(ud.solutions);  % The number of solutions already plotted.
            
            if nargin < 3 | isempty(flag) % odesplot(t,y) [v5 syntax] or odesplot(t,y,'')
                
                % Append t and y to ud.t and ud.y, allocating new memory if necessary.
                nt = length(t);
                chunk = max(chunk,nt);
                [rows,cols] = size(ud.y);
                plsols = length(NNN);   % The number of plots 
                oldi = ud.i;    % The number of previous steps
                newi = oldi + nt;    % The current number of steps
                if newi > rows
                    ud.t = [ud.t; zeros(chunk,1)];
                    ud.y = [ud.y; zeros(chunk,cols)];
                end
                ud.t(oldi+1:newi) = t;  
                ud.y(oldi+1:newi,:) = y.';
                ud.i = newi;  % The current number of steps
                set(dispfig,'UserData',ud);
                
                if ud.stop == 1                       % Has stop button been pushed?
                    status = 1;
                    tpout([],[],'done');
                else
                    % Rather than redraw all of the data every timestep, we will simply move
                    % the line segments for the new data, not erasing.  But if the data has
                    % moved out of the axis range, we redraw everything.  If there is
                    % already a solution plotted, we only move the line seqments.
                    
                    ylim = get(gca,'ylim');
                    if (NS == 0) & ((oldi == 1) | (min(y(:)) < ylim(1)) | (ylim(2) < max(y(:))))
                        % Replot everything if this is the first plot, and the data is
                        % out of axis range or if the plot is just initialized. 
                        for j = 1:plsols
                            set(ud.lines(j),'Xdata',ud.t(1:newi),'Ydata',ud.y(1:newi,NNN(j)));
                        end
                    else
                        % Plot only the new data if the axis range is ok, or if this is
                        % plotted on top of another solution.
                        for j = 1:plsols
                            set(ud.line(j),'Xdata',ud.t(oldi:newi),'Ydata',ud.y(oldi:newi,NNN(j)));
                        end
                    end
                end
                
            else
                switch(flag)
                    case 'init'                           % odesplot(tspan,y0,'init')
                        cols = length(y);
                        ud.t = zeros(chunk,1);
                        ud.y = zeros(chunk,cols);
                        ud.i = 1;
                        ud.t(1) = t(1);
                        ud.y(1,:) = y.';
                        if sud.pplotflag
                            mm = '.';
                        else
                            mm = 'none';
                        end
                        
                        axes(ud.axes);
                        
                        % Rather than redraw all data at every timestep, we will simply move
                        % the last line segment along, not erasing it.
                        
                        ms = 6;  % Marker size
                        ud.lines = plot(ud.t(1),ud.y(1,NNN),'-',...
                            'marker',mm,...
                            'markersize',ms,...
                            'erasemode','normal');
                        hold on
                        
                        ud.line = plot(ud.t(1),ud.y(1,NNN),'-',...
                            'marker',mm,...
                            'markersize',ms,...
                            'EraseMode','none');
                        set(gca,'XLim',sud.c.tvals(2:3));
                        hold off
                        
                        % The STOP button.
                        h = findobj(dispfig,'Tag','stop');
                        if isempty(h)
                            ud.stop = 0;
                            pos = get(0,'DefaultUicontrolPosition');
                            pos(1) = pos(1) - 15;
                            pos(2) = pos(2) - 15;
                            str = [
                                '[h,dispfig] = gcbo;',...
                                    'ud=get(dispfig,''UserData''); ',...
                                    'ud.stop=1;',...
                                    'set(dispfig,''UserData'',ud);'];
                            uicontrol( ...
                                'Style','push', ...
                                'String','Stop', ...
                                'Position',pos, ...
                                'Callback',str, ...
                                'Tag','stop');
                        else
                            set(h,'Visible','on');            % make sure it's visible
                            ud.stop = 0;
                        end
                        set(dispfig,'UserData',ud);
                        
                    case 'done'                           
                        ud.t = ud.t(1:ud.i);
                        ud.y = ud.y(1:ud.i,:);
                        delete(ud.line);
                        ud.line=[];
                        for j = 1:length(NNN)
                            set(ud.lines(j),'xdata',ud.t,...
                                'ydata',ud.y(:,NNN(j)),...
                                'erase','normal');
                        end
                        set(dispfig,'UserData',ud);
                        set(findobj(dispfig,'Tag','stop'),'Visible','off');
                        % refresh;                          % redraw figure to remove marker frags
                end
            end
            
            drawnow;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            function status = ppout(t,y,flag,varargin)
            
            status = 0;                             % Assume stop button wasn't pushed.
            chunk = 128;                            % Memory is allocated in chunks.
            odset = findobj('name','ODESOLVE Setup');
            sud = get(odset,'user');
            kk1 = sud.NNN(1);     % The variables to be plotted.
            kk2 = sud.NNN(2);     % The variables to be plotted.
            dispfig = sud.h.disp;
            ud = get(dispfig,'user');
            NS = length(ud.solutions);  % The number of solutions already plotted.
            
            if nargin < 3 | isempty(flag) % odesp2(t,y) [v5 syntax] or odesp2(t,y,'')
                
                % Append y to ud.y, allocating new memory if necessary.
                nt = length(t);
                chunk = max(chunk,nt);
                rows = size(ud.y,1);
                oldi = ud.i;
                newi = oldi + nt;
                if newi > rows
                    ud.y = [ud.y; zeros(chunk,2)];
                end
                y = y([kk1 kk2],:);  % Keep only the two rows of interest.
                ud.y(oldi+1:newi,:) = y.';
                ud.i = newi;
                set(dispfig,'UserData',ud);
                
                if ud.stop == 1                       % Has stop button been pushed?
                    status = 1;
                    ppout([],[],'done');
                else
                    % Rather than redraw all of the data every timestep, we will simply move
                    % the line segments for the new data, not erasing.  But if the data has
                    % moved out of the axis range, we redraw everything.  If there is
                    % already a solution plotted, we only move the line seqments.
                    
                    xlim = get(gca,'xlim');
                    ylim = get(gca,'ylim');
                    % Replot everything if out of axis range or if just initialized.
                    if ~NS & ((oldi == 1) | ...
                            (min(y(1,:)) < xlim(1)) | (xlim(2) < max(y(1,:))) | ...
                            (min(y(2,:)) < ylim(1)) | (ylim(2) < max(y(2,:))))
                        % Replot everything if this is the first plot, and the data is
                        % out of axis range or if the plot is just initialized. 
                        set(ud.lines, ...
                            'Xdata',ud.y(1:newi,1), ...
                            'Ydata',ud.y(1:newi,2));
                    else
                        % Plot only the new data if the axis range is ok, or if this is
                        % plotted on top of another solution.
                        
                        % set(ud.line,'Color',co(1,:));     % "erase" old segment
                        set(ud.line, ...
                            'Xdata',ud.y(oldi:newi,1), ...
                            'Ydata',ud.y(oldi:newi,2));
                    end
                end
                
            else
                switch(flag)
                    case 'init'                           % odesp2(tspan,y0,'init')
                        ud.y = zeros(chunk,2);
                        ud.i = 1;
                        ud.y(1,:) = y([kk1 kk2]).';
                        if sud.pplotflag
                            mm = '.';
                        else
                            mm = 'none';
                        end
                        axes(ud.axes);
                        
                        % Rather than redraw all data at every timestep, we will simply move
                        % the last line segment along, not erasing it.
                        ms = 6;  % Marker size
                        
                        ud.lines = plot(y(kk1),y(kk2),'-',...
                            'marker',mm,...
                            'markersize',ms);
                        hold on
                        ud.line = plot(y(kk1),y(kk2),'-',...
                            'marker',mm,...
                            'markersize',ms,...
                            'EraseMode','none');
                        hold off
                        
                        % The STOP button.
                        h = findobj(dispfig,'Tag','stop');
                        if isempty(h)
                            ud.stop = 0;
                            pos = get(0,'DefaultUicontrolPosition');
                            pos(1) = pos(1) - 15;
                            pos(2) = pos(2) - 15;
                            str = [
                                '[h,dispfig] = gcbo;',...
                                    'ud=get(dispfig,''UserData''); ',...
                                    'ud.stop=1;',...
                                    'set(dispfig,''UserData'',ud);'];
                            
                            uicontrol( ...
                                'Style','push', ...
                                'String','Stop', ...
                                'Position',pos, ...
                                'Callback',str, ...
                                'Tag','stop');
                        else
                            set(h,'Visible','on');            % make sure it's visible
                            ud.stop = 0;
                        end
                        set(dispfig,'UserData',ud);
                        
                    case 'done'                           % odesp2([],[],'done')
                        ud.y = ud.y(1:ud.i,:);
                        set(ud.lines, ...
                            'Xdata',ud.y(:,1), ...
                            'Ydata',ud.y(:,2));
                        set(dispfig,'UserData',ud);
                        set(findobj(dispfig,'Tag','stop'),'Visible','off');
                        refresh;                          % redraw figure to remove marker frags
                        
                end
            end
            
            drawnow;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            function status = p3out(t,y,flag,varargin)
            
            status = 0;                             % Assume stop button wasn't pushed.
            chunk = 128;                            % Memory is allocated in chunks.
            odset = findobj('name','ODESOLVE Setup');
            sud = get(odset,'user');
            NNN = sud.NNN;     % The variables to be plotted.
            NN = sud.c.NN;    % The number of x-variables.
            dispfig = sud.h.disp;
            ud = get(dispfig,'user');
            NS = length(ud.solutions);  % The number of solutions already plotted.
            
            if nargin < 3 | isempty(flag) % odesp2(t,y) [v5 syntax] or odesp2(t,y,'')
                
                % Append appropriate parts of y and t to ud.y, allocating new memory
                % if necessary. 
                nt = length(t);
                chunk = max(chunk,nt);
                rows = size(ud.y,1);
                oldi = ud.i;
                newi = oldi + nt;
                for k = 1:3  % Keep only the rows of interest.
                    if NNN(k) > NN;
                        yy(:,k) = t;
                    else
                        yy(:,k) = y(NNN(k),:).';
                    end
                end
                if newi > rows
                    ud.y = [ud.y; zeros(chunk,3)];
                end
                
                ud.y(oldi+1:newi,:) = yy;
                ud.i = newi;
                set(dispfig,'UserData',ud);
                
                if ud.stop == 1                       % Has stop button been pushed?
                    status = 1;
                    p3out([],[],'done');
                else
                    % Rather than redraw all of the data every timestep, we will simply move
                    % the line segments for the new data, not erasing.  But if the data has
                    % moved out of the axis range, we redraw everything.  If there is
                    % already a solution plotted, we only move the line seqments.
                    
                    xlim = get(gca,'xlim');
                    ylim = get(gca,'ylim');
                    zlim = get(gca,'zlim');
                    % Replot everything if out of axis range or if just initialized.
                    if ~NS & ((oldi == 1) | ...
                            (min(yy(:,1)) < xlim(1)) | (xlim(2) < max(yy(:,1))) | ...
                            (min(yy(:,2)) < ylim(1)) | (ylim(2) < max(yy(:,2))) | ...
                            (min(yy(:,3)) < zlim(1)) | (zlim(2) < max(yy(:,3))))
                        % Replot everything if this is the first plot, and the data is
                        % out of axis range or if the plot is just initialized. 
                        set(ud.lines, ...
                            'Xdata',ud.y(1:newi,1), ...
                            'Ydata',ud.y(1:newi,2),...
                            'Zdata',ud.y(1:newi,3));
                    else
                        % Plot only the new data if the axis range is ok, or if this is
                        % plotted on top of another solution.
                        
                        % set(ud.line,'Color',co(1,:));     % "erase" old segment
                        set(ud.line, ...
                            'Xdata',ud.y(oldi:newi,1), ...
                            'Ydata',ud.y(oldi:newi,2), ...
                            'Zdata',ud.y(oldi:newi,3));
                    end
                end
                
            else
                switch(flag)
                    
                    case 'init'                           % odesp2(tspan,y0,'init')
                        ud.y = zeros(chunk,3);
                        ud.i = 1;
                        for k = 1:3  % Keep only the rows of interest.
                            if NNN(k) > NN;
                                yy(:,k) = t(1);
                            else
                                yy(:,k) = y(NNN(k),:).';
                            end
                        end
                        ud.y(1,:) = yy;
                        if sud.pplotflag
                            mm = '.';
                        else
                            mm = 'none';
                        end
                        axes(ud.axes);
                        
                        % Rather than redraw all data at every timestep, we will simply move
                        % the last line segment along, not erasing it.
                        ms = 6;  % Marker size
                        
                        ud.lines = plot3(yy(1),yy(2),yy(3),'-',...
                            'marker',mm,...
                            'markersize',ms);
                        hold on
                        ud.line = plot3(yy(1),yy(2),yy(3),'-',...
                            'marker',mm,...
                            'markersize',ms,...
                            'EraseMode','none');
                        hold off
                        
                        % The STOP button.
                        h = findobj(dispfig,'Tag','stop');
                        if isempty(h)
                            ud.stop = 0;
                            pos = get(0,'DefaultUicontrolPosition');
                            pos(1) = pos(1) - 15;
                            pos(2) = pos(2) - 15;
                            str = [
                                '[h,dispfig] = gcbo;',...
                                    'ud=get(dispfig,''UserData''); ',...
                                    'ud.stop=1;',...
                                    'set(dispfig,''UserData'',ud);'];
                            
                            uicontrol( ...
                                'Style','push', ...
                                'String','Stop', ...
                                'Position',pos, ...
                                'Callback',str, ...
                                'Tag','stop');
                        else
                            set(h,'Visible','on');            % make sure it's visible
                            ud.stop = 0;
                        end
                        set(dispfig,'UserData',ud);
                        
                    case 'done'                           % odesp2([],[],'done')
                        ud.y = ud.y(1:ud.i,:);
                        set(ud.lines, ...
                            'Xdata',ud.y(:,1), ...
                            'Ydata',ud.y(:,2), ...
                            'Zdata',ud.y(:,3));
                        set(dispfig,'UserData',ud);
                        set(findobj(dispfig,'Tag','stop'),'Visible','off');
                        refresh;                          % redraw figure to remove marker frags
                        
                end
            end
            
            drawnow;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            function M = c2m(c)
            
            [rows,cols] = size(c);
            if rows*cols == 0
                M = [];
            else
                M = zeros(rows,cols);
                for i=1:rows 
                    M(i,:) = [c{i,[1:cols]}]; 
                end
            end
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            function outstring = pareval(string,par,value)
            
            string = deblank(string);
            string(find(abs(string)==32))=[];
            par = deblank(par);
            value = ['(',value,')'];
            ll = length(string);
            lp = length(par);
            lv = length(value);
            if strcmp(par,string)
                string = value;
            elseif (ll >= lp+1)
                k = findstr(par,string);
                lk = length(k);
                lopstr = '(+-*/^';
                ropstr = ')+-*/^';
                s = [];
                pos = 1;
                for jk = 1:lk
                    if (((k(jk) == 1)|(find(lopstr == string(k(jk)-1))))...
                            &((k(jk)+lp-1 == ll)|(find(ropstr == string(k(jk) + lp)))))
                        s = [s,string(pos:(k(jk)-1)),value];
                        pos = k(jk)+lp;
                    end
                end
                string = [s,string(pos:ll)];
            end
            outstring = string;
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            function [renn,rpnn] = pandecheck(flag)
            
            %% Checks which parameters and expressions are actually used.
            
            odesolveset = findobj('name','ODESOLVE Setup');
            sud = get(odesolveset,'user');
            
            %% The expressions.  Expressions can contain parameters.  Find the
            %% expressions that are actually used in a derivative.
            
            exname = sud.h.exname;
            exval = sud.h.exval;
            der = sud.c.der;
            NN = sud.c.NN;
            renn = [];
            for kk = 1:length(exname)
                exn = char(get(exname(kk),'string'));
                if ~isempty(exn)
                    present = 0;
                    kkk = 1;
                    while present == 0 & kkk <= NN
                        if ~isempty(findstr(exn,char(der(kkk))))
                            present = 1;
                        end
                        kkk = kkk + 1;
                    end
                    if present
                        renn = [renn,kk];
                    end
                end
            end
            krex = length(renn);
            
            %% Set up the parameters.  First find those that are actually used in
            %% either an expression or a drivative.
            
            pname = sud.h.pname;
            icond = sud.c.ic;
            rpnn = [];
            for kk = 1:length(pname)
                pn = char(get(pname(kk),'string'));
                if ~isempty(pn)
                    present = 0;
                    kkk = 1;
                    while present == 0 & kkk <= NN
                        if ~isempty(findstr(pn,char(der(kkk))))
                            present = 1;
                        end
                        kkk = kkk + 1;
                    end
                    kkk = 1;
                    while present == 0 & kkk <= krex
                        rexval = get(exval(renn(kkk)),'string');
                        if ~isempty(findstr(pn,char(rexval)))
                            present = 1;
                        end
                        kkk = kkk + 1;
                    end
                    if strcmp(flag,'write')
                        while present == 0 & kkk <= NN
                            if ~isempty(findstr(pn,icond{kkk}))
                                present = 1;
                            end
                            kkk = kkk + 1;
                        end
                    end
                    
                    if present
                        rpnn = [rpnn,kk];
                    end
                end
            end
            
            
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            function writefile(fname, pathname, renn, rpnn)
            
            %% Writes a function M-file for the system.
            
            odesolveset = findobj('name','ODESOLVE Setup');
            sud = get(odesolveset,'user');
            NN = sud.c.NN;
            xname = sud.c.xname;
            tname = sud.c.tname;
            der = sud.c.der;
            exname = sud.h.exname;
            exval = sud.h.exval;
            krex = length(renn);
            rexname = cell(1,krex);
            for kk = 1:krex
                rexname{kk} = get(exname(renn(kk)),'string');
                rexval{kk} = get(exval(renn(kk)),'string');
            end
            pname = sud.h.pname;
            pval = sud.h.pval;
            icond = sud.c.ic;
            krp = length(rpnn);
            for kk = 1:krp
                pn = get(pname(rpnn(kk)),'string');
                rpname{kk} = [',', pn];
                rpns{kk} = pn;
                rpval{kk} = get(pval(rpnn(kk)),'string');
            end  
            
            %% Check if tname is Greek.
            
            if (abs(tname(1)) == 92)
                tname(1) = [];
            end
            
            %% Find a convenient variable name not included in tname, xname,
            %% rpname, or rexname. 
            
            present = 1;
            tee = clock;
            tee = num2str(ceil(10000*tee(6)/6));
            kk=1;
            while present
                if kk == 1
                    uname = 'X';
                else
                    uname = ['X',tee(1,kk-1)]
                end
                present = ~isempty(strmatch(uname,xname));
                if ~present
                    present = ~isempty(strmatch(uname,tname));
                end
                if ~present & krp > 0
                    present = ~isempty(strmatch(uname,rpns));
                end
                if ~present & krex > 0
                    present = ~isempty(strmatch(uname,rexname));
                end
                kk = kk + 1;
            end % while present
            
            %% Start the file.
            
            if krp > 0
                fcnstr = ['function ', uname, 'pr = ',fname,'(',tname,',', uname, rpname{:},')\n\n'];
            else 
                fcnstr = ['function ', uname, 'pr = ',fname,'(',tname,',', uname, ')\n\n'];
            end
            
            cxn{1} = xname{1};
            for kk = 2:NN
                cxn{kk} = [', ', xname{kk}];
            end
            if krp
                cpn{1} = rpns{1};
                for kk = 2:krp
                    cpn{kk} = [', ', rpns{kk}];
                end      
            end
            
            dirstr{1} = '%%Input:\n';
            dirstr{2} = ['%%   Independent variable: ', tname, '\n'];
            dirstr{3} = ['%%   Dependent variable vector: X = [', cxn{:},']\n'];
            if krp == 1
                pdirstr{1} = ['%%   Parameter: ', cpn{:}, '\n'];
                pdirstr{2} = ['%%   ', cpn{:}, ' is a parameter\n'];
            elseif krp > 1
                pdirstr{1} = ['%%   Parameters: ', cpn{:}, '\n'];
                pdirstr{2} = ['%%   ', cpn{:}, ' are parameters\n'];
            end
            outstr = ['%%   Vector of derivatives: ', uname 'pr\n'];
            dirstr{4} = '%%To solve the system, execute\n';
            if krp
                dirstr{5} = ['%%      [t,u] = ode45(@', fname, ', tspan, u0, []', ...
                        rpname{:},')\n'];
            else
                dirstr{5} = ['%%      [t,u] = ode45(@', fname, ', tspan, u0)\n'];
            end
            dirstr{6} = '%%   tspan is the solution interval\n';
            dirstr{7} = '%%   u0 is the initial vector\n';
            commstr = '%%%%%% Created by ODESOLVE\n';
            
            dff = fopen([pathname,fname,'.m'],'w');
            fprintf(dff,fcnstr);
            fprintf(dff,commstr);
            fprintf(dff,'%%\n');
            for kk = 1:3
                fprintf(dff,dirstr{kk});
            end
            if krp
                fprintf(dff,pdirstr{1});
            end
            fprintf(dff,'%%\n');
            fprintf(dff,'%%Output:\n');
            fprintf(dff,outstr);
            fprintf(dff,'%%\n');
            for kk = 4:7
                fprintf(dff,dirstr{kk});
            end
            if krp
                fprintf(dff,pdirstr{2});
            end
            fprintf(dff,'\n\n');
            
            
            
            %% Enter the expressions.
            
            if krex
                for kk = 1:krex
                    exstr = rexval{kk};
                    
                    % Remove all periods
                    
                    l=length(exstr);
                    for ( k = fliplr(findstr('.',exstr)))
                        if (find('*/^' == exstr(k+1)))
                            exstr = [exstr(1:k-1), exstr(k+1:l)];
                        end
                        l=l-1;
                    end
                    
                    % Replace variable names by subscripted uname.  A variable must
                    % be preceded and followed by an operator, unless it is the first
                    % or last symbol in an expression.
                    
                    lopstr = '(+-*/^';
                    ropstr = ')+-*/^';
                    for ll = 1:NN
                        UN = [uname, '(', int2str(ll),')'];
                        XN = char(xname{ll});
                        if length(XN) <= length(exstr)
                            kkk = findstr(exstr,XN);
                            Le = length(XN);
                            while ~isempty(kkk)
                                Lde = length(exstr);
                                TP = 1; % True presence at this location is assumed.
                                kkkk = max(kkk);
                                if kkkk + Le < Lde & isempty(find(ropstr == exstr(kkkk+Le)))
                                    TP = 0;
                                end
                                if kkkk > 1 & isempty(find(lopstr == exstr(kkkk-1)))
                                    TP = 0;
                                end
                                if TP
                                    exstr = [exstr(1:kkkk-1),UN,exstr(kkkk+Le:Lde)];
                                end
                                if Le < kkkk
                                    kkk = findstr(exstr(1:kkkk-1),XN);
                                else
                                    kkk = [];
                                end
                            end
                        end
                    end
                    eqnstr = [rexname{kk}, ' = ', char(exstr),';\n'];
                    fprintf(dff,eqnstr);
                end
                fprintf(dff,'\n');
            end     
            
            %% Enter the derivatives.
            
            for kk = 1:NN
                derstr = char(der{kk});
                derstr(find(abs(derstr)==32))=[];   % Remove blanks.
                
                % Remove all periods
                
                l=length(derstr);
                for ( k = fliplr(findstr('.',derstr)))
                    if (find('*/^' == derstr(k+1)))
                        derstr = [derstr(1:k-1), derstr(k+1:l)];
                    end
                    l=l-1;
                end
                
                
                % Replace variable names by subscripted uname.  A variable must
                % be preceded and followed by an operator, unless it is the first
                % or last symbol in an expression.
                
                lopstr = '(+-*/^';
                ropstr = ')+-*/^';
                for ll = 1:NN
                    UN = [uname, '(', int2str(ll),')'];
                    XN = char(xname{ll});
                    if length(XN) <= length(derstr)
                        kkk = findstr(derstr,XN);
                        Le = length(XN);
                        while ~isempty(kkk)
                            Lde = length(derstr);
                            TP = 1; % True presence at this location is assumed.
                            kkkk = max(kkk);
                            if kkkk + Le < Lde & isempty(find(ropstr == derstr(kkkk+Le)))
                                TP = 0;
                            end
                            if kkkk > 1 & isempty(find(lopstr == derstr(kkkk-1)))
                                TP = 0;
                            end
                            if TP
                                derstr = [derstr(1:kkkk-1),UN,derstr(kkkk+Le:Lde)];
                            end
                            if Le < kkkk
                                kkk = findstr(derstr(1:kkkk-1),XN);
                            else
                                kkk = [];
                            end
                        end
                    end
                end
                eqnstr = [derstr,';'];
                if NN == 1
                    eqnstr = [uname, 'pr = ', eqnstr];
                else
                    if kk == 1
                        eqnstr = [uname, 'pr = [', eqnstr];
                    else
                        eqnstr = [blanks(7), eqnstr];
                    end
                    if kk < NN
                        eqnstr = [eqnstr, '...\n'];
                    else
                        eqnstr = [eqnstr, '];\n'];
                    end
                end
                fprintf(dff,eqnstr);
            end   
            fclose(dff);
            
