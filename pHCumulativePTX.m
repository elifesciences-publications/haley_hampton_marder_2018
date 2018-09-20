% Code to analyze intracellular measures for 
% Figure 4 of Haley, Hampton, Marder (2018)

%% Load Data

directory = '/Volumes/HardDrive/903/';
experiments = {'903_046','903_048','903_050','903_052','903_054',...
    '903_056','903_058','903_060','903_064'};

for i = 1:length(experiments)
    data.(['prep_',experiments{i}]) = load([directory,experiments{i},'/data.mat']);
    order{i} = data.(['prep_',experiments{i}]).info.order;
end

%% Compute Means for 10s Bins

binWidth = 10; % bin size (s)
numBin = 60/binWidth; % number of bins
numPrep = length(experiments); % number of preps

measures = {'waveMin','waveFreq','spikeAmp','spikeFreq'};
times = {'waveTime','waveTime','spikeTime','spikeTime'};
units = {'PD','LP'};

for i = 1:numPrep
    prep = ['prep_',experiments{i}];
    
    if strcmp(order{i},'AB')
        sorted = [6:-1:1,6:12]; %order of conditions for AB protocol
    else
        sorted = [12:-1:7,1:7]; %order of conditions for BA protocol
    end
    
    for j = 1:length(sorted)
        condition = ['condition',num2str(sorted(j),'%02d')];
        
        for k = 1:length(units)
            
            for l = 1:length(measures)
                measure = measures{l};
                time = times{l};
                
                % grab time and measure data
                eventTime = data.(prep).(condition).(units{k}).(time);
                eventData = data.(prep).(condition).(units{k}).(measure);
                if length(eventData) < length(eventTime)
                    eventTime = eventTime(1:length(eventData));
                end
                
                % compute means for bins
                for m = 1:numBin
                    include = find(eventTime >= binWidth*(m-1) & eventTime < binWidth*m);
                    if ~isempty(include)
                        violin.([units{k},'_',measure])(numBin*(i-1)+m,j) = nanmean(eventData(include));
                    elseif isempty(include) && l == 1
                        violin.([units{k},'_',measure])(numBin*(i-1)+m,j) = ...
                            nanmean(data.(prep).(condition).(units{k}).minVm(binWidth*(m-1)+1:binWidth*m));
                    else
                        violin.([units{k},'_',measure])(numBin*(i-1)+m,j) = 0;
                    end
                end
            end
        end
    end
end

%% Make Violin Plots

measures = {'PD_waveMin','LP_waveMin','PD_spikeAmp','LP_spikeAmp',...
    'PD_waveFreq','LP_spikeFreq'};
limits = [-60,-20;-60,-20;0,30;0,12;0,9;0,20];
labels = {'PD Minimum V_m (mV)','LP Minimum V_m (mV)',...
    'PD Spike Amplitude (mV)','LP Spike Amplitude (mV)',...
    'PD Burst Frequency (Hz)','LP Firing Rate (Hz)'};

for i = 1:length(measures)
    violinPlots(violin.(measures{i}));
    set(gcf,'Position',[1420 175 500 300]);
    ylim(limits(i,:))
    ylabel(labels{i})
    ax = gca;
    text(ax.XLim(2)*0.9,ax.YLim(1)+diff(ax.YLim)*0.95,['n = ',num2str(numPrep)],...
        'VerticalAlignment','top','HorizontalAlignment','right','FontSize',12);
    ax.FontSize = 12;
    ax.FontName = 'Arial';
    set(gcf,'Renderer','painters')
    saveas(gcf,['/Volumes/HardDrive/Haley Hampton Marder 2018/Figures/Violin/',measures{i},'.pdf']);
end

%% Export csvs for statistical analysis in R

pH_vars = {'pH78_1' 'pH55' 'pH61' 'pH67' 'pH72' 'pH78_2' 'pH78_3' 'pH83'...
    'pH88' 'pH93' 'pH98' 'pH104' 'pH78_4'};
path = '/Volumes/HardDrive/Haley Hampton Marder 2018/Data/';

for i = 1:length(measures)
    for j = 1:numPrep
        output.(measures{i})(j,:) = mean(violin.(measures{i})(numBin*(j-1)+1:numBin*j,:));
    end
    writetable(array2table(output.(measures{i}),'VariableNames',pH_vars),[path,measures{i},'.csv']);
end



%% Save data

data.violin = violin;
save('/Volumes/HardDrive/Haley Hampton Marder 2018/Data Sets/intracellularData.mat','-struct','data');