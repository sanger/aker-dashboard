# aker-dashboard
# Use ruby 2.3.1
FROM ruby:2.3.1

# Update package list and install required packages
RUN apt-get update -qq && apt-get install -y build-essential libpq-dev

# https://nodejs.org/en/download/package-manager/#debian-and-ubuntu-based-linux-distributions
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get install -y nodejs

# Install phantomjs - required for tests
# https://www.npmjs.com/package/phantomjs-prebuilt
# Using --unsafe-perm because: https://github.com/Medium/phantomjs/issues/707
RUN npm install -g phantomjs-prebuilt --unsafe-perm

# Create the working directory
# https://docs.docker.com/engine/reference/builder/#workdir
WORKDIR /code

# Add the Gemfile and .lock file
ADD Gemfile /code/Gemfile
ADD Gemfile.lock /code/Gemfile.lock

# Install bundler
# http://bundler.io/
RUN gem install bundler

# Install gems required by project
# We do not need the gems of the deployment group
RUN bundle install --without deployment

# Add all remaining contents to the image
ADD . /code
