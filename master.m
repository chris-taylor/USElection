function master

    data   = readData;
    munged = mungeData(data);
    result = runModel(munged);
    
    fprintf('Results:\n')
    fprintf('  P(Dem win) = %4.1f%%\n',100*result.pDemWin)
    fprintf('  P(GOP win) = %4.1f%%\n',100*result.pGopWin)
    fprintf('  P(Tie)     = %4.1f%%\n',100*result.pTie)
    
end