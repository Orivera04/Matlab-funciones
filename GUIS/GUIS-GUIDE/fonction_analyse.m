
%Author : DRABO CONSTANTIN
%Version 1.0
%Description
%Ce programme  permet l'analyse des fonction simples. Il est destiné à faciliter l'analyse des fonction en 
%mathématiques pour les étudiants en 1ere et terminale ( il pourrait aussi
%servir bien sur à d'autres
%Contact : drconstantin@hotmail.com

function varargout = fonction_analyse(varargin)
% FONCTION_ANALYSE M-file for fonction_analyse.fig
%      FONCTION_ANALYSE, by itself, creates a new FONCTION_ANALYSE or raises the existing
%      singleton*.
%
%      H = FONCTION_ANALYSE returns the handle to a new FONCTION_ANALYSE or the handle to
%      the existing singleton*.
%
%      FONCTION_ANALYSE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FONCTION_ANALYSE.M with the given input arguments.
%
%      FONCTION_ANALYSE('Property','Value',...) creates a new FONCTION_ANALYSE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fonction_analyse_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fonction_analyse_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fonction_analyse

% Last Modified by GUIDE v2.5 01-Jun-2006 00:23:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fonction_analyse_OpeningFcn, ...
                   'gui_OutputFcn',  @fonction_analyse_OutputFcn, ...
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

% --- Executes just before fonction_analyse is made visible.
function fonction_analyse_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fonction_analyse (see VARARGIN)

% Choose default command line output for fonction_analyse
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fonction_analyse wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = fonction_analyse_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%==========================================================================

% --- Executes on button press in bouton_limite.
function bouton_limite_Callback(hObject, eventdata, handles)
% Cette fonction permet de faire un calcul de la limite en un point
% de la fonction

 clear x ;
 syms x ;
 f1 = eval(get(handles.edit_fonction,'String'));
 valeur_limite = get(handles.edit_limite_constante,'String');
  
 %Dans le cas ou l'utilisateur introduit la valeur +inf ou -inf
  switch  valeur_limite
      
      case '-inf'
      %Cas ou l'utilisateur introduit une valeur -inf
      malimite_droite = limit(f1,-inf) ;
      malimite_gauche = limit(f1,-inf) ;
      set(handles.txt_limite_droite,'String', num2str(double(malimite_droite)));
      set(handles.txt_limite_gauche,'String',num2str(double(malimite_gauche))); 
     case 'inf'
      %Cas ou l'utilisateur introduit une valeur +inf
      malimite_droite = limit(f1,inf) ;
      malimite_gauche = limit(f1,inf) ;
      set(handles.txt_limite_droite,'String', num2str(double(malimite_droite)));
      set(handles.txt_limite_gauche,'String',num2str(double(malimite_gauche))); 
     otherwise         
     % Cas ou l'utilisateur introduite une valeur differente des autres cas
      malimite_droite = limit(f1,x,str2num(valeur_limite),'right') ;
      malimite_gauche = limit(f1,x,str2num(valeur_limite),'left') ;
      set(handles.txt_limite_droite,'String', num2str(double(malimite_droite)));
      set(handles.txt_limite_gauche,'String',num2str(double(malimite_gauche)));  
  end 

%==========================================================================
function bouton_nieme_derive_Callback(hObject,eventdata,handles)
%Ici on obtient la derivee nieme de la fonction 

 clear x ;
 syms x ;
 f2 = eval(get(handles.edit_fonction,'String'))
 valeur_derivee = get(handles.edit_nieme_derivation,'String')
 derive_n = diff(f2,str2num(valeur_derivee));
 derive_n = simplify(derive_n);
 set(handles.edit_derivee_nieme,'String',char(derive_n));
  

%==========================================================================
% --- Executes on button press in bouton_integrale.
function bouton_integrale_Callback(hObject, eventdata, handles)
% hObject    handle to bouton_integrale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
clear x ;
syms x ;
f3 = eval(get(handles.edit_fonction,'String'));
borne_inf = get(handles.edit_borne_inf_integrale,'String');
borne_inf = str2num(borne_inf);
borne_sup = get(handles.edit_borne_sup_integrale,'String');
borne_sup = str2num(borne_sup);
mon_int_fonction = int(f3,borne_inf,borne_sup);
format;
mon_int_fonction = double(mon_int_fonction);
set(handles.edit_integrale,'String',num2str(mon_int_fonction));

%==========================================================================
% --- Executes on button press in bouton_calculer.
function bouton_calculer_Callback(hObject, eventdata, handles)
% Ce bouton permet de faire tous les autres calculs 


%Ici j'obtiens la fonction introduite dans la zone de texte
 syms x ;
 ma_fonction = eval(get(handles.edit_fonction,'String'));
 
%Calcul des bornes du domaine de defintion 
 [numerateur,denominateur] = numden(ma_fonction);
 borne_domaine  = solve(denominateur);
 format;
 borne_domaine  = double(borne_domaine)
 
 longueur = length(borne_domaine);
 %%% Pour eviter les nombres complexes
  for i = 1:longueur
     if (isreal(borne_domaine(i)))
          borne_domaine1(i) = borne_domaine(i);
          format;
          borne_domaine1 = double(borne_domaine1) 
     end
     
     if isempty(borne_domaine1)
     
    set(handles.txt_domaine_definition,'String','[-inf inf]');
   else
    set(handles.txt_domaine_definition,'String',num2str(sort([borne_domaine1])));
   end
 end    
 
 
%Calcul de la derivée premiere
 deriv_princip = diff(ma_fonction); 
 deriv_princip = simplify(deriv_princip);
 set(handles.edit_derivee_princip,'String',char(deriv_princip));


%Détermination des maxima et des minima
  solution_maxima = solve(deriv_princip);
  if isempty(solution_maxima)
     set(handles.txt_maxima,'String','Pas de maxima'); 
  else    
  format;
  solution_maxima = double(solution_maxima);
  set(handles.txt_maxima,'String',num2str(sort([solution_maxima]')));
  end
      
  %Determination des zero de la fonction
   mes_zero = solve(ma_fonction);
   if isempty(mes_zero)
        set(handles.txt_zero,'String','Pas de zero');
        mes_z = mes_zero ;
    else
        format;
        mes_zero = double(mes_zero);
        for k = 1:length(mes_zero)
            if(isreal(mes_zero(k)))
                mes_z(k) = mes_zero(k);
            end 
        end
         mes_z = sort(mes_z);
         set(handles.txt_zero,'String',num2str([mes_z]));
    end
  
  
%Détermination de l'integrale de la fonction
  int_fonction = int (ma_fonction);
  set(handles.edit_integrale,'String',char(int_fonction));
  
 %Determination des asymptotes verticales
  racines_asymptote = solve(denominateur);
  format;
  racines_asymptote = double(racines_asymptote);
  longueur_as = length(racines_asymptote);
  for i = 1:longueur_as
     if (isreal(racines_asymptote(i)))
          racines_asymptote1(i) =racines_asymptote(i);
          
     end 
  end  
  racines_asymptote1  = sort(racines_asymptote1);
  
  
  
 %Determination des asymptotes horizontales
 ma_fonction2 = ma_fonction/x ;
 
 %Cas de l'asymptote à droite
 k1 = limit(ma_fonction2,inf);
 if (k1 == inf) || (k1 == -inf)
   % printf('Pas de asymptote');
     tfd = 0;
 else
 ma_fonction3 = ma_fonction2 - k1 ;
 b1 = limit(ma_fonction3,inf);
   if (b1 == inf) || (b1 == -inf)
    % printf('Pas d asymptote');
       tfd = 0 ;
   else
  mon_asymptoted = k1*x + b1 
   end 
end

%Cas de l'asymptote à gauche
 k2 = limit(ma_fonction2,inf);
 if (k2 == inf) || (k2 == -inf)
     %printf('Pas de asymptote');
     tfg = 0 ;
 else
 ma_fonction3 = ma_fonction2 - k2 ;
 b2 = limit(ma_fonction3,inf);
   if (b2 == inf) || (b2 == -inf)
      % printf('Pas d asymptote');
       tfg = 0 ;
   else
  mon_asymptoteg = k2*x + b2 
   end 
end
  
%Representation des points d'inflexion  
  derive_second = diff(deriv_princip);
  pt_inflect    = solve(derive_second);
   if isempty(pt_inflect)
      set(handles.txt_point_inflexion,'String','Pas de point d inflexion'); 
      pt_inflect1  =  pt_inflect ;
  else      
  format;
  pt_inflect    = double(pt_inflect);
    for cpteur    = 1:length(pt_inflect)
      if (isreal(pt_inflect(cpteur)))
          pt_inflect1(cpteur)= pt_inflect(cpteur) ;
      end 
   end     
     pt_inflect1 = sort(pt_inflect1);
     set(handles.txt_point_inflexion,'String',num2str([pt_inflect1]));
 end
      
  
%Representation graphique des données
  axes(handles.axes1)
  ezplot(ma_fonction)
  title('Répresentation graphique de la fonction')
  set(handles.axes1,'XMinorTick','on')
  grid on
  hold on 
  
  %Representation graphique des minima et maxima locaux
  if isempty(solution_maxima)
     set(handles.txt_maxima,'String','Pas de maxima ou de minima')
  else   
  plot (double(solution_maxima),double(subs(ma_fonction,solution_maxima)),'ro')
  end
  
  %Representation graphique des asymptotes verticales 
  if  isempty(racines_asymptote1)
       set(handles.txt_domaine_definition,'String','Pas asymptote');
   else  
      for i = 1:length(racines_asymptote1) 
         plot(double(racines_asymptote1(i))*[1 1], [-10 10],'r') 
     end  
  end
  
  
  %Representation graphique des asymptotes horizontales
    if (tfd == 0 || tfg == 0)
         td = 0
     else    
    plot([-10 10],mon_asymptoted);
    plot([-inf inf],mon_asymptoteg);
    end 
  
  
  %Representation des zero de la fonction
   if isempty(mes_z)
        set(handles.txt_zero,'String','Pas de zero');
    else   
       for j2 = 1:length(mes_z)
           plot(double(mes_z(j2)),double(subs(ma_fonction,mes_z(j2))),'X','MarkerEdgeColor','b','MarkerSize',10);
           
       end   
   end     
    
  
  
  
  %Representation graphique des points d'inflexion
    if isempty(pt_inflect1)
       set(handles.txt_point_inflexion,'String','Pas de point d inflexion');
    else   
       for j = 1:length(pt_inflect1)
           plot(double(pt_inflect1(j)),double(subs(ma_fonction,pt_inflect1(j))),'diamond','MarkerFaceColor','m');
           text(double(pt_inflect1(j)),double(subs(ma_fonction,pt_inflect1(j))),'Point d inflexion','HorizontalAlignment','center');
       end   
   end     
   
      
   %Exple d'aire
   
   
  hold off 
%=============== Fin de la fonction de calcul======================= 

function edit_fonction_Callback(hObject,eventdata,handles)
%Controle ici les valeurs introduite dans la boite de dialogue de edit_fonction
 if  isempty(get(hObject,'String'))
     set(handles.edit_fonction,'String','Introduire une fonction');
 end    


% --------------------------------------------------------------------
function APROPOS_Callback(hObject, eventdata, handles)
% hObject    handle to APROPOS (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
chemin = which('A_propos.html')
web(chemin)

% --------------------------------------------------------------------
function QUITTER_Callback(hObject, eventdata, handles)
% hObject    handle to QUITTER (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close all

