# Data simulation -------

# We will simulate a dataset for the spider transplant project, as if we are 

# load library -----
library(tidyverse)

# load dataset just for comparison -----
soil2016 <- read.csv("data/tidy/pad.csv") %>%
  ## select only 2016
  filter(Year == '2016') %>%
  ## Convert categorical variables to be factors (just to be sure they are being handled correctly in the model)
  mutate(across(
    .cols = c(SiteID, PadID, Treatment, Position),
    .fns = factor)) %>%
  mutate(wpd = (weight / Days * 1000) + 0.2381,
         ln_wpd = log(wpd)) %>%
  select(SiteID, PadID, Days, Treatment, Position, weight, wpd, ln_wpd) %>%
  na.omit()

str(soil2016)

pad_counts <- soil2016 %>%
  group_by(SiteID, Treatment) %>%
  summarize(mean_trt = mean(wpd, na.rm = TRUE),
            sd_trt = sd(wpd),
            ln_mean_trt = mean(ln_wpd, na.rm = TRUE),
            ln_sd_trt = sd(ln_wpd),
            n = n(), .groups = "drop")

pad_counts

# 1. Define your expected dataset ---------
# We need the following columns: 
  # response: weight per day
  # predictors: site, treatment, position

# We sampled 4 paired watersheds. 
# Sampled 4 watersheds (+) prairie strip, 4 watersheds (-) prairie strip
# In each watershed, we sampled 60-150 pads
# Half of the pads place in watersheds with prairie and half of the pads placed in watersheds without prairie
# Total = 480 pads

# 2. Simulate response ------------
# we will treat pad as a normal distribution
# we predict that mass soil movement will be smaller in watersheds with prairie 
# strips vs. field without prairie strips
strips <- rnorm(n = 240, mean = c(4.92), sd = c(1.23)) #simulate watershed with prairie
nostrips <- rnorm(n = 240, mean = c(4.74), sd = c(1.31)) #simulate watershed without prairie

weight <- c(strips, nostrips)

# 2. Simulate predictors ---------
SiteID <- factor(rep (c("ARM", "EIA", "RHO", "WHI"), each = 4, times = 120))
Position <- factor(rep (c("bottom", "middle", "top"), each = 8, times = 2))
treatment <- factor(rep (c("control", "strips"), each = 2, times = 240))

# Other helpful code for binomial data
# predictor: 
position <- sample(c("top","middle","bottom"), size = 20, replace = TRUE)
# response
ifelse(position=="top", yes = rnorm(20, 10, 1), no = rnorm(20, 20, 1))

# 3. Combine into a dataframe, and save ------
simpad <- data.frame(field,position,wpd)
write.csv(simpad,"data/tidy/sim_pad.csv")

# 4. Graph data ------
ggplot(simtransplant, aes(island, websize, fill=netting))+
  geom_boxplot()

ggplot(simtransplant, aes(websize))+
  geom_histogram(binwidth = 5) +
  facet_grid(netting ~ island)


# 5. Run a model with dataset -------
m1 <- lm(response ~ netting * island, data = simtransplant)
summary(m1)

# 6. Using tidyverse approach ---------
n_obs = 84 # must use a factor of 4, try 84, 168, 336, 504
tidysimtransplant <- data.frame(uniqueid = seq(1, n_obs, 1)) %>%
  mutate(
    island = rep(c("guam", "saipan"), each = 2, times = n_obs/4),
    #site = rep(c("a", "b", "c", "d", "e", "f"), each = 2, times = n_obs/12),
    netting = rep (c("yes", "no"), each = 1, times = n_obs/2), 
    websize = rnorm(n_obs, mean = c(54, 54, 54, 49), sd = c(5, 5, 5, 4)))

ggplot(tidysimtransplant, aes(island, websize, color = netting)) +
    geom_boxplot()

summary(lm(websize ~ island * netting, data = tidysimtransplant))

#change the mean values and the sample size, and see whether you get a significant result. Run several times at each set of values because each time you run rnorm, you get a new random draw of websizes. 
