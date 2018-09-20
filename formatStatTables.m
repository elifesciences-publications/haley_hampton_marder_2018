%% Directory

directory = '/Volumes/HardDrive/Haley Hampton Marder 2018/Statistics';
dirSave = '/Volumes/HardDrive/Haley Hampton Marder 2018/Figures/Statistics';
dirANOVA = [directory,'/ANOVAs/'];
dirTtest = [directory,'/T_Tests/'];

%% Figure 3-figure supplement 1

measures = {'STG_states','STG_hz','STG_spikes','STG_duty'};

panel = {'C','D','E','F'};
labels = {'Time Rhythmic','Pyloric Freq','PD Spikes/Burst','PD Duty Cycle'};
vars = {'Measure','','Acid','','Base','','pH 5.5','','pH 6.1','','pH 6.7',...
    '','pH 7.2','','pH 8.3','','pH 8.8','','pH 9.3','','pH 9.8','','pH 10.4'};

fig3 = cell(length(measures),23);

for i = 1:length(measures)
    anova = csvread([dirANOVA,measures{i},'.csv'],1,1);
    ttest = csvread([dirTtest,measures{i},'.csv'],1,1);
    
    fig3{i,1} = [panel{i},' - ',labels{i}];
    if anova(1,4) >= 0.0001
        fig3{i,3} = ['F(',num2str(anova(1,1)),',',num2str(anova(1,2)),') = ',...
            num2str(anova(1,3),'%.3f'),', p = ',num2str(anova(1,4),'%.4f')];
    else
        fig3{i,3} = ['F(',num2str(anova(1,1)),',',num2str(anova(1,2)),') = ',...
            num2str(anova(1,3),'%.3f'),', p < 0.0001'];
    end
    if anova(2,4) >= 0.0001
        fig3{i,5} = ['F(',num2str(anova(2,1)),',',num2str(anova(2,2)),') = ',...
            num2str(anova(2,3),'%.3f'),', p = ',num2str(anova(2,4),'%.4f')];
    else
        fig3{i,5} = ['F(',num2str(anova(2,1)),',',num2str(anova(2,2)),') = ',...
            num2str(anova(2,3),'%.3f'),', p < 0.0001'];
    end
    
    for j = 1:9
        if ttest(j,2) >= 0.0001
            fig3{i,2*j+5} = ['t(14) = ',...
                num2str(ttest(j,1),'%.3f'),', p = ',num2str(ttest(j,2),'%.4f')];
        else
            fig3{i,2*j+5} = ['t(14) = ',...
                num2str(ttest(j,1),'%.3f'),', p < 0.0001'];
        end
    end
end

fig3 = cell2table([vars;fig3]);

writetable(fig3,[dirSave,'/Figure 3.csv'])

%% Figure 4-figure supplement 1

measures = {'PD_waveMin','LP_waveMin','PD_spikeAmp','LP_spikeAmp',...
    'PD_waveFreq','LP_spikeFreq'};
panel = {'B','C','D','E','F','G'};
labels = {'PD Min Vm','LP Min Vm','PD Spike Amp','LP Spike Amp',...
    'PD Burst Freq','LP Firing Rate'};
vars = {'Measure','','Acid','','Base','','pH 5.5','','pH 6.1','','pH 6.7',...
    '','pH 7.2','','pH 8.3','','pH 8.8','','pH 9.3','','pH 9.8','','pH 10.4'};

fig4 = cell(length(measures),23);

for i = 1:length(measures)
    anova = csvread([dirANOVA,measures{i},'.csv'],1,1);
    ttest = csvread([dirTtest,measures{i},'.csv'],1,1);
    
    fig4{i,1} = [panel{i},' - ',labels{i}];
    if anova(1,4) >= 0.0001
        fig4{i,3} = ['F(',num2str(anova(1,1)),',',num2str(anova(1,2)),') = ',...
            num2str(anova(1,3),'%.3f'),', p = ',num2str(anova(1,4),'%.4f')];
    else
        fig4{i,3} = ['F(',num2str(anova(1,1)),',',num2str(anova(1,2)),') = ',...
            num2str(anova(1,3),'%.3f'),', p < 0.0001'];
    end
    if anova(2,4) >= 0.0001
        fig4{i,5} = ['F(',num2str(anova(2,1)),',',num2str(anova(2,2)),') = ',...
            num2str(anova(2,3),'%.3f'),', p = ',num2str(anova(2,4),'%.4f')];
    else
        fig4{i,5} = ['F(',num2str(anova(2,1)),',',num2str(anova(2,2)),') = ',...
            num2str(anova(2,3),'%.3f'),', p < 0.0001'];
    end
    
    for j = 1:9
        if ttest(j,2) >= 0.0001
            fig4{i,2*j+5} = ['t(14) = ',...
                num2str(ttest(j,1),'%.3f'),', p = ',num2str(ttest(j,2),'%.4f')];
        else
            fig4{i,2*j+5} = ['t(14) = ',...
                num2str(ttest(j,1),'%.3f'),', p < 0.0001'];
        end
    end
