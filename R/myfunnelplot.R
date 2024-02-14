#' @title Create a Funnel Plot
#'
#' @description This function creates a funnel plot to visualize potential
#' publication bias or heterogeneity in a meta-analysis. The plot displays
#' effect estimates against a measure of precision (usually standard error).
#' Credit to jksakaluk for the logic.
#'
#' @param data A data frame containing study data, including an effect estimate
#' column and a standard error column.
#' @param estimate The name of the column containing effect estimates.
#' @param se The name of the column containing standard errors.
#' @param y_column The name of the column containing the y-axis variable
#' (effect estimate). Defaults to "y".
#' @param v_column The name of the column containing the precision measure
#' (often the variance). Defaults to "v".
#' @param x_label The label for the x-axis. Defaults to "Standard Error".
#' @param y_label The label for the y-axis. Defaults to "Standardized Mean Difference".
#'
#' @return A ggplot2 object representing the funnel plot.
#'
#' @examples
#' # Example using sample data
#' sample_data <- data.frame(
#'   study = c("Study A", "Study B", "Study C"),
#'   y = c(0.5, -0.2, 0.1),
#'   v = c(0.05, 0.08, 0.03)
#' )
#' my_funnel_plot <- create_funnel_plot(sample_data, estimate = "y", se = "v")
#' my_funnel_plot
#'
#' @export
create_funnel_plot <- function(data, estimate, se, y_column = "y", v_column = "v", x_label = "Standard Error", y_label = "Standardized Mean Difference") {
  ## Load library
  library(ggplot2)

  ## Calculations for confidence intervals
  se.seq <- seq(0, max(sqrt(data[[v_column]])), 0.0001)  # Access 'v' using column name
  ll95 <- estimate - (1.96 * se.seq)
  ul95 <- estimate + (1.96 * se.seq)
  ll99 <- estimate - (3.29 * se.seq)
  ul99 <- estimate + (3.29 * se.seq)
  meanll95 <- estimate - (1.96 * se)
  meanul95 <- estimate + (1.96 * se)

  ## Dataframe for plotting
  dfCI <- data.frame(ll95, ul95, ll99, ul99, se.seq, estimate, meanll95, meanul95)

  ## Theme definition (moved outside for reusability)
  windowsFonts(Times = windowsFont("Times New Roman"))
  apatheme <- theme_bw() +
    theme(panel.grid.major = element_blank(),
          panel.grid.minor = element_blank(),
          panel.border = element_blank(),
          axis.line = element_line(),
          text = element_text(family = 'Times'),
          legend.position = 'none')

  ## Funnel plot generation
  fp <- ggplot(aes(x = sqrt(v), y = y), data = data) +
    geom_point(shape = 1) +
    xlab(x_label) +
    ylab(y_label) +
    geom_line(aes(x = se.seq, y = ll95), linetype = 'dotted', data = dfCI) +
    geom_line(aes(x = se.seq, y = ul95), linetype = 'dotted', data = dfCI) +
    geom_line(aes(x = se.seq, y = ll99), linetype = 'dashed', data = dfCI) +
    geom_line(aes(x = se.seq, y = ul99), linetype = 'dashed', data = dfCI) +
    geom_segment(aes(x = min(se.seq), y = meanll95, xend = max(se.seq), yend = meanll95),
                 linetype = 'dotted', data = dfCI) +
    geom_segment(aes(x = min(se.seq), y = meanul95, xend = max(se.seq), yend = meanul95),
                 linetype = 'dotted', data = dfCI) +
    scale_x_reverse() +
    scale_y_continuous(breaks = seq(-3, 3, 0.5)) +
    coord_flip() +
    apatheme

  ## Return the plot object
  return(fp)
}
