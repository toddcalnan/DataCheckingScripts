clear
close all
thePath = 'C:\Users\tmc54\Documents\EyeTracking\DukeACT_EGT\T2Background';
cd(thePath)
mainFolder = dir;
listOfSubjectFolders = {mainFolder(3:end).name}; % 3:end means that it will start with the first file
[targetFixation,targetFixationNext] = deal(zeros(size(listOfSubjectFolders,2), 4)); % preallocating; 4 is due to 4 JA segments
subjectList180 = cell(180,1); % preallocating

samplesForFixation = 24; % number of samples needed to count as a fixation

%% Go through all ACT numbers, 1-180
% This is a rather convoluted way of looking at each subject, but this way
% all subjects, even ones who didn't complete the experiment, end up in the
% output table. 

for index = 1:180
    if index < 10
        number = ['00' num2str(index)];
    elseif (10 <= index) && (index < 100)
        number = ['0' num2str(index)];
    elseif index >= 100
        number = num2str(index);
    end
    subjectList180(index,1) = {['ACT' number]};
end

for subectNumber = 1:180
    cd(thePath);
    subjectName = listOfSubjectFolders{subectNumber};
    cd(subjectName);
    contents = dir; % look at contents of the subject's folder
    contents = {contents(3:end).name}; % ignore the hidden files at the top of every directory
    if ~isempty(contents) % if the subject's folder has files in it
        fileName = [subjectName '_EGT_Analysis.mat'];
        datName = ['dat_' subjectName]; % open the output from EGT_Analysis_Master.m
        fileName = load(fileName, datName); % load only the dat structure in the EGT Analysis mat file, saves time and space
        listOfSegmentNames = fieldnames(fileName.(datName)); % list of segment names (ie, DB1, DB2, JAmonkey, MTrooster, etc)

    %% Did they look at the target toy at any time during the segment for a certain number of samples (ok to blink during these samples) (1=yes,0=no)
        for jaNumber = 1:4 % go through each of the JA segments
            condition = listOfSegmentNames{jaNumber+11}; % which JA condition you are currently looking at. The +11 is to get you to the JA section. 1 to 11 are the DB conditions
            dat = fileName.(['dat_' subjectName]).(condition); % the data for the JA condition in that subject's mat file
            ROItarget = dat.(['ROI' condition(3:end)]); 
            ROIall = dat.ROImoose + dat.ROImonkey + dat.ROIpenguin + ...
                dat.ROIrooster + dat.ROImouth + dat.ROIeyes +dat.ROIbody...
                + dat.ROIhands + dat.ROIbackground; 
            ROIwrong = ROIall-ROItarget; 
            gazeEventColumn = dat.gazeEventType; % what Tobii codes each sample as
            validityCodeColumn = dat.validitycode; 
            % figure out if subject was fixating on actress, when they 
            % started fixating, and when they stop; 
            % start and stop can have multiple instances
            if sum(ROItarget)>= samplesForFixation % no point in determining fixation if they didn't look enough to get up to samples for fixaiton
                [targetFixation(subectNumber, jaNumber), ~, ~] = determineFixation(ROItarget,...
                    ROIall, ROIwrong, samplesForFixation, gazeEventColumn,...
                    validityCodeColumn); 
            end
        end

        for jaNumber = 1:4 % go through each of the JA segments
            conditionNext = listOfSegmentNames{jaNumber+2}; % which JA condition you are currently looking at. The +2 is to get you to the DB section after the JA condition starts
            datNext = fileName.(['dat_' subjectName]).(conditionNext); % the data for the JA condition in that subject's mat file
            if strcmp(conditionNext,'DB3')
                DBtarget = 'JAmoose';
            elseif strcmp(conditionNext, 'DB4')
                DBtarget = 'JArooster';
            elseif strcmp(conditionNext, 'DB5')
                DBtarget = 'JAmonkey';
            elseif strcmp(conditionNext, 'DB6')
                DBtarget = 'JApenguin';
            end
            ROItargetNext = datNext.(['ROI' DBtarget(3:end)]); 
            ROIallNext = datNext.ROImoose + datNext.ROImonkey + ...
                datNext.ROIpenguin + datNext.ROIrooster + datNext.ROImouth...
                + datNext.ROIeyes + datNext.ROIbody + datNext.ROIhands +...
                datNext.ROIbackground; 
            ROIwrongNext = ROIallNext-ROItargetNext;
            gazeEventColumnNext = datNext.gazeEventType; % what Tobii codes each sample as
            validityCodeColumnNext = datNext.validitycode; 
            % figure out if subject was fixating on actress, when they 
            % started fixating, and when they stop; 
            % start and stop can have multiple instances
            if sum(ROItargetNext)>= samplesForFixation % no point in determining fixation if they didn't look enough to get up to samples for fixaiton
                [targetFixationNext(subectNumber, jaNumber), ~, ~] = determineFixation(ROItargetNext, ROIallNext, ROIwrongNext, samplesForFixation, gazeEventColumnNext, validityCodeColumnNext); 
            end
        end
    end
end
chronologicalTargetFixation = [targetFixation(:,2), targetFixation(:,3),...
    targetFixation(:,1), targetFixation(:,4)];
targetFixationTotal = sum(targetFixation,1);
targetFixationNextTotal = sum(targetFixationNext,1);
jaPlusDb = chronologicalTargetFixation+targetFixationNext;