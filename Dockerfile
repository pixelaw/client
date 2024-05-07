FROM node:20 AS base
 
FROM base AS deps
RUN corepack enable
WORKDIR /app
COPY package.json yarn.lock ./
RUN --mount=type=cache,id=node_modules,target=/app/node_modules yarn install --frozen-lockfile
 

FROM deps AS build
RUN corepack enable
COPY . .
RUN --mount=type=cache,id=node_modules,target=/app/node_modules yarn build
 
FROM base
WORKDIR /app
COPY --from=deps /app/node_modules /app/node_modules
COPY --from=build /app/dist /app/dist
ENV NODE_ENV production
CMD ["node", "./dist/index.js"]