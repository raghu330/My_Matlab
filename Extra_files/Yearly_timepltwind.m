function Yearly_timepltHGT(stnno,startdate,enddate)
%
%
%  Generation of Yearly (4 Panel Time plots Wave Heights)
%filein=['n',stnno,'_',startdate,'_',enddate];
filein = ['n',stnno,'_',startdate];
eval(['load  ',filein,'.ALL']);
eval(['A=',filein,';']);
eval(['clear ',filein,';']);

ddate=int2str(A(:,1));

long=A(1,10)-A(1,11)/60-A(1,12)/3600;
lat=A(1,7)+A(1,8)/60.+A(1,9)/3600;
%
%  Load in the Station File Containing the:
%       1.  Station Number
%       2.  Longitude (east)
%       3.  Latitude  (north)
%       4.  Water Depth (m)
%       5.  Overall 20-yr Max Wave Height (m)
%
% load Table_All_Stns.dat;
% stnG=Table_All_Stns(:,1);
% for ii=1:3
%     stnGC(ii,1:5)=int2str(stnG(ii));
% end
% dep=Table_All_Stns(:,8);
% HMAX=ceil(Table_All_Stns(:,9));
stnG = 45147;
stnumin=str2num(stnno(1:5));
stnproc=find(stnG == stnumin);
% DEP=dep(stnproc);
% MAXhgt=HMAX(stnproc);
DEP = 6.0;
MAXhgt = 2.0;
DATESTRT=str2num(startdate);
DATEEND =str2num(enddate);
totyrs=floor(DATEEND-DATESTRT)+ 1;
%
%  Generate the date for datvec
%
tim=datenum(A(:,2),A(:,3),A(:,4),A(:,5),A(:,6),A(:,7));
%
%
%rr = find(A(:,21) > 2.5);
hgt=A(:,15);
%hgt(rr) = 0.;
hmax=ceil(max(hgt));
%
%
%  Big loop to process all 20-years
%
STARTDTN=str2num(startdate)-1;
for ii=1:totyrs
    yearin=STARTDTN+ii;
    %  Set the Date Min and Max for the 4 Panels
    %
    dvecmin=[yearin,1,1,0,0,0];
    dvecmax=[yearin,4,1,0,0,0];
    minxx1=floor(min(datenum(dvecmin)));
    maxxx1=ceil(max(datenum(dvecmax)));
    %
    dvecmin=[yearin,4,1,0,0,0];
    dvecmax=[yearin,7,1,0,0,0];
    minxx2=floor(min(datenum(dvecmin)));
    maxxx2=ceil(max(datenum(dvecmax)));
    %
    dvecmin=[yearin,7,1,0,0,0];
    dvecmax=[yearin,10,1,0,0,0];
    minxx3=floor(min(datenum(dvecmin)));
    maxxx3=ceil(max(datenum(dvecmax)));
    %
    dvecmin=[yearin,10,1,0,0,0];
    dvecmax=[yearin+1,1,1,0,0,0];
    minxx4=floor(min(datenum(dvecmin)));
    maxxx4=ceil(max(datenum(dvecmax)));
    %
    %  Generate the times and wave heights contained from minxx1 to maxxx4
    %    This should be the one year interval to plot.
    %
    plttmyr=find(A(:,2) == yearin);
    tim2plt=tim(plttmyr);
    hgt2plt=hgt(plttmyr);
    
    %
    tchar1=['Lake St. Clair FEMA  YEAR:  ',int2str(yearin)];
    tchar2=['NDBC:  ',stnno];
    tchar3=['Long / Lat:  ',num2str(long),'\circ / ',num2str(lat),'\circ',...
        '  Dep:  ',num2str(DEP),' [m]'];
    tcharT=[{tchar1};{tchar2};{tchar3}];
    %
    %  Four Panel Plot oriented landscape
    %
    orient('Tall')
    subplot(4,1,1)
    if floor(tim2plt(1))  >= minxx1 & ceil(tim2plt(1)) <= maxxx1
        plttm=find(tim2plt >= minxx1 & tim2plt <= maxxx1);
        H=plot(tim2plt(plttm),hgt2plt(plttm),'b','LineWidth',2);
        xtcks=[minxx1:10:maxxx1];
        xlimxx=[minxx1,maxxx1];
        set(gca,'XTick',xtcks,'Xlim',xlimxx);
        set(gca,'XTick',xtcks,'Xlim',xlimxx,'XTickLabel',datestr(xtcks,'mm/dd'));
        ylimmx=[0,ceil(hmax)];
        set(gca,'Ylim',ylimmx);
        grid
        ylabel('H_{mo} [m]');
    else
        xtcks=[minxx1:10:maxxx1];
        xlimxx=[minxx1,maxxx1];
        set(gca,'XTick',xtcks,'Xlim',xlimxx);
        set(gca,'XTick',xtcks,'Xlim',xlimxx,'XTickLabel',datestr(xtcks,'mm/dd'));
        ylimmx=[0,ceil(hmax)];
        set(gca,'Ylim',ylimmx);
        grid
        ylabel('H_{mo} [m]');
        text(xtcks(5),0.5*hmax,'Not Deployed','Color',[1,0,0])
    end
    title(tcharT);
    %
    subplot(4,1,2)
    clear plttm;
