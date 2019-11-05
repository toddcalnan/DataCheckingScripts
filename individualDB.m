clear
thePath = 'C:\Users\tmc54\Documents\EyeTracking\DukeACT_EGT\T2Background';
cd(thePath)
mainFolder = dir;
listOfSubjectFolders = {mainFolder(3:end).name};
label=listOfSubjectFolders; %this will run all subjects that you have in thePath
j=size(label,2);
allSubjectsRawCounts = [];

for folderNumber=1
    cd(thePath)
    varname = label{folderNumber}(1:9);  %for DukeACT
    filename=[ varname '_EGT_Analysis.mat'];
    cd(varname);
    analysisFile = load(filename, ['ACT_Data_' varname]);
    datFile = analysisFile.(['ACT_Data_' varname]);
    listOfSegmentNames = fieldnames(datFile);
    subjectRawCounts = [];
    for segmentNumber = 1:11 % 11 DB segments
        dbSegment = datFile.(listOfSegmentNames{segmentNumber});
        subjectRawCounts = [subjectRawCounts, dbSegment{2,[5,7:14,25]}];
    end
    
    allSubjectsRawCounts = [allSubjectsRawCounts; subjectRawCounts];
end