# Title:    My agenda analysis
# Author:   André Canal
# Date:     June 2022

# Install and load packages
# renv::init()    # Initialize virtual environment
# install.packages("ical")
# install.packages("dplyr")
# install.packages("lubridate")
# install.packages("ggplot2")

library(ical)
library(dplyr)
library(lubridate)
library(ggplot2)

# Load and read file
# Raw
my_agenda_raw <- "my_agenda.ics" %>%
ical_parse_df() %>%
as_tibble()

# Edited
my_agenda <- "my_agenda.ics" %>%
ical_parse_df() %>%
as_tibble() %>%
mutate(
    start_datetime = with_tz(start, tzone = "America/Sao_Paulo"),
    end_datetime = with_tz(end, tzone = "America/Sao_Paulo"),
    minutes = end_datetime - start_datetime,
    date = floor_date(start_datetime, unit = "day")
    ) %>%
mutate(summary = tolower(summary)) %>%
mutate(description = tolower(description)) %>%
group_by(date, summary, status) %>%
summarize(minutes = sum(minutes)) %>%
mutate(
    minutes = as.numeric(minutes) / 60,
    hours = minutes / 60
) %>%
filter(date > "2020-01-01")
