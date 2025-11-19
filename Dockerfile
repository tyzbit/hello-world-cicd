FROM golang:1.24.3 AS build

COPY . /app
WORKDIR /app
RUN go build /app

FROM scratch
COPY --from=build /app/hello-world-cicd /
ENTRYPOINT [ "/hello-world-cicd" ]