# containerized-coq

A container image for using coq within a container as your local user.

The idea is that the user used within the container will have the same
user id and group id as the host user, so that files created from
within the container will have the correct permissions.
