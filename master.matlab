function result = master

    data   = readData;
    munged = mungeData(data);
    result = runModel(munged);
    
    fprintf('Results:\n')
    fprintf('  P(Dem win) = %6.2f%%\n',100*result.pDemWin)
    fprintf('  P(GOP win) = %6.2f%%\n',100*result.pGopWin)
    fprintf('  P(Tie)     = %6.2f%%\n',100*result.pTied)
    
    % Write output file
    fname = sprintf('USElectionForecast%s.csv',datestr(date,'yyyymmdd'));
    fid = fopen(fname,'w');
    for ii = 1:length(result.state)
        if result.pStateDem(ii) > 0.5
            party = 'DEM';
        else
            party  = 'REP';
        end
        fprintf(fid,'%s,%s,%f,%f\n',result.state{ii},party,result.pStateDem(ii),result.pStateGop(ii));
    end
    fclose(fid);
    
end