# STAT 486 PROJECT 3
# HEBA SYED

setwd("C:/Users/heb/Documents/STAT")
library(aod)
library(lmtest)
orings<-read.csv("Orings.csv")



summary(orings$Temperature)

# split
spl<-split(orings, orings$Temperature >= 70)
warmtemp<-spl[[2]]
coldtemp<-spl[[1]]

# plots
par(mfrow=c(1,2))
plot(warmtemp$TD,warmtemp$Temperature, pch = 17)
plot(coldtemp$TD,coldtemp$Temperature, pch = 17)
par(mfrow=c(1,1))

pairs(orings)
corrmatrix<-data.frame(round(cor(orings), 3))
plot(orings$TD ~ orings$Temperature)
plot(jitter(orings$TD, 0.1) ~ orings$Temperature)

model1 <- glm(TD ~ Temperature, data = orings, family = binomial)
summary(model1)

# Call:
# glm(formula = TD ~ Temperature, family = binomial, data = orings)
# 
# Coefficients:
#   Estimate Std. Error z value Pr(>|z|)  
# (Intercept)  32.3381    17.6301   1.834   0.0666 .
# Temperature  -0.5028     0.2643  -1.902   0.0571 .
# ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# (Dispersion parameter for binomial family taken to be 1)
# 
# Null deviance: 24.0850  on 22  degrees of freedom
# Residual deviance:  9.8032  on 21  degrees of freedom
# AIC: 13.803
# 
# Number of Fisher Scoring iterations: 7

plot(residuals(model1) ~ fitted(model1),
     xlab = expression(hat(y)[i]), ylab = expression(r[i]),cex=0.8)
abline(0, 0, lty = 2, col=4)

x <- seq(min(orings$Temperature), max(orings$Temperature), length = 100)
y <- predict(model1, newdata = data.frame(Temperature = x), type = "response")
plot(orings$Temperature, orings$TD, col = "black")
lines(x, y, col = "pink", lwd = 2)

par(mfrow=c(2,2))
plot(model1)
par(mfrow=c(1,1))

predict(model1, newdata = data.frame(Temperature = 31), type = "response")
# 0.9999999

32.3381/-0.5028 # 
# -64.31603
(exp(32.3381+(-0.5028*64.31603)))/(1+exp(32.3381+(-0.5028*64.31603)))
# 0.5

exp(-0.5028) # odds ratio
# 0.6048347

wald.test(Sigma = vcov(model1), b = coef(model1), Terms = 1)
# Wald test
# 
# Model 1: TD ~ Temperature
# Model 2: TD ~ 1
# Res.Df Df      F  Pr(>F)  
# 1     21                    
# 2     22 -1 3.6193 0.07092 .
# ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

null<-glm(TD ~ 1, data = orings, family = binomial)
lrtest(null, model1)
# Likelihood ratio test
# 
# Model 1: TD ~ 1
# Model 2: TD ~ Temperature
# #Df   LogLik Df  Chisq Pr(>Chisq)    
# 1   1 -12.0425                         
# 2   2  -4.9016  1 14.282  0.0001574 ***
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

model2<-glm(Damaged>= 1 ~ Temperature, family = binomial, data = orings)
summary(model2)
# Call:
#   glm(formula = Damaged >= 1 ~ Temperature, family = binomial, 
#       data = orings)
# 
# Coefficients:
#   Estimate Std. Error z value Pr(>|z|)  
# (Intercept)  15.0429     7.3786   2.039   0.0415 *
#   Temperature  -0.2322     0.1082  -2.145   0.0320 *
#   ---
#   Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1
# 
# (Dispersion parameter for binomial family taken to be 1)
# 
# Null deviance: 28.267  on 22  degrees of freedom
# Residual deviance: 20.315  on 21  degrees of freedom
# AIC: 24.315
# 
# Number of Fisher Scoring iterations: 5

x <- seq(min(orings$Temperature), max(orings$Temperature), length = 100)
y <- predict(model2, newdata = data.frame(Temperature = x), type = "response")
plot(orings$Temperature, orings$TD, col = "black")
lines(x, y, col = "purple", lwd = 2)

predict(model2, newdata = data.frame(Temperature = 31), type = "response")
# 0.9996088

15.0429 / -0.2322
# -64.78424
(exp(15.0429+(-0.2322*64.78424)))/(1+exp(15.0429+(-0.2322*64.78424)))
# 0.4999999

exp(-0.2322) # odds ratio
#0.7927875

