%%Goes through all of the folders in the given path, opens up all of the
%%.txt files outputted from DukeACTT_EGT_Analysis_Master, and pulls various 
%%pieces of the text file, such as total number of samples and DB samples, 
%%calculates averages, ranges, that kind of thing 
clear
%thePath = 'C:\Users\tmc54\Documents\EyeTracking\NARSAD_EGT';
%thePath = 'C:\Users\tmc54\Documents\EyeTracking\DukeACT_EGT\T2';
thePath = 'C:\Users\tmc54\Desktop\Segmented2';
cd(thePath)
mainFolder = dir;
listOfSubjectFolders = {mainFolder(3:end).name};
label=listOfSubjectFolders; %this will run all subjects that you have in thePath
labelSize=size(label,2);
percentTracked = zeros([labelSize 1]);
totalSamples = zeros([labelSize 1]);
totalDBSamples = zeros([labelSize 1]);
proportionAdditionsAllConditions = zeros([labelSize 1]);
proportionAdditionsDB = zeros([labelSize 1]);
for i=1:labelSize
    varname = label{i};
    cd(thePath);
    cd(varname);
    fileID = fopen([varname '_EGT_Analysis.txt']);
    file = textscan(fileID, '%f64');
    file = file{1, 1};
    percentTracked(i, 1) = file(1, 1);
    totalSamples(i, 1) = file(8, 1);
    totalDBSamples(i, 1) = file(9, 1);
    
    proportionAdditionsAllConditions(i, 1) = file(6,1)+file(12,1);
    proportionAdditionsDB(i,1) = file(7,1)+file(11,1);
    if file(1,1) > 1 || file(2,1) > 1 || file(3,1) > 1 || file(4,1) > 1 || file(5,1) > 1 || file(6,1) > 1 || file(7,1) > 1 || file(11,1) > 1 || file(12,1) > 1 
        disp(['**********' varname ' has a proportion greater than 1, look into it **********'])
    end
    if proportionAdditionsAllConditions(i,1) > 1
        disp(['*********' varname ' has a proportion of actress + toys for all conditions greater than 1 ********'])
    end
    if proportionAdditionsDB(i,1) > 1
        disp(['*********' varname ' has a proportion of actress + toys for DB conditions greater than 1 ********'])
    end
    if totalSamples(i,1) < 19970
        disp(['********* ' varname ' has a low totalSample count of ' num2str(totalSamples(i,1)) ', look into it *********'])
    end
    if totalSamples(i,1) > 19978
        disp(['********* ' varname ' has a high totalSample count of ' num2str(totalSamples(i,1)) ', look into it *********'])
    end
    if totalDBSamples(i,1) < 6530
        disp(['********* ' varname ' has a low totalDBSample count of ' num2str(totalDBSamples(i,1)) ', look into it *********'])
    end
    if totalDBSamples(i,1) > 6534
        disp(['********* ' varname ' has a high totalDBSample count of ' num2str(totalDBSamples(i,1)) ', look into it *********'])
    end
    
    fclose all;
end

disp(['The number of subjects analyzed so far is ' num2str(labelSize)])
disp(['The mean percent tracked is ' num2str(mean(percentTracked))])
disp(['The standard deviation is ' num2str(std(percentTracked))])
disp(['The lowest percent tracked is ' num2str(min(percentTracked))])
disp(['The highest percent tracked is ' num2str(max(percentTracked))])
disp(['The average totalSample count is ' num2str(mean(totalSamples))])
disp(['The average totalDBSample count is ' num2str(mean(totalDBSamples))])
disp(['The median totalSample count is ' num2str(median(totalSamples))])
disp(['The median totalDBSample count is ' num2str(median(totalDBSamples))])
disp(['The standard deviation totalSample count is ' num2str(std(totalSamples))])
disp(['The standard deviation totalDBSample count is ' num2str(std(totalDBSamples))])
disp(['The lowest totalSample count is ' num2str(min(totalSamples))])
disp(['The lowest totalDBSample count is ' num2str(min(totalDBSamples))])
disp(['The highest totalSample count is ' num2str(max(totalSamples))])
disp(['The highest totalDBSample count is ' num2str(max(totalDBSamples))])
disp(['The highest proportionAdditionAllConditions is ' num2str(max(proportionAdditionsAllConditions))])
disp(['The highest proportionAdditionDB is ' num2str(max(proportionAdditionsDB))])