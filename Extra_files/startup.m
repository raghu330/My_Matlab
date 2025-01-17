% startup file 

% Set up some default fonts and sizes for plotting
 
set(0,'DefaultTextFontSize',10);
set(0,'DefaultAxesFontSize',10);
set(0,'DefaultAxesFontname','arial');
set(0,'DefaultTextFontname','arial');
set(0,'DefaultAxesBox','off');



% Set any local user paths
%   such as your home Matlab directory)
%dplocal = '/net/massey/export/data/blue/disk1/massey/My_Matlab/';
dplocal = '/home/thesser1/My_Matlab/';
path(path,[dplocal,'m_map']);
path(path,[dplocal,'WAM_proc']);
path(path,[dplocal,'WW3_proc']);
path(path,[dplocal,'Wis_plot']);
path(path,[dplocal,'Wis_plot/GOM']);
path(path,[dplocal,'Wis_plot/PAC']);
path(path,[dplocal,'Wis_plot/ATL']);
path(path,dplocal);

cd(dplocal);
clear dplocal
