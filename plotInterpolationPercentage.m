clear
thePathNew = 'C:\Users\tmc54\Desktop\T1Background';
%thePathNew = 'C:\Users\tmc54\Documents\EyeTracking\NARSAD_EGT';
cd(thePathNew)
mainFolder = dir;
listOfSubjectFolders = {mainFolder(3:end).name};
label=listOfSubjectFolders; %this will run all subjects that you have in thePath
labelSize=size(label,2);

for i=1:labelSize
    cd(thePathNew)
    varname = label{i};
    cd(varname)
    filename=[ varname '_EGT_Analysis.mat'];
    interpolationPercentage = load(filename, 'interpolationPercentage*');
    interpolationPercentage = interpolationPercentage.(['interpolationPercentage_' varname]);
    interpolationPercent(i) = interpolationPercentage*100;
    fclose all;
end
    
scatter(1:labelSize, interpolationPercent)
title('ACT T1 Interpolation Percentage')
xlabel('Subject Number (out of valids)')
ylabel('Interpolation Percentage')