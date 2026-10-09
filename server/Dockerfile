FROM node:24-alpine
WORKDIR /app
COPY package*.json ./
COPY server/package*.json server/
COPY client/package*.json client/
RUN npm ci
COPY . .
WORKDIR /app/server
RUN npx prisma generate
ENV NODE_ENV=production
EXPOSE 4000
CMD ["sh","-c","npx prisma migrate deploy && node server.js"]
