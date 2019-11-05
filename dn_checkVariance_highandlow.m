function [ varchans ] = dn_checkVariance_highandlow( datain, varCriteria_low, varCriteria_high, numberOfChannels )
% [ low_variance_channels ] = dn_checkVariance( datain, varCriteria ) 
%   datain = Nchan x Nsamp arrray calculates variance across the entire
%   time series and returns any channels below varCriteria_low (default =
%   5) and any channels above varCriteria_high (default = 28000) in a
%   combined vector varchans

%% Find high & low variance channels
if nargin ==1
    varCriteria_low = 5; %5 is an arbitrary low variance detection threshold
    varCriteria_high = 28000; % 28000 is an abitrary high variance detection threshold
end

%a=datain.trial{:}; TMC removal
for n=1:numberOfChannels;
    b(n)=var(squeeze(datain(n,:)));
end

[i,lowvarchans]=find(b < varCriteria_low); 
[j,highvarchans]=find(b > varCriteria_high);


%% Display high & low variance channels
if ~isempty(lowvarchans)
    disp([' It appears that channels ' num2str(lowvarchans) ' have very low variance. Keep an eye on these']);
else
    lowvarchans=0;
    disp('No obvious low variance were channels found.');
end

if ~isempty(highvarchans)
    disp([' It appears that channels ' num2str(highvarchans) ' have very high variance. Keep an eye on these']);
else
    highvarchans=0;
    disp(' No obvious high variance were channels found.');
end

%% Combine high & low variance channels, and remove zeros from final combined vector
varchans_temp = [lowvarchans , highvarchans];
varchans = varchans_temp(varchans_temp~=0);

end

