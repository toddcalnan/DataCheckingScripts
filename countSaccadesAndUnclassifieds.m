% countSaccadesAndUnclassifieds goes through all EGT subjects, even those
% that did not complete the experiment and calculates how many saccade,
% unclassified, and fixation samples there are for each segment for each
% subject. 
% This script expects the path to point towards a folder that contains all
% the analyzed EGT data seperated into individual subject folders.
% Output will be an Excel file named saccadeAndUnclassifiedCounts.xlsx in
% the original path.
clear
thePath = 'C:\Users\tmc54\Documents\EyeTracking\DukeACT_EGT\T2Background';
cd(thePath)
mainFolder = dir;
listOfSubjectFolders = {mainFolder(3:end).name};

[numberOfSaccadesTotal, numberOfSaccadesDb, numberOfUnclassifiedsTotal, ...
    numberOfUnclassifiedsDb, numberOfFixationsNotOnRoiTotal,...
    numberOfFixationsNotOnRoiDb] = deal(zeros(180, 1)); % preallocating
subjectList180 = cell(180,1); % preallocating
[numberOfFixationNotOnRoiVector,numberOfSamplesOnRoisVector,...
    numberOfSamplesOnMediaVector,numberOfSaccadesVector,...
    numberOfUnclassifiedsVector] = deal(zeros(180,21)); % preallocating

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

for subjectNumber=1:180 % go through all subjects
    cd(thePath);
    subjectName = listOfSubjectFolders{subjectNumber};
    cd(subjectName);
    contents = dir; % look at contents of the subject's folder
    contents = {contents(3:end).name}; % ignore the hidden files at the top of every directory
    
    if ~isempty(contents) % if the subject's folder has files in it
        fileName = [subjectName '_EGT_Analysis.mat']; 
        datFile = load(fileName, ['dat_' subjectName]); % open the output from EGT_Analysis_Master.m
        datFile = datFile.(['dat_' subjectName]); % the loaded datFile is a 1x1 struct, this pulls out the fields from that struct to be more easily accessible
        listOfFields = fields(datFile); % list of the fields in datFile. Expects to see DB1, DB2, etc. 1 per condition. 
        
        for fieldNumber = 1:size(listOfFields,1) % go through each of the fields, usually 21
            field = datFile.(listOfFields{fieldNumber}); 
            gazeEvent = field.gazeEventType; % looking at just the gaze event type field for each EGT segment
            [fixationNotOnRoi, numberOfSaccades, numberOfUnclassifieds,...
                roiCount, samplesOnMedia] = deal(0); % initializing
            
            % add up the values in the ROI columns to see how much the
            % subject was looking at the screen.
            roiSum = field.ROIpenguin+field.ROIrooster+field.ROImoose+...
                field.ROImonkey+field.ROIhands+field.ROIbody+...
                field.ROIeyes+field.ROImouth+field.ROIbackground;
            
            for rowNumber = 1:size(gazeEvent,1)
                % if the subject is looking at the screen but not at the
                % media, which doesn't take up the full screen
                if strcmp(gazeEvent(rowNumber), 'Fixation') && roiSum(rowNumber) ~= 1  && ~isnan(field.gazeonmedia(rowNumber,1)) 
                    fixationNotOnRoi = fixationNotOnRoi + 1;
                end
                % if the subject is looking at the screen but their eyes
                % are moving 
                if strcmp(gazeEvent(rowNumber), 'Saccade') &&  ~isnan(field.gazeonmedia(rowNumber,1))
                    numberOfSaccades = numberOfSaccades+1;
                end
                % if Tobii just doesn't know for sure where the subject is
                % looking
                if strcmp(gazeEvent(rowNumber), 'Unclassified')  && ~isnan(field.gazeonmedia(rowNumber,1))
                    numberOfUnclassifieds = numberOfUnclassifieds+1;
                end
                % if the subject is looking at one of the predefined
                % regions of interest 
                if roiSum(rowNumber) == 1 && ~isnan(field.gazeonmedia(rowNumber,1))
                    roiCount = roiCount+1;
                end
                % how many samples the subject is looking at the media
                % portion of the screen
                if ~isnan(field.gazeonmedia(rowNumber,1)) 
                    samplesOnMedia = samplesOnMedia + 1;
                end
            end
            
            numberOfFixationNotOnRoiVector(subjectNumber, fieldNumber) = fixationNotOnRoi;
            numberOfSamplesOnRoisVector(subjectNumber, fieldNumber) = roiCount;

            numberOfSamplesOnMediaVector(subjectNumber, fieldNumber) = samplesOnMedia;

            numberOfSaccadesVector(subjectNumber,fieldNumber) = numberOfSaccades;
            numberOfUnclassifiedsVector(subjectNumber, fieldNumber) = numberOfUnclassifieds;
        end
        
        %% Sum up the number of Saccades, Unclassifieds, and Fixations for DB conditions and the entire experiment
        numberOfSaccadesTotal(subjectNumber,1) = sum(numberOfSaccadesVector(subjectNumber,:));
        numberOfSaccadesDb(subjectNumber,1) = sum(numberOfSaccadesVector(subjectNumber, 1:11));
        numberOfUnclassifiedsTotal(subjectNumber,1) = sum(numberOfUnclassifiedsVector(subjectNumber,:));
        numberOfUnclassifiedsDb(subjectNumber,1) = sum(numberOfUnclassifiedsVector(subjectNumber,1:11));
        numberOfFixationsNotOnRoiTotal(subjectNumber,1) = sum(numberOfFixationNotOnRoiVector(subjectNumber,:));
        numberOfFixationsNotOnRoiDb(subjectNumber,1) = sum(numberOfFixationNotOnRoiVector(subjectNumber,1:11));
        
    else % if the subject folder is empty, meaning they did not complete the experiment
        numberOfSaccadesTotal(subjectNumber,1) = 0;
        numberOfSaccadesDb(subjectNumber,1) = 0;
        numberOfUnclassifiedsTotal(subjectNumber,1) = 0;
        numberOfUnclassifiedsDb(subjectNumber,1) = 0;
        numberOfFixationsNotOnRoiTotal(subjectNumber,1) = 0;
        numberOfFixationsNotOnRoiDb(subjectNumber,1) = 0; 
    end
    
    %% merge all of these sums into a single matrix to output
        combinedMatrix = horzcat(numberOfSaccadesTotal, numberOfSaccadesDb,...
            numberOfUnclassifiedsTotal, numberOfUnclassifiedsDb, ...
            numberOfFixationsNotOnRoiTotal, numberOfFixationsNotOnRoiDb);

end
%% Find how many samples the subject was looking at the media, but not considered a Saccade, Fixation, or Unclassified
% max(max(difference)) should always be 0, or else something went wrong in
% the data export process. 
difference = numberOfSamplesOnMediaVector -...
    (numberOfSamplesOnRoisVector + numberOfUnclassifiedsVector +...
    numberOfSaccadesVector + numberOfFixationNotOnRoiVector);

%% Export the combinedMatrix variable as an Excel file
cd(thePath)
xlswrite('SaccadeAndUnclassifiedCounts.xlsx', combinedMatrix)