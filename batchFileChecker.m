% Script to be used after running all EEG subjects through
% automatedMaster_Run.m 

% The path should contain all of the analyzed subject files outputted from
% automatedMaster_Run. Each of these files will be of the form
% subjectName_maxChanInterp or subjectName_maxAlphaFreqs.

% This script opens up each file in the path, looks for certain criteria to
% be met ( alpha band peak too high, too many interpolated channels) and
% flags the subjects that meet those criteria. 

% Someone will need to go through and reanalyze those flagged subjects. 

clear
thePath = 'C:\Users\tmc54\Documents\MATLAB\TextFiles05-Jul-2018';
cd(thePath)
mainFolder = dir;
listOfFiles = {mainFolder(3:end).name}; 
alphaPeakThreshold = 80; % Maximum power of the alpha peak we allow (in microvolts squared)
maxInterpThreshold = 37; % How many bad electrodes are we allowing out of 124
outputName = ['subjectsToCheck' date]; % name of the output file

%% 

fid = fopen(outputName, 'w'); % create a blank output file
for fileNumber=1:size(listOfFiles,2)
    cd(thePath)
    fileName = listOfFiles{fileNumber};
    % There are two types of files in the path, maxAlphaFreqs and
    % maxChanInterp, so the following if statements check to see which
    % category the current file falls under.
    if strcmp(fileName(11:end), 'maxAlphaFreqs') 
        try
            maxAlphaFreqs = load(fileName); % load the max alpha file into a variable
                for segmentNumber = 1:size(maxAlphaFreqs, 2) % go through each of the segments for the file (typically 6)
                    if maxAlphaFreqs(segmentNumber) >= alphaPeakThreshold
                        trigger = [fileName(1:9) ' segment ' int2str(segmentNumber) ' has a 5-10 Hz band peak above ' int2str(alphaPeakThreshold) ' microvolts (' int2str(maxAlphaFreqs(segmentNumber)) ')'];
                        fprintf(fid, [trigger '\n']); % add the above line to the output file
                    end
                end
        catch
        end
    end
    if strcmp(fileName(11:end), 'maxChanInterp')
        try
            maxInterpolatedChannels = load(fileName); % load the interpolated channels file into a variable
            for segmentNumber = 1:size(maxInterpolatedChannels,2)
                if maxInterpolatedChannels(segmentNumber) >= maxInterpThreshold
                    trigger = [fileName(1:9) ' segment ' int2str(segmentNumber) ' has ' int2str(maxInterpolatedChannels(segmentNumber)) ' interpolated channels'];
                    fprintf(fid, [trigger '\n']); % add the above line to the output file
                end

            end
        catch
        end
    end


end
fid = fclose(fid); % close the output file when we are done