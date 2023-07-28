# Bitcoin Price Prediction with Machine Learning and On-Chain Metrics

The main notebooks can be found in: src/python/main-experiment-notebooks
This repository contains a collection of Jupyter notebooks detailing a machine learning project for predicting Bitcoin prices. The project utilizes two datasets, `ta_df` and `oc_ta_df`, which include Bitcoin prices, technical indicators, and on-chain metrics. 

## Content

Here's a brief description of what each notebook does:

1. **`1-exploratory.ipynb`**: This notebook is the initial exploration of our datasets. It contains visualization of data, outlier detection, correlation analysis.

2. **`2-experiment_1.ipynb`**: This notebook trains BiLSTM and BiRNN models on the `ta_df` and `oc_ta_df` datasets. The objective is to quantify the impact of including on-chain metrics in the model. It provides initial insights into how on-chain metrics influence the model's predictive performance.

3. **`3-hypertuning_tadf_birnn.ipynb`** and **`4-hypertuning_tadf_bilstm.ipynb`**: These notebooks perform hyperparameter tuning for the BiRNN and BiLSTM models, respectively, on the `ta_df` dataset without any human intervention. The goal here is to ensure that the results from the first experiment are not merely due to the selection of hyperparameters.

5. **`5-experiment_2.ipynb`**: This notebook repeats the process of `2-experiment_1.ipynb`, but now using the hyperparameters obtained from the tuning notebooks (`3-hypertuning_tadf_birnn.ipynb` and `4-hypertuning_tadf_bilstm.ipynb`). The main aim is to validate the robustness of the findings - if the models still perform better on the `oc_ta_df` dataset even when tuned on the `ta_df` dataset, it confirms the robustness of our findings.

## Usage

To reproduce the findings, run the notebooks in the order they are numbered. You'll need to have Jupyter installed, along with libraries such as pandas, numpy, matplotlib, seaborn, and scikit-learn.

## Conclusion

The goal of this project is to evaluate the impact of on-chain metrics for Bitcoin price prediction. On-chain metrics are found to improve model performance in both experiments.