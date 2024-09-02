#2. madde
df <- as.data.frame(ist366)

summary(df)
install.packages("psych")
library(psych)
describe(df)
attach(df)

# Histogramlar
ggplot(df, aes(x = y)) + 
  geom_histogram(binwidth = 5, fill = "blue", color = "black") + 
  ggtitle("y Değişkeninin Histogramı")

ggplot(df, aes(x = x1)) + 
  geom_histogram(binwidth = 1, fill = "blue", color = "black") + 
  ggtitle("x1 Değişkeninin Histogramı")

ggplot(df, aes(x = x2)) + 
  geom_histogram(binwidth = 0.5, fill = "blue", color = "black") + 
  ggtitle("x2 Değişkeninin Histogramı")

ggplot(df, aes(x = x3)) + 
  geom_histogram(binwidth = 1, fill = "blue", color = "black") + 
  ggtitle("x3 Değişkeninin Histogramı")

ggplot(df, aes(x = x4)) + 
  geom_histogram(binwidth = 1, fill = "blue", color = "black") + 
  ggtitle("x4 Değişkeninin Histogramı")

ggplot(df, aes(x = ln_y)) + 
  geom_histogram(binwidth = 0.1, fill = "blue", color = "black") + 
  ggtitle("ln_y Değişkeninin Histogramı")

df$x4 <- as.factor(df$x4)

#3. madde
plot(x1,y)
plot(x2, y)
plot(x3, y)
plot(x4, y)
qqnorm(y)
qqline(y)
shapiro.test(y)
install.packages('nortest')
library(nortest)
ad.test(y)
nortest::lillie.test(y)


""" logaritmik dönüşüm yapıp normallik tekrar kontrol edilecek"""

df$ln_y <- log(df$y)

qqnorm(df$ln_y)
qqline(df$ln_y)
# Shapiro-Wilk testi ile normallik kontrolü
shapiro.test(df$ln_y)

""" logaritmik dönüşüm yapıldı fakat normallik sağlanmadı p değeri 0.04 olduğundan dolayı bu yüzde aykırı değer incelemesi yapıldı ve aykırı değerler veriden çıkartılarak normallik sağlandı"""

# Aykırı değerleri tespit etme
Q1 <- quantile(df$ln_y, 0.25)
Q3 <- quantile(df$ln_y, 0.75)
IQR <- Q3 - Q1

lower_bound <- Q1 - 1.5 * IQR
upper_bound <- Q3 + 1.5 * IQR

outliers <- df$ln_y < lower_bound | df$ln_y > upper_bound

# Aykırı değerleri çıkarmak
df_clean <- df[!outliers,]

shapiro.test(df_clean$ln_y)


# Scatter plotlar
install.packages("ggplot2")
install.packages("tidyr")

library(ggplot2)
library(tidyr)
ggplot(df_clean, aes(x = x1, y = ln_y)) + 
  geom_point() + 
  geom_smooth(method = "lm", col = "red") + 
  ggtitle("x1 ve y Değişkenleri Arasındaki Doğrusallık")

ggplot(df_clean, aes(x = x2, y = ln_y)) + 
  geom_point() + 
  geom_smooth(method = "lm", col = "red") + 
  ggtitle("x2 ve y Değişkenleri Arasındaki Doğrusallık")

ggplot(df_clean, aes(x = x3, y = ln_y)) + 
  geom_point() + 
  geom_smooth(method = "lm", col = "red") + 
  ggtitle("x3 ve y Değişkenleri Arasındaki Doğrusallık")

ggplot(df_clean, aes(x = x4, y = ln_y)) + 
  geom_point() + 
  geom_smooth(method = "lm", col = "red") + 
  ggtitle("x4 ve y Değişkenleri Arasındaki Doğrusallık")

""""""

pairs(df_clean)




#4.madde

# Q-Q Plot ve doğrusal çizgi
qqnorm(df_clean$ln_y)
qqline(df_clean$ln_y)

# Shapiro-Wilk testi
shapiro.test(df_clean$ln_y)


# Regresyon modelini kur
model <- lm(ln_y ~ x1 + x2 + x3 + x4, data=df_clean)
model
summary(model)

# Breusch-Pagan testi
library(lmtest)
bptest(model)

# Durbin-Watson testi
library(lmtest)
dwtest(model)

