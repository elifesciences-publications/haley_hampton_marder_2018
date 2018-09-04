function [ pH_avg, pH_min, pH_sec, T_sec ] = convertpH( abf )
%Given an abf file with a pH channel, it converts the voltage values to pH
%and outputs an average pH and arrays of averages of minutes and seconds
%   INPUTS:
%       abf: abf file output from LoadAbf('filename.abf')
%   OUTPUTS:
%       pH_avg: average pH of the entire file
%       pH_min: array of pH values averaged over each minute
%       pH_sec: array of pH values averaged over each second

V = abf.data.pH;
T = abf.data.Temp;
sampleFreq = 1000/abf.time(2);

V_sec = zeros(1,round(length(V)/sampleFreq));
T_sec = V_sec;
pH_sec = V_sec;

V_min = zeros(1,round(length(V_sec)/60));
T_min = V_min;
pH_min = V_min;

temperatures = 6:1:36;
% pHvTemp is a 31x2 array giving the slope and y-intercept for each temp
pHvTemp = [-1.96813234062519,6.99371901171837;-1.96614163983911,6.99561861287150;-1.96413454879936,6.99749947031243;-1.96211091258808,6.99936132685323;-1.96007057588858,7.00120392126684;-1.95801338306697,7.00302698823280;-1.95593917825986,7.00483025828323;-1.95384780546829,7.00661345774952;-1.95173910865839,7.00837630870961;-1.94961293186908,7.01011852893608;-1.94746911932735,7.01183983184513;-1.94530751557138,7.01353992644678;-1.94312796558220,7.01521851729620;-1.94093031492421,7.01687530444656;-1.93871440989516,7.01850998340352;-1.93648009768622,7.02012224508151;-1.93422722655257,7.02171177576216;-1.93195564599536,7.02327825705504;-1.92966520695547,7.02482136586094;-1.92735576202002,7.02634077433806;-1.92502716564219,7.02783614987141;-1.92267927437529,7.02930715504566;-1.92031194712179,7.03075344762191;-1.91792504539835,7.03217468051866;-1.91551843361773,7.03357050179752;-1.91309197938854,7.03494055465394;-1.91064555383402,7.03628447741359;-1.90817903193088,7.03760190353482;-1.90569229286947,7.03889246161778;-1.90318522043656,7.04015577542073;-1.90065770342197,7.04139146388432];

for i=1:length(V_sec)
    if i*sampleFreq > length(V)
        max = length(V);
    else
        max = i*sampleFreq;
    end
    max = uint32(max);
    V_sec(i) = mean(V((i-1)*sampleFreq+1:max));
    T_sec(i) = mean(T((i-1)*sampleFreq+1:max));
    pH_sec(i) = pHvTemp(round(T_sec(i))-5,1)*V_sec(i)+pHvTemp(round(T_sec(i))-5,2);
end

for i=1:length(V_min)
    if i*60 > length(V_sec)
        max = length(V_sec);
    else
        max = i*60;
    end
    V_min(i) = mean(V_sec((i-1)*60+1:max));
    T_min(i) = mean(T_sec((i-1)*60+1:max));
    pH_min(i) = mean(pH_sec((i-1)*60+1:max));
end

pH_avg = mean(pH_sec);

end

