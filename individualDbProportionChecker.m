clear
excelPath = 'C:\Users\tmc54\Documents';
cd(excelPath)
excelFile = xlsread('rawSampleCountsSeperateDBsT2.xlsx');
thePath = 'C:\Users\tmc54\Documents\EyeTracking\DukeACT_EGT\T2Background';
cd(thePath)
mainFolder = dir;
listOfSubjectFolders = {mainFolder(3:end).name};
label=listOfSubjectFolders; %this will run all subjects that you have in thePath
j=size(label,2);

for folderNumber=1:j
    cd(thePath)
    varname = label{folderNumber}(1:9);  %for DukeACT
    filename=[ varname '_EGT_Analysis.txt'];
    cd(varname);
    analysisFile = load(filename);
    
    monkeyCount = sum(excelFile(folderNumber, 2:10:end));
    mooseCount = sum(excelFile(folderNumber, 3:10:end));
    roosterCount = sum(excelFile(folderNumber, 4:10:end));
    penguinCount = sum(excelFile(folderNumber, 5:10:end));
    
    handsCount = sum(excelFile(folderNumber, 6:10:end));
    bodyCount = sum(excelFile(folderNumber, 7:10:end));
    eyesCount = sum(excelFile(folderNumber, 8:10:end));
    mouthCount = sum(excelFile(folderNumber, 9:10:end));
    
    actressCount = mouthCount + eyesCount + bodyCount + handsCount;
    toysCount = monkeyCount + mooseCount + roosterCount + penguinCount;
    
    sampleCount = sum(excelFile(folderNumber, 1:10:end));
    
    actressProportion = actressCount/sampleCount;
    toysProportion = toysCount/sampleCount;
    eyesProportion = eyesCount/sampleCount;
    mouthProportion = mouthCount/sampleCount;
    
    a(folderNumber) = strcmp(num2str(actressProportion), num2str(analysisFile(7)));
    b(folderNumber) = strcmp(num2str(toysProportion), num2str(analysisFile(11)));
    c(folderNumber) = strcmp(num2str(eyesProportion), num2str(analysisFile(3)));
    d(folderNumber) = strcmp(num2str(mouthProportion), num2str(analysisFile(4)));
    e(folderNumber) = strcmp(num2str(sampleCount), num2str(analysisFile(10)));
end