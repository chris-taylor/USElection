function master

    data   = readData;
    munged = mungeData(data);
    result = runModel(munged);
    
    fprintf('Results:\n')
    fprintf('  P(Dem win) = %.1f%%\n',100*result.pDemWin)
    fprintf('  P(GOP win) = %.1f%%\n',100*result.pGopWin)
    
end