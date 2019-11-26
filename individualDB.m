% Pulls out raw sample counts on total samples viewing media as well as 
% total samples on each ROI for each subject. 
% The path should contain all of the analyzed subject files outputted from
% EGT_Analysis_Master.
% Output will be an Excel file containing a large matrix of sample counts.
% Rows will be the subjects
% Columns will be total samples on media, followed by the 10 ROI counts.
% These columns are repeated 10 more times, for a total of 11 sets, one per
% DB condition

clear
thePath = 'C:\Users\tmc54\Documents\EyeTracking\DukeACT\T2Background';
outputFileName = 'rawSampleCountsSeperateDBsT2.xlsx'; % the name of the output file
cd(thePath)
mainFolder = dir;
listOfSubjectFolders = {mainFolder(3:end).name};
allSubjectsRawCounts = []; % preallocating

for folderNumber=1:size(listOfSubjectFolders,2) % go through all subjects
    cd(thePath)
    subjectName = listOfSubjectFolders{folderNumber}(1:9);  %for DukeACT
    filename=[ subjectName '_EGT_Analysis.mat'];
    cd(subjectName);
    analysisFile = load(filename, ['ACT_Data_' subjectName]);
    datFile = analysisFile.(['ACT_Data_' subjectName]);
    listOfSegmentNames = fieldnames(datFile);
    subjectRawCounts = []; % preallocating
    for segmentNumber = 1:11 % 11 DB segments, out of 21 total segments
        dbSegment = datFile.(listOfSegmentNames{segmentNumber}); % pull the data for an individual DB segment
        % Each dbSegment has 2 rows, the first are the headers, the second
        % is the actual data
        % Column 5 is the samples viewing media, while columns 7:14,16,25
        % are the total samples in each ROI
        subjectRawCounts = [subjectRawCounts, dbSegment{2,[5,7:14,16,25]}];
    end
    %% Merge all subjectRawCounts into a single matrix
    allSubjectsRawCounts = [allSubjectsRawCounts; subjectRawCounts];
end

%% Write output Excel file
xlswrite(outputFileName, allSubjectsRawCounts);