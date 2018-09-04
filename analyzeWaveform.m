function [ data ] = analyzeWaveform ( Vm, sampleFreq, params )
%Given the membrane potential and sampling frequency, this code analyzes 
%the waveform and computes various measures
%   INPUTS:
%       Vm: array of voltage (mV)
%       sampleFreq: sampling frequency (Hz)
%   OUTPUTS:
%       data: structure with the following fields:
%           spikeTime: time of spike peak (ms)
%           spikeMin: voltage of spike trough (mV)
%           spikeMax: voltage of spike peak (mV)
%           spikeAmp: amplitude of spike (mV)
%           spikeFreq: instantaneous frequency of spikes (Hz)
%           waveTime: time of slow wave peak (ms)
%           waveMin: voltage of slow wave trough (mV)
%           waveMax: voltage of slow wave peak (mV)
%           waveAmp: amplitude of slow wave (mV)
%           waveFreq: instantaneous frequency of slow waves (Hz)
%           minVm: minimum Vm for each second of data (mV)
%           parameters: structure containing parameters used for analysis

% Loop until satisfied with results
done = "no";
while strcmp(done,"no")

% Query user for parameters
params = inputdlg({"Maximum Burst Frequency (Hz)",...
    "Minimum Spike Height (mV)"},...
    "Define Parameters",[1 40],params); % get parameters
maxBurstFreq = str2num(params{1}); % estimated burst frequency (Hz)
minSpikeHeight = str2num(params{2}); % minimum spike height (mV)

% Create butterworth filter
fPass = 10; % high-pass filter frequency (Hz)
filter = (2 * 1/sampleFreq) * fPass; 
[B,A] = butter(2, filter, 'high');

% Filter Membrane Potential to remove spikes
Vm_spike = filtfilt(B, A, Vm); % filtered Vm gives spikes only
Vm_wave = Vm - Vm_spike; % subtract filtered Vm to get slow wave only
time = [1:length(Vm)]'/sampleFreq; % time vector (s)

% Find Peaks and Troughs
[peaks1,locs1] = findpeaks(Vm_wave,sampleFreq,'MinPeakDistance',...
    1/maxBurstFreq,'MinPeakProminence',1);
[peaks2,locs2] = findpeaks(-Vm_wave,sampleFreq,'MinPeakDistance',...
    1/maxBurstFreq,'MinPeakProminence',1);
[peaks3,locs3] = findpeaks(Vm_spike,sampleFreq,'MinPeakProminence',minSpikeHeight);
[peaks4,locs4] = findpeaks(-Vm_spike,sampleFreq,'MinPeakProminence',minSpikeHeight);

% Find Minimum Vm (in the absence of waveform)
for i = 1:time(end)
    ind = find(time >= i-1 & time < i);
    minVm(i) = min(Vm_wave(ind));
end

% Plot Results
figure
set(gcf,'Position',[0 0 1500 400]);

subplot(3,8,[1,9])
hold on
plot(time,Vm,'b','LineWidth',1.5)
plot(time,Vm_wave,'k','LineWidth',2)
scatter(locs1,peaks1,'r');
scatter(locs2,-peaks2,'r');
scatter(1:time(end),minVm,'g')
xlim([0 2])
ylabel('Vm (mv)')

subplot(3,8,[2:8,10:16])
hold on
plot(time,Vm,'b','LineWidth',1.5)
plot(time,Vm_wave,'k','LineWidth',2)
scatter(locs1,peaks1,'r');
scatter(locs2,-peaks2,'r');
scatter(1:time(end),minVm,'g')
xlim([0 max(time)])

subplot(3,8,17)
hold on
plot(time,Vm_spike,'k','LineWidth',2)
scatter(locs3,peaks3,'r');
scatter(locs4,-peaks4,'r');
xlim([0 2])
ylabel('Vm (mv)')

subplot(3,8,[18:24])
hold on
plot(time,Vm_spike,'k','LineWidth',2)
scatter(locs3,peaks3,'r');
scatter(locs4,-peaks4,'r');
xlim([0 max(time)])
xlabel('Time (s)')

% Query user to redo analysis with new parameters
done = questdlg("Satisfied with these results?","Query to Redefine Parameters",...
    "yes","no","yes");

end

% Define and calculate output variables
data.waveTime = locs1(1:min(length(peaks1),length(peaks2)));
data.waveMax = peaks1(1:min(length(peaks1),length(peaks2)));
data.waveMin = -peaks2(1:min(length(peaks1),length(peaks2)));
data.waveAmp = data.waveMax - data.waveMin;
data.waveFreq = 1./diff(data.waveTime);
data.spikeTime = locs3(1:min(length(peaks3),length(peaks4)));
data.spikeMax = peaks3(1:min(length(peaks3),length(peaks4)));
data.spikeMin = -peaks4(1:min(length(peaks3),length(peaks4)));
data.spikeAmp = data.spikeMax - data.spikeMin;
data.spikeFreq = 1./diff(data.spikeTime);
data.minVm = minVm;
data.parameters.maxBurstFreq = maxBurstFreq;
data.parameters.minSpikeHeight = minSpikeHeight;
data.parameters.highPassFreq = fPass;

close all

end

