FROM wordpress:latest
LABEL maintainer="Oshane Bailey b4.oshany@gmail.com"

# Update container
RUN apt-get update

# Install packages
RUN apt-get install -y curl zip unzip git

# Adding deploy key
RUN mkdir -p ~/.ssh
COPY docker-gid ~/.ssh/id_rsa
RUN chmod 600 ~/.ssh/id_rsa
RUN ssh-keyscan -H github.com >> ~/.ssh/known_hosts
RUN ssh-keyscan -H gitlab.com >> ~/.ssh/known_hosts


# Get Theme
RUN git clone git@gitlab.com:osoobe/wmd/wmdcompetition-theme.git \
    /usr/src/wordpress/wp-content/themes/wmdcompetition

# Get Plugins
RUN git clone https://github.com/sheabunge/code-snippets.git \
    /usr/src/wordpress/wp-content/plugins/code-snippets

RUN git clone https://github.com/justintadlock/members.git \
    /usr/src/wordpress/wp-content/plugins/members

# Create an upload folder
RUN mkdir /uploads
RUN chown www-data:www-data /uploads
RUN ln -s uploads /usr/src/wordpress/wp-content/uploads

# Increase the file size limit for uploads
COPY uploads.ini /usr/local/etc/php/conf.d/uploads.ini