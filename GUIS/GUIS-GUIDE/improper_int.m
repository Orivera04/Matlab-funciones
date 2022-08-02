function varargout = improper_int(varargin)
% This GUI demonstrates the numerical intergration of an improper
% integral using different methods:     
%    1) Trapezoidal Rule (not implemented here since the function
%       f used is not defined at x=0; this serves as an example to
%       show that closed Newton-Cotes formulas cannot be applied
%       here).
%    2) Midpoint Rule, the simplest open Newton-Cotes formula.
%    3) Midpoint Rule with regularisation.
%    4) Gauss Qaudrature with special points. 
%
% For an explanation of the concepts of regularisation and the
% application of Gauss quatrature with special points, please refer
% to numerical mathematics literature.
%
% The convergence plot of these methods is shown with error
% vs. number of function evaluations. The integral used for the
% comparison is
%
%              1                              
%             Int (cos(x)/sqrt(x)) dx 
%              0  
%
% Limits of integration used are from 0 to 1. Note that the
% integrand approaches infinity at x=0, the integral is thus 
% improper. 
%
%
% The provided example has been taken from this book:
%   Author   : G. Opfer
%   Title    : Numerische Mathematik fuer Anfaenger, 4. Auflage
%   Year     : 2002
%   Publisher: Vieweg, Braunschweig/Wiesbaden, Germany

% Author : Mirza Faisal Baig
% Version: 1.0
% Date   : 20.08.2003

% Variable definitions within GUIDE:
%
% Trapeziodal Rule : Radio Button. To use trapezoidal method to
%   find solution (not implemented here) 
% Midpoint Rule : Radio Button. To use  Midpoint rule to find solution
% Midpoint Rule with regulisation : Radio Button. To use Midpoint
%   rule with regulisation to find solution
%	Gauss Quadrature with Special Points : Radio Button. To use Gauss
%	  Quadrature with Special Points to find solution
% info : Push Button.  To display help
% close: Push Button.  To close the application

%-----------------------------------------------------------------------------
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @improper_int_OpeningFcn, ...
                   'gui_OutputFcn',  @improper_int_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

%-----------------------------------------------------------------------------
% --- Executes just before improper_int is made visible.
function improper_int_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;
guidata(hObject, handles);
movegui(hObject,'onscreen')                 % To display application onscreen
movegui(hObject,'center')                   % To display
                                            % application in the
                                            % center of screen
f = inline('cos(x)./sqrt(x)');																						
plot_function(f,handles)
exact_sol = 1.80904847580054;
set(handles.exact_sol,'String',num2str(exact_sol,15))

%-----------------------------------------------------------------------------
% --- Outputs from this function are returned to the command line.
function varargout = improper_int_OutputFcn(hObject, eventdata, handles)

varargout{1} = handles.output;


%-----------------------------------------------------------------------------
% --- Executes on button press in trapezoidal.
function trapezoidal_Callback(hObject, eventdata, handles)

f = inline('cos(x)./sqrt(x)');
set(handles.text2,'String','f(x) = cos(x)/sqrt(x)')
set(handles.midpoint_rule,'Value',0)
set(handles.midpoint_regul,'Value',0)
set(handles.gauss_guad,'Value',0)
set(handles.functionplot,'HandleVisibility','ON') % to make plot 1 unvisible
set(handles.errorplot,'HandleVisibility','OFF')     % to make plot 2 visible
plot_function(f,handles)
set(handles.functionplot,'HandleVisibility','OFF') % to make plot 1 unvisible
set(handles.errorplot,'HandleVisibility','ON')     % to make plot 2 visible
cla;
set(handles.not_rel_message,'visible','on')

%------------------------------------------------------------------------------
% --- Executes on button press in midpoint_rule.
function midpoint_rule_Callback(hObject, eventdata, handles)

set(handles.not_rel_message,'visible','off')
f = inline('cos(x)./sqrt(x)');
set(handles.text2,'String','f(x) = cos(x)/sqrt(x)')
set(handles.trapezoidal,'Value',0)
set(handles.midpoint_regul,'Value',0)
set(handles.gauss_guad,'Value',0)
plot_function(f,handles)

exact_sol =  1.80904847580054;
n = [1 2 4 8 16 32 64];
for k = 1:length(n),
    res = midpoint_integral(f,0,1,n(k));
    error(k) = abs(exact_sol-res);
