ARG BASE
FROM ${BASE}

# Automatically install the dependencies from .vcpkg file in the root of the
# build context
ONBUILD COPY .vcpkg /tmp/vcpkg/
ONBUILD RUN vcpkg install $(cat /tmp/vcpkg/.vcpkg | tr '\n' ' ')
