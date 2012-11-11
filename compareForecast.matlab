function data = compareForecast(forecast,result)

    nCorrect = 0;
    right    = {};
    wrong    = {};
    
    brierScore    = 0;
    logLikelihood = 0;
    
    for ii = 1:length(result.state)
       
        idx = strmatch(result.state{ii},forecast.state,'exact');
        
        prediction = forecast.prediction{idx};
        confidence = forecast.confidence(idx);
        
        if strcmp(prediction,result.result{ii})
            nCorrect      = nCorrect + 1;
            brierScore    = brierScore + (1 - confidence)^2;
            logLikelihood = logLikelihood - log(confidence);
            right{end+1}  = result.state{ii};
        else
            brierScore    = brierScore + confidence^2;
            logLikelihood = logLikelihood - log(1 - confidence);
            wrong{end+1}  = result.state{ii};
        end
        
    end
    
    brierScore = brierScore / length(result.state);
    
    data.nCorrect      = nCorrect;
    data.brierScore    = brierScore;
    data.logLikelihood = logLikelihood;
    data.right         = right;
    data.wrong         = wrong;
    
end