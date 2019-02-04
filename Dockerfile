#This is a two step build process that 
#1. creates a build image and builds project on node:alpine image
#2. copies build files over to nginx image to serve it up

# Build step
FROM node:alpine as builder
WORKDIR '/app'
COPY package*.json .
RUN npm install
COPY . .
# BUG!: need to install new version of terser so that react-scripts build works!
RUN npm i terser@3.14
RUN npm run build

# Run step
FROM nginx
# Needed to expose ports when deploying to services like aws
EXPOSE 80
COPY --from=builder /app/build /usr/share/nginx/html

