% Copies text files to a separate folder to give to statisticians 

clear 
thePath = 'C:\Users\tmc54\Documents\EyeTracking\NARSAD_EGT';
cd(thePath)
mainFolder = dir;
listOfSubjectFolders = {mainFolder(3:end).name};
textFileFolderDatForProportions = 'C:\Users\tmc54\Documents\EyeTracking\NARSAD_EGT\datForProportionsTextFilesNARSAD';
textFileFolder = 'C:\Users\tmc54\Documents\EyeTracking\NARSAD_EGT\TextFilesNARSAD';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for subjectNumber = 1:size(listOfSubjectFolders,2)
    cd(thePath)
    cd(listOfSubjectFolders{subjectNumber})
    folderContents = dir;
    if(size(folderContents,1)) > 3
        copyfile('*datForProportions.txt', textFileFolderDatForProportions)
        copyfile('*EGT_Analysis.txt', textFileFolder)
    end
end
    

