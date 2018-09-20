function [ f1, f2 ] = rectanglePlots(dadata)
%Given a 2D matrix with columns as pH conditions and rows as preps
%this plots rectangles with saturation giving fraction

% Define colors that match my other figures
plotColors = [0 114 178; 0 158 115]./255;

% Create Colormap
f1 = figure;
set(gcf,'Position',[0 0 80 240]);
steps = 0:1/100:1;
for j = 1:2
    subplot(1,2,j)
    hold on
    for i = 1:length(steps)
        patch([0 0 1 1],[i-1 i i i-1],plotColors(j,:),...
            'FaceAlpha',steps(i),'EdgeAlpha',0);
    end
    patch([0 0 1 1],[0 length(steps) length(steps) 0],'w',...
        'FaceAlpha',0,'LineWidth',2);
    xlim([0 1])
    ylim([0 length(steps)])
    set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[])
end

% Set figure properties 
f2 = figure;
set(gcf,'Position',[0 0 560 240]);

% Plot Rectangles
for j = 1:size(dadata,2)
    subplot(6,1,j)
    hold on
    if j < 4
        color = plotColors(1,:);
    else
        color = plotColors(2,:);
    end
    for i = 1:size(dadata,1)
        patch([i i+1 i+1 i],[j j j+1 j+1],color,'FaceAlpha',dadata(i,j),...
            'LineWidth',2);
    end
    xlim([1 size(dadata,1)+1])
    set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[])
end

end