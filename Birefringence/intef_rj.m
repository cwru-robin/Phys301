KDMM_Address = 11;


    % Trying to open an instrument that is already open will cause errors.
    % Check if there are any open instruments and close them.
    addrhvsupply=1;
    addrlock=4;
    vi=100;% 2
    vf=5000;% 32
    dv=100;% 0.05
    out = instrfind;
    if (size(out) ~= 0)
        fclose(instrfind);
        delete(instrfind);
    end

    % Create a GPIB object 
    % check NImax for primary address
    hvsupply = gpib('ni',0,addrhvsupply);
    lockin = gpib('ni',0,addrlock);
    % Open a connection to the instruments
    fopen( hvsupply);
    fopen(lockin);

    %Query instruments to identify them  
    fprintf( hvsupply,'*IDN?');
    out = fscanf( hvsupply);
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
    end
   
    
    % Start taking measurements.
    % Loop to set the voltage on the piezo stack 
    %  and read the measurement from the lockin amplifer
    v = vi;
    i = 1;
    fprintf(hvsupply, '*RST');
    fprintf(hvsupply, 'HVON'); %Turning on the High Voltage
                      %Make sure the front panael HV switch not off
                      %Otherwise we get an error
    fprintf(hvsupply, 'VLIM 6000')
    hvsupplyv = 0;
    lockv = 0;
    fprintf('Taking data...\n');
    while v <= vf+dv
        fprintf(hvsupply, 'VSET%f', v);
        pause(2);
        fprintf(lockin,'outp? 3');
        ans = fscanf(lockin);
        %output = strtok(ans,'A')
        lockv(i) = str2num(ans);
        
        fprintf(hvsupply, 'VOUT?');
        ans = fscanf(hvsupply);
        hvsupplyv(i) = str2num(ans); % (now-startTime)*24*3600;%v;%this is actually time right now
        i = i + 1;
        v = v + dv;
        pause(0.5);% 2
        plot(hvsupplyv,lockv);
    end
    fprintf(hvsupply, 'VSET%f', 0);
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
