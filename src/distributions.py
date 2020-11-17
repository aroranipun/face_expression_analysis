import warnings
import numpy as np
import pandas as pd
import scipy.stats as st
import statsmodels as sm
import matplotlib
import matplotlib.pyplot as plt


import numpy as np
from statsmodels.base.model import GenericLikelihoodModel

from scipy.stats import gamma
shape = 12; loc = 0.71; scale = 0.0166
data = record["peaks"]
params = gamma.fit(data) # params close to but not the same as (shape, loc, scale)
# HOW TO ESTIMATE/GET ERRORS FOR EACH PARAM?

print(params)
print('\n')


class Gamma(GenericLikelihoodModel):

    nparams = 3

    def loglike(self, params):
        return gamma.logpdf(self.endog, *params).sum()


res = Gamma(data).fit(start_params=params)
res.df_model = len(params)
res.df_resid = len(data) - len(params)
print(res.summary())