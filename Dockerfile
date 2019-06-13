FROM *BUILD_IMAGE* as builder

# Specify Arguments for build stage (or delete if not required)
ARG x

# Specify Environment variables needed for build tasks
ENV x y

# Add a user for the app to run as
RUN adduser -D -g '' appuser

# Add the source code to the temporary build container
ADD src /build

# Set the PWD to the location the code was added to
WORKDIR /build

# Run the build Steps
RUN BUILD CODE HERE

FROM *RUN_IMAGE*

# Required arguments for the build process
ARG VCS_REF
ARG BUILD_DATE

LABEL org.label-schema.build-date=${BUILD_DATE} \
      org.label-schema.vcs-ref=${VCS_REF} \
      org.label-schema.vcs-url="https://github.com/tnwhitwell/docker-sslh" \ # URL of this projects git repository
      org.label-schema.docker.cmd="" \ # `docker run` command to launch the app in as minimal a way as possible, but still working
      org.label-schema.docker.params="" \ # Comma separated list of available environment variables for the app to use (ENV_VAR=description of what this does. Default: some_default,...)
      org.label-schema.schema-version="1.0" \
      maintainer="" # Your email address, in the format Firstname Lastname <email@domain.com>

# Copy the user definition of the user created in the build container
COPY --from=builder /etc/passwd /etc/passwd

# Copy the build artifacts from the temporary build container to the output image
COPY --from=builder /build/build_output /app

# Set the working directory to the right one for the app (will be created if it does not exist)
WORKDIR /app

RUN Any commands required to get the run image ready for the app to start (installing dependencies etc)

# Set the output container to run as a non-root user
USER appuser

# Specify the ports that the service will expose TCP / UDP on
EXPOSE 8080

ENTRYPOINT [ "/path/to/run/app" ]
