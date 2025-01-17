function map_contscalar_STCL2(xlonw,xlone,xlats,xlatn,res,storm,track,modelnm,field)
%
%
%  This is a generic contouring routine that generates movie loops
%   from MAP files built by WAM.
%
%   INPUT:
%   -----
%           1.  xlonw       = NUMERIC       west longitude (deg W)
%           2.  xlone       = NUMERIC       east longitude (deg W)
%           3.  xlats       = NUMERIC       southern latitude (deg N)
%           4.  xlatn       = NUMERIC       northern latitude (deg N)
%           5.  res         = NUMERIC       grid resolution (IN MINUTES)
%           6.  storm       = CHARACTER     Hurricane Storm Name (alpha, use single quotes)
%           7.  track       = CHARACTER     e.g. A93E  OFCL [OUTPUT FILES]
%           8.  modelnm     = CHARACTER     e.g. OWI-NRAQ, WAVEWATCH III
%           9.  field       = CHARACTER     field identifier
%                                               Used to set the range for plotting,
%                                                   Titles, and legends
%                                               w = wave height
%                                               p = peak period
%                                               s = wind speed
%                                               c = drag coeficient
%
%   REQUIREMENTS:
%   ------------
%           1.  Requires an input file containing the dates "mapcont.dat"
%           2.  The full shoreline(s) files from the data base.
%
%
%
%
clf;
set(gcf,'Color',[1,1,1])
%
resd = res / 60.;
x=xlonw:resd:xlone;
y=xlats:resd:xlatn;
[xx,yy] = meshgrid(x,y);
nx = length(x);
ny = length(y);
xlim=[min(x),max(x)];
ylim=[min(y),max(y)];
domain='Basin';
%
%


    colposit = [0.2982 0.038 0.4500 0.0300];
%    legboxx=0.50;legboxy=0.075;
    legboxx=0.55;legboxy=0.93;
    project_in = 'mercator';

%
%
%  WIND SPEED PREFIX
%
if field == 'w'
    wavstr='w';
    titlefld1='       Total      Height H_{mo}';
    titlefld2='H_{total}  ';
    titfile='HMOFLD';
    unts = 'm';
end
if field == 'a'
    wavstr='a';
    titlefld1='       Wind-Sea    Height H_{mo}';
    titlefld2='H_{sea} :  ';
    titfile='HSEFLD';
    unts = 'm';
end
if field == 'l'
    wavstr='l';
    titlefld1='       Swell      Height H_{mo}';
    titlefld2='H_{swell} :  ';
    titfile='HSWFLD';
    unts = 'm';
end
if field == 's'
    wavstr='s';
    titlefld1='        Wind Speed     U_{10}';
    titlefld2='U_{10}  ';
    titfile='WSDFLD';
    unts = 'm/s';
end
if field == 'm'
    wavstr='m';
    titlefld1='     Total: Mean Period T_{mean}';
    titlefld2='T_{mean}  ';
    titfile='TMMFLD';
    unts = 's';
end
%
%
%  Load in the List of dates to generate the wave and direction file names.
%
eval(['load mapcont_',domain,'.dat']);
eval(['mapcont = mapcont_',domain,';'])
eval(['clear mapcont_',domain,';'])
startdate=int2str(floor(min(mapcont)));
enddate=int2str(ceil(max(mapcont)));

xlonwp=xlonw;
xlonep=xlone;
xlatsp=xlats;
xlatnp=xlatn;
%
kkk=length(mapcont);
MAXHGT=0.;
MINHGT=0.;
maxhgtmt(nx,ny)=0;
minhgtmt(nx,ny)=0;
min_maxhgt(nx,ny)=0;
meanhgt(nx,ny)=0.;
for kk=1:kkk
    wwav=[wavstr,int2str(mapcont(kk))];
    FILE1=fopen(wwav,'r');
    WHGT=fscanf(FILE1,'%10f',[nx,ny]);
    WHGT = WHGT;
    meanhgt = meanhgt + WHGT;
    maxhtc=max(max(abs(WHGT)));
    MAXHGT = max(maxhtc,MAXHGT);
    maxhgtmt = max(maxhgtmt,WHGT);
    minhtc= min(min(WHGT));
    MINHGT = min(minhtc,MINHGT);
    minhgtmt = min(minhgtmt,WHGT);
    [kmaxpt] = find(WHGT == maxhtc);
    fclose(FILE1);
end
%
%  Generate Mean Field Matrix

