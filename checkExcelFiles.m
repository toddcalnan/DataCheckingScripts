clear
thePath = 'C:\Users\tmc54\Desktop\Segmented2';
cd(thePath)
mainFolder = dir;
listOfSubjectFolders = {mainFolder(3:end).name};
label=listOfSubjectFolders; %this will run all subjects that you have in thePath
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
segmentNames={'DB1' 'DB2' 'DB3' 'DB4' 'DB5' 'DB6' 'DB7' 'DB8' 'DB9' 'DB10' 'DB11' 'JAmonkey' 'JAmoose' 'JArooster' 'JApenguin' 'sandwich1' 'sandwich2' 'MTmonkey' 'MTmoose' 'MTrooster' 'MTpenguin'};
j=size(label,2);
for folderNumber=1:j
    cd(thePath)
    varname = label{folderNumber};
    filename=[ varname 'a.xls']
    cd(varname);
    [num, txt, raw]=xlsread(filename); 
    raw = raw(2:end,:);
    
    %% Check what filter type was used during the export process
    
    filterType = unique(raw(:,10));
    if ~strcmp(filterType, 'I-VT filter')
        wrongFilterType(folderNumber) = 1;
    end
    
    %% Check that there is only one subject name in the Excel file and that the subject name in Excel matches the Excel file name
    
    subjectNameFromExcel(folderNumber) = unique(raw(:,6));
    if ~strcmp(subjectNameFromExcel(folderNumber), varname)
        subjectNamesDifferent(folderNumber) = 1;
    end
    if size(subjectNameFromExcel,1) > 1
        multipleSubjectsInOneFile(folderNumber) = 1;
    end
    
    %% Check that there are Fixations, Saccades, and Unclassifieds
    
    gazeEventTypes = unique(raw(:,44));
    fixationCheck = find(ismember(gazeEventTypes, 'Fixation'));
    saccadeCheck = find(ismember(gazeEventTypes, 'Saccade'));
    unclassifiedCheck = find(ismember(gazeEventTypes, 'Unclassified'));
    
    if isempty(fixationCheck) && isempty(saccadeCheck) && isempty(unclassifiedCheck)
        missingGazeEventType(folderNumber) = 1;
    end
    
    %% Check Number of Unique Segments
    % *** Still need to check if there is another segment after segment 21
    numberOfUniqueSegments = size(unique(cellstr(raw(:,16))),1);
    if numberOfUniqueSegments ~= 21
        abnormalNumberOfUniqueSegments(folderNumber) = 1;
    end
    
    if ~strcmp(raw(end,16),'21')
        wrongFinalSegment(folderNumber) = 1;
    end
    
    if ~isequal(txt(1, :), {'ExportDate','StudioVersionRec','StudioProjectName','StudioTestName','ParticipantName','RecordingName','RecordingDate','RecordingDuration','RecordingResolution','FixationFilter','MediaName','MediaPosX (ADCSpx)','MediaPosY (ADCSpx)','MediaWidth','MediaHeight','SegmentName','SegmentStart','SegmentEnd','SegmentDuration','SceneName','SceneSegmentStart','SceneSegmentEnd','SceneSegmentDuration','RecordingTimestamp','LocalTimeStamp','EyeTrackerTimestamp','MouseEventIndex','MouseEvent','MouseEventX (ADCSpx)','MouseEventY (ADCSpx)','MouseEventX (MCSpx)','MouseEventY (MCSpx)','KeyPressEventIndex','KeyPressEvent','StudioEventIndex','StudioEvent','StudioEventData','ExternalEventIndex','ExternalEvent','ExternalEventValue','EventMarkerValue','FixationIndex','SaccadeIndex','GazeEventType','GazeEventDuration','FixationPointX (MCSpx)','FixationPointY (MCSpx)','AOI[Penguin]Hit','AOI[Rooster]Hit','AOI[Moose]Hit','AOI[Monkey]Hit','AOI[Hands]Hit','AOI[Body]Hit','AOI[Eyes]Hit','AOI[Mouth]Hit','AOI[Background]Hit','GazePointIndex','GazePointLeftX (ADCSpx)','GazePointLeftY (ADCSpx)','GazePointRightX (ADCSpx)','GazePointRightY (ADCSpx)','GazePointX (ADCSpx)','GazePointY (ADCSpx)','GazePointX (MCSpx)','GazePointY (MCSpx)','GazePointLeftX (ADCSmm)','GazePointLeftY (ADCSmm)','GazePointRightX (ADCSmm)','GazePointRightY (ADCSmm)','StrictAverageGazePointX (ADCSmm)','StrictAverageGazePointY (ADCSmm)','EyePosLeftX (ADCSmm)','EyePosLeftY (ADCSmm)','EyePosLeftZ (ADCSmm)','EyePosRightX (ADCSmm)','EyePosRightY (ADCSmm)','EyePosRightZ (ADCSmm)','CamLeftX','CamLeftY','CamRightX','CamRightY','DistanceLeft','DistanceRight','PupilLeft','PupilRight','ValidityLeft','ValidityRight','IRMarkerCount','IRMarkerID','PupilGlassesRight'})
        wrongColumns(folderNumber) = 1;
    end
end
