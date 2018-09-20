% Code to analyze extracellular measures for 
% Figures 2-3,6-8 of Haley, Hampton, Marder (2018)

%% Load Data

clear
close all

directory = '/Volumes/HardDrive/';
ganglia = {'STG','CG'};
exp.STG = {'877_093','877_101','877_121','877_127','877_141','887_005',...
    '887_049','887_069','887_097','887_105','887_137','887_141',...
    '887_145','897_005','897_037'};
units.STG = 'PD';
exp.CG = {'877_149','877_149','887_005','887_011','887_017','887_061',...
    '887_065','887_073','887_093','887_127','887_149','887_149',...
    '897_041','897_041','897_041'};
units.CG = {'CG1L','CG2L','CG2L','CG3L','CG3L','CG1L',...
    'CG2L','CG2L','CG2L','CG1L','CG1L','CG2L',...
    'CG1L','CG3L','CG7L'};

for i = 1:length(ganglia)
    ganglion = ganglia{i};
    for j = 1:length(exp.(ganglion))
        experimentName = exp.(ganglion){j};
        notebook = experimentName(1:3);
        data.(ganglion).(['prep_',experimentName]) = ...
            load([directory,notebook,'/',experimentName,'/Spike2 Analysis/data.mat']);
        order.(ganglion){j,1} = data.(ganglion).(['prep_',experimentName]).info.order;
    end
    numPrep.(ganglion) = length(exp.(ganglion)); % number of preps
end

%% Compute Means for 10s Bins of last 8 mins

binWidth = 10; % bin size (s)
window = 8*60; % window for analysis (s)
numBin = window/binWidth; % number of bins

measures = {'hz','spikes','duty'};

for g = 1:length(ganglia)
    ganglion = ganglia{g};
    
    for i = 1:numPrep.(ganglion)
        prep = ['prep_',exp.(ganglion){i}];
        
        if strcmp(order.(ganglion){i},'AB')
            sorted = [6:-1:1,6:12]; %order of conditions for AB protocol
        else
            sorted = [12:-1:7,1:7]; %order of conditions for BA protocol
        end
        
        for j = 1:length(sorted)
            condition = ['condition',num2str(sorted(j),'%02d')];
            fileName = data.(ganglion).(prep).(condition).fileName;
            f = find(strcmp(data.(ganglion).(prep).info.fileOrder,fileName));
            
            for k = 1:length(units)
                if g == 1
                    unit = units.STG;
                else
                    unit = units.CG{i};
                end
                
                if isfield(data.(ganglion).(prep).(condition).(unit),'state')
                    stateData = data.(ganglion).(prep).(condition).(unit).state;
                    state.(ganglion)(window*(i-1)+1:window*i,j) = stateData(end-window+1:end);
                else
                    state.(ganglion)(window*(i-1)+1:window*i,j) = NaN;
                end
                
                for l = 1:length(measures)
                    measure = measures{l};
                    
                    % grab time and measure data
                    eventTime = data.(ganglion).(prep).(condition).(unit).tstart;
                    eventData = data.(ganglion).(prep).(condition).(unit).(measure);
                    start = min(find(eventTime > data.(ganglion).(prep).info.fileLength(f) - ...
                        data.(ganglion).(prep).info.sampleFreq*window)); % last 8 minutes only
                    eventTime = eventTime(start:end);
                    eventTime = eventTime - min(eventTime);
                    eventData = eventData(start:end);
                    
                    % compute means for bins
                    for m = 1:numBin
                        include = find(eventTime >= binWidth*(m-1) & eventTime < binWidth*m);
                        if ~isempty(include)
                            violin.([ganglion,'_',measure])(numBin*(i-1)+m,j) = ...
                                nanmean(eventData(include));
                        end
                        if isempty(include) || isnan(nanmean(eventData(include)))
                            violin.([ganglion,'_',measure])(numBin*(i-1)+m,j) = 0;
                        end
                    end
                    if strcmp(condition,'condition01')
                        control.([ganglion,'_',measure])(:,i) = ...
                            violin.([ganglion,'_',measure])(numBin*(i-1)+[1:numBin],j);
                    end
                end
            end
        end
    end
