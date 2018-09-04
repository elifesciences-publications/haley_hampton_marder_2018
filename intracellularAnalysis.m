function [ ] = intracellularAnalysis ( )
%Compiles data from a single experiment
%   INPUTS:
%       Choose folder containing experiment abf files
%       GUI will ask for channel names
%   OUTPUTS:
%       data: structure containing all analyzed variables divided by
%       filenumber; saves these structures as unit.mat files in the parent
%       folder
%   ACCESSORY FILES
%       LoadAbf.m: loads abf files into structure

% Query User for Experiment Information
directory=uigetdir(); % get directory
if exist(strcat(directory,'/data.mat'))
    data = load(strcat(directory,'/data.mat'));
    info = data.info;
else
    info.abfFiles = dir(strcat(directory,'/*_*.abf')); %find abf files in the directory
    for i = 1:length(info.abfFiles) % pull out file names
        fileChoice{i} = convertCharsToStrings(info.abfFiles(i).name);
    end
    
    info.channels = inputdlg({"PD Channel","LP Channel"},"Define Channels"); % get channel names
    info.order = questdlg("Which protocol order was used?","Acid of Base First","AB","BA","AB"); % get protocol order
    if strcmp(info.order,"AB")
        info.conditions = {'pH 8.2','pH 7.6','pH 7.0','pH 6.4','pH 5.9',...
            'pH 8.2','pH 9.0','pH 9.6','pH 10.1','pH 10.6','pH 11.1','pH 8.2'}';
    else
        info.conditions = {'pH 8.2','pH 9.0','pH 9.6','pH 10.1','pH 10.6','pH 11.1',...
            'pH 8.2','pH 7.6','pH 7.0','pH 6.4','pH 5.9','pH 8.2'}';
    end
    
    for i = 1:length(info.conditions)
        fileOrder = listdlg("ListString",fileChoice,...
            "PromptString",strcat("Choose the file for ",info.conditions{i},":"),...
            "SelectionMode","single");
        info.fileOrder{i} = fileChoice{fileOrder};
        fileChoice(1:fileOrder) = [];
    end
    info.fileOrder = info.fileOrder';
end
data.info = info;
save(strcat(directory,'/data.mat'),'-struct','data'); % save structures

fieldsToDo = []; %log conditions still needed
for i = 1:length(info.conditions)
    fieldNames{i} = ['condition',num2str(i,'%02d')];
    if ~isfield(data,fieldNames{i})
        fieldsToDo = [fieldsToDo,i];
    end
end

% Analyze Data
for i = fieldsToDo
    % Reload data
    if exist(strcat(directory,'/data.mat'))
        data = load(strcat(directory,'/data.mat'));
        info = data.info;
    end
    
    % Load data and get file info
    abf = LoadAbf(info.fileOrder{i});
    recTime(i,1:2) = [abf.header.recTime(1),abf.header.recTime(2)]; % start and end of file
    recTime(i,3) = recTime(i,2) - recTime(i,1); % file length
    recTime(i,4) = recTime(i,1) - recTime(1,1); % file offset
    info.sampleFreq = 1000/abf.time(2); % sampling frequency
    
    % Save File and Condition information
    data.(fieldNames{i}).fileName = info.fileOrder{i};
    data.(fieldNames{i}).condition = info.conditions{i};
    
    % Get membrane potential
    VmPD = abf.data.(info.channels{1});
    VmLP = abf.data.(info.channels{2});
    
    % Extract last minute of data for waveform analysis
    VmPD_lastMin = VmPD(end-info.sampleFreq*60:end);
    VmLP_lastMin = VmLP(end-info.sampleFreq*60:end);
%     VmPD_lastMin = VmPD(end-info.sampleFreq*120:end-info.sampleFreq*60);
%     VmLP_lastMin = VmLP(end-info.sampleFreq*120:end-info.sampleFreq*60);
%     VmPD_lastMin = VmPD(info.sampleFreq*14*60:info.sampleFreq*15*60);
%     VmLP_lastMin = VmLP(info.sampleFreq*14*60:info.sampleFreq*15*60);
    
    % Analyze Waveforms
    if i == 1
        paramsPD = {'2','10'}; % maxBurstFreq, minSpikeHeight
        paramsLP = {'10','3'}; % maxBurstFreq, minSpikeHeight
    else % grab most recent parameters
        paramsPD = {num2str(data.(fieldNames{i-1}).PD.parameters.maxBurstFreq),...
            num2str(data.(fieldNames{i-1}).PD.parameters.minSpikeHeight)};
        paramsLP = {num2str(data.(fieldNames{i-1}).LP.parameters.maxBurstFreq),...
            num2str(data.(fieldNames{i-1}).LP.parameters.minSpikeHeight)};
    end
    data.(fieldNames{i}).PD = ...
        analyzeWaveform(VmPD_lastMin,info.sampleFreq,paramsPD);
    data.(fieldNames{i}).LP = ...
        analyzeWaveform(VmLP_lastMin,info.sampleFreq,paramsLP);
    
    % Rename some measures for saving
    info.fileStart = recTime(:,1);
    info.fileEnd = recTime(:,2);
    info.fileLength = recTime(:,3);
    info.fileOffset = recTime(:,4);
    data.info = info;
    
    % Save after each file
    save(strcat(directory,'/data.mat'),'-struct','data'); % save structures
end

end