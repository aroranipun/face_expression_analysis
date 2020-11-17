from scipy.signal import find_peaks , find_peaks_cwt
import scipy.stats as stats
import matplotlib.pyplot as plt
import numpy as np

def plot_peaks(time_series):
    peak_indexes, _ = find_peaks(record["time_series"])

    plt.plot(record["time_series"])
    plt.plot(peak_indexes, record["time_series"][peak_indexes], "x")
    plt.plot(np.zeros_like(record["time_series"]), "--", color="gray")
def build_mm_record(dist_ts="gamma", valleys=False):


dist_ts="gamma"
valleys=False


record = {}
record["time_series"] = time_series
if valleys:
    record["time_series"] = -time_series - min(-time_series)

#Peaks
record["peaks_loc"], _ = find_peaks(record["time_series"])
record["peaks"] = record["time_series"][record["peaks_loc"]]

shape, loc, scale = params = stats.gamma.fit(record["peaks"] )
loglh = stats.gamma.logpdf(record["peaks"], shape, lo
c, scale).sum()
record['time_series_']


from statsmodels.base.model import GenericLikelihoodModel


class Gamma(GenericLikelihoodModel):

    nparams = 3

    def loglike(self, params):
        return gamma.logpdf(self.endog, *params).sum()

from scipy.stats import gamma
res = Gamma(record["peaks"]).fit(start_params=params)
res.df_model = len(params)
res.df_resid = len(data) - len(params)
print(res.summary())