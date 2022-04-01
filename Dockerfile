# set base
FROM node:14
# set working directory
WORKDIR /app
# copy app files to image working directory
 COPY *.js /app/
 COPY *.json /app/
 COPY public /app/public
# COPY . .
# Install dependancies given in Package.json file
RUN npm install
# overide default 8080 port through environment variable (set in bash script now)
ENV PORT=5000
# set entry point
ENTRYPOINT ["npm","start"]