# VIF (Variance Inflation Factor) değerlerini hesaplama
library(car)
vif(model)


confint(model,level = .95)
anova(model)


inf <- ls.diag(model)
inf

n= 99
k= 4
cooksd <- cooks.distance(model)
plot(cooksd, pch="*", cex=2, main="Influential Obs by Cooks distance") 
abline(h = if (n>50) 4/n else 4/(n-k-1) , col="red")  
text(x=1:length(cooksd)+1, y=cooksd, labels=ifelse(cooksd>if (n>50) 4/n else 4/(n-k-1),names(cooksd),""), col="red")

library(zoo) #index fonksiyonu için paket
hat<-inf$hat
plot(hat, pch="*", cex=2, main="Leverage Value by Hat value") 
abline(h = 2*(k+1)/n , col="red")  
text(x=1:length(hat)+1, y=hat, labels=ifelse(hat>2*(k+1)/n,index(hat),""),col="red")


df_new <- df_clean[-c(6, 21, 25, 36, 44, 53, 91, 92, 95, 9, 8, 19, 17, 22, 23, 85, 89), ]

print(df_new)

attach(df_new)

# Gerekli paketi yükleme ve dahil etme
install.packages("dplyr")
library(dplyr)

# Regresyon modeli kurma ve artık değerleri hesaplama
model <- lm(ln_y ~ x1 + x2 + x3 + x4, data = df_new)
summary(model)
residuals <- model$residuals

# Artık değerleri veri çerçevesine ekleme
df_new <- df_new %>% mutate(residuals = residuals)

# Artık değerlerin belirli bir eşik değerin üzerinde olan gözlemleri tespit etme
threshold <- 2 * sd(residuals)
df_new <- df_new %>% mutate(outliers = abs(residuals) > threshold)

# Artık değerleri çıkarma
df_new_clean <- df_new %>% filter(!outliers)

# Sonuçları kontrol etme
print(df_new_clean)

#5.madde
# Regresyon modeli
model <- lm(y ~ x1 + x2 + x3 + x4, data=df_new_clean)
model

shapiro.test(df_new_clean$y)

# Artıkların Q-Q plot'u
qqnorm(model$residuals)
qqline(model$residuals)

# Artıkların histogramı
hist(model$residuals, breaks=10, main="Histogram of Residuals")


summary(model)
confint(model, level = 0.95)






# Modelin özetini yazdırma
model_summary <- summary(model)
model_summary

# Katsayılar ve standart hatalar
coefficients <- model_summary$coefficients

# Kestirim denklemi
intercept <- coefficients["(Intercept)", "Estimate"]
x1_coef <- coefficients["x1", "Estimate"]
x2_coef <- coefficients["x2", "Estimate"]
x3_coef <- coefficients["x3", "Estimate"]
x4_coef <- coefficients["x4", "Estimate"]

# Standart hatalar
intercept_se <- coefficients["(Intercept)", "Std. Error"]
x1_se <- coefficients["x1", "Std. Error"]
x2_se <- coefficients["x2", "Std. Error"]
x3_se <- coefficients["x3", "Std. Error"]
x4_se <- coefficients["x4", "Std. Error"]

# Kestirim denklemi (standart hatalar ile)
cat("Kestirim denklemi (standart hatalar ile):\n")
cat("ln_y = ", intercept, " (", intercept_se, ") + ", x1_coef, " (", x1_se, ") * x1 + ", x2_coef, " (", x2_se, ") * x2 + ", x3_coef, " (", x3_se, ") * x3 + ", x4_coef, " (", x4_se, ") * x4\n")



# Model anlamlılığı testi
f_statistic <- model_summary$fstatistic
f_value <- f_statistic[1]
f_df1 <- f_statistic[2]
f_df2 <- f_statistic[3]
p_value <- pf(f_value, f_df1, f_df2, lower.tail = FALSE)

cat("Modelin F istatistiği: ", f_value, "\n")
cat("Serbestlik dereceleri: ", f_df1, " ve ", f_df2, "\n")
cat("P değeri: ", p_value, "\n")

if(p_value < 0.05) {
  cat("Model anlamlıdır (p < 0.05).\n")
} else {
  cat("Model anlamlı değildir (p >= 0.05).\n")
}

#6.madde
summary(model)
confint(model, level = 0.99)

