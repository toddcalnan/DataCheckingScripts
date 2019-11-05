%Moves all Run Logs that you have in thePath into the subject folders in
%thePath. If there is no matching folder for the run log to go in, it just
%won't move. Really quick, significantly better than moving by hand. Just
%copy and paste run logs from Neuro_data into your directory and run this.

clear all
%thePath = 'C:\Users\tmc54\Documents';
thePath = 'C:\Users\tmc54\Documents\EyeTracking\Segment3718';
cd(thePath)
mainFolder = dir;
listOfSubjectFolders = {mainFolder(3:end).name};
label=listOfSubjectFolders; %this will run all subjects that you have in thePath; it pleases me greatly
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

k=size(label);
j=k(2);
for kk=1:j
    cd(thePath)  
    varname = label{kk};
    if size(varname,2) > 9
        if any(strcmp(listOfSubjectFolders, varname(1:9)))
            movefile(varname, varname(1:9))
        end    
    end
end


