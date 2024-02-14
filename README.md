README.md

# myfunnelplot

A package for creating funnel plots in R.

## Installation

You can install the development version of myfunnelplot from GitHub with:

```{r}
install.packages("devtools")
devtools::install_github("gohgabriel/myfunnelplot")
```
## Explanation of the Function

The create_funnel_plot function produces a funnel plot to visualize potential publication bias or study heterogeneity. Here's how the arguments work:

    data: A data frame containing effect sizes, standard errors, and optionally study labels.
    estimate: The name of the column containing effect sizes.
    se: The name of the column containing standard errors.
    y_column: (Optional) The name of the column containing y-axis labels. Defaults to "y".
    v_column: (Optional) The name of the column containing precision measures (usually the variance). Defaults to "v".
    x_label: (Optional) Label for the x-axis. Defaults to "Standard Error".
    y_label: (Optional) Label for the y-axis. Defaults to "Standardized Mean Difference".

## Usage

Here's a basic example of how to use the create_funnel_plot function:

```
library(myfunnelplot)

# Sample data
sample_data <- data.frame(
  study = c("Study A", "Study B", "Study C"),
  y = c(0.5, -0.2, 0.1),
  v = c(0.05, 0.08, 0.03)
)

# Create the funnel plot
my_funnel_plot <- create_funnel_plot(sample_data, estimate = "y", se = "v")
my_funnel_plot

# Optionally save:
ggsave('funnel.png', plot = my_funnel_plot, width = 6, height = 6, unit = "in", dpi = 300)
```
