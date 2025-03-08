# Build stage
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN apk update && apk upgrade --no-cache libxml2
RUN npm ci
COPY . .
RUN npm run build

# Production stage
FROM nginx:alpine
COPY --from=build /app/dist /usr/share/nginx/html
# Add nginx configuration if needed
# COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