#7.madde
summary(model)$r.squared
summary(model)$adj.r.squared

#8.madde
confint(model, level = 0.99)

# %99 güven aralıklarını hesaplama
confint_99 <- confint(model, level = 0.99)

# Güven aralıklarını yazdırma
cat("Regresyon Katsayıları için %99 Güven Aralıkları:\n")
print(confint_99)

# Güven aralıklarının yorumlanması
cat("\nKatsayılar için %99 Güven Aralıklarının Yorumlanması:\n")
for (i in 1:nrow(confint_99)) {
  cat(row.names(confint_99)[i], "için %99 güven aralığı: [", confint_99[i, 1], ", ", confint_99[i, 2], "]\n")
  if (confint_99[i, 1] > 0 || confint_99[i, 2] < 0) {
    cat("Bu güven aralığı 0'ı içermiyor, dolayısıyla katsayı anlamlıdır.\n")
  } else {
    cat("Bu güven aralığı 0'ı içeriyor, dolayısıyla katsayı anlamlı değildir.\n")
  }
}






#9.madde
# 9. Değişen Varyanslılık Sorununu İnceleme

# Artıkların tahmin edilen değerlere karşı grafiği
plot(model$fitted.values, model$residuals, 
     main="Artıkların Tahmin Edilen Değerlere Karşı Dağılımı",
     xlab="Tahmin Edilen Değerler",
     ylab="Artıklar",
     pch=20, col="blue")
abline(h=0, col="red", lwd=2)

# Breusch-Pagan testi
library(lmtest)
bp_test <- bptest(model)
cat("Breusch-Pagan Testi Sonuçları:\n")
print(bp_test)

# Breusch-Pagan testi sonucunu yorumlama
if(bp_test$p.value < 0.05) {
  cat("Değişen varyanslılık sorunu vardır (p < 0.05).\n")
} else {
  cat("Değişen varyanslılık sorunu yoktur (p >= 0.05).\n")
}

#10.madde
# 10. Öz İlişki Sorununu İnceleme


# Durbin-Watson testi
library(lmtest)
dw_test <- dwtest(model)
cat("Durbin-Watson Testi Sonuçları:\n")
print(dw_test)

# Durbin-Watson testi sonucunu yorumlama
if(dw_test$p.value < 0.05) {
  cat("Öz ilişki sorunu vardır (p < 0.05).\n")
} else {
  cat("Öz ilişki sorunu yoktur (p >= 0.05).\n")
}



#10.maddedeki öz ilişki problemi pozitif veya negaatif yönüne bakılacak




#11.madde
# Gerekli kütüphanelerin yüklenmesi
if (!require("car")) install.packages("car")
library(car)


# VIF hesaplama
vif_values <- vif(lm(y ~ x1 + x2 + x3 + x4, data = df_new_clean))
print("VIF Değerleri:")
print(vif_values)

# Tolerans değerleri
tolerance_values <- 1 / vif_values
print("Tolerans Değerleri:")
print(tolerance_values)


#12.madde
# Gözlem seçimi (örneğin, 10. gözlem)
selected_observation <- df_clean[10, ]

# Seçilen gözlem için uyum kestiriminin hesaplanması
predicted_value <- predict(model, newdata = selected_observation, interval = "confidence", level = .95)
predicted_value
# Sonucun yazdırılması
print("Seçilen gözlem:")
print(selected_observation)
print("Uyum kestirimi (predicted value):")
print(predicted_value)


#13.madde
# Yeni gözlem oluşturma
new_observation <- data.frame(x1 = 3,    # Tıbbi sorun sayısı
                              x2 = 7,    # Ameliyat öncesi hastanede kalış gün sayısı
                              x3 = 1,   # Hasta yaşı
                              x4 = "2")    # Ameliyat türü

# Yeni gözlem için tahmin yapma (ln_y)
predicted_ln_y <- predict(model, newdata = new_observation, interval = "prediction", level = 0.95)

# Tahmin sonuçlarını yazdırma
cat("Yeni Gözlem için Tahmin Sonuçları (ln_y):\n")
print(predicted_ln_y)


#14.madde
# Mevcut Veri İçin Uyum Kestirimi (E(ŷ_i))
predictions <- predict(model, interval = "confidence", level = 0.95)
cat("Mevcut Veri İçin Uyum Kestirimi (E(ŷ_i)) ve %95 Güven Aralıkları:\n")
print(predictions)

