clear
%thePath = 'C:\Users\tmc54\Documents\EEG\NARSAD_Check';
%thePath = 'C:\Users\tmc54\Desktop\NARSAD\TextFiles29-Jan-2018';
%thePath = 'C:\Users\tmc54\Desktop\ACT_T1\TextFiles09-May-2018';
thePath = 'C:\Users\tmc54\Documents\MATLAB\TextFiles05-Jul-2018';
cd(thePath)
mainFolder = dir;
listOfFiles = {mainFolder(3:end).name}; %change back to 3:end after testing
%label={'ACT127_T1'};; %this will run just specific subjects if you have the
%next line commented out
label=listOfFiles; %this will run all subjects that you have in thePath
alphaPeakThreshold = 80;
maxInterpThreshold = 37;
outputName = ['subjectsToCheck' date];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fid = fopen(outputName, 'w');
k=size(label);
j=k(2);
for kk=1:j
    cd(thePath)
    varname = label{kk};
    if strcmp(varname(end), 's')
        try
            maxAlphaFreqs = load(varname);
                for n = 1:size(maxAlphaFreqs, 2)
                    if maxAlphaFreqs(n) >= alphaPeakThreshold
                        trigger = [varname(1:end-14) ' segment ' int2str(n) ' has a 5-10 Hz band peak above ' int2str(alphaPeakThreshold) ' microvolts (' int2str(maxAlphaFreqs(n)) ')'];
                        fprintf(fid, [trigger '\n']);
                    end
%                     if maxAlphaFreqs(n) ==0 && n<7
%                         trigger = [varname(1:end-14) ' segment ' int2str(n) ' has a 0'];
%                         fprintf(fid, [trigger '\n']);
%                     end
                end
        catch
        end
    end
    if strcmp(varname(end), 'p')
        try
            maxInterpolatedChannels = load(varname);
            for l = 1:size(maxInterpolatedChannels,2)
                if maxInterpolatedChannels(l) >= maxInterpThreshold
                    trigger = [varname(1:end-14) ' segment ' int2str(l) ' has ' int2str(maxInterpolatedChannels(l)) ' interpolated channels'];
                    fprintf(fid, [trigger '\n']);
                end

            end
        catch
        end
    end


end
fid = fclose(fid);