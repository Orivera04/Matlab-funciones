function []=Gauss3D(arg)
% GAUSS3D performs numerical integration over a user defined volume.
% The file int.jpg is used to generate the graphic, thus an error will
% result if this file cannot be found.

if nargin==0
    arg = 'initialize';
else 
    % Retrieve/redefine (See definitions below) Mainly for easy reading.
    hands = get(gcf,'userdata');
    calculate = hands(1); % 
    edit_a = hands(2);  % The edits are for inputing the function defs. 
    edit_b = hands(3);   
    edit_c = hands(4);   
    edit_d = hands(5);
    edit_e = hands(6);
    edit_f = hands(7);   
    edit_g = hands(8);   
    edit_h = hands(9);
    edit_j = hands(10);
    example = hands(11);  % Generates an example.
    points = hands(12);  % Allows user to specify # of Gauss points to use.
    result = hands(13);  % Displays the results of the calculation.
end
    
switch arg
    
    case 'initialize'

          h_fig = figure('name','3D Gaussian Quadrature','resize','off',...
                'menubar','none','position',[500 400 621 399]);
          picture = axes;   % Here and next 3 lines, draw graphic.
          A = imread('int.jpg');  
          image(A);
          set(picture,'units','pixels','box','on','ytick',[],...
              'xtick',[],'position',[60 230 400 140]);
          % Define uicontrols.
          calculate = uicontrol(h_fig,'style','pushbutton','fontweight',...
                    'bold','string','Calculate','backgroundcolor','g',...
                    'fontsize',10,'position',[240 15 101 44],'callback',...
                    'Gauss3D(''calculate'')');
          edit_a = uicontrol(h_fig,'style','edit','string','a(y,z)',...
                 'position',[394 81 126 28]);
          edit_b = uicontrol(h_fig,'style','edit','string','b(y,z)',...
                 'position',[394 181 126 28]);
          edit_c = uicontrol(h_fig,'style','edit','string','c(z)',...
                 'position',[230 81 126 28]);
          edit_d = uicontrol(h_fig,'style','edit','string','d(z)',...
                 'position',[230 181 126 28]);  
          edit_e = uicontrol(h_fig,'style','edit','string','e',...
                 'position',[60 81 39 28]);              
          edit_f = uicontrol(h_fig,'style','edit','string','f',...
                 'position',[60 181 39 28]);
          edit_g = uicontrol(h_fig,'style','edit','string','G(x)',...
                 'position',[394 131 126 28]);
          edit_h = uicontrol(h_fig,'style','edit','string','H(y)',...
                 'position',[230 131 126 28]); 
          edit_j = uicontrol(h_fig,'style','edit','string','J(z)',...
                 'position',[60 131 126 28]);
          example = uicontrol(h_fig,'style','pushbutton',...
                  'string','Example','fontweight','bold','callback',...
                  'Gauss3D(''example'')','position',[62 18 76 31]);             
          frame = uicontrol(h_fig,'style','frame','position',...
                 [490 328 111 41],'string','fgggg','BackgroundColor','b');             
          points = uicontrol(h_fig,'style','edit','position',...
                 [514 298 64 28],'string','20');             
          result = uicontrol(h_fig,'style','edit','position',...
                 [390 28 201 25],'string','Result');
          text = uicontrol(h_fig,'style','text','position',...
                [498 339 95 20],'string','Gauss Points','fontsize',10,...
                'BackgroundColor',[0.706 0.706 0.706],'fontweight','bold');
          hands = [calculate edit_a edit_b edit_c edit_d edit_e ... 
                   edit_f edit_g edit_h edit_j example points result];
          set(h_fig,'userdata',hands);  % Store handles in fig's userdata.
          
    case 'calculate'
          
          set(result,'foregroundcolor','r')
          set(result,'String','Please Wait...')
          pause(.01)   % I found this needed for the above to take effect.
          a=fcnchk(inline([get(edit_a,'String'),'+0*y*z']),'vectorized');
          b=fcnchk(inline([get(edit_b,'String'),'+0*y*z']),'vectorized');
          c=fcnchk(inline(get(edit_c,'String')),'vectorized');
          d=fcnchk(inline(get(edit_d,'String')),'vectorized');
          e=str2num(get(edit_e,'String'));
          f=str2num(get(edit_f,'String'));
          g=fcnchk(inline(get(edit_g,'String')),'vectorized');
          h=fcnchk(inline(get(edit_h,'String')),'vectorized');
          j=fcnchk(inline(get(edit_j,'String')),'vectorized');
          Points=str2num(get(points,'String'));
          answer=num2str(gau(g,h,j,a,b,c,d,e,f,Points),10)
          set(result,'foregroundcolor','black')
          set(result,'String',answer)

    case 'example'
         
          set(edit_a,'String','-1')
          set(edit_b,'String','4-y^2-z^2')
          set(edit_c,'String','0')
          set(edit_d,'String','sqrt(4-z^2)')
          set(edit_e,'String','0')
          set(edit_f,'String','2')
          set(edit_g,'String','x^4')
          set(edit_h,'String','y^8')
          set(edit_j,'String','z^6')
          
