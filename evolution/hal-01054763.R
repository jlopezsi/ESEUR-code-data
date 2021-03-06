#
# hal-01054763.R, 21 May 17
#
# Data from:
#
# Collective mind: {Towards} practical and collaborative auto-tuning
# Grigori Fursin and Renato Miceli and Anton Lokhmotov and Michael Gerndt and Marc Baboulin and Allen D. Malony and Zbigniew Chamski and Diego Novillo and Davide Del Vento
#
# Example from:
# Empirical Software Engineering using R
# Derek M. Jones

source("ESEUR_config.r")


library("reshape2")


pal_col=rainbow(2)

gcc_opts=read.csv(paste0(ESEUR_dir, "evolution/hal-01054763_flags.csv.xz"), as.is=TRUE)

gcc_12=subset(gcc_opts, year < 2016)

plot(gcc_12$year, gcc_12$opt_flags, col=pal_col[1],
	ylim=c(2, max(gcc_12$opt_flags)),
	xlab="Year", ylab="Total\n")
points(gcc_12$year, gcc_12$parameters, col=pal_col[2])

gcc_all_opts=melt(gcc_12, id.vars=c("gcc_version", "year"))

opt_mod=glm(value ~ year+variable, data=gcc_all_opts)
# opt_mod=glm(value ~ year+I(year^2)+variable, data=gcc_all_opts)
pred_vals=predict(opt_mod)

opt_pred=pred_vals[gcc_all_opts$variable == "opt_flags"]
lines(gcc_12$year, opt_pred, col=pal_col[1])
 
param_pred=pred_vals[gcc_all_opts$variable != "opt_flags"]
lines(gcc_12$year, param_pred, col=pal_col[2])
 
legend(x="topleft", legend=c("Flags", "Options"), bty="n", fill=pal_col, cex=1.2)
 
