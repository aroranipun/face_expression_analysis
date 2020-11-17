import pandas as pd

df = pd.read_csv("data/for_matlab.csv")
time_series = df['press_time'].values