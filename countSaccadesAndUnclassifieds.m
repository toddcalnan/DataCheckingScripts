
clear
thePath = 'C:\Users\tmc54\Documents\EyeTracking\DukeACT_EGT\T2Background';
cd(thePath)
mainFolder = dir;
listOfSubjectFolders = {mainFolder(3:end).name};

[numberOfSaccadesTotal, numberOfSaccadesDb, numberOfUnclassifiedsTotal, numberOfUnclassifiedsDb, numberOfFixationsNotOnRoiTotal, numberOfFixationsNotOnRoiDb] = deal(zeros(180, 1)); % preallocating

for index = 1:180
    if index < 10
        number = ['00' num2str(index)];
    elseif (10 <= index) && (index < 100)
        number = ['0' num2str(index)];
    elseif index >= 100
        number = num2str(index);
    end
    subjectList180(index) = {['ACT' number]};
end

subjectList180 = subjectList180';
noDataLine = zeros(1,6);

for i=1:180
    cd(thePath);
    varname = listOfSubjectFolders{i};
    cd(varname);
    contents = dir;
    contents = {contents(3:end).name};
    if ~isempty(contents)
        fileName = [varname '_EGT_Analysis.mat'];
        datFile = load(fileName, ['dat_' varname]);
        datFile = datFile.(['dat_' varname]);
        listOfFields = fields(datFile);
        for fieldNumber = 1:size(listOfFields,1)
            field = datFile.(listOfFields{fieldNumber});
            gazeEvent = field.gazeEventType;
            fixationNotOnRoi = 0;
            numberOfSaccades = 0;
            numberOfUnclassifieds = 0;
            roiCount = 0;
            samplesOnMedia = 0;
            roiSum = field.ROIpenguin+field.ROIrooster+field.ROImoose+field.ROImonkey+field.ROIhands+field.ROIbody+field.ROIeyes+field.ROImouth+field.ROIbackground;
            for rowNumber = 1:size(gazeEvent,1)
                if strcmp(gazeEvent(rowNumber), 'Fixation') && roiSum(rowNumber) ~= 1  && ~isnan(field.gazeonmedia(rowNumber,1)) 
                    fixationNotOnRoi = fixationNotOnRoi + 1;
                end
                if strcmp(gazeEvent(rowNumber), 'Saccade') &&  ~isnan(field.gazeonmedia(rowNumber,1))
                    numberOfSaccades = numberOfSaccades+1;
                end
                if strcmp(gazeEvent(rowNumber), 'Unclassified')  && ~isnan(field.gazeonmedia(rowNumber,1))
                    numberOfUnclassifieds = numberOfUnclassifieds+1;
                end
                if roiSum(rowNumber) == 1 && ~isnan(field.gazeonmedia(rowNumber,1))
                    roiCount = roiCount+1;
                end
                if ~isnan(field.gazeonmedia(rowNumber,1)) 
                    samplesOnMedia = samplesOnMedia + 1;
                end
            end
            numberOfFixationNotOnRoiVector(i, fieldNumber) = fixationNotOnRoi;
            numberOfSamplesOnRois(i, fieldNumber) = roiCount;

            numberOfSamplesOnMedia(i, fieldNumber) = samplesOnMedia;

            numberOfSaccadesVector(i,fieldNumber) = numberOfSaccades;
            numberOfUnclassifiedsVector(i, fieldNumber) = numberOfUnclassifieds;
        end

        numberOfSaccadesTotal(i,1) = sum(numberOfSaccadesVector(i,:));
        numberOfSaccadesDb(i,1) = sum(numberOfSaccadesVector(i, 1:11));
        numberOfUnclassifiedsTotal(i,1) = sum(numberOfUnclassifiedsVector(i,:));
        numberOfUnclassifiedsDb(i,1) = sum(numberOfUnclassifiedsVector(i,1:11));
        numberOfFixationsNotOnRoiTotal(i,1) = sum(numberOfFixationNotOnRoiVector(i,:));
        numberOfFixationsNotOnRoiDb(i,1) = sum(numberOfFixationNotOnRoiVector(i,1:11));
    else
        numberOfSaccadesTotal(i,1) = 0;
        numberOfSaccadesDb(i,1) = 0;
        numberOfUnclassifiedsTotal(i,1) = 0;
        numberOfUnclassifiedsDb(i,1) = 0;
        numberOfFixationsNotOnRoiTotal(i,1) = 0;
        numberOfFixationsNotOnRoiDb(i,1) = 0; 
    end
        combinedMatrix = horzcat(numberOfSaccadesTotal, numberOfSaccadesDb, numberOfUnclassifiedsTotal, numberOfUnclassifiedsDb, numberOfFixationsNotOnRoiTotal, numberOfFixationsNotOnRoiDb);

end
difference = numberOfSamplesOnMedia-(numberOfSamplesOnRois+numberOfUnclassifiedsVector+numberOfSaccadesVector+numberOfFixationNotOnRoiVector);