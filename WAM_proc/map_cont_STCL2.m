function map_cont_STCL2(xlonw,xlone,xlats,xlatn,res,pars,ice_coverin,storm,...
    track,modelnm,field)
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
%           6.  pars        = NUMERIC       Sampling of vectors
%                                           (= 0 for NO vectors)
%           7.  ice_coverin   = CHARACTER     For Ice Coverage REQUIRES
%                                                3  CHARACTERS
%                                           000: for NO Ice Coverage
%                                           NUMERICAL VALUE (Percentage
%                                           setting water to land  and
%                                           Canadian Ice Data Base i.e. 70C)
%           8.  storm       = CHARACTER     Hurricane Storm Name (alpha, use single quotes)
%           9.  track       = CHARACTER     e.g. A93E  OFCL [OUTPUT FILES]
%          10.  modelnm     = CHARACTER     e.g. OWI-NRAQ, WAVEWATCH III
%          11.  field       = CHARACTER     field identifier
%                                               Used to set the range for plotting,
%                                                   Titles, and legends
%                                               w = wave height
%                                               p = peak period
%                                               s = wind speed
%                                               c = drag coeficient
%                                               a = wind-sea wave height
%                                               l = swell wave height
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
[xx,yy]=meshgrid(x,y);

nx = length(x);
ny = length(y);
domain='Basin';
%
%  Split the input ice cover into 2 parts
%
ice_cover=str2double(ice_coverin(1:2));
ice_flg=ice_coverin(3:3);
ice_flg2(1:3) = 'CIS';
if ice_flg == 'N'
    ice_flg2(1:3) = 'NIC';
end
%
%
colposit = [0.2982 0.038 0.4500 0.0300];
legboxx=0.55;legboxy=0.93;
project_in = 'mercator';
custerC=[1.,1.,1.];
%
%
%  WIND SPEED PREFIX
%
if field == 'w'
    wavstr='w';
    dirstr='d';
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
%
%  Load in the List of dates to generate the wave and direction file names.
%  NOTE:  For Ice Coverage there are two dates to read
eval(['load mapcont_',domain,'.dat']);
eval(['TIME = mapcont_',domain,';'])
eval(['clear mapcont_',domain,';'])
if ice_coverin(3:3) == 'C' || ice_coverin(3:3) == 'N';
    ice_date=int2str(TIME(:,2));
end
startdate=int2str(floor(min(TIME)));
enddate=int2str(ceil(max(TIME)));
xlonwp=xlonw;
xlonep=xlone;
xlatsp=xlats;
xlatnp=xlatn;

long = [xlonw xlonw xlone xlone];
latg = [xlats xlatn xlatn xlats];
%
kkk=length(TIME);
 MAXHGT=0.;
 MINHGT=0.;
% maxhgtmt(nx,ny)=0;
 maxhgtmt(ny,nx) = 0;
% minhgtmt(nx,ny)=0;
 minhgtmt(ny,nx) = 0;
% min_maxhgt(nx,ny)=0;
% min_maxhgt(ny,nx) = 0;
% meanhgt(nx,ny)=0.;
 meanhgt(ny,nx) = 0.;
