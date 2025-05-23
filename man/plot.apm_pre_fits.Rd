% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/plot.apm_pre_fits.R
\name{plot.apm_pre_fits}
\alias{plot.apm_pre_fits}
\title{Plot outputs of \code{apm_pre()}}
\usage{
\method{plot}{apm_pre_fits}(
  x,
  type = "weights",
  abs = TRUE,
  ncol = 4L,
  clip_at = 15,
  model = ".optimal",
  ...
)
}
\arguments{
\item{x}{an \code{apm_pre_fits} object; the output of a call to \code{\link[=apm_pre]{apm_pre()}}.}

\item{type}{which values to plot: allowable options include \code{"weights"} to plot the BMA weights/posterior probabilities (default), \code{"errors"} to plot the difference in average predictions errors for all models across validation periods, \code{"predict"} to plot the time series and model predictions for each model, and \code{"corrected"} to plot the corrected predictions for the treated group for each model. Abbreviations allowed.}

\item{abs}{\code{logical}; when \code{type = "errors"}, whether to plot the differences in average prediction errors in absolute value (\code{TRUE}, default) or not (\code{FALSE}).}

\item{ncol}{when \code{type} is \code{"errors"}, \code{"predict"}, or \code{"corrected"}, the number of columns to use to display the plots. Default is 4.}

\item{clip_at}{when \code{type = "errors"}, the value (in robust z-score units) at which to clip the y-axis of the plot to prevent outliers from distorting it. Default is 15. Set to \code{Inf} to prevent clipping.}

\item{model}{string; when \code{type = "predict"} or \code{type = "corrected"}, the model(s) to plot. Allowable values include \code{".optimal"} to plot the model with the smallest maximum absolute difference in average prediction errors, \code{".all"} to plot all models (excluding the BMA-weighted predictions), or the names of one or more specific models. Abbreviations allowed.}

\item{\dots}{ignored.}
}
\value{
A \code{ggplot} object, which can be manipulated using \code{ggplot2} syntax (after loading \code{ggplot2}).
}
\description{
\code{plot()} displays the Bayesian model averaging (BMA) weights for each model (computed by \code{apm_fit()} as the posterior probability of selection) and the distribution of the difference in average prediction errors.
}
\details{
When \code{type = "weights"}, \code{plot()} displays a bar plot with a bar for each model with height equal to the BMA weight/posterior probability of selection for that model. (Note that the plot margins can sometimes cut off the model names; use \code{theme(plot.margins =)} after loading \code{ggplot2} to extend the left margin of the plot to ensure all text is visible. Alternatively, the axis text can be rotated using \code{theme(axis.text.x =)}.)

When \code{type = "errors"}, \code{plot()} displays a lattice of bar plots with a plot for each model displaying the difference in average prediction errors for each validation period. The period with the largest difference in average prediction errors will be shaded black. The model with the smallest maximum absolute difference in average prediction errors will have a gray label.

When \code{type = "predict"}, \code{plot()} displays a lattice of line plots with a plot for each model displaying the observed and predicted outcomes for each validation period under each model. The observed outcomes are displayed as points, while the predicted outcomes are displayed as lines.

When \code{type = "corrected"}, \code{plot()} displays a lattice of line plots with a plot for each model displaying the observed and corrected predictions for the treated group for each validation period under each model. The observed outcomes are displayed as points, while the corrected predictions are displayed as lines. Corrected predictions are computed as the observed outcome in the treated group minus the prediction error in the treated group plus the prediction error in the control group.
}
\examples{
data("ptpdata")

# Combination of 8 models: 2 baseline formulas,
# 2 families, 2 lags
models <- apm_mod(crude_rate ~ 1,
                  family = "gaussian",
                  time_trend = 0:1,
                  lag = 0:1,
                  diff_k = 0:1)
models

# Fit the models to data
fits <- apm_pre(models, data = ptpdata,
                group_var = "group",
                time_var = "year",
                val_times = 1999:2007,
                unit_var = "state",
                nsim = 50,
                verbose = FALSE)
fits

plot(fits, type = "weights")

plot(fits, type = "error", ncol = 2)

plot(fits, type = "predict", model = ".optimal")

plot(fits, type = "corrected", model = ".optimal")
}
\seealso{
\code{\link[=apm_pre]{apm_pre()}} to to compute the difference in average prediction errors and BMA weights; \code{\link[ggplot2:geom_bar]{ggplot2::geom_col()}}, which is used to create the plots.
}