end
set(handles.functionplot,'HandleVisibility','OFF') % to make plot 1 unvisible
set(handles.errorplot,'HandleVisibility','ON')     % to make plot 2 visible
loglog(n,error,'LineWidth',2,'Color','Red'),grid
set(handles.exact_sol,'String',num2str(exact_sol,15))
set(handles.approx_sol,'String',num2str(res,15))

%------------------------------------------------------------------------------
% --- Executes on button press in midpoint_regul.
function midpoint_regul_Callback(hObject, eventdata, handles)

set(handles.not_rel_message,'visible','off')
f = inline('(cos(x)-1)./sqrt(x)+2');
set(handles.text2,'String','f(x) = (cos(x)-1)/sqrt(x) + 2')
set(handles.midpoint_rule,'Value',0)
set(handles.trapezoidal,'Value',0)
set(handles.gauss_guad,'Value',0)
plot_function(f,handles)

exact_sol = 1.80904847580054;
n = [1 2 4 8 16 32 64];
for k = 1:length(n),
    res = midpoint_integral(f,0,1,n(k));
    error(k) = abs(exact_sol-res);
end

set(handles.functionplot,'HandleVisibility','OFF') % to make plot 1 unvisible
set(handles.errorplot,'HandleVisibility','ON')  % to make plot 2 visible
loglog(n,error,'LineWidth',2,'Color','Red'),grid
set(handles.exact_sol,'String',num2str(exact_sol,15))
set(handles.approx_sol,'String',num2str(res,15))

%------------------------------------------------------------------------------
% --- Executes on button press in gauss_guad.
function gauss_guad_Callback(hObject, eventdata, handles)

set(handles.not_rel_message,'visible','off')
f = inline('cos(x)./sqrt(x)');
f1 = ('cos(x)');
set(handles.text2,'String','f(x) = cos(x)/sqrt(x)')
set(handles.midpoint_rule,'Value',0)
set(handles.midpoint_regul,'Value',0)
set(handles.trapezoidal,'Value',0)
plot_function(f,handles)
exact_sol = 1.80904847580054;
n = [1 2 4 8 16 32 64];
for k = 1:length(n),
    res = gaussq_integral(f1,0,1,n(k));
    error(k) = abs(exact_sol-res);
end

set(handles.functionplot,'HandleVisibility','OFF') % to make plot 1 unvisible
set(handles.errorplot,'HandleVisibility','ON')  % to make plot 2 visible
loglog(n,error,'LineWidth',2,'Color','Red'),grid
set(handles.exact_sol,'String',num2str(exact_sol,15))
set(handles.approx_sol,'String',num2str(res,15))

%------------------------------------------------------------------------------
function res = midpoint_integral(f,a,b,n)
% function to approximate definite intergral of given funtion f 
% with interval [a,b] and n equal subintervals
%
% This function is implemented to approximate integral using Reimann Sum.

function_sum = 0;
for k = 1:n
    function_sum = function_sum + f((2*n*a+2*k*b-2*k*a-b-a)/(2*n));
end
res = ((b-a)/n)*function_sum;


%------------------------------------------------------------------------------
% --- Executes on button press in info.
function info_Callback(hObject, eventdata, handles)
helpwin('improper_int.m') 


%------------------------------------------------------------------------------
% --- Executes on button press in close.
function close_Callback(hObject, eventdata, handles)
close(gcbf) % to close GUI

%------------------------------------------------------------------------------
function plot_function(f,handles)

x = 0.01:0.001:1;
set(handles.functionplot,'HandleVisibility','ON') % to make plot 1 unvisible
set(handles.errorplot,'HandleVisibility','OFF')   % to make plot 2 visible
plot(x,f(x),'linewidth',2),grid

%------------------------------------------------------------------------------
function int = gaussq_integral(fun,xlow,xhigh,gn)
% Numerically evaluates a  integral using a Gauss quadrature.
%              b                              
%             Int (Fun(x)/(sqrt(x))) dx 
%              a                 

tol = 1e-1;
wfun=2;
istart=1; alpha1=0;beta1=0;
FindWeigths=1;
if prod(size(xlow))==1,   
  xlow=xlow(ones(size(xhigh)));;
elseif prod(size(xhigh))==1,
  xhigh=xhigh(ones(size(xlow)));;
