FROM wordpress:latest
LABEL maintainer="Oshane Bailey b4.oshany@gmail.com"

# Update container
RUN apt-get update

# Install packages
RUN apt-get install -y curl zip unzip git wget

# Install Wordpress CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /root/wp-cli.phar
RUN php /root/wp-cli.phar --info
RUN chmod +x /root/wp-cli.phar
RUN mv /root/wp-cli.phar /usr/local/bin/wp
RUN wp --info

# Adding deploy key
RUN mkdir -p /root/.ssh
COPY docker-gid /root/.ssh/id_rsa
RUN ls -al /root/.ssh
RUN chmod 600 /root/.ssh/id_rsa
RUN ssh-keyscan -H github.com >> /root/.ssh/known_hosts
RUN ssh-keyscan -H gitlab.com >> /root/.ssh/known_hosts


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