# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Set environment variables for non-interactive installation
ENV DEBIAN_FRONTEND=noninteractive \
# Set environment variables for cron jobs
    TEST_ENV=/var/www/frank/crons/headers/test \
    WWWDIR=/var/www/frank/pod \
    HOST=test01 \
    #TEST_ROLE=nothing \
    LOGDIR=/var/log/pod/test \
    PHP=/usr/bin/php \
    DISTDIR=/var/www/frank \
    LOCKDIR=/var/lock/test \
    LOCAL_LOCKDIR=/var/test/lock


########################################################################################################################
# Initializing system and updating packages
########################################################################################################################
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recoTESTends \
    wget \
    curl \
    gnupg \
    software-properties-coTESTon \
    locales \
    tzdata \
    cron \
    gcc \
    git \
    graphviz \
    apache2 \
    apache2-dev \
    libapache2-mod-php \
    php \
    php-cli \
    php-coTESTon \
    php-curl \
    php-bcmath \
    php-intl \
    php-mbstring \
    php-xml \
    php-mysql \
    php-soap \
    php-zip \
    php-gd \
    php-redis \
    php-xdebug \
    php-pear \
    php-dev \
    redis \
    mysql-client \
    unzip \
    zip \
    rsyslog \
    sudo \
    xfonts-base \
    xfonts-75dpi \
    imagemagick \
    openssl \
    openssh-server \
    p7zip-full \
    libexpect-perl \
    libwww-perl \
    libmime-lite-perl \
    libpcre3-dev \
    recode \
    apt-utils \
    vim \
    acl \
    screen \
    unrar && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

########################################################################################################################
# Set Timezone
########################################################################################################################
RUN ln -snf /usr/share/zoneinfo/Europe/Vienna /etc/localtime && \
    echo "Europe/Vienna" > /etc/timezone && \
    dpkg-reconfigure -f noninteractive tzdata

########################################################################################################################
# Configure Locale
########################################################################################################################
RUN locale-gen en_GB.UTF-8 hu_HU.UTF-8 fr_FR.UTF-8 && \
    update-locale LANG=en_GB.UTF-8

# Ensure the cron directory exists
#RUN mkdir -p /var/spool/cron/crontabs && \
#    touch /var/spool/cron/crontabs/root && \
#    \
    # Ensure correct permissions for the crontab file
#    chown root:root /var/spool/cron/crontabs/root && \
#    chmod 0600 /var/spool/cron/crontabs/root

# Copy and set up cron jobs
#COPY /docker/config/etc/cron/test_jobs /etc/cron.d/test_jobs
#RUN chmod 0644 /etc/cron.d/test_jobs

########################################################################################################################
# Create User and Groups
########################################################################################################################
#RUN groupadd -g 498 test && \
#    useradd -ms /bin/bash -p '$1$999hdshshdshjds.' -u 498 -g 498 test && \
#    usermod -a -G www-data test

RUN groupadd -g 600 test && \
    useradd -ms /bin/bash -p '$1$999hdshshdshjds.'-u 600 -g 600 test && \
    usermod -a -G www-data test

# Grant sudo permissions to "test" user (optional if needed)
RUN echo "test ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/test 


# Apply cron job permissions and set cron to run
RUN touch /var/log/cron.log && \
    chown test:crontab /var/log/cron.log && \
    chmod 664 /var/log/cron.log

#Cron is working fine from here
# Copy the script into the container
COPY /docker/config/etc/cron/add_cron_jobs.sh /usr/local/bin/add_cron_jobs.sh
RUN chmod +x /usr/local/bin/add_cron_jobs.sh

# Run the script to add cron jobs
RUN /usr/local/bin/add_cron_jobs.sh


#RUN touch /var/log/cron.log && \
#    echo "TEST_ENV=/var/www/frank/crons/headers/new-test-header" >> /etc/cron.d/test_jobs && \
#    echo "* * * * * echo 'Hello World!!' >> /var/log/cron.log 2>&1" >> /etc/cron.d/test_jobs && \
#    echo "* * * * * . $TEST_ENV && $PHP $WWWDIR/private/test/jobs/tester.php host=$HOST >> /var/log/cron.log 2>&1" >> /etc/cron.d/test_jobs && \
#    \
    # Give proper permissions to the cron file
#    chmod 0644 /etc/cron.d/test_jobs && \
#    chown root:root /etc/cron.d/test_jobs
    
# Add Ubuntu 20.04 (Focal) repository to access libssl1.1
RUN echo "deb http://archive.ubuntu.com/ubuntu focal main universe" >> /etc/apt/sources.list && \
    apt-get update

# Install libssl1.1 from Ubuntu 20.04 repository
RUN apt-get install -y libssl1.1 && \
    sed -i '/focal/d' /etc/apt/sources.list && \
    apt-get update

# Verify installation
RUN dpkg -l | grep libssl1.1

# Copy and install wkhtmltox
COPY /docker/config/etc/wkhtmltox/wkhtmltox.deb /tmp/wkhtmltox.deb
RUN apt-get update && apt-get install -y /tmp/wkhtmltox.deb && \
    apt-get clean && rm -f /tmp/wkhtmltox.deb



RUN apt-get update && apt-get install -y --no-install-recoTESTends \
    php-apcu \
    php-memcached \
    php-ast \
    php-imap \
    php-tidy \
    php-ssh2 \
    php-xmlrpc \
    netcat \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

