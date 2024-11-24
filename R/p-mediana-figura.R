library(magick)

gif_files <- c("./plot/P_mod_1b.png", "./plot/plot_Mod_2A.png", "./plot/plot_Mod_2B.png", "./plot/plot_Mod_3.png")

png_file <- "./plot/p_mediana_T67_post.png"



# Criar o GIF a partir das imagens
gif <- image_read(gif_files)               # Lê as imagens
gif <- image_animate(gif, fps = 1)         # Cria o GIF com 1 frame por segundo
image_write(gif, path = "./plot/modelos.gif")      # Salva o GIF

# Carregar a imagem PNG e o GIF gerado
png_image <- image_read(png_file)

image_info(image_read(png_file))
image_info(image_read(gif_files))


# Duplicar a imagem PNG para combinar com cada frame do GIF
png_frames <- image_scale(png_image, geometry = image_info(gif)[1, "geometry"]) # Ajusta o tamanho
png_repeated <- image_apply(gif, function(frame) png_frames)  # Repete o PNG para cada frame do GIF

# Combinar cada frame do PNG com o correspondente frame do GIF
image_mapply <- function(p, g) {
  image_append(c(p, g))
}


combined_frames <- image_mapply(png_repeated, gif)


# Criar o GIF final com os frames combinados
combined_gif <- image_animate(image_join(combined_frames), fps = 1)
image_write(combined_gif, path = "combined_output.gif")




####

# Caminhos das imagens

gif_files <- c("./plot/P_mod_1b.png", "./plot/plot_Mod_2A.png", "./plot/plot_Mod_2B.png", "./plot/plot_Mod_3.png")

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
image_write(combined_gif, path = "combined_output.gif")