end

fig4 = cell2table([vars;fig4]);

writetable(fig4,[dirSave,'/Figure 4.csv'])

%% Figure 7-figure supplement 1

measures = {'CG_states','CG_hz','CG_spikes','CG_duty'};

panel = {'C','D','E','F'};
labels = {'Time Rhythmic','Cardiac Freq','LC Spikes/Burst','LC Duty Cycle'};
vars = {'Measure','','Acid','','Base','','pH 5.5','','pH 6.1','','pH 6.7',...
    '','pH 7.2','','pH 8.3','','pH 8.8','','pH 9.3','','pH 9.8','','pH 10.4'};

fig7 = cell(length(measures),23);

for i = 1:length(measures)
    anova = csvread([dirANOVA,measures{i},'.csv'],1,1);
    ttest = csvread([dirTtest,measures{i},'.csv'],1,1);
    
    fig7{i,1} = [panel{i},' - ',labels{i}];
    if anova(1,4) >= 0.0001
        fig7{i,3} = ['F(',num2str(anova(1,1)),',',num2str(anova(1,2)),') = ',...
            num2str(anova(1,3),'%.3f'),', p = ',num2str(anova(1,4),'%.4f')];
    else
        fig7{i,3} = ['F(',num2str(anova(1,1)),',',num2str(anova(1,2)),') = ',...
            num2str(anova(1,3),'%.3f'),', p < 0.0001'];
    end
    if anova(2,4) >= 0.0001
        fig7{i,5} = ['F(',num2str(anova(2,1)),',',num2str(anova(2,2)),') = ',...
            num2str(anova(2,3),'%.3f'),', p = ',num2str(anova(2,4),'%.4f')];
    else
        fig7{i,5} = ['F(',num2str(anova(2,1)),',',num2str(anova(2,2)),') = ',...
            num2str(anova(2,3),'%.3f'),', p < 0.0001'];
    end
    
    for j = 1:9
        if ttest(j,2) >= 0.0001
            fig7{i,2*j+5} = ['t(14) = ',...
                num2str(ttest(j,1),'%.3f'),', p = ',num2str(ttest(j,2),'%.4f')];
        else
            fig7{i,2*j+5} = ['t(14) = ',...
                num2str(ttest(j,1),'%.3f'),', p < 0.0001'];
        end
    end
end

fig7 = cell2table([vars;fig7]);

writetable(fig7,[dirSave,'/Figure 7.csv'])

%% Figure 8-figure supplement 1

measures = {'STG_CG_states'};

labels = {'Ganglion','pH','Ganglion x pH'};
vars = {'Effect','','Acid','','Base','','pH 5.5','','pH 6.1','','pH 6.7',...
    '','pH 7.2','','pH 8.3','','pH 8.8','','pH 9.3','','pH 9.8','','pH 10.4'};

anova = csvread([dirANOVA,measures{1},'.csv'],1,1);
ttest = csvread([dirTtest,measures{1},'.csv'],1,1);

fig8 = cell(length(labels),23);

for i = 1:length(labels)
    fig8{i,1} = [labels{i}];
    if anova(i,4) >= 0.0001
        fig8{i,3} = ['F(',num2str(anova(i,1)),',',num2str(anova(i,2)),') = ',...
            num2str(anova(i,3),'%.3f'),', p = ',num2str(anova(i,4),'%.4f')];
    else
        fig8{i,3} = ['F(',num2str(anova(i,1)),',',num2str(anova(i,2)),') = ',...
            num2str(anova(i,3),'%.3f'),', p < 0.0001'];
    end
    if anova(i+3,4) >= 0.0001
        fig8{i,5} = ['F(',num2str(anova(i+3,1)),',',num2str(anova(i+3,2)),') = ',...
            num2str(anova(i+3,3),'%.3f'),', p = ',num2str(anova(i+3,4),'%.4f')];
    else
        fig8{i,5} = ['F(',num2str(anova(i+3,1)),',',num2str(anova(i+3,2)),') = ',...
            num2str(anova(i+3,3),'%.3f'),', p < 0.0001'];
    end
end

for j = 1:9
    if ttest(j,2) >= 0.0001
        fig8{1,2*j+5} = ['t(14) = ',...
            num2str(ttest(j,1),'%.3f'),', p = ',num2str(ttest(j,2),'%.4f')];
    else
        fig8{1,2*j+5} = ['t(14) = ',...
            num2str(ttest(j,1),'%.3f'),', p < 0.0001'];
    end
end

fig8 = cell2table([vars;fig8]);

writetable(fig8,[dirSave,'/Figure 8.csv'])