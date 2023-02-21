%% Robin and Grace
clc
close all
clear

%% Use after first initialization and Making Connections
KDMM_Address = 11;
KDMM_Address2 = 4;
Tempcontrol_Address=5;
SPS_Address = 1;
KDMM = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', KDMM_Address, 'Tag', '');
SPS = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', SPS_Address, 'Tag', '');
KDMM2 = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', KDMM_Address2, 'Tag', '');
TPS = instrfind('Type', 'gpib', 'BoardIndex', 0, 'PrimaryAddress', Tempcontrol_Address, 'Tag', '');

%fclose(instrfind()); %Keep for every run after the first of the day
%KDMM = gpib('n+i',0,11);
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

if isempty(KDMM2)
    KDMM2 = gpib('ni', 0, KDMM_Address2);
else
    fclose(KDMM2);
    KDMM2 = KDMM2(1);
end

if isempty(TPS)
    TPS = gpib('ni', 0, Tempcontrol_Address);
else
    fclose(TPS);
    TPS = TPS(1);
end


% Opening GPIB Connections

fopen(KDMM);
fopen(KDMM2);
fopen(TPS);
fopen(SPS);
fprintf(SPS, '*RST');
fprintf(SPS, 'HVON'); %Turning on the High Voltage
                      %Make sure the front panael HV switch not off
                      %Otherwise we get an error
fprintf(SPS, 'VLIM 5000');
fprintf(TPS,'*RST');
fprintf(TPS,'SOURce:CURRent:PROTection:STATe 0');
fprintf(TPS,'INST:NSELect 1');
fprintf(TPS,'OUTPut:STATe ON');
fprintf(TPS, 'CURR 1.4');
fprintf(TPS, 'VOLT 0.01');


 %%
 f1=figure(1);
 f2= figure(2);
 i = 100;
 HV=linspace(100,5000,i);
Tempture = 0.01:0.03:1.3;
fileheader="voltAcrossLC_45N45";
count=24;
Voltage_O = zeros([1 length(Tempture)]);
 for j=1:length(Tempture)
        
        Voltage_R = zeros([1 length(HV)]);
        fprintf(TPS, ['VOLT ',num2str(Tempture(j))]);
        pause(1);
        fprintf(KDMM2, ':CONF:VOLT:DC'); %setting up the kdmm to read "  "
        x1=query(KDMM2, ':MEAS:VOLT?');
        pause(10+40*Tempture(j));
        fprintf(KDMM2, ':CONF:VOLT:DC'); %setting up the kdmm to read "  "
        x2=query(KDMM2, ':MEAS:VOLT?');
        while abs(str2num(x1(5:end))-str2num(x2(5:end))) > .0001
            pause(2)
            fprintf(KDMM2, ':CONF:VOLT:DC'); %setting up the kdmm to read "  "
            x1=query(KDMM2, ':MEAS:VOLT?');
            pause(3);
            fprintf(KDMM2, ':CONF:VOLT:DC'); %setting up the kdmm to read "  "
            x2=query(KDMM2, ':MEAS:VOLT?');
        end
        fprintf("Temp leveled\n");
        fprintf(x1(5:end));
        fprintf(x2(5:end));
        fprintf(KDMM2, ':CONF:VOLT:DC'); %setting up the kdmm to read "  "
        x=query(KDMM2, ':MEAS:VOLT?');
        Voltage_O(j) =str2num(x(5:end));  
        set(0,"CurrentFigure",f1);
        plot(Tempture,Voltage_O);
       
        
     for i = 1:length(HV)
        
        fprintf(SPS, ['VSET',num2str(HV(i))]);
        pause(2);
        fprintf(KDMM, ':CONF:VOLT:DC'); %setting up the kdmm to read "  "
        x=query(KDMM, ':MEAS:VOLT?');
         fprintf(x)
        fprintf(": Voltage at"+HV(i)+"\n")
        Voltage_R(i) =str2num(x(2:end));
       
        set(0,"CurrentFigure",f2);
        plot(HV,Voltage_R);
      end
    filename=num2str(count)+fileheader+num2str(Tempture(j)*100);
    set(0,"CurrentFigure",f2);
    saveas(gcf,filename)
    save(filename,'Voltage_R','HV')
    count=count+1; 
      
 end
 filename=fileheader+"_temp";
 set(0,"CurrentFigure",f1);
 saveas(gcf,filename)
 save(filename,'Voltage_O','Tempture')
fprintf(TPS, 'VOLT 0.01');

%%
f1=figure(1);
 f2= figure(2);
 i = 100;
 HV=linspace(100,5000,i);
Tempture = 0.01:0.5:3.4;
fileheader="temp22-92(-4)_120N45";
count=24;
Voltage_O = zeros([1 length(Tempture)]);

        
Voltage_R = zeros([1 length(HV)]);

pause(2)
        
for i = 1:length(HV)

    fprintf(SPS, ['VSET',num2str(HV(i))]);
    pause(1.5);
    fprintf(KDMM, ':CONF:VOLT:DC'); %setting up the kdmm to read "  "
    x=query(KDMM, ':MEAS:VOLT?');
     fprintf(x)
    fprintf(": Voltage at"+HV(i)+"\n")
    Voltage_R(i) =str2num(x(2:end));

    set(0,"CurrentFigure",f2);
    plot(HV,Voltage_R);
end
filename=num2str(count)+fileheader+num2str(Tempture(j)*100);
set(0,"CurrentFigure",f2);
saveas(gcf,filename)
save(filename,'Voltage_R','HV')
count=count+1; 


 
fprintf(TPS, 'VOLT 0.01');

%%
 f1=figure(1);
 f2= figure(2);
 i = 100;
 HV=linspace(100,5000,i);
Tempture = 0.01:0.5:3.4;
fileheader="voltAcrossLC30c_45N45";
count=24;
Voltage_O = zeros([1 length(Tempture)]);
 for j=1:length(Tempture)
        
        Voltage_R = zeros([1 length(HV)]);
        fprintf(TPS, ['VOLT ',num2str(Tempture(j))]);
       pause(2)
        
     for i = 1:length(HV)
        
        fprintf(SPS, ['VSET',num2str(HV(i))]);
        pause(1.5);
        fprintf(KDMM, ':CONF:VOLT:DC'); %setting up the kdmm to read "  "
        x=query(KDMM, ':MEAS:VOLT?');
         fprintf(x)
        fprintf(": Voltage at"+HV(i)+"\n")
        Voltage_R(i) =str2num(x(2:end));
       
        set(0,"CurrentFigure",f2);
        plot(HV,Voltage_R);
      end
    filename=num2str(count)+fileheader+num2str(Tempture(j)*100);
    set(0,"CurrentFigure",f2);
    saveas(gcf,filename)
    save(filename,'Voltage_R','HV')
    count=count+1; 
      
 end
 
fprintf(TPS, 'VOLT 0.01');
