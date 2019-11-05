clear
close all
%thePath = 'C:\Users\tmc54\Documents\EyeTracking\DukeABCs_EGT';
thePath = 'C:\Users\tmc54\Documents\EyeTracking\DukeACT_EGT\T2Background';
cd(thePath)
mainFolder = dir;
listOfSubjectFolders = {mainFolder(3:end).name}; %3:end means that it will start with the first file
label=listOfSubjectFolders;
targetFixation = zeros(size(label,2), 4); %preallocating; 4 is due to 4 JA segments
targetFixationNext = zeros(size(label,2), 4); %preallocating; 4 is due to 4 JA segments

samplesForFixation = 24;

for index = 1:180
    if index < 10
        number = ['00' num2str(index)];
    elseif (10 <= index) && (index < 100)
        number = ['0' num2str(index)];
    elseif index >= 100
        number = num2str(index);
    end
    subjectList180(index) = {['ACT' number]};
end

subjectList180 = subjectList180';
noDataLine = zeros(1,6);

for m = 1:180
    cd(thePath);
    varname = listOfSubjectFolders{m};
    cd(varname);
    contents = dir;
    contents = {contents(3:end).name};
    if ~isempty(contents)
        fileName = [varname '_EGT_Analysis.mat'];
        datName = ['dat_' varname]; 
        fileName = load(fileName, datName); %load only the dat structure in the EGT Analysis mat file, saves time and space
        listOfSegmentNames = fieldnames(fileName.(datName)); %list of segment names (ie, DB1, DB2, JAmonkey, MTrooster, etc)

    %% Did they look at the target toy at any time during the segment for a certain number of samples (ok to blink during these samples) (1=yes,0=no)
        for n = 1:4 %go through each of the JA segments
            condition = listOfSegmentNames{n+11}; %which JA condition you are currently looking at. The +11 is to get you to the JA section. 1 to 11 are the DB conditions
            dat = fileName.(['dat_' varname]).(condition); %the data for the JA condition in that subject's mat file
            ROItarget = dat.(['ROI' condition(3:end)]); 
            ROIall = dat.ROImoose + dat.ROImonkey + dat.ROIpenguin + dat.ROIrooster + dat.ROImouth + dat.ROIeyes +dat.ROIbody + dat.ROIhands + dat.ROIbackground; 
            ROIwrong = ROIall-ROItarget;
            gazeEventColumn = dat.gazeEventType; %what Tobii codes each sample as
            validityCodeColumn = dat.validitycode; 
            if sum(ROItarget)>= samplesForFixation %no point in determining fixation if they didn't look enough to get up to samples for fixaiton
                [targetFixation(m, n), ~, ~] = determineFixation(ROItarget, ROIall, ROIwrong, samplesForFixation, gazeEventColumn, validityCodeColumn); %figure out if subject was fixating on actress, when they started fixating, and when they stop; start and stop can have multiple instances
            end
        end

        for n = 1:4 %go through each of the JA segments
            conditionNext = listOfSegmentNames{n+2}; %which JA condition you are currently looking at. The +2 is to get you to the DB section after the JA condition starts
            datNext = fileName.(['dat_' varname]).(conditionNext); %the data for the JA condition in that subject's mat file
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
            ROIallNext = datNext.ROImoose + datNext.ROImonkey + datNext.ROIpenguin + datNext.ROIrooster + datNext.ROImouth + datNext.ROIeyes + datNext.ROIbody + datNext.ROIhands + datNext.ROIbackground; 
            ROIwrongNext = ROIallNext-ROItargetNext;
            gazeEventColumnNext = datNext.gazeEventType; %what Tobii codes each sample as
            validityCodeColumnNext = datNext.validitycode; 
            if sum(ROItargetNext)>= samplesForFixation %no point in determining fixation if they didn't look enough to get up to samples for fixaiton
                [targetFixationNext(m, n), ~, ~] = determineFixation(ROItargetNext, ROIallNext, ROIwrongNext, samplesForFixation, gazeEventColumnNext, validityCodeColumnNext); %figure out if subject was fixating on actress, when they started fixating, and when they stop; start and stop can have multiple instances
            end
        end
    end
end
chronologicalTargetFixation = [targetFixation(:,2), targetFixation(:,3), targetFixation(:,1), targetFixation(:,4)];
targetFixationTotal = sum(targetFixation,1);
targetFixationNextTotal = sum(targetFixationNext,1);
jaPlusDb = chronologicalTargetFixation+targetFixationNext;