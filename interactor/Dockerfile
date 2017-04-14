FROM nodesource/node:4.0.0

ENV NODE_ENV development

RUN useradd --user-group --create-home --shell /bin/false app && npm install --global npm

WORKDIR /usr/local/src

RUN git clone https://github.com/geocontrol/actormapp.git /root/interactor

RUN cp -R /root/interactor/* .

RUN sed -i 's/db:27017/interactor-db:27017/g' app.js

RUN npm install
RUN npm run build

RUN rm /etc/localtime
RUN ln -s /usr/share/zoneinfo/Europe/Luxembourg /etc/localtime
RUN echo "Europe/Luxembourg" > /etc/timezone

CMD ["npm","start"]
