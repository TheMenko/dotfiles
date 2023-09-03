#!/bin/sh  
# ---------- select random image ----------------
wallust $(ls -1  ~/wallpapers/*.jpg |  shuf | head -1)
# -----------------------------------------------
