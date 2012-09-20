% Floyd
% 8-28-2012
% Beyler_hood.m

close all
clear all

addpath('../../Validation/Beyler_Hood/Experimental_Data')
addpath('../../Validation/Beyler_Hood/FDS_Output_Files')

% load experimental data and FDS prediction
[exp_data] = csvread('Beyler_Hood_data_lr.csv',2);

Fuel{1} = 'acetone';

TestID(1,1)  = 117;
TestID(1,2)  = 119;
TestID(1,3)  = 122;
TestID(1,4)  = 142;
TestID(1,5)  = 145;

Fuel{2} = 'ethanol';

TestID(2,1)  = 106;
TestID(2,2)  = 107;
TestID(2,3)  = 108;
TestID(2,4)  = 110;
TestID(2,5)  = 115;

Fuel{3} = 'isopropanol';

TestID(3,1)  = 130;
TestID(3,2)  = 132;
TestID(3,3)  = 133;
TestID(3,4)  = 136;
TestID(3,5)  = 141;

Fuel{4} = 'methanol';

TestID(4,1)  = 942;
TestID(4,2)  = 943;
TestID(4,3)  = 945;
TestID(4,4)  = 947;
TestID(4,5)  = 951;

Fuel{5} = 'propane';

TestID(5,1)  = 232;
TestID(5,2)  = 257;
TestID(5,3)  = 287;
TestID(5,4)  = 303;
TestID(5,5)  = 307;
TestID(5,6)  = 318;
TestID(5,7)  = 322;
TestID(5,8)  = 334;
TestID(5,9)  = 355;
TestID(5,10) = 359;
TestID(5,11) = 371;
TestID(5,12) = 389;
TestID(5,13) = 429;
TestID(5,14) = 433;
TestID(5,15) = 445;

Fuel{6} = 'propylene';

TestID(6,1)  = 780;
TestID(6,2)  = 805;
TestID(6,3)  = 859;
TestID(6,4)  = 870;
TestID(6,5)  = 882;
TestID(6,6)  = 886;
TestID(6,7)  = 910;

Fuel{7} = 'toluene';

TestID(7,1)  = 160;
TestID(7,2)  = 162;
TestID(7,3)  = 165;
TestID(7,4)  = 166;
TestID(7,5)  = 170;

Species{1} = 'O$_2$';
Species{2} = 'CO$_2$';
Species{3} = 'H$_2$O';
Species{4} = 'CO';
Species{5} = 'UHC';
Species{6} = 'Soot';

SaveName{1} = 'O2';
SaveName{2} = 'CO2';
SaveName{3} = 'H2O';
SaveName{4} = 'CO';
SaveName{5} = 'UHC';
SaveName{6} = 'Soot';

NumPoints(1) = 5;
NumPoints(2) = 5;
NumPoints(3) = 5;
NumPoints(4) = 5;
NumPoints(5) = 15;
NumPoints(6) = 7;
NumPoints(7) = 5;

N_Fuels = 7;
N_Species = 6;

X_leg_pos = [0.55 0.3 0.2 0.2];
Y_leg_pos = [0.55 0.3 0.2 0.2];

% Color per fuel
color{1} = 'k';
color{2} = 'r';
color{3} = 'b';
color{4} = 'g';
color{5} = 'm';
color{6} = 'c';
color{7} = 'y';

% Marker per fuel
marker{1} = 'o';
marker{2} = 's';
marker{3} = 'd';
marker{4} = '^';
marker{5} = 'v';
marker{6} = '>';
marker{7} = '<';

MarkerSize = 7;
LineWidth = 1.5;

% Collect data

for f = 1:N_Fuels
   for s = 1:NumPoints(f)
      FDS_File = ['Beyler_Hood_' Fuel{f} '_' num2str(TestID(f,s)) '_lr_devc.csv'];
      [fds_data] = csvread(FDS_File,2);
      n_fds = size(fds_data,1);
      for ns = 1:N_Species
         ExpPlot(f,s,ns) = exp_data(s,(f-1)*N_Species+ns);
         FDSPlot(f,s,ns) = mean(fds_data(n_fds-60:n_fds,1+ns));
      end   
   end
end

for ns = 1:N_Species
   hf(ns)=figure(ns);
   %n = 0; 
   Xmax = max(max(FDSPlot(:,:,ns)));
   Xmax = max(max(max(ExpPlot(:,:,ns))),Xmax);
   Xmax = ceil(Xmax*10)/10;
   for f = 1:N_Fuels
      for s = 1:NumPoints(f)      
         XLegendStr{f} = [Fuel{f}];
         %n = n + 1;
         hX(f) = plot(ExpPlot(f,s,ns),FDSPlot(f,s,ns));
         set(hX(f),'Marker',marker{f},...
        'MarkerSize',MarkerSize,...
        'MarkerEdgeColor',color{f},...
        'MarkerFaceColor','none',...
        'LineWidth',LineWidth,...
        'LineStyle','none');
        hold on
      end
   end
   
xmin = 0;
ymin = 0;
xmax = Xmax;
ymax = xmax;
plot([xmin xmax],[ymin ymax],'k-')
axis([xmin xmax ymin ymax])

plot_style
set(gca,'Units',Plot_Units)
set(gca,'FontName',Font_Name)
set(gca,'Position',[Scat_Plot_X,Scat_Plot_Y,Scat_Plot_Width,Scat_Plot_Height])
set(hf(1),'DefaultLineLineWidth',Line_Width)
xtitle = ['Measured ' Species{ns} ' (volume fraction)'];
ytitle = ['Predicted ' Species{ns} ' (volume fraction)'];
xlabel(xtitle,'Interpreter',Font_Interpreter,'FontSize',Scat_Label_Font_Size)
ylabel(ytitle,'Interpreter',Font_Interpreter,'FontSize',Scat_Label_Font_Size)
legend(hX,XLegendStr,'Location','NorthWest')

% add SVN if file is available

svn_file = '../../Validation/Beyler_Hood/FDS_Output_Files/Beyler_Hood_acetone_117_lr_svn.txt';

if exist(svn_file,'file')
    SVN = importdata(svn_file);
    x_lim = get(gca,'XLim');
    y_lim = get(gca,'YLim');
    X_SVN_Position = x_lim(1)+SVN_Scale_X*(x_lim(2)-x_lim(1));
    Y_SVN_Position = y_lim(1)+SVN_Scale_Y*(y_lim(2)-y_lim(1));
    text(X_SVN_Position,Y_SVN_Position,['SVN ',num2str(SVN)], ...
        'FontSize',10,'FontName',Font_Name,'Interpreter',Font_Interpreter)
end

% print to pdf
set(gcf,'Visible',Figure_Visibility);
set(gcf,'PaperUnits',Paper_Units);
set(gcf,'PaperSize',[Scat_Paper_Width Scat_Paper_Height]);
set(gcf,'PaperPosition',[0 0 Scat_Paper_Width Scat_Paper_Height]);
plotname = ['../../Manuals/FDS_Validation_Guide/FIGURES/Beyler_Hood/Beyler_Hood_' SaveName{ns}];
print(gcf,'-dpdf',plotname);
   
clear hX

end


