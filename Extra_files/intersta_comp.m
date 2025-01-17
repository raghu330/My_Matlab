function intersta_comp(yrinch,julinch)
%
ii=0;
filein=['COMP_STNLOC_',yrinch,'_',julinch,'.dat'];
%filein=['STNLOC-',yrinch,'-',julinch,'.dat'];
fid=fopen(filein);
while 1
    ii=ii+1;
    tline = fgetl(fid);
    if ~ischar(tline), break, end
    flagp(ii,:) = sscanf(tline(:,1:1),'%c');
    stnnum(ii,:) = sscanf(tline(:,2:7),'%c');
    yrjul(ii,:) = sscanf(tline(:,11:17),'%c');
    stnid(ii,:)=  sscanf(tline(:,18:37),'%c');
    lat(ii,:) = sscanf(tline(:,38:41),'%c');
    long(ii,:) = sscanf(tline(:,42:45),'%c');
end
fclose(fid);
kk=find(flagp == '1');
usaf2prC=stnnum(kk,:);
stnid2prC=stnid(kk,:);
totcomp=length(kk);
%
%Load Data
filein2=['metobs-',yrinch,'-',julinch,'-TSMTH2NN.dat'];
fid=fopen(filein2,'rt');
fmt='%11c%*c%6c %f %f %f %f %f %f %f %f %f %f';
dat=textscan(fid,fmt);
fclose(fid);
%Parse data
date=dat{1};
yr_met=str2num(date(:,1:4));
jul_met=str2num(date(:,5:7));
hr_met = str2num(date(:,8:9));
usaf_met= dat{2};
u_met = dat{6};
v_met = dat{7};
dir_met = 180*atan2(v_met,u_met) / pi;
dir_met = 270 - dir_met;
ifx=find(dir_met < 0);
dir_met(ifx)=dir_met(ifx) + 360;
clear ifx;
ifx2=find(dir_met >= 360);
dir_met(ifx2) = dir_met(ifx2) - 360;
clear ifx2;
spd_met = dat{8};
ifx=find(spd_met == 999.9);
spd_met(ifx)= NaN;
dir_met(ifx) = NaN;
clear date dat;
%
%  Now pull appropriate station and then plot up the wind speed, direction
%      times are equilivant for both sets.
%      Have place holder for the barometric pressure
%

pltfile=[yrinch,'_',julinch,'_',usaf2prC(1,:),'_',num2str(totcomp)];
AA={'.b-';'.r-';'.g-';'.k-';'ob-.';'or-.';'og-.';'ok-.';'xb:';'xr:';'xg:';...
    'xk:'};
clear titch2T; clear titch3T; clear titlT;
for k1=1:totcomp
    titch2(k1,:)=['St No. / St Name :  ',usaf2prC(k1,:),' / ',...
        stnid2prC(k1,:)];
end
titch1=['Comparison Met Stations from Metedit'];
titlT = [{titch1};{titch2(:,:)}];
xlabT = ['Month/Day in  ',yrinch];
%  Plot time series for each of the Met Stations
%

for k2=1:totcomp
    k21(:,k2)=strmatch(usaf2prC(k2,:),usaf_met(:,1:6),'exact');
end
mtime=datenum(yr_met(k21(:,1)),1,0) + jul_met(k21(:,1)) + hr_met(k21(:,1))/24;
minxx=floor(min(mtime));
maxxx=ceil(max(mtime));
xlimxx=[minxx, maxxx];

subplot(2,1,1)
hold on
for k3=1:totcomp
    H(k3)=plot(mtime,spd_met(k21(:,k3)),AA{k3});
end
xticks=get(gca,'XTick');
xx=datestr(xticks,6);
set(gca,'XTick',xticks,'XTicklabel',xx);
ylimyy=get(gca,'Ylim');
set(gca,'Ylim',ylimyy);
set(gca,'Xlim',xlimxx);
grid
ylabel('Wind Spd [m/s]');
title(titlT)

for k4=1:totcomp
    legtxt(k4,:)=['St:  ',usaf2prC(k4,1:6)];
end
hleg=legend(H,legtxt);
po=[0.825 0.875 0.08 0.03];
set(hleg,'position',po);
hold off
%
%  Wind Direction (Meteorological)
subplot(2,1,2)
hold on
for k5=1:totcomp
    plot(mtime,dir_met(k21(:,k5)),AA{k5});
end
xticks=get(gca,'XTick');
xx=datestr(xticks,6);
set(gca,'XTick',xticks,'XTicklabel',xx);
ylimmx=[0,360];
set(gca,'Ylim',ylimmx);
set(gca,'Xlim',xlimxx);
grid
ylabel('Wind Dir [\circ-MET]');
xlabel(xlabT);
hold off
eval(['print -dpng -r600 timplt_',pltfile]);
clf
%
%  Barometric Pressure (add in the Metedit results when ready)
%     subplot(3,1,3)
%     hold on
%     plot(mtime,barpprc(k21),'.b-')
%     xticks=get(gca,'XTick');
%     xx=datestr(xticks,6);
%     set(gca,'XTick',xticks,'XTicklabel',xx);
%     set(gca,'Xlim',xlimxx);
%     grid
%     ylabel('Sea Level Press [mb]');
%     xlabel(xlabT);
%     eval(['print -dpng -r600 timplt_',pltfile]);
%     clf