function hfigset(width,height,xlabels,subplab,linew)
 %a qfigset a rajzot (width x height) mereture allitja es
 %          beallitja a vonalvastagsagot linew ertekre
 %
 % © Kollar Istvan, Gergo Lajos 1998; program a Grafika c. reszhez
 %
 %   width = az abra szelessege, alapertelmezes: az 
 %           aranymetszes szerint a magassag ertekehez 
 %           illesztve
 %   height = az abra magassaga, az aranymetszes szabalya 
 %            szerint a szelesseg alapjan szamitva vagy  
 %            3.5 inch, ha a szelesseg nincs megadva
 %   xlabels = a keret es az x-tengely kozotti teruletet 
 %            szabalyozza
 %           'xtick':    megengedi, hogy az x-tengely 
 %                       beosztasait megcimkezzuk
 %           'nolabels': nem enged cimkezest
 %           'plot' (alapertelmezes): megengedi az x-tengely
 %                       es a beosztas megcimkezeset is
 %           'subplot': megengedi az x-tengely es a beosztas 
 %                      megcimkezeset
 %    subplab = 'felirat' ha elozoleg a 'subplot' parameter 
 %                      volt megadva, akkor az x-tengely 
 %                      kozepere helyezi a feliratot.
 %  A keret meretenek az alapertelmezese  3.5 x 5.66 inch.
 %
 if nargin<5, linew=1.7; end
 if nargin<3, xlabels='plot'; end
 if strcmp(xlabels,'nolabels'), fcdist=0.1;
    elseif strcmp(xlabels,'xtick'), fcdist=0.25;
    elseif strcmp(xlabels,'plot'), fcdist=0.48;
    elseif strcmp(xlabels,'subplot'), fcdist=0.70;
    else error(['xlabels = ''',xlabels,''' is not valid'])
 end
 if nargin<4, subplab=''; end
 if nargin<1, width = NaN; end
 if nargin<2, height = NaN; end
 gold=(sqrt(5)-1)/2; 
 if isempty(height), height=NaN; end
 if isempty(width), width=NaN; end
 %
 %
 % ha nem adtak meg szelesseget vagy magassagot 
 % (vagy egyiket sem),akkor beallitjuk az 
 % aranymetszes szerint (3.5 inch magassaggal)
 %
 %
 if isnan(height) & isnan(width), height=3.5; end
 if isnan(height), height=gold*width; end
 if isnan(width), width=height/gold; end
 %
 Hp = 11;        Wp = 8.4;
 eval('tp=get(0,''TerminalProtocol'');','tp=''PCWIN'';')
 if strcmp(tp,'PCWIN')
    zunits=get(0,'Units');
    set(0,'Units', 'inches')
    scrdim=get(0,'ScreenSize');
    if ~all(finite(scrdim))
       scrdim
       figure(1), scrdim=get(0,'ScreenSize')
    end  
    set(0,'Units',zunits)
 elseif ~strcmp(tp,'none') %ha csak rajz keszulhet
    zunits=get(0,'Units');
    set(0,'Units', 'inches')
    scrdim=get(0,'ScreenSize');
    set(0,'Units',zunits)
 else
    scrdim=get(0,'ScreenSize');
 end
 %
 %
 % itt szamitjuk ki a kepernyo meretet es a papir 
 % meretet a papir legfeljebb 8.4x11 inch meretu 
 % lehet (kb A4-es meret)
 %
 Hm=scrdim(4);  Wm=scrdim(3);
 Hp=min(Hp,Hm); Wp=min(Wm,Wp);

 TopMarg = 0.1;  BotMarg = fcdist;
 LefMarg = 0.25; RiMarg = 0.25;
 %
 % ha vannak mar grafikus ablakok a kepernyon, es 
 % az aktualis ablak 'NextPlot' parametere 'new', 
 % akkor uj ablakot nyitunk
 %
 hc=get(0,'Children');
 if ~isempty(hc)
    if strcmp(get(gcf,'NextPlot'),'new'), 
    figure(max(hc)+1); 
    end
 end
 funits=get(gcf,'Units');
 set( gcf, 'Units', 'inches' )
 set( gcf, 'PaperUnits', 'inches' )

 pwidth = width+RiMarg+LefMarg+0.5;
 pheight = height+TopMarg+BotMarg+0.35;


 % a grafikus ablak meretenek a beallitasa a 
 % kepernyon, az ablakot igyekszunk a jobb 
 % felso sarokba tenni
 %
 fleft = Wm - pwidth-0.05;
 fbottom = Hm - pheight-0.7;
 if fleft<0, pwidth=pwidth-fleft; fleft=0; end
 if pwidth>Wp, pwidth=Wp; end
 if pheight>Hp, pheight=Hp; end
 if fbottom<0,pheight=pheight-fbottom;fbottom=0;end

 set( gcf, 'Position',...
                  [ fleft fbottom pwidth pheight ])


 % az abra meretenek a beallitasa a papiron

 left = (Wp-pwidth);
 bottom = Hp-pheight;
 set( gcf, 'PaperPosition',...
                 [left-1.0 bottom pwidth pheight]) 
 set(gcf,'DefaultAxesLineWidth',0.7)
 set(gca,'LineWidth',0.7)
 set(gcf,'DefaultLineLineWidth',linew)
 set(gca,'DefaultLineLineWidth',linew)


 %
 %  a tengelyek es a keret mereteinek a beallitasa
 %
 aunits=get(gca,'Units');
 set( gca, 'Units', 'inches')
 set( gca, 'Position', [ 0.75 fcdist width height ])
 set(gcf,'DefaultAxesUnits','inches')
 set( gcf, 'Units',funits)
 set(gcf,'DefaultAxesPosition',[ 0.75/pwidth ...
     fcdist/pheight width/pwidth height/pheight ])
 set( gca, 'Units',aunits)

 figure(gcf)
 %
 %
 % a szoveg elhelyezese az x-tengely ala
 %
 %
 if strcmp(xlabels,'subplot')
    if ~isempty(subplab)
        ax=axis;
        xc=mean(ax(1:2));
        yc=ax(3)-fcdist/pheight;
        delete(findobj(gca,'Type','text','string',subplab))
        text(xc,yc,subplab,...
	      'Horizontalalignment',...
            'center','Verticalalignment','top');
    end
 end
 %vege a qfigset programnak