% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/apm_pre.R
\name{apm_pre}
\alias{apm_pre}
\alias{summary.apm_pre_fits}
\title{Fit validation models to pre-treatment data}
\usage{
apm_pre(
  models,
  data,
  weights = NULL,
  group_var,
  time_var,
  val_times,
  unit_var,
  nsim = 1000L,
  cl = NULL,
  verbose = TRUE
)

\method{summary}{apm_pre_fits}(object, order = NULL, ...)
}
\arguments{
\item{models}{an \code{apm_models} object; the output of a call to \code{\link[=apm_mod]{apm_mod()}}.}

\item{data}{a dataset containing all the variables named in the supplied models (i.e., the outcome and any predictors) as well as any variable named below.}

\item{weights}{an optional vector of weights (e.g., sampling weights) used to fit weighted regression models.}

\item{group_var}{string; the name of the treatment variable in \code{data} defining the "to be treated" and "not to be treated" groups. The corresponding variable should take on values of 0 and 1 only.}

\item{time_var}{string; the name of the variable in \code{data} containing the time variable.}

\item{val_times}{a numeric vector corresponding to the pre-treatment times that will be used as validation times when select the model with the optimal average expected prediction error.}

\item{unit_var}{string; the name of the unit ID variable in \code{data}.}

\item{nsim}{the number of simulated draws from the joint posterior of the fitted models to use to compute the BMA weights. Default is 1000. More is better but takes longer.}

\item{cl}{a cluster object created by \code{\link[parallel:makeCluster]{parallel::makeCluster()}}, or an integer to indicate number of child-processes (integer values are ignored on Windows) for parallel evaluations. It can also be \code{"future"} to use a future backend. \code{NULL} (default) refers to sequential evaluation. See the \code{cl} argument of \code{\link[pbapply:pbapply]{pbapply::pblapply()}} for details.}

\item{verbose}{\code{logical}; whether to print information about the progress of the estimation, including a progress bar. Default is \code{TRUE}.}

\item{object}{an \code{apm_pre_fit} object; the output of a call to \code{apm_pre()}.}

\item{order}{how to order the summary; \code{NULL} (the default) is the same ordering as the models supplied to \code{apm_pre()}, \code{"weights"} orders the models by their computed BMA weights with the highest weights on top, and \code{"errors"} orders the models by their maximum absolute difference in prediction errors with the smallest errors on top.}

\item{\dots}{ignored.}
}
\value{
\code{apm_pre()} returns an \code{apm_pre_fits} object, which is a list containing the models supplied to \code{models}, a grid of all fitted models, a list of all model fit objects, a list of all estimated coefficients, the joint covariance of the coefficients, the dataset supplied to \code{data}, and other components supplied to \code{apm_pre()}.

\code{summary()} produces a data frame containing the BMA weights and maximum absolute difference in mean prediction errors for each model, ordered according \code{order}. An asterisk appears next to the model with the smallest error.
}
\description{
\code{apm_pre()} fits models to the pre-treatment data to compute the observed prediction errors for each model in each period and compute the Bayesian model averaging (BMA) weights eventually used in \code{\link[=apm_est]{apm_est()}} to estimate the treatment effect.
}
\details{
\code{apm_pre()} creates a grid of all models and all time points and fits all corresponding models. For each validation time supplied to \code{val_times}, each model is fit using all previous times. For example, for a validation time of 5, a model is fit with data only from periods 1-4.

\code{\link[=lm]{lm()}}, \code{\link[=glm]{glm()}}, or \code{\link[MASS:glm.nb]{MASS::glm.nb()}} are used to fit the given models. The joint covariance matrix of all the coefficients is computed using the SUEST method described in Mize et al. (2019, p164), which is also used by the STATA command \code{suest}. This is equivalent to the covariance matrix computed by stacking the score equations for the models and fitting them using M-estimation and yields the equivalent of the HC0 covariance matrix for all within-model covariances. The covariance is clustered by \code{unit_id}.

To compute the BMA weights, random variate drawn from a multivariate normal distribution \code{nsim} times with mean vector equal to the concatenated model coefficients and covariance equal to the joint covariance matrix described above. For each iteration, the absolute average prediction errors are calculated for each model and validation period. A model is considered the "winner" if it its largest absolute average prediction error across validation periods is the smallest among all models. The BMA weight for each model is equal to the proportion of iterations in which that model was the "winner".
}
\examples{
data("ptpdata")

# Combination of 8 models: 2 baseline formulas,
# 2 families, 2 lags
models <- apm_mod(crude_rate ~ 1,
                  family = list("gaussian", "quasipoisson"),
                  time_trend = 0:1,
                  lag = 0:1)
models

# Fit the models to data
fits <- apm_pre(models, data = ptpdata,
                group_var = "group",
                time_var = "year",
                val_times = 1999:2007,
                unit_var = "state",
                nsim = 200,
                verbose = FALSE)

fits

summary(fits)

plot(fits, type = "weights")

plot(fits, type = "error")
}
\seealso{
\code{\link[=lm]{lm()}},\code{\link[=glm]{glm()}}, and \code{\link[MASS:glm.nb]{MASS::glm.nb()}} for the functions used to fit the models; \code{\link[=apm_est]{apm_est()}} to compute the ATT and its uncertainty; \code{\link[=plot.apm_pre_fits]{plot.apm_pre_fits()}} for plotting an \code{apm_pre_fits} object.
}
