# natuurindicatoren
Calculation of the nature indicators for Flanders

## Repo structure

    ├── LICENSE          : present, MIT
    ├── Makefile         : to rerun specific or all indicator reports
    ├── README.md        : present, but minimal for now
    ├── data
    │   ├── external     : probably not necessary. If we use open data, we can request it through script
    │   ├── interim      : data that has been transformed from original source. Allows to run analysis outside the INBO
    │   ├── processed    : data ready for charts/modelling/analysis
    │   └── raw          : probably not necessary, will be managed elsewhere
    │
    ├── docs             : probably not necessary, README should be sufficient initially
    │
    ├── models           : maybe for trend analysis, otherwise use src
    │
    ├── notebooks        : for exploration and examples only
    │
    ├── references       : maybe for papers explaining certain analysis, but links should be fine
    │
    ├── reports          : generated Rmd reports as HTML, PDF, ...
    │   └── figures      : generated figures used in reports
    │
    ├── requirements.txt : requirements file for reproducing the analysis environment, e.g generated with `pip freeze > requirements.txt`
    │
    ├── src              : source code for use in this project.
    │   ├── __init__.py  : To make a Python module, not required, maybe there's something similar for R
    │   │
    │   ├── data         : scripts to download or generate data
    │   │   └── make_dataset.py
    │   │
    │   ├── features     : scripts to turn raw data into features for modeling
    │   │   └── build_features.py
    │   │
    │   ├── models       : scripts to train models and then use trained models to make predictions
    │   │   ├── predict_model.py
    │   │   └── train_model.py
    │   │
    │   └── visualization : scripts to create exploratory and results oriented visualizations
    │       └── visualize.py
    │
    └── tox.ini           : tox file with settings for running tox; see tox.testrun.org
