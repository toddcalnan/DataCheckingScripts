clearvars
thePath = 'D:\';
cd(thePath)
mainFolder = dir;
fileListToUse = 'ACT_T2_Final_EEG_List_10_9_2018';
[~, ~, raw]=xlsread(fileListToUse);
numberOfSubjects = size(raw,1);
listOfSubjectFolders = {mainFolder(5).name}; %change back to 3:end after testing
label=listOfSubjectFolders; %this will run all subjects that you have in thePath
newDnFolder = 'C:\Users\tmc54\Documents\EEG\dnFiles';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for c = 2:(numberOfSubjects-1)
    cd(thePath)
    varname = [raw{c,1} '_T2'];
    cd(varname)
    toysSegmentNumber = raw{c,2};
    socialSegmentNumber = raw{c,3};
    bubblesSegmentNumber = raw{c,4};
        fileLookUp = 'dn_*';
        dnFileNames = dir(fileLookUp);
        listOfFiles = {dnFileNames.name};
    if ~isempty(listOfFiles)
        for n = 1:size(listOfFiles, 2)
            dnFile = cell2mat(listOfFiles(n));
            if strcmp(dnFile(1:17), ['dn_Toys_Segment_' int2str(toysSegmentNumber)]) || strcmp(dnFile(1:17), ['dn_Socl_Segment_' int2str(socialSegmentNumber)]) || strcmp(dnFile(1:17), ['dn_Bubl_Segment_' int2str(bubblesSegmentNumber)])
                copyfile(dnFile, newDnFolder)
            end
        end
    end
end
