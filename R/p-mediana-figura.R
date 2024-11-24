library(magick)
library(dplyr)


####

# Caminhos das imagens

gif_files <- c("./plot/P_mod_1.png", "./plot/plot_Mod_2A.png", "./plot/plot_Mod_2B.png", "./plot/plot_Mod_3.png" )

png_file <- "./plot/p_mediana_T67_post.png"

# Redimensionar PNG estático para proporção ajustada
png_resized <- image_read(png_file) %>%
  image_resize("1200x900")  # Ajuste proporcional para LinkedIn

# Redimensionar imagens do GIF para proporção ajustada
gif_resized <- lapply(gif_files, function(file) {
  image_read(file) %>%
    image_resize("1200x825")  # Ajuste proporcional para LinkedIn
})

# Criar GIF animado
gif <- image_join(gif_resized) %>%
  image_animate(fps = 1)

# Combinar PNG com cada frame do GIF
combined_frames <- lapply(seq_along(gif), function(i) {
  image_append(c(png_resized, gif[i]))
})

# Criar GIF final
combined_gif <- image_animate(image_join(combined_frames), fps = 1)
image_write(combined_gif, path = "./plot/figura-p-mediana.gif")