# Yeni gözlem oluşturma
new_observation <- data.frame(x1 = 3,    # Tıbbi sorun sayısı
                              x2 = 7,    # Ameliyat öncesi hastanede kalış gün sayısı
                              x3 = 1,   # Hasta yaşı
                              x4 = "2")    # Ameliyat türü

# Yeni gözlem için tahmin yapma (ln_y)
predicted_ln_y <- predict(model, newdata = new_observation, interval = "prediction", level = 0.95)

# Tahmin sonuçlarını yazdırma
cat("Yeni Gözlem için Tahmin Sonuçları (ln_y):\n")
print(predicted_ln_y)

#15.madde
install.packages("MASS")
install.packages("leaps")
library(MASS)
library(leaps)
library(readxl)

# İleriye doğru seçim yöntemi
forward_model <- stepAIC(model, direction="forward")
cat("İleriye Doğru Seçim Yöntemi:\n")
summary(forward_model)

# Geriye doğru çıkarma yöntemi
backward_model <- stepAIC(model, direction="backward")
cat("Geriye Doğru Çıkarma Yöntemi:\n")
summary(backward_model)

# Adımsal regresyon yöntemi
stepwise_model <- stepAIC(model, direction="both")
cat("Adımsal Regresyon Yöntemi:\n")
summary(stepwise_model)




# Gerekli paketlerin yüklenmesi
install.packages("MASS")
library(MASS)

# Regresyon modeli
model <- lm(y ~ x1 + x2 + x3 + x4, data = df_new_clean)

# İleriye doğru seçim yöntemi
forward_model <- stepAIC(model, direction = "forward")
forward_summary <- summary(forward_model)
cat("İleriye Doğru Seçim Yöntemi:\n")
print(forward_summary)

# Geriye doğru çıkarma yöntemi
backward_model <- stepAIC(model, direction = "backward")
backward_summary <- summary(backward_model)
cat("Geriye Doğru Çıkarma Yöntemi:\n")
print(backward_summary)

# Adımsal regresyon yöntemi
stepwise_model <- stepAIC(model, direction = "both")
stepwise_summary <- summary(stepwise_model)
cat("Adımsal Regresyon Yöntemi:\n")
print(stepwise_summary)

# İleriye doğru seçim yöntemi için AIC ve adjusted R-squared değerleri
forward_aic <- AIC(forward_model)
forward_adj_r2 <- forward_summary$adj.r.squared

# Geriye doğru çıkarma yöntemi için AIC ve adjusted R-squared değerleri
backward_aic <- AIC(backward_model)
backward_adj_r2 <- backward_summary$adj.r.squared

# Adımsal regresyon yöntemi için AIC ve adjusted R-squared değerleri
stepwise_aic <- AIC(stepwise_model)
stepwise_adj_r2 <- stepwise_summary$adj.r.squared

# Sonuçları karşılaştırma
cat("Model Karşılaştırması:\n")
cat("İleriye Doğru Seçim Yöntemi - AIC: ", forward_aic, ", Adjusted R-squared: ", forward_adj_r2, "\n")
cat("Geriye Doğru Çıkarma Yöntemi - AIC: ", backward_aic, ", Adjusted R-squared: ", backward_adj_r2, "\n")
cat("Adımsal Regresyon Yöntemi - AIC: ", stepwise_aic, ", Adjusted R-squared: ", stepwise_adj_r2, "\n")

# En iyi modeli belirleme
models <- data.frame(
  Model = c("İleriye Doğru", "Geriye Doğru", "Adımsal"),
  AIC = c(forward_aic, backward_aic, stepwise_aic),
  Adjusted_R2 = c(forward_adj_r2, backward_adj_r2, stepwise_adj_r2)
)

best_model <- models[which.min(models$AIC), ]
cat("En İyi Model:\n")
print(best_model)





#16.madde
library(MASS)
ridge <- lm.ridge(df_new$ln_y~x1+x2+x3+x4 , lambda = seq(0,1,0.05))
matplot(ridge$lambda , t(ridge$coef), type = "l" , xlab = expression(lambda), ylab = expression(hat(beta)))
abline(h=0,lwd=2)
ridge$coef

select(ridge)

ridge$coef[,ridge$lam == 0.4]




df_new_clean