%    if floor(tim2plt(1)) >= minxx2 & tim2plt(1) <= maxxx2
        plttm=find(tim2plt >= minxx2 & tim2plt <= maxxx2);
        plot(tim2plt(plttm),hgt2plt(plttm),'b','LineWidth',2);
        xtcks=[minxx2:10:maxxx2];
        xlimxx=[minxx2,maxxx2];
        set(gca,'XTick',xtcks,'Xlim',xlimxx);
        set(gca,'XTick',xtcks,'Xlim',xlimxx,'XTickLabel',datestr(xtcks,'mm/dd'));
        ylimmx=[0,ceil(hmax)];
        set(gca,'Ylim',ylimmx);
        grid
        ylabel('H_{mo} [m]');
%     else
%         xtcks=[minxx2:10:maxxx2];
%         xlimxx=[minxx2,maxxx2];
%         set(gca,'XTick',xtcks,'Xlim',xlimxx);
%         set(gca,'XTick',xtcks,'Xlim',xlimxx,'XTickLabel',datestr(xtcks,'mm/dd'));
%         ylimmx=[0,hmax];
%         set(gca,'Ylim',ylimmx);
%         grid
%         ylabel('H_{mo} [m]');
%         text(xtcks(5),0.5*hmax,'Not Deployed','Color',[1,0,0])
%     end
    %
    subplot(4,1,3)
    clear plttm;
%    if floor(tim2plt(1)) >= minxx3 & tim2plt(1) <= maxxx3
        plttm=find(tim2plt >= minxx3 & tim2plt <= maxxx3);
        plot(tim2plt(plttm),hgt2plt(plttm),'b','LineWidth',2);
        xtcks=[minxx3:10:maxxx3];
        xlimxx=[minxx3,maxxx3];
        set(gca,'XTick',xtcks,'Xlim',xlimxx);
        set(gca,'XTick',xtcks,'Xlim',xlimxx,'XTickLabel',datestr(xtcks,'mm/dd'));
        ylimmx=[0,ceil(hmax)];
        set(gca,'Ylim',ylimmx);
        grid
        ylabel('H_{mo} [m]');
%     else
%         xtcks=[minxx3:10:maxxx3];
%         xlimxx=[minxx3,maxxx3];
%         set(gca,'XTick',xtcks,'Xlim',xlimxx);
%         set(gca,'XTick',xtcks,'Xlim',xlimxx,'XTickLabel',datestr(xtcks,'mm/dd'));
%         ylimmx=[0,hmax];
%         set(gca,'Ylim',ylimmx);
%         grid
%         ylabel('H_{mo} [m]');
%         text(xtcks(5),0.5*hmax,'Not Deployed','Color',[1,0,0])
%     end
    %
    subplot(4,1,4)
    clear pltmm;
%    if floor(tim2plt(1)) >= minxx4 & tim2plt(1) <= maxxx4
        plttm=find(tim2plt >= minxx4 & tim2plt <= maxxx4);
        plot(tim2plt(plttm),hgt2plt(plttm),'b','LineWidth',2);
        xtcks=[minxx4:10:maxxx4];
        xlimxx=[minxx4,maxxx4];
        set(gca,'XTick',xtcks,'Xlim',xlimxx);
        set(gca,'XTick',xtcks,'Xlim',xlimxx,'XTickLabel',datestr(xtcks,'mm/dd'));
        ylimmx=[0,hmax];
        set(gca,'Ylim',ylimmx);
        grid
        ylabel('H_{mo} [m]');
%     else
%         xtcks=[minxx4:10:maxxx4];
%         xlimxx=[minxx4,maxxx4];
%         set(gca,'XTick',xtcks,'Xlim',xlimxx);
%         set(gca,'XTick',xtcks,'Xlim',xlimxx,'XTickLabel',datestr(xtcks,'mm/dd'));
%         ylimmx=[0,hmax];
%         set(gca,'Ylim',ylimmx);
%         grid
%         ylabel('H_{mo} [m]');
%         text(xtcks(5),0.5*hmax,'Not Deployed','Color',[1,0,0])
%     end
    xlabch=['Days in  ',int2str(yearin)];
    xlabel(xlabch);
    eval(['print -dpng -r600 Time-plt-wind_',stnno,'_',int2str(yearin)]);
    clf
    clear tim2plt; clear hgt2plt;
    
end

