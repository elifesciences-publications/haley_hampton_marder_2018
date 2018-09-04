# Statistics Code for Haley, Hampton & Marder 2018
# Last Edited 08.28.18 by JAH
# ------------------------------------------------------------------
# 1. One-Way Repeated Measures ANOVA w/ Paired Samples T-Tests (Bonferroni)
# 2. Two-Way Mixed Measures ANOVA w/ Independent Samples T-Tests (Bonferroni)
# ------------------------------------------------------------------

# Clear Workspace
rm(list = ls())

# Input Directory, Filename, and Test type (1 or 2)
directory = "/Volumes/HardDrive/Haley Hampton Marder 2018/Data"
directory_out = "/Volumes/HardDrive/Haley Hampton Marder 2018/Statistics"
filename = 'PD_waveFreq.csv'
test = 1 # type 1 for one-way ANOVa, 2 for two-way

# ------------------------------------------------------------------

# Load car package, set directory and filename
library(car)
setwd(directory)
data.csv = read.csv(filename)

# ------------------------------------------------------------------
# 1. One-Way Repeated Measures ANOVA (Type III) from car package
#    Paired Samples T-Tests with Bonferroni correction
#    Data must be formatted for 1 row per preparation, 1 col per condition
#    More info on this ANOVA here: http://dwoll.de/rexrepos/posts/anovaRBFpq.html

