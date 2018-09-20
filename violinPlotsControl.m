function [] = violinPlotsControl(dadata)
%Given a 2D matrix with columns as pH conditions and rows as data points of
%equal weight, this plots violin plots specific for my experiments

% Number of preps conditions (should be 15)
n = size(dadata,2);

% Determine width of violin plots based on max KDE for all conditions
for i = 1:n
    bw = max(abs(dadata(:,i)))/20;
    [density,value] = ksdensity(dadata(:,i),'BandWidth',bw);
    densityMax(i) = max(density);
    valueMax(i) = max(value);
    valueMin(i) = min(value);
end
[densityMaxMax,i] = max(densityMax);
density2Max = densityMax; density2Max(i) = [];
width = 0.43./densityMax;
limits = [min(valueMin) max(valueMax)];

% Make Figure and add gray patches for recovery and line to separate ramps
figure
hold on
xlim([0.5 15.5])
ylim([limits])
xticks([1:15])
xlabel('Preparation #')

for i = 1:n
    % Extract data for that condition
    thisdata = dadata(:,i);
    
    % Calculate kernel density estimation for the violin
    bw = max(abs(dadata(:,i)))/20;
    [density, value] = ksdensity(thisdata,'BandWidth',bw);
    density = density(value >= min(thisdata) & value <= max(thisdata));
    value = value(value >= min(thisdata) & value <= max(thisdata));
    value(1) = min(thisdata); value(end) = max(thisdata);
    if min(thisdata) == max(thisdata) % if all data is identical
        density = 1;
    end

    % Plot Violins of KDEs
    fill([i+density*width(i) i-density(end:-1:1)*width(i)], ...
        [value value(end:-1:1)], 'k',...
        'FaceAlpha',0.3,'EdgeColor','k','EdgeAlpha',1,'LineWidth',1);
    
    % Plot Mean of data
    meanValue = mean(thisdata);
    if length(density) > 1
        meanDensity = interp1(value, density, meanValue);
    else % all data is identical:
        meanDensity = density;
    end
    plot([i-meanDensity*width(i) i+meanDensity*width(i)],...
        [meanValue meanValue],'k','LineWidth',3);
    
    % Plot Quartiles (25%,75%)
    quartiles = quantile(thisdata, [0.25, 0.5, 0.75]);
    fill([i-0.03 i+0.03 i+0.03 i-0.03], ...
        [quartiles(1) quartiles(1) quartiles(3) quartiles(3)],'k');
    
    % Plot Quartiles +/- Interquartile Range
    IQR = quartiles(3) - quartiles(1);
    lowhisker = quartiles(1) - 1.5*IQR;
    lowhisker = max(lowhisker, min(thisdata(thisdata > lowhisker)));
    hiwhisker = quartiles(3) + 1.5*IQR;
    hiwhisker = min(hiwhisker, max(thisdata(thisdata < hiwhisker)));
    if ~isempty(lowhisker) && ~isempty(hiwhisker)
       plot([i i], [lowhisker hiwhisker],'k','LineWidth',1);
    end
    
    % Plot Median
    scatter(i, quartiles(2),'w','Filled','MarkerEdgeColor','k','LineWidth',1.5);
    
end
end