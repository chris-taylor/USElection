function result = master(year)

    if nargin < 1
        year = 2012;
    end

    data   = readData(year);
    munged = mungeData(data);
    result = runModel(munged);
    
    fprintf('Results:\n')
    fprintf('  P(Dem win) = %6.2f%%\n',100*result.pDemWin)
    fprintf('  P(GOP win) = %6.2f%%\n',100*result.pGopWin)
    fprintf('  P(Tie)     = %6.2f%%\n',100*result.pTied)
    
    % Write output file
    fname = sprintf('forecast/USElectionForecast%s%s.csv',num2str(year),datestr(date,'mmmdd'));
    fid = fopen(fname,'w');
    
    fprintf(fid,'State,Winner,Confidence\n');
    
    for ii = 1:length(result.state)
        if result.pStateDem(ii) > 0.5
            party = 'DEM';
            conf  = 100 * result.pStateDem(ii);
        else
            party  = 'REP';
            conf   = 100 * result.pStateGop(ii);
        end
        
        fprintf(fid,'%s,%s,%.0f%%\n',result.state{ii},party,conf);
    end
    fclose(fid);
    
end