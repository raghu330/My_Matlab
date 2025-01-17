function get_WIS_ERIE(outfile)
%
%   get_WIS_EXP
%     grabs data from raid and start the WIS post processing
%     created TJ Hesser
% 
%   INPUT: 
%     outfile   STRING : directory listing for local location of files
%                       including year-mon
%                        i.e. /home/thesser1/GOM/model/1996-01
%                        i.e. C:\GOM\model\1996-01
% -------------------------------------------------------------------------
% subgrid identifier
subgrid = '';
year = outfile(end-6:end-3);
mon = outfile(end-1:end);
% identifies location of files on raid (Change for specific basin)
if isunix
    % linux listing for raid
   fdir = '/mnt/CHL_WIS_1/LAKE_ERIE/';
   get_file = [fdir,'/Production/Model/',year,'-',mon,'/'];
   get_ice  = [fdir,'ICE/',year,'/',year(3:4),mon,'/'];
   slash = '/';
else
    % Windows listing for raid
    fdir = 'X:\LAKE_ERIE\';
    get_file = [fdir,'Production\Model\',year,'-',mon,'\'];
    get_ice  = [fdir,'ICE\',year,'\',year(3:4),mon,'\'];
    slash = '\';
end
% creates local directory if not already made
if ~exist(outfile,'dir')
    mkdir(outfile);
end
% moves to local directory
cd(outfile);
% identies all sub grids for simulation (change these to match model
% output)
loc{1} = [outfile];

fillm = 1;
iceC = '000';

year = outfile(end-6:end-3);
mon = outfile(end-1:end);
% Loop through each subgrid to create Max-mean and time series plots
for zz = 1:length(loc)
    % creates subgrid directory if not already created
     if ~exist(loc{zz},'dir')
         mkdir(loc{zz});
     end
     % move to subgrid directory
    cd (loc{zz})
    % identify the sub grid identifier i.e. 3C1 after LEVEL (might need to
    % change subgrid identifier depending on file name)
    if ~exist(get_file,'dir')
       return
    end
    fice = dir([get_ice,'*.CUM']);
    if ~isempty(fice)
        copyfile([get_ice,'*.CUM'],'.');
        iceC = '70C';
    end
    copyfile([get_file,'*_MMd.tgz'],'.');
    copyfile([get_file,'*-STNS_ONLNS.tgz'],'.');
    % run ww3_read (change grid identifier to basin)
    wis_read('ERIE',year,mon,slash,fillm,'iceC',iceC)
    
end
% runs basin specific archiving 
archive_erie(year,mon);
%system(['rm -rf ',outfile]);
end
