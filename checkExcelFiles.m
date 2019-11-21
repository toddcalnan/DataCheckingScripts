% Script created in response to realizing that different eye tracking
% computers were exporting files with different settings. This script is
% meant to be run after all eye tracking data has been exported from the
% Tobii computers at both sites. 

% This script will check to make sure that:
% Files from both sites are using the appropriate filters. 
% There are all 3 Gaze Event Types (Fixation, Saccade, Unclassified). 
% There are 21 unique segments for each subject.
% There is only one subject in each Excel file. 

clear
thePath = 'C:\Users\tmc54\Desktop\Segmented2';
cd(thePath)
mainFolder = dir;
listOfSubjectFolders = {mainFolder(3:end).name};
[wrongFilterType, subjectNamesDifferent, multipleSubjectsInOneFile, ...
 missingGazeEventType, abnormalNumberOfUniqueSegments, wrongFinalSegment,...
 wrongColumns] = deal(zeros(size(listOfSubjectFolders)));
%%

segmentNames={'DB1' 'DB2' 'DB3' 'DB4' 'DB5' 'DB6' 'DB7' 'DB8' 'DB9' 'DB10' 'DB11' 'JAmonkey' 'JAmoose' 'JArooster' 'JApenguin' 'sandwich1' 'sandwich2' 'MTmonkey' 'MTmoose' 'MTrooster' 'MTpenguin'}; % The list of names for each segment in the Sandwich Lady video
for folderNumber=1:size(listOfSubjectFolders,2)
    cd(thePath)
    subjectName = listOfSubjectFolders{folderNumber};
    filename=[ subjectName 'a.xls'];
    cd(subjectName);
    [~, ~, raw]=xlsread(filename); % load the subject's Excel file
    headers = raw(1,:); % saving the headers as a seperate variable, used at the end of this script
    raw = raw(2:end,:); % removing the headers
    
    %% Check what filter type was used during the export process
    
    filterType = unique(raw(:,10)); % pull out the filter Type column, there should only be 1 value
    if ~strcmp(filterType, 'I-VT filter')
        wrongFilterType(folderNumber) = 1; % if the filter used was not I-VT, flag this subject
    end
    
    %% Check that there is only one subject name in the Excel file and that the subject name in Excel matches the Excel file name
    
    subjectNameFromExcel = unique(raw(:,6)); % pull out the subject name from the Excel file, there should only be 1 value
    if ~strcmp(subjectNameFromExcel, subjectName)
        subjectNamesDifferent(folderNumber) = 1; % if the subject name in the file is not the same as the subject name in the file name itself, flag this file
    end
    if size(subjectNameFromExcel,1) > 1
        multipleSubjectsInOneFile(folderNumber) = 1; % if there are multiple subject names in the file, flag this file
    end
    
    %% Check that there are Fixations, Saccades, and Unclassifieds
    
    gazeEventTypes = unique(raw(:,44)); % pull out the gaze event type column
    fixationCheck = find(ismember(gazeEventTypes, 'Fixation')); % check for Fixations
    saccadeCheck = find(ismember(gazeEventTypes, 'Saccade')); % check for Saccades
    unclassifiedCheck = find(ismember(gazeEventTypes, 'Unclassified')); % check for Unclassifieds 
    
    if isempty(fixationCheck) && isempty(saccadeCheck) && isempty(unclassifiedCheck)
        missingGazeEventType(folderNumber) = 1;
    end
    
    %% Check Number of Unique Segments
    
    numberOfUniqueSegments = size(unique(cellstr(raw(:,16))),1);
    if numberOfUniqueSegments ~= 21 % We expect 21 unique segments in a normal experiment
        abnormalNumberOfUniqueSegments(folderNumber) = 1;
    end
    
    % If the last segment isn't segment 21, there is a problem
    if ~strcmp(raw(end,16),'21')
        wrongFinalSegment(folderNumber) = 1;
    end
    
    %% Check the order of the columns
    
    if ~isequal(txt(1, :), {'ExportDate','StudioVersionRec','StudioProjectName','StudioTestName','ParticipantName','RecordingName','RecordingDate','RecordingDuration','RecordingResolution','FixationFilter','MediaName','MediaPosX (ADCSpx)','MediaPosY (ADCSpx)','MediaWidth','MediaHeight','SegmentName','SegmentStart','SegmentEnd','SegmentDuration','SceneName','SceneSegmentStart','SceneSegmentEnd','SceneSegmentDuration','RecordingTimestamp','LocalTimeStamp','EyeTrackerTimestamp','MouseEventIndex','MouseEvent','MouseEventX (ADCSpx)','MouseEventY (ADCSpx)','MouseEventX (MCSpx)','MouseEventY (MCSpx)','KeyPressEventIndex','KeyPressEvent','StudioEventIndex','StudioEvent','StudioEventData','ExternalEventIndex','ExternalEvent','ExternalEventValue','EventMarkerValue','FixationIndex','SaccadeIndex','GazeEventType','GazeEventDuration','FixationPointX (MCSpx)','FixationPointY (MCSpx)','AOI[Penguin]Hit','AOI[Rooster]Hit','AOI[Moose]Hit','AOI[Monkey]Hit','AOI[Hands]Hit','AOI[Body]Hit','AOI[Eyes]Hit','AOI[Mouth]Hit','AOI[Background]Hit','GazePointIndex','GazePointLeftX (ADCSpx)','GazePointLeftY (ADCSpx)','GazePointRightX (ADCSpx)','GazePointRightY (ADCSpx)','GazePointX (ADCSpx)','GazePointY (ADCSpx)','GazePointX (MCSpx)','GazePointY (MCSpx)','GazePointLeftX (ADCSmm)','GazePointLeftY (ADCSmm)','GazePointRightX (ADCSmm)','GazePointRightY (ADCSmm)','StrictAverageGazePointX (ADCSmm)','StrictAverageGazePointY (ADCSmm)','EyePosLeftX (ADCSmm)','EyePosLeftY (ADCSmm)','EyePosLeftZ (ADCSmm)','EyePosRightX (ADCSmm)','EyePosRightY (ADCSmm)','EyePosRightZ (ADCSmm)','CamLeftX','CamLeftY','CamRightX','CamRightY','DistanceLeft','DistanceRight','PupilLeft','PupilRight','ValidityLeft','ValidityRight','IRMarkerCount','IRMarkerID','PupilGlassesRight'})
        wrongColumns(folderNumber) = 1;
    end
end
