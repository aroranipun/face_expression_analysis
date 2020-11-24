
mappings = list(
V1 = c(17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 33, 36, 37, 38, 39, 40, 41, 68, 42, 43, 44, 45, 46, 47),
V2 = c(31, 32, 34, 35, 48, 49, 50, 51, 52, 53, 54, 61, 62, 63),
V3 = c(0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 55, 56, 57, 58, 59, 60, 64, 65, 66, 67),

# frontalis and procerus muscle (5x2= 10)
brow_l = c(17:21),
brow_r = c(22:26),

#Masseter muscles (4x2) = 8
chk_l = c(0:3),
chk_r = c(13:16),

#  Platysma and Risorious (3x2+1) = 7
chin_l = c(4:7),
chin_r = c(9:12),
chin_mid = c(8),

#orbicularis (25)
nose_lip = c(31:35), #5

lower_lip_l= c(66,67,57:59), #5
lower_lip_r= c(65,56:55), # 3

upper_lip_l = c(60:62, 48:51), # 7
uper_lip_r = c(52:54,63:64), # 6

#nasalisa
nose = c(27:30), #4

#orbicularis # 6x2+2 =14
eye_l = c(36:41),
eye_r = c(42:47),
pupil_l = c(68),
pupil_r= c(69),
face_sections = c("brows","cheeks","chin","lips","eyes","pupils","nose"))

mappings[["V"]] = unname(unlist(mappings[grep(names(mappings),pattern = "V")]))
mappings[["brows"]] = unname(unlist(mappings[grep(names(mappings),pattern = "brow")]))
mappings[["cheeks"]] = unname(unlist(mappings[grep(names(mappings),pattern = "chk")]))
mappings[["chin"]] = unname(unlist(mappings[grep(names(mappings),pattern = "chin")]))
mappings[["lips"]] = unname(unlist(mappings[grep(names(mappings),pattern = "lip")]))
mappings[["eyes"]] = unname(unlist(mappings[grep(names(mappings),pattern = "eye")]))
mappings[["pupils"]] = unname(unlist(mappings[grep(names(mappings),pattern = "pupil")]))