function [ data ] = readSpikeOutput ( filename )
%Given the name of a .txt file of bursts from spikenburst.s2s, this script
%outputs a data structure with fields for manipulation, file number, burst
%starts, burst ends, spikes per burst, burst length, duty cycle, frequency,
%and period; The output is compiled and also divided by each filenumber
%   INPUTS:
%       filename: e.g. 'PD_bursts.txt'
%   OUTPUTS:
%       data: structure with the following fields:
%           manipulation
%           file
%           tstart
%           tend
%           spikes
%           duration
%           period
%           hz
%           duty
%           'manipulationfile'... for each file

fid=fopen(filename,'r');
text=textscan(fid,'%s','delimiter',','); text=text{1};
nBursts=(length(text)/5);
for i = 1:nBursts
    manipulation{i} = text{5*(i - 1) + 1}; %experimental group
    file{i} = text{5*(i - 1) + 2}; %file number
    tstart(i) = str2double(text{5*(i - 1) + 3}); %burst start time
    tend(i) = str2double(text{5*(i - 1) + 4}); %burst end time
    spikes(i) = str2double(text{5*(i - 1) + 5}); %spikes per burst
    duration(i) = tend(i)-tstart(i); %burst length
end

for i = 2:nBursts
    period(i) = tstart(i)-tstart(i-1); %instantaneous period
    hz(i) = 1/period(i); %instantaneous frequency
    duty(i) = duration(i)/period(i); %duty cycle
end

period(1) = NaN; hz(1) = NaN; duty(1) = NaN; anic(1) = NaN;

for i = 2:nBursts
    if hz(i) < 0
        hz(i) = NaN;
        period(i) = NaN;
        duty(i) = NaN;
    end
    anic(i) = abs(hz(i)-hz(i-1))/hz(i); %cycle-to-cycle variability of frequency
end

data.manipulation = manipulation;
data.file = file;
data.tstart = tstart;
data.tend = tend;
data.spikes = spikes;
data.duration = duration;
data.period = period;
data.hz = hz;
data.duty = duty;
data.anic = anic;

end

