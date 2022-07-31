FROM node:16-alpine as base

WORKDIR /app

# Installing all dependencies from package.json
FROM base as dependencies
COPY package*.json ./
RUN npm install

# Building our application
FROM dependencies as build
WORKDIR /app
COPY . .
RUN npm run build


# Application starting phase
FROM node:16-alpine as application
ENV NODE_ENV=production

# Copy all dependancies and file that was build
COPY --from=build /app/package*.json ./
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/dist ./dist

USER node
ENV PORT=4000
EXPOSE 4000

ENTRYPOINT [ "npm", "run" ]
CMD [ "start:prod" ]