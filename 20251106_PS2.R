# Get summary statistics, then run out some RD plots.

# Packages

library(tidyverse)
library(haven)
library(gt)
library(magrittr)
library(patchwork)

# Data

dat = "data/ecological_footprint_restat_deforestation_data.dta" %>% read_dta

# Wrangle

dat_use = 
  dat %>% 
  select(lnarea,
         lnslope,
         perforestK,
         pctdefor,
         carrconlkm,
         d,
         treat) %>% 
  # mutate(area = lnarea %>% exp,
  #        slope = lnslope %>% exp) %>% 
  # rename(area = lnarea,
  #        slope = lnslope) %>% # Band-Aid.
  mutate(area = lnarea %>% exp,
         slope = lnslope) %>% # Better?
  select(area,
         slope,
         perforestK,
         pctdefor,
         carrconlkm,
         d,
         treat) %>% 
  group_by(treat) %>% 
  summarize(area_min = area %>% min,
            slope_min = slope %>% min,
            perforest_min = perforestK %>% min,
            perdeforest_min = pctdefor %>% min,
            roads_min = carrconlkm %>% min,
            bindeforest_min = d %>% min,
            area_max = area %>% max,
            slope_max = slope %>% max,
            perforest_max = perforestK %>% max,
            perdeforest_max = pctdefor %>% max,
            roads_max = carrconlkm %>% max,
            bindeforest_max = d %>% max,
            area_mean = area %>% mean,
            slope_mean = slope %>% mean,
            perforest_mean = perforestK %>% mean,
            perdeforest_mean = pctdefor %>% mean,
            roads_mean = carrconlkm %>% mean,
            bindeforest_mean = d %>% mean,
            area_sd = area %>% sd,
            slope_sd = slope %>% sd,
            perforest_sd = perforestK %>% sd,
            perdeforest_sd = pctdefor %>% sd,
            roads_sd = carrconlkm %>% sd,
            bindeforest_sd = d %>% sd) %>% 
  ungroup %>% 
  pivot_longer(cols = 2:25,
               names_to = c("var", "stat"),
               names_sep = "_") %>% 
  mutate(value = value %>% round(3)) %>% 
  pivot_wider(names_from = stat,
              values_from = value) %>% 
  pivot_wider(names_from = treat,
              values_from = c(min, max, mean, sd)) %T>% 
  write_csv("out/20251106_PS2.csv")

# Plot

#  Percent Treated

vis_scatter_1 = 
  dat %>% 
  select(treatpct9702, indice95) %>% 
  ggplot() +
  geom_point(aes(x = indice95,
                 y = treatpct9702),
             alpha = 0.05) +
  labs(x = "Marginality Index",
       y = "Percent Treated") +
  theme_minimal()

vis_scatter_2 = 
  dat %>% 
  filter(indice95 >= -2.00 & indice95 <= -0.20) %>% 
  select(treatpct9702, indice95) %>% 
  ggplot() +
  geom_point(aes(x = indice95,
                 y = treatpct9702),
             alpha = 0.05) +
  labs(x = "Marginality Index",
       y = "Percent Treated") +
  scale_x_continuous(breaks = c(-2.00, -1.20, -0.20)) +
  theme_minimal()

vis_scatter = vis_scatter_1 + vis_scatter_2

ggsave("out/20251106_PS2_1.png",
       dpi = 300,
       width = 6.5,
       height = 4)
  
#  Deforestation

vis_scatter_deforestation = 
  dat %>% 
  filter(indice95 >= -2.00 & indice95 <= -0.20) %>% 
  select(pctdefor, indice95) %>% 
  ggplot() +
  geom_point(aes(x = indice95,
                 y = pctdefor),
             alpha = 0.25,
             color = "#D73F09") +
  labs(x = "Marginality Index",
       y = "Percent Deforestation") +
  scale_x_continuous(breaks = c(-2.00, -1.20, -0.20)) +
  theme_minimal()

vis_deforestation = vis_scatter_deforestation / vis_scatter_2

ggsave("out/20251106_PS2_2.png",
       dpi = 300,
       width = 6.5,
       height = 4)
