function [ lowvarchans ] = dn_checkVarianceBadChanChecker( datain, varCriteria, numberOfChannels )
% [ low_variance_channels ] = dn_checkVariance( datain, varCriteria ) 
%   datain = Nchan x Nsamp arrray
%   calculates variance across the entire time series and returns any 
%   channels below varCriteria (default = 5)


if nargin ==1
    varCriteria = 5;
end

%a=datain.trial{:};
for n=1:numberOfChannels;
    b(n)=var(squeeze(datain(n,:)));
end

[i,lowvarchans]=find(b < varCriteria); % 5 is arbitrary low variance detection threshold

if ~isempty(lowvarchans)
    disp([' it appears that channels ' num2str(lowvarchans) ' have very low variance, keep an eye on these']);
else
    lowvarchans=0;
    disp('no obvious low variance were channels found');
end

end

