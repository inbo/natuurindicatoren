# natuurindicatoren
Calculation of the nature indicators for Flanders

## Repo structure

The repo structure is based on [cookiecutter-data-science](https://github.com/drivendata/cookiecutter-data-science).

    ├── README.md        : Top-level description of the project and how to run it
    ├── Makefile         : File to rerun get-data or reports
    ├── LICENSE          : MIT License
    ├── data
    │   └── processed    : Tidy format, not-aggregated data; allows to run the analysis from outside the INBO
    │
    ├── reports          : Generated output; no manual editing!
    │   ├── html         : HTML report for each indicator
    │   │   ├── europese-vlinderindex-graslanden.html
    │   │   ├── aantal-verkochte-visverloven.html
    │   │   └── ...
    │   │
    │   ├── docx         : Combined report for editorial
    │   │   └── draft-natuurindicatoren-report.docx
    │   │
    │   └── figures      : Figures for each indicator
    │       ├── europese-vlinderindex-graslanden-1.png
    │       ├── europese-vlinderindex-graslanden-2.png
    │       ├── aantal-verkochte-visverloven-1.png
    │       └── ...
    │
    ├── requirements.txt : Requirements file for reproducing the analysis environment
    │
    |── src              : All source code for this project
    |   ├── utils        : Reusable functions, applicable for multiple reports 
    |   |   └── ...
    |   |
    |   ├── get-data     : Scripts to generate processed data from raw data for each indicator
    |   │   ├── europese-vlinderindex-graslanden.R
    |   │   ├── aantal-verkochte-visverloven.R
    |   │   └── ...
    |   |
    |   ├── europese-vlinderindex-graslanden.Rmd 
    |   └── aantal-verkochte-visverloven.Rmd
    |
    |__ information      : Papers, useful documents or guidelines. Make names of papers consistent
    
    
    
## Rendering

In order to make the rendering of the `.Rmd` file to the proper reports/html folder, use the rmarkdwon `render` function instead of the knitr-button, as follows (for the vlinderindex example):

```R
rmarkdown::render("europese-vlinderindex-graslanden.Rmd", output_file = "../reports/html/europese-vlinderindex-graslanden.html") 
```

