% Small scripts that makes copies of our dn output files from EEG analysis
% in FieldTrip 

clear
thePath = 'D:\'; % Where all of the subject data is located 
cd(thePath)
mainFolder = dir;
fileListToUse = 'ACT_T2_Final_EEG_List_10_9_2018'; % List of what subjects we are actually calling valid, ignore the others
[~, ~, raw]=xlsread(fileListToUse); % load in the good subject file list
numberOfSubjects = size(raw,1);
listOfSubjectFolders = {mainFolder(3:end).name}; % change back to 3:end after testing
newDnFolder = 'C:\Users\tmc54\Documents\EEG\dnFiles';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for c = 2:(numberOfSubjects-1)
    cd(thePath)
    varname = [raw{c,1} '_T2'];
    cd(varname)
    toysSegmentNumber = raw{c,2};
    socialSegmentNumber = raw{c,3};
    bubblesSegmentNumber = raw{c,4};
        fileLookUp = 'dn_*'; % we only care about the files starting with 'dn_'
        dnFileNames = dir(fileLookUp); % find files starting with 'dn_' in the current directory
        listOfFiles = {dnFileNames.name}; % a list of those files that start with 'dn_'
    if ~isempty(listOfFiles) % If dn files exist in the subject's folder
        for n = 1:size(listOfFiles, 2)
            dnFile = cell2mat(listOfFiles(n));
            if strcmp(dnFile(1:17), ['dn_Toys_Segment_' int2str(toysSegmentNumber)])...
                    || strcmp(dnFile(1:17), ['dn_Socl_Segment_' int2str(socialSegmentNumber)])...
                    || strcmp(dnFile(1:17), ['dn_Bubl_Segment_' int2str(bubblesSegmentNumber)])
                copyfile(dnFile, newDnFolder)
            end
        end
    end
end
