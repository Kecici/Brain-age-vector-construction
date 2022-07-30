### Brain volumes normalization by ICV 

import pandas as pd
import numpy as np

volume = pd.read_csv(r"D:\rc111\paper\csv\data7\ff_HC.csv")
icv = pd.read_csv(r"D:\rc111\paper\csv\data7\ICV_summury_HC.csv")
info = pd.read_csv(r"D:\rc111\paper\csv\data7\HC2022_3DT1bl_4_21_2022.csv")

features = icv.drop(columns=['name']).columns
for feas in features:
    icv[feas] = icv1[feas] * 1000000
    
rel_volume = pd.merge(volume, icv, on='name')
feature = rel_volume.drop(columns=['name','ICV']).columns

for fea in feature:
    rel_volume[fea] = rel_volume[fea] / rel_volume['ICV']
    
rel_volume = rel_volume.drop(columns=['ICV','sum_vol'])
rel_volume = pd.merge(rel_volume, info[['name','Sex','Age']], on='name')

for i in range(np.shape(rel_volume)[0]):
    if rel_volume.loc[i,'Sex'] == 'F':
        rel_volume.loc[i,'Sex'] = 0
    if rel_volume.loc[i,'Sex'] == 'M':
        rel_volume.loc[i,'Sex'] = 1

rel_volume.to_csv(r"D:\rc111\paper\csv\data7\HC2022.csv", index=False)
print(rel_volume)