elseif any( size(xhigh)~=size(xlow) )
  error('The input must have equal size!')
end
[N M]=size(xlow);
exec_string=['y=',fun ';'];
nk=N*M;    
k=(1:nk)';
int=zeros(nk,1);
tol1=int;
wfuntxt= int2str(wfun);
wtxt=[int2str(gn),'_',wfuntxt];

eval(['global cb',wtxt,' cw',wtxt,';']);

if isempty(eval(['cb',wtxt]))|FindWeigths ,  
  eval(['[cb',wtxt,',cw',wtxt,']=qrulea(gn);']);
end

xlow=xlow(:);
jacob=(xhigh(:)-xlow(:))/2;

calcx_string=['(ones(nk,1),:)).*jacob(k,ones(1, gn ))*2+xlow(k,ones(1,gn ));'];
int_string=['(ones(nk,1),:).*y,2).*sqrt(jacob(k)*2);'];
eval(['x=(cb',wtxt, calcx_string]);            
eval(exec_string);                       
eval(['int(k)=sum(cw',wtxt, int_string]); 

int_old=int;

for i=1:10,
  gn=gn*2;
  wtxt=[int2str(gn),'_',wfuntxt];
  eval(['global cb',wtxt,' cw',wtxt]);
  if isempty(eval(['cb',wtxt]))|FindWeigths ,  
    eval(['[cb',wtxt,',cw',wtxt,']=qrulea(gn);']);
  end
  eval(['x=(cb',wtxt, calcx_string]);       
  eval(exec_string);                        
  eval(['int(k)=sum(cw',wtxt, int_string]); 
  tol1(k)=abs(int_old(k)-int(k));          
  k=find(tol1 > abs(tol*int));                
  if any(k),
      nk=length(k);
  else
    break;
  end
  int_old=int;
end

int=reshape(int,N,M);
%------------------------------------------------------------------------------
function [bp,wf]=qrulea(n)

[bp wf]=gauss_base_weights(2*n);
wf(bp<0)=[];
wf=wf*2;
bp(bp<0)=[];
bp=bp.^2;

%------------------------------------------------------------------------------
function [bp,wf] = gauss_base_weights(n)

bp=zeros(n,1); wf=bp; iter=2; m=fix((n+1)/2); e1=n*(n+1);
mm=4*m-1; t=(pi/(4*n+2))*(3:4:mm); nn=(1-(1-1/n)/(8*n*n));
xo=nn*cos(t);
for j=1:iter
    pkm1=1; pk=xo;
    for k=2:n
        t1=xo.*pk; pkp1=t1-pkm1-(t1-pkm1)/k+t1;
        pkm1=pk; pk=pkp1;
    end
    den=1.-xo.*xo; d1=n*(pkm1-xo.*pk); dpn=d1./den;
    d2pn=(2.*xo.*dpn-e1.*pk)./den;
    d3pn=(4*xo.*d2pn+(2-e1).*dpn)./den;
    d4pn=(6*xo.*d3pn+(6-e1).*d2pn)./den;
    u=pk./dpn; v=d2pn./dpn;
    h=-u.*(1+(.5*u).*(v+u.*(v.*v-u.*d3pn./(3*dpn))));
    p=pk+h.*(dpn+(.5*h).*(d2pn+(h/3).*(d3pn+.25*h.*d4pn)));
    dp=dpn+h.*(d2pn+(.5*h).*(d3pn+h.*d4pn/3));
    h=h-p./dp; xo=xo+h;
end
bp=-xo-h;
fx=d1-h.*e1.*(pk+(h/2).*(dpn+(h/3).*(...
    d2pn+(h/4).*(d3pn+(.2*h).*d4pn))));
wf=2*(1-bp.^2)./(fx.*fx);
if (m+m) > n,
    bp(m)=0; 
end
if ~((m+m) == n), 
    m=m-1; 
end
jj=1:m; n1j=(n+1-jj); bp(n1j)=-bp(jj); wf(n1j)=wf(jj);


% --- Executes during object creation, after setting all properties.
function exact_sol_CreateFcn(hObject, eventdata, handles)

function exact_sol_Callback(hObject, eventdata, handles)

% --- Executes during object creation, after setting all properties.
function approx_sol_CreateFcn(hObject, eventdata, handles)

function approx_sol_Callback(hObject, eventdata, handles)
