function [] = comparisonBarPlots(dadata1,dadata2)
%Given a 2 matrices with rows as pH conditions data points as fraction of 
%time at a healthy state, this plots a comparison bar graph specific for 
%my experiments

% Define colors that match my other figures
plotColors = [0 114 178; 0 158 115]./255;

% Set figure properties 
figure
set(gcf,'Position',[0 0 560 240]);
hold on
xlim([-0.25 14.75]);
ylim([0 1])
xticks([0.5,2:6,7.5:1:12.5,14])
yticks([0 1])
xticklabels({'7.8','5.5','6.1','6.7','7.2','7.8',...
    '7.8','8.3','8.8','9.3','9.8','10.4','7.8'})
xlabel('pH')
ylabel('Fraction of Time with Normal Rhythm');
plot([6.75 6.75],[0 100],'k','LineWidth',1);
ax = gca;
ax.FontSize = 12;
ax.FontName = 'Arial';

% Plot Bars
p1 = bar([0.5,2:6,7.5:1:12.5,14]-0.1,dadata1,...
    'FaceColor',plotColors(1,:),'FaceAlpha',0.3,...
    'EdgeColor','k','BarWidth',0.6,'LineWidth',2);
p3 = bar([0.5,2:6,7.5:1:12.5,14]+0.1,dadata2,...
    'FaceColor','w','FaceAlpha',1,...
    'EdgeColor','w','BarWidth',0.6,'LineWidth',2);
p2 = bar([0.5,2:6,7.5:1:12.5,14]+0.1,dadata2,...
    'FaceColor',plotColors(2,:),'FaceAlpha',0.3,...
    'EdgeColor','k','BarWidth',0.6,'LineWidth',2);

end