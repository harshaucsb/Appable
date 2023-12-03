# syntax=docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.2.2
FROM ruby:$RUBY_VERSION

# Set environment variables for production
ENV RAILS_ENV=production \
    RACK_ENV=production \
    NODE_ENV=production

# Install system dependencies
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev libvips pkg-config \
    # For native extensions like those in sassc gem
    libffi-dev

# Install Node.js and Yarn (you need to install Node.js before adding the Yarn repository)
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list && \
    apt-get update && apt-get install -y yarn

# Clean up the apt cache to reduce image size
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Configure bundler and PATH
ENV LANG=C.UTF-8 \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3
# Consider setting BUNDLE_PATH if you want to bundle gems in a specific directory

WORKDIR /app

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle config set --local deployment 'true' && \
    bundle install --without development test

# Copy application code
COPY . .

# Add a default command, such as starting a Puma server
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]

# Expose the port the server is running on
EXPOSE 3000
