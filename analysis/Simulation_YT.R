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
  mutate(wpd = weight / Days * 1000) %>%
  select(SiteID, PadID, Days, Treatment, Position, weight, wpd) %>%
  na.omit()

str(s2016)

pad_counts <- s2016 %>%
  group_by(SiteID, Treatment) %>%
  summarize(mean_trt = mean(wpd),
            sd_trt = sd(wpd),
            n = n(), .groups = "drop")

# 1. Define your expected dataset ---------
# We need the following columns: 
  # response: weight per day
  # predictors: site, treatment, position, year

# We sampled 4 paired watersheds. 
# Sampled 4 watersheds (+) prairie strip, 4 watersheds (-) prairie strip
# In each watershed, we sampled 60-150 pads
# Half of the pads place in watersheds with prairie and half of the pads placed in watersheds without prairie
# Total = 480 pads

# 2. Simulate response ------------
# we will treat pad as a normal distribution
# we predict that mass soil movement will be smaller in watersheds with prairie 
# strips vs. field without prairie strips
strips <- rnorm(n = 240, mean = c(436), sd = c(938)) #simulate watershed with prairie
nostrips <- rnorm(n = 240, mean = c(307), sd = c(545)) #simulate watershed without prairie
#snetwebsize <- rnorm(n = 21, mean = c(54), sd = c(5)) #simulate saipan with net
#snonetwebsize <- rnorm(n = 21, mean = c(49), sd = c(4)) #simulate saipan without net
#websize <- c(gnetwebsize, gnonetwebsize, snetwebsize, snonetwebsize)

# 2. Simulate predictors ---------
#SiteID <- factor(rep (c("a", "b", "c"), each = 7, times = 2))
#ssite <- factor(rep (c("d", "e", "f"), each = 7, times = 2))
#site <- c(gsite, ssite) #just need to use c() because both are vectors
field <- rep (c("control", "strips"), each = 21, times = 2)

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
