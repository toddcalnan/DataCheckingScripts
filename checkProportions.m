clear
%thePath = 'C:\Users\tmc54\Documents\EyeTracking\NARSAD_EGT';
thePath = 'C:\Users\tmc54\Documents\EyeTracking\DukeACT_EGT\ACT_T1_Background';
cd(thePath)
mainFolder = dir;
listOfSubjectFolders = {mainFolder(3:end).name};
label=listOfSubjectFolders; %this will run all subjects that you have in thePath
labelSize=size(label,2);

a = zeros(1,labelSize);
b = zeros(1,labelSize);
c = zeros(1,labelSize);
d = zeros(1,labelSize);
e = zeros(1,labelSize);
f = zeros(1,labelSize);
g = zeros(1,labelSize);

for i=1:labelSize
    varname = label{i};
    cd(thePath);
    cd(varname);
    originalTextFileName = fopen([varname '_EGT_Analysis.txt']);
    datForProportionsName = fopen([varname '_datForProportions.txt']);
    originalTextFile = textscan(originalTextFileName, '%f64');
    datForProportions = textscan(datForProportionsName, '%f64');
    datForProportions = datForProportions{1,1};
    originalTextFile = originalTextFile{1,1};
    percentLookingAtEyesDbStats = datForProportions(8)/datForProportions(7);
    percentLookingAtMouthDbStats = datForProportions(9)/datForProportions(7);
    percentLookingAtFaceDbStats = (datForProportions(8)+datForProportions(9))/datForProportions(7);
    percentOnActressAllConditionsStats = datForProportions(10)/datForProportions(6);
    percentOnActressDbStats = datForProportions(11)/datForProportions(7);
    percentTimeOnToysTotalStats = datForProportions(12)/datForProportions(6);
    percentTimeOnToysDbStats = datForProportions(13)/datForProportions(7);

    percentLookingAtEyesDb = originalTextFile(3);
    percentLookingAtMouthDb = originalTextFile(4);
    percentLookingAtFaceDb = originalTextFile(5);
    percentOnActressAllConditions = originalTextFile(6);
    percentOnActressDb = originalTextFile(7);
    percentTimeOnToysTotal = originalTextFile(12);
    percentTimeOnToysDb = originalTextFile(11);

    
    a(i) = strcmp(num2str(percentLookingAtEyesDbStats), num2str(percentLookingAtEyesDb));
    b(i) = strcmp(num2str(percentLookingAtMouthDbStats), num2str(percentLookingAtMouthDb));
    c(i) = strcmp(num2str(percentLookingAtFaceDbStats), num2str(percentLookingAtFaceDb));
    d(i) = strcmp(num2str(percentOnActressAllConditionsStats), num2str(percentOnActressAllConditions));
    e(i) = strcmp(num2str(percentOnActressDbStats), num2str(percentOnActressDb));
    f(i) = strcmp(num2str(percentTimeOnToysTotalStats), num2str(percentTimeOnToysTotal));
    g(i) = strcmp(num2str(percentTimeOnToysDbStats), num2str(percentTimeOnToysDb));
    
    fclose all;
end


size(a,2)-sum(a)
size(b,2)-sum(b)
size(c,2)-sum(c)
size(d,2)-sum(d)
size(e,2)-sum(e)
size(f,2)-sum(f)
size(g,2)-sum(g)