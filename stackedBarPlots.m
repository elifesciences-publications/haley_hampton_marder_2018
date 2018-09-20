function [] = stackedBarPlots(dadata)
%Given a 2D matrix with rows as pH conditions and columns as fraction of 
%time at a particular state, this plots stacked bar graphs specific for 
% my experiments

% Define colors that match my other figures
if size(dadata,2) == 5
    plotColors = [213 94 0; 0 158 115; 0 114 178; 255 255 255; 0 0 0]./255;
else
    plotColors = [213 94 0; 0 114 178; 255 255 255; 0 0 0]./255;
end

% Set figure properties 
figure
set(gcf,'Position',[0 0 560 240]);
hold on
xlim([0 14.5]);
ylim([0 1])
xticks([0.5,2:6,7.5:1:12.5,14])
yticks([0 1])
xticklabels({'7.8','5.5','6.1','6.7','7.2','7.8',...
    '7.8','8.3','8.8','9.3','9.8','10.4','7.8'})
xlabel('pH')
ylabel('Fraction of Time in State');
plot([6.75 6.75],[0 100],'k','LineWidth',1);
ax = gca;
ax.FontSize = 12;
ax.FontName = 'Arial';

% Plot Stacked Bars
p = bar([0.5,2:6,7.5:1:12.5,14],dadata,'stacked');
for i = 1:length(p)
    set(p(i),'FaceColor',plotColors(i,:),'EdgeColor','k',...
        'FaceAlpha',0.3,'LineWidth',2);
end

end