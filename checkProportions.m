% Small script used to double check the math in EGT_Analysis_Master.m 
% EGT_Analysis_Master outputs two text files, one used by the neruo team
% (EGT_Analysis.txt) and one used by the statisticians
% (datForProportions.txt).
% For input, this script wants all of the analyzed subject folders in
% thePath listed below. Each of these subject files should contain both
% subjectName_EGT_Analysis.txt and subjectName_datForProportions.txt.
% Output of this script will be 7 numbers, one for each percentage check.
% These outputted numbers should each be 0 if everything went right.

clear
thePath = 'C:\Users\tmc54\Documents\EyeTracking\DukeACT_EGT\ACT_T1_Background';
cd(thePath)
mainFolder = dir;
listOfSubjectFolders = {mainFolder(3:end).name};
[percentEyesCheck,percentMouthCheck,percentFaceCheck,percentActressTotalCheck,percentActressDbCheck,percentToysTotalCheck,percentToysDbCheck] = deal(zeros(1,size(listOfSubjectFolders,2))); % preallocating


for subjectNumber=1:size(listOfSubjectFolders,2) % run all subjects
    subjectName = listOfSubjectFolders{subjectNumber}; 
    cd(thePath);
    cd(subjectName);
    originalTextFileName = fopen([subjectName '_EGT_Analysis.txt']); 
    datForProportionsName = fopen([subjectName '_datForProportions.txt']);
    originalTextFile = textscan(originalTextFileName, '%f64'); % read data in from EGT_Analysis file
    datForProportions = textscan(datForProportionsName, '%f64'); % read data in from datForProportions file
    datForProportions = datForProportions{1,1}; % pulls the data out of a 1x1 cell array
    originalTextFile = originalTextFile{1,1}; % pulls the data out of a 1x1 cell array
    
    %% Looking at percentages from the datForProportions files
    percentLookingAtEyesDbStats = datForProportions(8)/datForProportions(7); 
    percentLookingAtMouthDbStats = datForProportions(9)/datForProportions(7); 
    percentLookingAtFaceDbStats = (datForProportions(8)+datForProportions(9))/datForProportions(7); 
    percentOnActressAllConditionsStats = datForProportions(10)/datForProportions(6);
    percentOnActressDbStats = datForProportions(11)/datForProportions(7);
    percentTimeOnToysTotalStats = datForProportions(12)/datForProportions(6);
    percentTimeOnToysDbStats = datForProportions(13)/datForProportions(7);

    %% Looking at percentages from the EGT_Analysis file
    percentLookingAtEyesDb = originalTextFile(3);
    percentLookingAtMouthDb = originalTextFile(4);
    percentLookingAtFaceDb = originalTextFile(5);
    percentOnActressAllConditions = originalTextFile(6);
    percentOnActressDb = originalTextFile(7);
    percentTimeOnToysTotal = originalTextFile(12);
    percentTimeOnToysDb = originalTextFile(11);

    %% Compare percentages from EGT_Analysis file and datForProportions file
    % Need to cast the percentages as strings and then do strcmp because 
    % some of the percentages are off by a few hundreths of a percentage, 
    % and MATLAB 2014a doesn't have a rounding function
    percentEyesCheck(subjectNumber) = strcmp(num2str(percentLookingAtEyesDbStats), num2str(percentLookingAtEyesDb));
    percentMouthCheck(subjectNumber) = strcmp(num2str(percentLookingAtMouthDbStats), num2str(percentLookingAtMouthDb));
    percentFaceCheck(subjectNumber) = strcmp(num2str(percentLookingAtFaceDbStats), num2str(percentLookingAtFaceDb));
    percentActressTotalCheck(subjectNumber) = strcmp(num2str(percentOnActressAllConditionsStats), num2str(percentOnActressAllConditions));
    percentActressDbCheck(subjectNumber) = strcmp(num2str(percentOnActressDbStats), num2str(percentOnActressDb));
    percentToysTotalCheck(subjectNumber) = strcmp(num2str(percentTimeOnToysTotalStats), num2str(percentTimeOnToysTotal));
    percentToysDbCheck(subjectNumber) = strcmp(num2str(percentTimeOnToysDbStats), num2str(percentTimeOnToysDb));
    
    fclose all; % close the EGT_Analysis and datForProportions files
end

%% Check to see if all the percentages matched
% If each percentage matched, the sum of percentEyesCheck et al should be 
% equal to the size of percentEyesCheck et al.
size(percentEyesCheck,2)-sum(percentEyesCheck)
size(percentMouthCheck,2)-sum(percentMouthCheck)
size(percentFaceCheck,2)-sum(percentFaceCheck)
size(percentActressTotalCheck,2)-sum(percentActressTotalCheck)
size(percentActressDbCheck,2)-sum(percentActressDbCheck)
size(percentToysTotalCheck,2)-sum(percentToysTotalCheck)
size(percentToysDbCheck,2)-sum(percentToysDbCheck)