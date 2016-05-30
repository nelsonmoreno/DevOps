#!/bin/sh

echo 'Provisioning Environment with Dovecot and Test Messages'
if which dovecot > /dev/null; then
    echo 'Dovecot is already installed'
else 
    echo 'Installing Dovecot'

    # Install Dovecot.
    # Pass the -y flag to suppress interactive requests.
    sudo apt-get -qq -y install dovecot-imapd dovecot-pop3d

    # Prepare the local.conf for custom values
    sudo touch /etc/dovecot/local.conf

    # Move Maildir to the users home directory.
    # This keeps things consistent across environments.
    sudo echo 'mail_location = maildir:/home/%u/Maildir' >> /etc/dovecot/local.conf

    # Enable plaintext for testing.
    # This is pretty awful for production environments.
    sudo echo 'disable_plaintext_auth = no' >> /etc/dovecot/local.conf

    # Running tests in isolation requires a lot of connections very quickly.
    sudo echo 'mail_max_userip_connections = 10000' >> /etc/dovecot/local.conf

    # Restart Dovecot so it gets it's new settings.
    sudo restart dovecot
fi
   # Create "testuser"

   # First check to see if the user already exits
   if getent passwd testuser > /dev/null; then
       echo 'testuser already exists'
   else
      echo 'Creating User "testuser" with password "applesauce"'
      sudo useradd testuser -m -s /bin/bash

      # Use chpasswd since we can pipe in a new password
      echo "testuser:applesauce"|sudo chpasswd
      echo 'User created'
   fi







