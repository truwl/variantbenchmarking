FROM rocker/binder

RUN R --quiet -e "devtools::install_github('Illumina/happyR')"

USER root
RUN pip install papermill