if (test==1){

# Prepare 1-Way ANOVAs
acid.lm=lm(cbind(pH59,pH64,pH70,pH76,pH82_2)~1,data=data.csv)
acid.i=expand.grid(pH=gl(5,1))
base.lm=lm(cbind(pH82_3,pH90,pH96,pH101,pH106,pH110)~1,data=data.csv)
base.i=expand.grid(pH=gl(6,1))

# Compute 1-Way ANOVAs (separate tests for acid and base)
acid.Anova=Anova(acid.lm,idata=acid.i,idesign=~pH,type="III")
a = summary(acid.Anova,multivariate=FALSE,univariate=TRUE)
base.Anova=Anova(base.lm,idata=base.i,idesign=~pH,type="III")
b = summary(base.Anova,multivariate=FALSE,univariate=TRUE)

# Produce ANOVA Output Table
one_anova = t(matrix(c(a$univariate.tests[2,c(2,4,5,6)],b$univariate.tests[2,c(2,4,5,6)]),nrow=4,ncol=2))
colnames(one_anova) <- c("df1","df2","F(pH)","p")
rownames(one_anova) <- c("acid","base")
one_anova <- as.table(one_anova)

# Compute Paired T-Tests
t_59 = t.test(data.csv$pH82_2,data.csv$pH59, paired = TRUE)
t_64 = t.test(data.csv$pH82_2,data.csv$pH64, paired = TRUE)
t_70 = t.test(data.csv$pH82_2,data.csv$pH70, paired = TRUE)
t_76 = t.test(data.csv$pH82_2,data.csv$pH76, paired = TRUE)
t_90 = t.test(data.csv$pH82_3,data.csv$pH90, paired = TRUE)
t_96 = t.test(data.csv$pH82_3,data.csv$pH96, paired = TRUE)
t_101 = t.test(data.csv$pH82_3,data.csv$pH101, paired = TRUE)
t_106 = t.test(data.csv$pH82_3,data.csv$pH106, paired = TRUE)
t_110 = t.test(data.csv$pH82_3,data.csv$pH110, paired = TRUE)

# Produce Paired T-Test Output Table
paired_t = matrix(c(t_59$statistic,t_64$statistic,t_70$statistic,t_76$statistic,t_90$statistic,
                   t_96$statistic,t_101$statistic,t_106$statistic,t_110$statistic,
                   t_59$p.value*4,t_64$p.value*4,t_70$p.value*4,t_76$p.value*4,t_90$p.value*5,
                   t_96$p.value*5,t_101$p.value*5,t_106$p.value*5,t_110$p.value*5),nrow=9,ncol=2)
colnames(paired_t) <- c("T","p")
rownames(paired_t) <- c("pH 5.9","pH 6.4","pH 7.0","pH 7.6","pH 9.0","pH 9.6","pH 10.1","pH 10.6","pH 11.0")
paired_t <- as.table(paired_t)

# Save Output Tables
write.csv(one_anova, file = paste(directory_out,"ANOVAs",filename,sep = "/"))
write.csv(paired_t, file = paste(directory_out,"T_Tests",filename,sep = "/"))

# ------------------------------------------------------------------
# 2. Two-Way Mixed Measures ANOVA (Type III) from car package
#    Independent Samples T-Tests with Bonferroni correction
#    Data must be formatted for 1 row per preparation, 1 col per condition
#    More info on this ANOVA here: http://psych.wisc.edu/moore/Rpdf/610-R11_MixedDesign.pdf

} else {

# Prepare 2-Way ANOVAs
g = factor(data.csv$Ganglion)
acid.lm=lm(cbind(pH59,pH64,pH70,pH76,pH82_2)~g,data=data.csv)
acid.i=expand.grid(pH=gl(5,1))
base.lm=lm(cbind(pH82_3,pH90,pH96,pH101,pH106,pH110)~g,data=data.csv)
base.i=expand.grid(pH=gl(6,1))

# Compute 2-Way ANOVAs
acid.Anova=Anova(acid.lm,idata=acid.i,idesign=~pH,type="III")
a = summary(acid.Anova,multivariate=FALSE,univariate=TRUE)
base.Anova=Anova(base.lm,idata=base.i,idesign=~pH,type="III")
b = summary(base.Anova,multivariate=FALSE,univariate=TRUE)

# Produce ANOVA Output Table
two_anova = t(matrix(c(a$univariate.tests[2,c(2,4,5,6)],a$univariate.tests[3,c(2,4,5,6)],a$univariate.tests[4,c(2,4,5,6)],
                       b$univariate.tests[2,c(2,4,5,6)],b$univariate.tests[3,c(2,4,5,6)],b$univariate.tests[4,c(2,4,5,6)]),
                     nrow=4,ncol=6))
colnames(two_anova) <- c("df1","df2","F","p")
rownames(two_anova) <- c("acid:ganglion","acid:pH","acid:ganglion*pH","base:ganglion","base:pH","base:ganglion*pH")
two_anova <- as.table(two_anova)

# Independent Samples T-tests
t_59 = t.test(data.csv$pH59~g)
t_64 = t.test(data.csv$pH64~g)
t_70 = tryCatch(t.test(data.csv$pH70~g),error=function(cond)
  list("statistic" = NA,p.value = NA))
t_76 = tryCatch(t.test(data.csv$pH76~g),error=function(cond)
  list("statistic" = NA,p.value = NA))
t_90 = t.test(data.csv$pH90~g)
t_96 = t.test(data.csv$pH96~g)
t_101 = t.test(data.csv$pH101~g)
t_106 = t.test(data.csv$pH106~g)
t_110 = t.test(data.csv$pH110~g)

# Produce Independent T-Test Output Table
independent_t = matrix(c(t_59$statistic,t_64$statistic,t_70$statistic,t_76$statistic,t_90$statistic,
                    t_96$statistic,t_101$statistic,t_106$statistic,t_110$statistic,
                    t_59$p.value*4,t_64$p.value*4,t_70$p.value*4,t_76$p.value*4,t_90$p.value*5,
                    t_96$p.value*5,t_101$p.value*5,t_106$p.value*5,t_110$p.value*5),nrow=9,ncol=2)
colnames(independent_t) <- c("T","p")
rownames(independent_t) <- c("pH 5.9","pH 6.4","pH 7.0","pH 7.6","pH 9.0","pH 9.6","pH 10.1","pH 10.6","pH 11.0")
independent_t <- as.table(independent_t)

# Save Output Tables
write.csv(two_anova, file = paste(directory_out,"ANOVAs",filename,sep = "/"))
write.csv(independent_t, file = paste(directory_out,"T_Tests",filename,sep = "/"))
}