files = dir('*.dep');
fid2 = fopen(getfield(files,'name'),'r');
date = fgetl(fid2);
dep = fscanf(fid2,'%5i%1c',[2*nx ny]);
depth = dep(2:2:end,:)';
for kk=1:kkk
    wwav=[wavstr,int2str(TIME(kk))];
    FILE1=fopen(wwav,'r');
    field=fscanf(FILE1,'%10f',[nx,ny]);
    FIELD=flipud(field');
    maxfld=max(max(FIELD));
    meanhgt = meanhgt + FIELD;
    MAXHGT = max(maxfld,MAXHGT);
    if (maxfld == MAXHGT)
        [kmaxpt,kmaxpty]=find(FIELD == maxfld);
    end
    maxhgtmt = max(maxhgtmt,FIELD);
    minhtc= min(min(FIELD));
    MINHGT = min(minhtc,MINHGT);
    minhgtmt = min(minhgtmt,FIELD);
    date=wwav(2:end);
    fclose(FILE1);
end
    %
    %  Generate Mean Field Matrix

meanhgt=meanhgt/(kkk);
kk = find(meanhgt(:) > 0.0);
overallmn=mean(meanhgt(kk));
MEAN_HGT=meanhgt;
%
min_maxhgt=max(abs(maxhgtmt),abs(minhgtmt));
min_maxhgt=min_maxhgt.*sign(minhgtmt+maxhgtmt);
%
%  Plot up the Maximum Wave Heights for the given time period
%
min_maxhgt=min_maxhgt;
dmnt=TIME(1);
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
    

    RANGMM=MAXHGT;
    
    disp([titlefld1,'  ',num2str(RANGMM),'  ',num2str(MINHGT)]);
    interv=0.005*RANGMM;
    v=[-1,-interv/2,0:interv:RANGMM];
    %v = [0:interv:RANGMM];
    nummax=length(kmaxpt);
    %
    load cmap.mat
    colormap(cmap)
    %
    % find where wave heights are zero to not plot the wave
    %  direction vectors.
    %
    in=FIELD==0;
    %  Open and read Overall VECTOR MEAN WAVE DIRECTION files
    %   Note that the WAM directional output is Oceanographic
    %   "Toward which" where 0 is to the north.
    %                   thus translating the u and v component
    %                   below in pol2cart routine.
    %
    if pars > 0
        wdir=[dirstr,int2str(TIME(kk))];
        FILE2=fopen(wdir,'r');
        vmwdir=fscanf(FILE2,'%10f',[nx,ny]);
        vmwdir2=flipud(vmwdir');
        rad2deg = pi / 180.;
        %
        [vc,uc]=pol2cart(rad2deg*vmwdir2,1);
        %
        %  Set Up for Plotting every 1.0 deg
        %
        [X,Y]=meshgrid(x,y);
        i1=mod(1:length(x),pars)==0;
        i2=mod(1:length(y),pars)==0;
        [I1,I2]=meshgrid(i1,i2);
        in2=~in & I1 &I2;
        fclose(FILE2);
    end
    %

    load_coast
    %figure('inverthardcopy','off','color','white','Visible','off')
    m_proj(project_in,'long',[xlonwp xlonep],'lat',[xlatsp xlatnp]);

    [CMCF,hh]=m_contourf(x,y,min_maxhgt,v);
    hold on
    caxis([0,RANGMM]);
    set(hh,'EdgeColor','none');
    for ii = 1:123
        m_plot(lon{ii},lat{ii},'y','LineWidth',1);
    end
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
    %k2=strmatch('m_gshhs_h',tags); %finds indices for coast patch handles
    %h_water=findobj(hcc(k2),'FaceColor',[1,1,1]); %finds coast patches that are white
    %set(h_water,'FaceColor','none') %resets white facecolor to 'none'
    hold on
    %
    %  Plot up the near zero FIELD Info (for WHITE)
    %m_plot(xx(ijj),yy(ijj),'s','Color',[1 1 1],'MarkerFaceColor',[1 1 1],'MarkerSize',2);
    %
        %
    %
    %  Plot the max condition in the map
    %
    for ii = 1:size(kmaxpt,1)
    m_plot(xx(kmaxpt(ii),kmaxpty(ii)),yy(kmaxpt(ii),kmaxpty(ii)),'.','Color',[1,1,1],'MarkerSize',12);
    end
    xlocmax = xx(kmaxpt(1),kmaxpty(1))-360;
    deg4lon=' \circ W / ';
    if xlocmax < -180;
        xlocmax = xlocmax + 360;
        if xlocmax > 0
            deg4lon=' \circ E / ';
        else
            deg4lon=' \circ W / ';
        end
    end
    %  Plot the Vectors
    %
    if pars > 0
        hq=m_quiver(X(in2),Y(in2),uc(in2),vc(in2),0.5);
        set(hq,'color',custerC);
    end
    %
    %  Setting of the Text for max, location and dates of simulation
    %
    textstg1=[titlefld2,sprintf('%5.2f',MAXHGT),' [',unts,']'];
    textstg2=['LOC (Obs= ',int2str(nummax), ' ):  ' ,num2str(xlocmax),deg4lon,...
        num2str(yy(kmaxpt(1),kmaxpty(1))),'\circ N'];
    textstg3=['DATE: ',date];
    textstrt=[{textstg1};{textstg2};{textstg3}];
    %
    %  Plot the ice when applicable
    %
    if ice_cover > 0
        ice_file=['I',ice_date(kk,:),ice_flg2,'.ice'];
        [lat long gpt sLat sLong Zang Depth Ice zero7] = textread(ice_file,'%f%f%f%f%f%f%f%f%f','headerlines',1);
        ice=find(zero7 == 1);
        m_plot(sLong(ice),sLat(ice),'s','Color',[0.8 0.8 0.8],'MarkerFaceColor',[0.8 0.8 0.8],'MarkerSize',2);
        ice_type(kk,1) = ice_date(kk,end);
        if ice_type(kk,1) == '0'
            ice_ch='NODATA';
        elseif ice_type(kk,1) == '1'
            ice_ch='INTERP';
        else
            ice_ch=' DATA ';
        end
        textstg4=['ICE Conc (',ice_flg2,'):  ',num2str(ice_cover), '%  ',ice_ch];
        textstrt=[{textstg1};{textstg2};{textstg3};{textstg4}];
    end
    %
    %  Colorbar
    hcolmax=colorbar('horizontal');
    set(hcolmax,'Position',colposit,'FontSize',8)
    textcolbr=[titlefld1,'  [',unts,']'];
    text(0.34,-.116,textcolbr,'FontWeight','bold','FontSize',8,'units','normalized');
    title(titlnam1,'FontWeight','bold');
    text(legboxx,legboxy,textstrt,'FontWeight','bold','FontSize',8,'units','normalized','BackgroundColor','w');
    %
    
    pos=get(gcf,'Position');
    pos(3:4)=[649,664];
    set(gcf,'Position',pos,'PaperPositionMode','auto');
    %
    eval(['print -dpng -r600 ',fileout1]);
    clf
    clear CMCF; clear hh;

%



    
    RANGMN=max(max(MEAN_HGT(:)));
    bottom = min(MEAN_HGT(:));
    disp(['Mean','  ',num2str(RANGMN),'  ',num2str(bottom)]);
    interv=0.005*RANGMN;
    %v=[-1,-interv/2,0:interv:RANGMN];
    v = [-1,0:interv:RANGMN];
    %
        [MAX_MEAN,I]=max(MEAN_HGT(:));
    [J,I]=ind2sub(size(MEAN_HGT),I);
    nummnn=length(kmaxpt);
 
    
%figure('inverthardcopy','off','color','white','Visible','off')
m_proj(project_in,'long',[xlonwp xlonep],'lat',[xlatsp xlatnp]);
[CMCF,hh]=m_contourf(x,y,MEAN_HGT,v);
hold on
caxis([0,RANGMN]);
set(hh,'EdgeColor','none');
% h--> f
for ii = 1:123
    m_plot(lon{ii},lat{ii},'y','LineWidth',1);
end
%m_gshhs_f('patch',[.0 .5 .0],'edgecolor','k');
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
%k2=strmatch('m_gshhs_f',tags); %finds indices for coast patch handles 
%h_water=findobj(hcc(k2),'FaceColor',[1,1,1]); %finds coast patches that are white
%set(h_water,'FaceColor','none') %resets white facecolor to 'none'
hold on
%  Plot the max condition in the map
%


    for ii = 1:size(kmaxpt,1)
    m_plot(xx(kmaxpt(ii),kmaxpty(ii)),yy(kmaxpt(ii),kmaxpty(ii)),'.','Color',[1,1,1],'MarkerSize',12);
    end
    xlocmax = xx(kmaxpt(1),kmaxpty(1))-360;
    deg4lon=' \circ W / ';
    if xlocmax < -180;
        xlocmax = xlocmax + 360;
        if xlocmax > 0
            deg4lon=' \circ E / ';
        else
            deg4lon=' \circ W / ';
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
    num2str(yy(kmaxpt(1),kmaxpty(1))),'\circ N'];
textstg3=['DAT:  ',startdate(1:10),' - ',enddate(1:10)];
textstrt=[{textstg1A};{textstg2A};{textstg2B};{textstg3}];
%
%  Colorbar
hcolmax=colorbar('horizontal');
set(hcolmax,'Position',colposit,'FontSize',8)
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

