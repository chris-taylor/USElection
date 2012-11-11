function optimizeParams(year,window,method)

    data   = readData(year);
    
    paramvals = linspace(0.0, 0.01, 11);
    
    actual = loadResults(year);
    
    brier = zeros(size(paramvals));
    logLik = zeros(size(paramvals));
    
    for ii = 1:length(paramvals)
        munged     = mungeData(data,window,method);
        forecast   = runModel(munged,0.0,paramvals(ii));
        score      = compareForecast(forecast,actual);
        
        brier(ii)  = score.brierScore;
        logLik(ii) = score.logLikelihood;
    end
    
    figure;
    plot(100*paramvals,brier);
    xlabel('Poll error (%)')
    ylabel('Brier Score')
    title('Brier Score')
    
    figure;
    plot(100*paramvals,logLik)
    xlabel('Poll error (%)')
    ylabel('Negative log likelihood')
    title('Negative log likelihood')

end