end

% Sort control data by increasing frequency
measures = {'STG_hz','STG_spikes','STG_duty',...
    'CG_hz','CG_spikes','CG_duty'};
[sortSTG,orderSTG] = sortrows(mean(control.STG_hz)');
[sortCG,orderCG] = sortrows(mean(control.CG_hz)');
for i = 1:length(measures)
    if i < 4
        control.(measures{i}) = control.(measures{i})(:,orderSTG);
    else
        control.(measures{i}) = control.(measures{i})(:,orderCG);
    end
end

% Fix STG states that are 8.x (this indicated gastric rhythm)
fix = find(state.STG > 8);
state.STG(fix) = uint8(10*(state.STG(fix)-8));

% Accumulate state data
for g = 1:length(ganglia)
    ganglion = ganglia{g};
    states = unique(state.(ganglion)(~isnan(state.(ganglion))));
    
    % Mean fraction of time in each state
    for i = 1:length(states)
        thisState = state.(ganglion) == states(i);
        thisSum(:,i) = sum(thisState)';
        for j = 1:length(exp.(ganglion))
            thisData = thisState(window*(j-1)+1:window*j,:);
            thisPrep(:,i,j) = sum(thisData)';
        end
    end
    state.([ganglion,'_sum']) = thisSum./sum(thisSum,2);
    state.([ganglion,'_prep']) = thisPrep./window;
    
    % Mean fraction of time rhythmic
    if g == 1
        state.([ganglion,'_health'])(:,1) = ...
            sum(state.([ganglion,'_sum'])(:,1:2),2);
        state.([ganglion,'_prepHealth'])(:,:) = ...
            squeeze(sum(state.([ganglion,'_prep'])(:,1:2,:),2))';
    else
        state.([ganglion,'_health'])(:,1) = ...
            sum(state.([ganglion,'_sum'])(:,1),2);
        state.([ganglion,'_prepHealth'])(:,:) = ...
            squeeze(state.([ganglion,'_prep'])(:,1,:))';
    end
end

%% Figure 3 and 7 - Make Violin Plots for Pooled Data

measures = {'STG_hz','STG_spikes','STG_duty',...
    'CG_hz','CG_spikes','CG_duty'};

limits = [0,5;0,12;0,0.4;0,1;0,25;0,0.4];
labels = {'Pyloric Frequency (Hz)','# PD Spikes per Burst',...
    'PD Duty Cycle','Cardiac Frequency (Hz)',...
    '# LC Spikes per Burst','LC Duty Cycle'};

for i = 1:length(measures)
    numPrep = size(violin.(measures{i}),1)/numBin;
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

%% Figure 2 and 6 - Make Violin Plots for Example Preps

STG_1 = '897_037';
CG_1 = {'877_149','CG2L'};

STG_1 = find(strcmp(exp.STG,STG_1));
CG_1 = find(strcmp(exp.CG,CG_1(1)) & strcmp(units.CG,CG_1(2)));

measures = {'STG_hz','STG_spikes','STG_duty',...
    'CG_hz','CG_spikes','CG_duty'};
saveMeas = {'STG1_hz','STG1_spikes','STG1_duty',...
    'CG1_hz','CG1_spikes','CG1_duty'};

limits = [1,1.8;1.5,4.5;0.15,0.3;0.1,0.25;0,25;0.05,0.35];
labels = {'Pyloric Frequency (Hz)','# PD Spikes per Burst',...
    'PD Duty Cycle','Cardiac Frequency (Hz)',...
    '# LC Spikes per Burst','LC Duty Cycle'};

for i = 1:length(measures)
    if i < 4
        thisPrep = [1:numBin]+numBin*(STG_1-1);
    else
        thisPrep = [1:numBin]+numBin*(CG_1-1);
    end
    violinPlots(violin.(measures{i})(thisPrep,:));
    set(gcf,'Position',[1420 175 500 300]);
    ylim(limits(i,:))
    ylabel(labels{i})
    ax = gca;
    ax.FontSize = 12;
    ax.FontName = 'Arial';
    set(gcf,'Renderer','painters')
    saveas(gcf,['/Volumes/HardDrive/Haley Hampton Marder 2018/Figures/Violin/',saveMeas{i},'.pdf']);
end

%% Supplements for Figures 3 and 7 - Make Violin Plots for Preps at Control

measures = {'STG_hz','STG_spikes','STG_duty',...
    'CG_hz','CG_spikes','CG_duty'};
limits = [0.6,2;0,12;0.1,0.35;0,1;0,12;0,0.35];
labels = {'Pyloric Frequency (Hz)','# PD Spikes per Burst',...
    'PD Duty Cycle','Cardiac Frequency (Hz)',...
    '# LC Spikes per Burst','LC Duty Cycle'};

for i = 1:length(measures)
    violinPlotsControl(control.(measures{i}));
    set(gcf,'Position',[1420 175 500 300]);
    ylim(limits(i,:))
    ylabel(labels{i})
    ax = gca;
    ax.FontSize = 12;
    ax.FontName = 'Arial';
    set(gcf,'Renderer','painters')
    saveas(gcf,['/Volumes/HardDrive/Haley Hampton Marder 2018/Figures/Violin/',measures{i},'_ctl.pdf']);
end

%% Figure 3 and 7 - Make Stacked Bar Graphs for STG and CG State Analysis

stackedBarPlots(state.STG_sum);
saveas(gcf,['/Volumes/HardDrive/Haley Hampton Marder 2018/Figures/Violin/STG_states.pdf']);
stackedBarPlots(state.CG_sum);
saveas(gcf,['/Volumes/HardDrive/Haley Hampton Marder 2018/Figures/Violin/CG_states.pdf']);

%% Figure 8 - Make Bar Graphs for Comparison of STG and CG Rhythmicity

comparisonBarPlots(state.STG_health,state.CG_health);
saveas(gcf,['/Volumes/HardDrive/Haley Hampton Marder 2018/Figures/Violin/STG_CG_states.pdf']);

[f1,f2] = rectanglePlots([state.STG_prepHealth(:,[2,1,12]),state.CG_prepHealth(:,[2,6,12])]);
saveas(f1,['/Volumes/HardDrive/Haley Hampton Marder 2018/Figures/Violin/STG_CG_colormap.pdf']);
saveas(f2,['/Volumes/HardDrive/Haley Hampton Marder 2018/Figures/Violin/STG_CG_rectangle.pdf']);

%% Export csvs for statistical analysis in R

pH_vars = {'pH78_1' 'pH55' 'pH61' 'pH67' 'pH72' 'pH78_2' 'pH78_3' 'pH83'...
    'pH88' 'pH93' 'pH98' 'pH104' 'pH78_4'};
path = '/Volumes/HardDrive/Haley Hampton Marder 2018/Data/';

for i = 1:length(measures)
    for j = 1:15
        output.(measures{i})(j,:) = mean(violin.(measures{i})(numBin*(j-1)+1:numBin*j,:));
    end
    writetable(array2table(output.(measures{i}),'VariableNames',pH_vars),[path,measures{i},'.csv']);
end

state.STG_CG_health = [repmat({'STG'},length(exp.STG),1),num2cell(state.STG_prepHealth);...
    repmat({'CG'},length(exp.CG),1),num2cell(state.CG_prepHealth)];
writetable(array2table(state.STG_prepHealth,'VariableNames',pH_vars),[path,'STG_states.csv']);
writetable(array2table(state.CG_prepHealth,'VariableNames',pH_vars),[path,'CG_states.csv']);
writetable(array2table(state.STG_CG_health,'VariableNames',['Ganglion',pH_vars]),[path,'STG_CG_states.csv']);

%% Save data

data.violin = violin;
data.control = control;
data.state = state;
save('/Volumes/HardDrive/Haley Hampton Marder 2018/Data Sets/extracellularData.mat','-struct','data');