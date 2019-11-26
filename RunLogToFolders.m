% Moves all Run Logs that you have in thePath into the subject folders in
% thePath. If there is no matching folder for the run log to go in, it just
% won't move. Really quick, significantly better than moving by hand. Just
% copy and paste run logs from Neuro_data into your directory and run this.

clear
thePath = 'C:\Users\tmc54\Documents\EyeTracking\Segment3718';
cd(thePath)
mainFolder = dir;
listOfSubjectFolders = {mainFolder(3:end).name};
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for subjectNumber=1:size(listOfSubjectFolders,2)
    cd(thePath)  
    subjectName = listOfSubjectFolders{subjectNumber};
    if size(subjectName,2) > 9
        if any(strcmp(listOfSubjectFolders, subjectName(1:9)))
            movefile(subjectName, subjectName(1:9))
        end    
    end
end


