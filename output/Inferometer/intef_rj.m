function [piezov, lockv] = interf
    % Trying to open an instrument that is already open will cause errors.
    % Check if there are any open instruments and close them.
    addrpiezo=6;
    addrlock=3;
    vi=4;% 2
    vf=18;% 32
    dv=0.01;% 0.05
    out = instrfind;
    if (size(out) ~= 0)
        fclose(instrfind);
        delete(instrfind);
    end

    % Create a GPIB object 
    % check NImax for primary address
    piezo = gpib('ni',0,addrpiezo);
    lockin = gpib('ni',0,addrlock);
    % Open a connection to the instruments
    fopen(piezo);
    fopen(lockin);

    %Query instruments to identify them  
    fprintf(piezo,'*IDN?');
    out = fscanf(piezo);
    fprintf('Found instrument:   %s',out);

    fprintf(lockin,'*IDN?');
    out = fscanf(lockin);
    fprintf('Found instrument:   %s',out);

    % Check to make sure the limits on the voltage scan make sense
    if vi > vf && dv > 0
        fprintf('Sign error in dv');
        fclose(instrfind);
        delete(instrfind);
        return
    elseif vf > 65
        fprintf('Max voltage exceeds 65V');
        fclose(instrfind);
        delete(instrfind);
        return
    end

    % Start taking measurements.
    % Loop to set the voltage on the piezo stack 
    %  and read the measurement from the lockin amplifer
    v = vi;
    i = 1;
    fprintf(piezo,'OUTPut:STATe 1');
    fprintf(piezo, 'SOURce:VOLTage %f', 4);
    pause(0.3);% 2
    piezov = 0;
    lockv = 0;
    fprintf('Taking data...\n');
    while v <= vf+dv
        
        fprintf(piezo, 'SOURce:VOLTage %f', v);
        pause(0.35);% 2
        fprintf(lockin,'outp? 3');
        ans = fscanf(lockin);
        %output = strtok(ans,'A')
        lockv(i) = str2num(ans);
        piezov(i) = v ;% (now-startTime)*24*3600;%v;%this is actually time right now
        i = i + 1;
        v = v + dv;
        pause(0.1);% 2
        plot(piezov,lockv);
    end
    % Closing the instruments
    fclose(instrfind);
    delete(instrfind);
    plot(piezov,lockv);

    % Save the measurement
    %  The arrays can be reloaded into matlab arrays using
    %    load('test.mat')
    save('test.mat','piezov','lockv');

    % Save in a filename with a date and time stamp
    fname = sprintf('%s %s.mat','MI',datestr(now,'mmm-dd-yyyy at HH-MM-SS'));
    save(fname,'piezov','lockv'); 
    writetable(table(piezov,lockv),'FPms1.xlsx');

    fprintf('Done!\n');