end


function integral=gau(G,H,J,a,b,c,d,e,f,gp)
% This function does the integration.

[abs1, wgt1] = Gauss(gp); % Generate the abcissa and weights.
% This next block basically performs a meshgrid, only faster.
yy = abs1';
zz = reshape(abs1(:),[1 1 gp]);
absc1 = abs1(ones(gp,1),:,ones(gp,1));
absc2 = yy(:,ones(1,gp),ones(gp,1));
absc3 = zz(ones(gp,1),ones(gp,1),:);
yyy = wgt1';
zzz = reshape(wgt1(:),[1 1 gp]);
wght1 = wgt1(ones(gp,1),:,ones(gp,1));
wght2 = yyy(:,ones(1,gp),ones(gp,1));
wght3 = zzz(ones(gp,1),ones(gp,1),:);

Alphas = ((f-e)./2).*(absc1+1)+e;  % Map the functions to [-1,1]
Betas = ((d(Alphas)-c(Alphas))./2).*(absc2+1)+c(Alphas);
Gammas = ((b(Betas,Alphas)-a(Betas,Alphas))./2).*(absc3+1)+a(Betas,Alphas);
     
summ = wght1.*S3(Alphas,e,f,J).*...  % Evaluate the integrals at G. points.
       wght2.*S2(Alphas,Betas,d,c,H).*...
       wght3.*S1(Alphas,Betas,Gammas,a,b,G);

integral = sum(summ(:))/8;  % Perform final sum. 


function [x, w] = Gauss(n)
% Generates the abscissa and weights for a Gauss-Legendre quadrature.
% Reference:  Numerical Recipes in Fortran 77, Cornell press.
x = zeros(1,n);                                           % Preallocations.
w = x;
m = (n+1)/2;
for ii=1:m
    z = cos(pi*(ii-.25)/(n+.5));                        % Initial estimate.
    z1 = z+1;
while abs(z-z1)>eps
    p1 = 1;
    p2 = 0;
    for jj = 1:n
        p3 = p2;
        p2 = p1;
        p1 = ((2*jj-1)*z*p2-(jj-1)*p3)/jj;       % The Legendre polynomial.
    end
    pp = n*(z*p1-p2)/(z^2-1);                        % The L.P. derivative.
    z1 = z;
    z = z1-p1/pp;
end
    x(ii) = -z;                                   % Build up the abscissas.
    x(n+1-ii) = z;
    w(ii) = 2/((1-z^2)*(pp^2));                     % Build up the weights.
    w(n+1-ii) = w(ii);
end


function anss1=S1(Alphas,Betas,Gammas,a,b,G)
anss1=(b(Betas,Alphas)-a(Betas,Alphas)).*G(Gammas);


function anss2=S2(Alphas,Betas,d,c,H)
anss2=(d(Alphas)-c(Alphas)).*H(Betas);


function anss3=S3(Alphas,e,f,J)
anss3=(f-e).*J(Alphas);