#To install fonts
# Step 1: Install required packages for fontconfig, and available fonts
RUN apt-get update && apt-get install -y --no-install-recoTESTends \
    fontconfig-config \
    texlive-base \
    texlive-fonts-recoTESTended \
    texlive-fonts-extra \
    texlive-latex-extra \
    libxft2 \
    fonts-ubuntu \
    fonts-noto \
    fonts-roboto \
    fonts-open-sans \
    fontconfig \
    fonts-dejavu \
    fonts-droid-fallback \
    fonts-liberation \
    fonts-arphic-ukai \
    fonts-arphic-uming \
    fonts-crosextra-caladea \
    fonts-crosextra-carlito \
    fonts-firacode \
    fonts-hack-ttf \
    fonts-inconsolata \
    fonts-liberation2 \
    fonts-noto-cjk \
    fonts-texgyre \
    fonts-urw-base35 \
    fonts-wqy-zenhei \
    fonts-wqy-microhei \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Step 2: Update font cache after installing fonts
RUN fc-cache -fv

# Final cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/*


 

########################################################################################################################
# SSH Keys for SFTP
########################################################################################################################

#RUN mkdir -p /root/.ssh
#COPY /docker/config/etc/ssh/id_rsa /root/.ssh/id_rsa
#COPY /docker/config/etc/ssh/id_rsa.pub /root/.ssh/id_rsa.pub
#COPY /docker/config/etc/ssh/sshconfig /root/.ssh/config
#RUN chmod 700 /root/.ssh && \
#    chmod 600 /root/.ssh/id_rsa && \
#    chmod 644 /root/.ssh/id_rsa.pub && \
#    chmod 644 /root/.ssh/config && \
#    chown -R root:root /root/.ssh

RUN mkdir -p /home/test/.ssh
COPY /docker/config/etc/ssh/id_rsa /home/test/.ssh/id_rsa
COPY /docker/config/etc/ssh/id_rsa.pub /home/test/.ssh/id_rsa.pub
COPY /docker/config/etc/ssh/sshconfig /home/test/.ssh/config
RUN chmod 700 /home/test/.ssh && \
    chmod 600 /home/test/.ssh/id_rsa && \
    chmod 644 /home/test/.ssh/id_rsa.pub && \
    chmod 644 /home/test/.ssh/config && \
    chown -R test:test /home/test && \
    chown -R test:test /home/test/.ssh/config && \
    cat /home/test/.ssh/config


########################################################################################################################
# Copy Application Code and Configurations
########################################################################################################################
COPY . /var/www/frank
COPY /docker/config/etc/php/php.ini /etc/php/8.1/cli/php.ini
COPY /docker/config/etc/php/php.ini /etc/php/8.1/apache2/php.ini
COPY /docker/config/etc/php/php-next-prepend.php /etc/php/8.1/apache2/php-next-prepend.php
#COPY /docker/config/etc/php/php-next-prepend.php /etc/php-next-prepend.php
COPY /docker/config/etc/apache2/sites-available/10-test.conf /etc/apache2/sites-available/10-test.conf
COPY /docker/config/etc/apache2/sites-available/10-test-ssl.conf /etc/apache2/sites-available/10-test-ssl.conf
COPY /docker/config/etc/apache2/conf-available/php.conf /etc/apache2/conf-available/php.conf
COPY /docker/config/etc/apache2/conf-available/autoindex.conf /etc/apache2/conf-available/autoindex.conf
COPY /docker/config/home/test/.my.cnf /home/test/.my.cnf

RUN mkdir -p /run/lock/apache2 && \
    chmod 775 /run/lock /run/lock/apache2 && \
    ln -sf /run/lock /var/lock && \
    echo "Mutex file:/run/lock/apache2 default" >> /etc/apache2/apache2.conf && \
    echo "export APACHE_LOCK_DIR=/run/lock/apache2" >> /etc/apache2/envvars

########################################################################################################################
# Configure Apache and Enable Modules
########################################################################################################################
#RUN a2enmod rewrite ssl && \
#    a2ensite 000-default.conf && \
#    service apache2 restart

RUN a2ensite 10-test.conf 10-test-ssl.conf&& \
    a2enmod ssl rewrite headers && \
    a2enconf php autoindex 

########################################################################################################################
# Install Composer
########################################################################################################################
ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /tmp
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

########################################################################################################################
# Supervisor Configuration
########################################################################################################################
#COPY /docker/config/etc/supervisor/supervisord.conf /etc/supervisor/supervisord.conf


#Starting services
COPY /docker/config/usr/local/bin/start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh


########################################################################################################################
# Application Directory Structure
########################################################################################################################
RUN mkdir -p \
    #/var/www/frank \
    /var/www/docker \
    /var/log/test \
    /var/log/test/shirt && \
    \
    # Set permissions for /var/log/test
    chown -R test:www-data /var/test/lock && \
    chmod -R 775 /var/test/lock && \
    chmod g+s /var/test/lock 

# Set specific permissions for /mnt/boomi/Staging
RUN mkdir -p /mnt/boomi/Staging && \
    chown -R test:www-data /mnt/boomi/Staging && \
    chmod -R 775 /mnt/boomi/Staging && \
    chmod g+s /mnt/boomi/Staging

#Ensure SFTP config in place properly
RUN ls -la /home/test/.ssh && \
    cat /home/test/.ssh/config

# Switch to "test" user
USER test






########################################################################################################################
# Expose Ports and Define Entry Point
########################################################################################################################
EXPOSE 80 443
#ENTRYPOINT ["/usr/bin/supervisord"]
#CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
ENTRYPOINT ["/bin/bash", "/usr/local/bin/start.sh"]
#CMD ["/bin/bash", "/usr/local/bin/start.sh"]


