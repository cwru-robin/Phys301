%% Robin and Grace
clc
close all
clear

%% Use after first initialization and Making Connections
KDMM_Address = 11;
SPS_Address = 1;
KDMM = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', KDMM_Address, 'Tag', '');
SPS = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', SPS_Address, 'Tag', '');

%fclose(instrfind()); %Keep for every run after the first of the day
%KDMM = gpib('ni',0,11);
if isempty(KDMM)
    KDMM = gpib('ni', 0, KDMM_Address);
else
    fclose(KDMM);
    KDMM = KDMM(1);
end

%TPS = gpib('ni',0,5);
%SPS = gpib('ni',0,1);
if isempty(SPS)
    SPS = gpib('ni', 0, SPS_Address);
else
    fclose(SPS);
    SPS = SPS(1);
end

% Opening GPIB Connections

fopen(KDMM);
%fopen(TPS);
fopen(SPS);
fprintf(SPS, '*RST');
fprintf(SPS, 'HVON'); %Turning on the High Voltage
                      %Make sure the front panael HV switch not off
                      %Otherwise we get an error
fprintf(SPS, 'VLIM 5000')
% fprintf(TPS,'*RST')
% fprintf(TPS, 'VOLT .10');
%%
figure(1)


i = 100;
Voltage_O = zeros([1 i]);
VP = linspace(100,5000,i);
for i = 1:length(Voltage_O)
    fprintf(SPS, ['VSET',num2str(VP(i))])
    pause(1.5)
    fprintf(KDMM, ':CONF:VOLT:DC'); %setting up the kdmm to read "  "
    x=query(KDMM, ':MEAS:VOLT?');
    Voltage_O(i) =str2num(x(2:end));
    figure(1)
    plot(VP,Voltage_O)
end

fprintf(SPS, ['VSET',num2str(VP(1))])
V=VP(find(Voltage_O==max(Voltage_O)))
%% Saving Data
filename='40-c100-5000';
saveas(gcf,filename)
save(filename,'Voltage_O','VP')

% %%        ; % Current voltage string
% 
% for i = 1:length(VP)
%     fprintf(SPS, ['VSET',num2str(VP(i))])
% end
fprintf("done")

% figure(1)
% i = 100
% Voltage_O = zeros([1 i]);
% VP = linspace(0,4500,i);
% for i = 1:length(Voltage_O)
%     fprintf(SPS, ['VSET',num2str(VP(i))])
%     pause(1)
%     for j=1:10
%         x= fscanf(KDMM)
%         temp(j)=str2num(x(6:end));
%     end
%     Voltage_O(i)=mean(temp);
%     plot(VP,Voltage_O)
% end
% fprintf(SPS, ['VSET',num2str(VP(1))])

% figure(1)
% i = 100
% Voltage_O = zeros([1 i]);
% VP = linspace(0,4500,i);
% for i = 1:length(Voltage_O)
%     fprintf(SPS, ['VSET',num2str(VP(i))])
%     pause(5)
%     x= fscanf(KDMM)
%     Voltage_O(i) =str2num(x(6:end));
%     plot(VP,Voltage_O)
% end
% fprintf(SPS, ['VSET',num2str(VP(1))])

