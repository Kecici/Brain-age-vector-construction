### Brain age model training and estimation

import pandas as pd
import numpy as np
import joblib
import xgboost as xgb

data = pd.read_csv(r"D:\rc111\paper\csv\data5\rel_volume_test.csv")
X_test = data.drop(columns=['name','age,','sites'])
y_test = data['age']

data0 = pd.read_csv(r"D:\rc111\paper\csv\data5\rel_volume_train.csv")
X = data0.drop(columns=['name','age','sites'])
y = data0['age']

# for fea in features:
#     Max = np.max(X[fea])
#     Min = np.min(X[fea])
#     X[fea] = MinMaxNormalization(X[fea], Max, Min)
#     X_test[fea] = MinMaxNormalization(X_test[fea], Max, Min)


model = xgb.XGBRegressor(learning_rate=0.01, n_estimators=6000, max_depth=7, subsample=0.8)
model.fit(X, y)
joblib.dump(model, r"D:\rc111\paper\model\brain_age_estimator.m")

y_pred = model.predict(X_test)
gap = y_pred - y_test

BA_gap = pd.DataFrame(gap, columns=['gap'])
BA_gap['name'] = data['name']
print(BA_gap)
