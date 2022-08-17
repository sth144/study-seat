
FROM debian:bullseye-slim AS base
RUN apt update
RUN apt install -y npm \
                    nodejs 
RUN npm install -g typescript@latest react-scripts create-react-app

FROM base as build
COPY . /usr/src/app
WORKDIR /usr/src/app
RUN mkdir -p build

# build client
WORKDIR /usr/src/app/client
RUN npm install
RUN npm run build

# build server
WORKDIR /usr/src/app/server
RUN npm install
RUN npm run build

FROM build as deploy
# TODO: define environment variables here and pass them in
ARG LISTEN_PORT=8000
ENV LISTEN_PORT=${LISTEN_PORT}
ARG PORT=8080
ENV PORT=${PORT}
ARG API_KEY=
ENV API_KEY=${API_KEY}
ARG AUTH0_CLIENT_ID=
ENV AUTH0_CLIENT_ID=${AUTH0_CLIENT_ID}
ARG AUTH0_DOMAIN=
ENV AUTH0_DOMAIN=${AUTH0_DOMAIN}
ARG AUTH0_CLIENT_SECRET=
ENV AUTH0_CLIENT_SECRET=${AUTH0_CLIENT_SECRET}

CMD ["npm", "start"]