meanhgt=meanhgt/(kkk);
overallmn=mean(meanhgt(:));
MEAN_HGT=flipud(meanhgt');
%
min_maxhgt=max(abs(maxhgtmt),abs(minhgtmt));
min_maxhgt=min_maxhgt.*sign(minhgtmt+maxhgtmt);
%
%  Plot up the Maximum Wave Heights for the given time period
%
min_maxhgt=flipud(min_maxhgt');
dmnt=mapcont(1);
yrmnt=int2str(floor(dmnt/100000000));
YRMNT=floor((dmnt/100000000));
mtst=3*rem(YRMNT,100)-2;
yrr=floor(YRMNT/100);
%
%  Storm Output only 1 Ice Field Mean Monthly
%
monchk=YRMNT-100*yrr;
if monchk <= 9
    mntchar=['0',int2str(monchk)];
else
    mntchar=int2str(monchk);
end
%
%  Setting up the file name and movie titles
%
fileout1=[titfile,domain,'_',modelnm,track,'_',storm,'_MAX']
titlnam1A=[modelnm,' ',storm,' ',domain,'  (Res ',num2str(resd),'\circ',...
    ' )  TEST CASE:  ',  track];
titlnam1B=['  MAXIMUM ',titlefld1,'  RESULTS:   ',storm];
titlnam1=[{titlnam1A};{titlnam1B}];
%
%  add third variable v = contour levels rather than automatically
%   setting the number of contours based on maximum....
%
%
RANGMM=MAXHGT;

disp([titlefld1, num2str(ceil(RANGMM))]); %debug feature --njw 16 Feb 2004
interv=0.005*RANGMM;
v=[0:interv:RANGMM];
%
%  Find the location of the overall maximum wave height
%  NEED TO FLIP THE JJ since the matrix is coming in from North to South
%
[ii,j1]=find(MAXHGT == maxhgtmt);
jj = ny-j1 + 1;
nummax=length(kmaxpt);
%
load cmap.mat
colormap(cmap)

m_proj(project_in,'long',[xlonwp xlonep],'lat',[xlatsp xlatnp]);
[CMCF,hh]=m_contourf(x,y,min_maxhgt,v);
caxis([0,RANGMM]);
set(hh,'EdgeColor','none');
% h --> f
m_gshhs_f('patch',[.0 .5 .0],'edgecolor','k');
set(gca,'Position',[0.13 0.17 0.775 0.725]);
xlabel('Longitude','FontWeight','bold')
ylabel('Latitude','FontWeight','bold')
m_grid('box','fancy','tickdir','in','FontWeight','Bold');
hcc=get(gca,'children');
tags=get(hcc,'Tag');
k=strmatch('m_grid',tags);
hgrd=hcc(k);
hp=findobj(gca,'Tag','m_grid_color');
set(hp,'Visible','off');
set(hgrd,'HandleVisibility','off');
%Turn off white areas of Coast Patches
% h --> f
k2=strmatch('m_gshhs_f',tags); %finds indices for coast patch handles 
h_water=findobj(hcc(k2),'FaceColor',[1,1,1]); %finds coast patches that are white
set(h_water,'FaceColor','none') %resets white facecolor to 'none'
hold on
%
%
thresh = 0.1*mean(unique(WHGT(:)));
[ijj] = find(abs(WHGT) <= thresh);
m_plot(xx(ijj),yy(ijj),'s','Color',cmap(2,:),'MarkerFaceColor',cmap(2,:), ...
    'MarkerSize',2);
%  Plot the max condition in the map
%
m_plot(xx(kmaxpt),yy(kmaxpt),'.','Color',[1,1,1],'MarkerSize',12);
xlocmax = xx(kmaxpt(1))-360;
deg4lon=[' \circ W / '];
if xlocmax < -180;
    xlocmax = xlocmax + 360;
    if xlocmax > 0
        deg4lon=[' \circ E / '];
    else
        deg4lon=[' \circ W / '];
    end
end
%
%  Setting of the Text for max, location and dates of simulation
%
textstg1=[titlefld2,sprintf('%5.2f',MAXHGT),' [',unts,']'];
textstg2=['LOC (Obs= ',int2str(nummax), ' ):  ' ,num2str(xlocmax),deg4lon,...
    num2str(y(jj(1))),'\circ N'];
textstg3=['DAT:  ',startdate(1:10),' - ',enddate(1:10)];
    
textstrt=[{textstg1};{textstg2};{textstg3}];
%
%  Colorbar
hcolmax=colorbar('horizontal');
set(hcolmax,'Position',colposit)
textcolbr=[titlefld1,'  [',unts,']'];
% .175 --> 0.15  -.119 -->-0.109
hcbtxt=text(0.34,-.116,textcolbr,'FontWeight','bold','FontSize',8,'units','normalized');
title(titlnam1,'FontWeight','bold');
text(legboxx,legboxy,textstrt,'FontWeight','bold','FontSize',8,'units','normalized','BackgroundColor','w');
%
pos=get(gcf,'Position');
pos(3:4)=[649,664];
set(gcf,'Position',pos,'PaperPositionMode','auto');
%
eval(['print -dpng -r600 ',fileout1]);
%
%  Generate the Mean Field PLOT
%
clf
clear CMCF; clear hh;

RANGMN=ceil(max(MEAN_HGT(:)));
interv=0.005*RANGMN;
v=[0:interv:RANGMN];
%
%  Find the location of the Max of the Mean Wave Height Distribution
%

[MAX_MEAN,I]=max(MEAN_HGT(:));
[J,I]=ind2sub(size(MEAN_HGT),I);
nummnn=length(I);

m_proj(project_in,'long',[xlonwp xlonep],'lat',[xlatsp xlatnp]);
[CMCF,hh]=m_contourf(x,y,MEAN_HGT,v);
caxis([0,RANGMN]);
set(hh,'EdgeColor','none');
% h--> f
m_gshhs_f('patch',[.0 .5 .0],'edgecolor','k');
set(gca,'Position',[0.13 0.17 0.775 0.725]);
xlabel('Longitude','FontWeight','bold')
ylabel('Latitude','FontWeight','bold')
m_grid('box','fancy','tickdir','in','FontWeight','Bold');
hcc=get(gca,'children');
tags=get(hcc,'Tag');
k=strmatch('m_grid',tags);
hgrd=hcc(k);
hp=findobj(gca,'Tag','m_grid_color');
set(hp,'Visible','off');
set(hgrd,'HandleVisibility','off');
%Turn off white areas of Coast Patches
% h-->f
k2=strmatch('m_gshhs_f',tags); %finds indices for coast patch handles 
h_water=findobj(hcc(k2),'FaceColor',[1,1,1]); %finds coast patches that are white
set(h_water,'FaceColor','none') %resets white facecolor to 'none'
hold on
%  Plot the max condition in the map
%
m_plot(x(I(1)),y(J(1)),'.','Color',[1,1,1],'MarkerSize',12);
xlocmax = x(I(1))-360;
deg4lon=[' \circ W / '];
if xlocmax < -180;
    xlocmax = xlocmax + 360;
    if xlocmax > 0
        deg4lon=[' \circ E / '];
    else
        deg4lon=[' \circ W / '];
    end
end
%

fileout2=[titfile,domain,'_',modelnm,track,'_',storm,'_MEAN']
titlnam1A=[modelnm,' ',storm,' ',domain,'  (Res ',num2str(resd),'\circ',...
    ' )  TEST CASE:  ',  track];
titlnam1B=[' MEAN  ',titlefld1,'  RESULTS:   ',storm];
titlnam1=[{titlnam1A};{titlnam1B}];
textstg1A=['OVERALL :  ',titlefld2,sprintf('%5.2f',overallmn),' [',unts,']'];
textstg2A=['MAXIMUM :  ',titlefld2,sprintf('%5.2f',MAX_MEAN),' [',unts,']'];
textstg2B=['LOC (Obs= ',int2str(nummnn), ' ):  ' ,num2str(xlocmax),deg4lon,...
    num2str(y(J(1))),'\circ N'];
textstg3=['DAT:  ',startdate(1:10),' - ',enddate(1:10)];
textstrt=[{textstg1A};{textstg2A};{textstg2B};{textstg3}];
%
%  Colorbar
hcolmax=colorbar('horizontal');
set(hcolmax,'Position',colposit)
textcolbr=[titlefld1,'  [',unts,']'];
hcbtxt=text(0.34,-.116,textcolbr,'FontWeight','bold','FontSize',8,'units','normalized');
title(titlnam1,'FontWeight','bold');
text(legboxx,legboxy,textstrt,'FontWeight','bold','FontSize',8,'units','normalized','BackgroundColor','w');
%
pos=get(gcf,'Position');
pos(3:4)=[649,664];
set(gcf,'Position',pos,'PaperPositionMode','auto');
%
eval(['print -dpng -r600 ',fileout2]);
clf
%

